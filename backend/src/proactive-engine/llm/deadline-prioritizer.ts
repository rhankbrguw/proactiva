import { openai, isLLMConfigured } from '../../lib/llm.js';
import { config } from '../../config/index.js';
import { AssignmentCollisionItem, PrioritizedAssignmentResult } from '../types.js';

export async function prioritizeCollidingDeadlines(
  assignments: AssignmentCollisionItem[]
): Promise<{ results: PrioritizedAssignmentResult[]; source: 'LLM' | 'RULE_FALLBACK' }> {
  // If LLM is not configured, directly use Rule Fallback
  if (!isLLMConfigured()) {
    return {
      results: fallbackSortDeadlines(assignments),
      source: 'RULE_FALLBACK',
    };
  }

  const prompt = `Anda adalah asisten akademik cerdas yang membantu mahasiswa menyusun prioritas pengerjaan tugas kuliah yang bertabrakan.
Berikut adalah daftar tugas/kuis yang tenggat waktunya sangat berdekatan:

${JSON.stringify(assignments, null, 2)}

Tugas Anda:
1. Analisis urgensi berdasarkan: tanggal tenggat (deadline), jenis (Kuis vs Tugas Proyek), tingkat kesulitan/deskripsi, dan nama mata kuliah.
2. Tentukan urutan prioritas pengerjaan dari Rank 1 (paling mendesak/prioritas tertinggi) sampai Rank N.
3. Berikan alasan singkat, jelas, dan memotivasi untuk setiap urutan prioritas (maksimal 1-2 kalimat per tugas).

KEMBALIKAN HANYA FORMAT JSON MURNI tanpa markdown ticks, dengan format persis:
[
  {
    "assignmentId": "id-tugas",
    "priorityRank": 1,
    "reason": "Alasan singkat prioritas"
  }
]`;

  try {
    const response = await openai.chat.completions.create({
      model: config.llm.model,
      messages: [
        { role: 'system', content: 'You are an expert academic advisor AI. Always output valid JSON array only.' },
        { role: 'user', content: prompt },
      ],
      temperature: 0.2,
      response_format: { type: 'json_object' },
    });

    const content = response.choices[0]?.message?.content?.trim() || '[]';
    
    // Parse JSON
    let parsed: any;
    try {
      parsed = JSON.parse(content);
      if (parsed && !Array.isArray(parsed) && Array.isArray(parsed.results)) {
        parsed = parsed.results;
      } else if (parsed && !Array.isArray(parsed) && Array.isArray(parsed.priorities)) {
        parsed = parsed.priorities;
      }
    } catch {
      // Regex fallback extraction if wrapped
      const match = content.match(/\[[\s\S]*\]/);
      if (match) {
        parsed = JSON.parse(match[0]);
      } else {
        throw new Error('Invalid JSON format returned by LLM');
      }
    }

    if (Array.isArray(parsed) && parsed.length > 0) {
      return {
        results: parsed.map((item: any, idx: number) => ({
          assignmentId: item.assignmentId || assignments[idx]?.id,
          priorityRank: item.priorityRank || idx + 1,
          reason: item.reason || 'Dianjurkan diselesaikan terlebih dahulu berdasarkan estimasi waktu.',
        })),
        source: 'LLM',
      };
    }

    throw new Error('LLM output array empty');
  } catch (err: any) {
    console.warn('[LLM Deadline Prioritizer Warning] Fallback activated due to:', err.message);
    return {
      results: fallbackSortDeadlines(assignments),
      source: 'RULE_FALLBACK',
    };
  }
}

// Deterministic Graceful Degradation / Fallback Rule
function fallbackSortDeadlines(assignments: AssignmentCollisionItem[]): PrioritizedAssignmentResult[] {
  const sorted = [...assignments].sort((a, b) => {
    // Sort by deadline asc, then KUIS before TUGAS if deadline is equal
    const dateDiff = new Date(a.deadline).getTime() - new Date(b.deadline).getTime();
    if (dateDiff !== 0) return dateDiff;
    if (a.jenis === 'KUIS' && b.jenis !== 'KUIS') return -1;
    if (b.jenis === 'KUIS' && a.jenis !== 'KUIS') return 1;
    return 0;
  });

  return sorted.map((item, index) => ({
    assignmentId: item.id,
    priorityRank: index + 1,
    reason: `Urutan ke-${index + 1} berdasarkan tanggal tenggat terdekat (${new Date(item.deadline).toLocaleString('id-ID')}). [Fallback Heuristik]`,
  }));
}
