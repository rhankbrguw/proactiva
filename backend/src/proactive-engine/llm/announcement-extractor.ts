import { openai, isLLMConfigured } from '../../lib/llm.js';
import { config } from '../../config/index.js';
import { ExtractedAnnouncementResult } from '../types.js';

export async function extractAnnouncementInformation(
  title: string,
  content: string
): Promise<{ extracted: ExtractedAnnouncementResult; source: 'LLM' | 'RULE_FALLBACK' }> {
  if (!isLLMConfigured()) {
    return {
      extracted: fallbackExtractAnnouncement(title, content),
      source: 'RULE_FALLBACK',
    };
  }

  const prompt = `Anda adalah sistem ekstraksi informasi akademik universitas.
Analisis pengumuman akademik berikut dan ekstrak informasi penting:

Judul: ${title}
Isi Pengumuman:
${content}

Ekstrak informasi berikut dalam format JSON:
1. "deadline": Tanggal tenggat penting/batas akhir aksi jika ada (Format ISO 8601 YYYY-MM-DDTHH:mm:ss.sssZ atau null jika tidak ada). Asumsikan tahun berjalan adalah ${new Date().getFullYear()}.
2. "action": Tindakan konkret yang harus dilakukan mahasiswa (misal: "Daftar ujian susulan di loket BAP dan bayar administrasi", atau null).
3. "targetAudience": Siapa yang dituju (misal: "Mahasiswa remedial / susulan UTS", "Seluruh Mahasiswa").
4. "summary": Ringkasan inti 1 kalimat singkat padat.
5. "isUrgent": boolean (true jika ada tenggat ketat / sanksi pembatalan).

KEMBALIKAN HANYA OBJEK JSON:
{
  "deadline": string | null,
  "action": string | null,
  "targetAudience": string | null,
  "summary": string,
  "isUrgent": boolean
}`;

  try {
    const response = await openai.chat.completions.create({
      model: config.llm.model,
      messages: [
        { role: 'system', content: 'You are an academic NLP extraction model. Always output valid JSON object.' },
        { role: 'user', content: prompt },
      ],
      temperature: 0.1,
      response_format: { type: 'json_object' },
    });

    const text = response.choices[0]?.message?.content?.trim() || '{}';
    const parsed = JSON.parse(text);

    // Rule validation on extracted date
    let validDeadline: string | null = null;
    if (parsed.deadline) {
      const parsedDate = new Date(parsed.deadline);
      if (!isNaN(parsedDate.getTime())) {
        validDeadline = parsedDate.toISOString();
      }
    }

    return {
      extracted: {
        deadline: validDeadline,
        action: parsed.action || null,
        targetAudience: parsed.targetAudience || 'Seluruh Mahasiswa',
        summary: parsed.summary || title,
        isUrgent: Boolean(parsed.isUrgent),
      },
      source: 'LLM',
    };
  } catch (err: any) {
    console.warn('[LLM Announcement Extractor Warning] Fallback activated due to:', err.message);
    return {
      extracted: fallbackExtractAnnouncement(title, content),
      source: 'RULE_FALLBACK',
    };
  }
}

// Deterministic Regex & Keyword Fallback for Announcement
function fallbackExtractAnnouncement(title: string, content: string): ExtractedAnnouncementResult {
  const combined = `${title} ${content}`.toLowerCase();

  // Basic regex for dates (e.g. 15 Oktober 2026 or 15/10/2026)
  const isUrgent = combined.includes('batas akhir') || combined.includes('tenggat') || combined.includes('segera') || combined.includes('remedial');
  
  let action: string | null = null;
  if (combined.includes('pendaftaran') || combined.includes('daftar')) {
    action = 'Lakukan pendaftaran sesuai petunjuk pengumuman sebelum batas waktu.';
  } else if (combined.includes('pembayaran') || combined.includes('bayar')) {
    action = 'Selesaikan pembayaran administrasi.';
  }

  return {
    deadline: null, // Null in fallback unless exact regex matches
    action,
    targetAudience: 'Mahasiswa Terkait',
    summary: `${title.substring(0, 100)}...`,
    isUrgent,
  };
}
