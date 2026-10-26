import { Worker, Job } from 'bullmq';
import { redis } from '../lib/redis.js';
import { PROACTIVE_QUEUE_NAME } from './proactive.queue.js';
import { runGlobalProactiveCycle, runProactiveCycleForUser } from '../proactive-engine/evaluator.js';
import { extractAnnouncementInformation } from '../proactive-engine/llm/announcement-extractor.js';
import { prisma } from '../lib/prisma.js';
import { NotificationPriority, NotificationSource, Role } from '@prisma/client';
import { dispatchProactiveNotification } from '../proactive-engine/dispatcher.js';

export function startProactiveWorker() {
  const worker = new Worker(
    PROACTIVE_QUEUE_NAME,
    async (job: Job) => {
      console.log(`[BullMQ Worker] ⚙️ Processing job "${job.name}" (ID: ${job.id})`);

      if (job.name === 'EVALUATE_ALL_STUDENTS') {
        return await runGlobalProactiveCycle();
      }

      if (job.name === 'EVALUATE_SINGLE_STUDENT') {
        const { userId } = job.data;
        return await runProactiveCycleForUser(userId);
      }

      if (job.name === 'PROCESS_ANNOUNCEMENT') {
        const { announcementId } = job.data;
        const announcement = await prisma.announcement.findUnique({
          where: { id: announcementId },
        });

        if (!announcement) {
          throw new Error(`Announcement ${announcementId} not found`);
        }

        console.log(`[Worker] Extracting LLM information for announcement: "${announcement.judul}"`);
        const { extracted, source } = await extractAnnouncementInformation(
          announcement.judul,
          announcement.isiTeks
        );

        // Update announcement record with extracted metadata
        await prisma.announcement.update({
          where: { id: announcementId },
          data: {
            extractedDeadline: extracted.deadline ? new Date(extracted.deadline) : null,
            extractedAction: extracted.action,
            targetAudience: extracted.targetAudience,
            source: source === 'LLM' ? 'LLM_EXTRACTED' : 'MANUAL',
            rawLlmOutput: JSON.stringify(extracted),
          },
        });

        // Broadcast proactive notification to students
        const students = await prisma.user.findMany({
          where: { role: Role.MAHASISWA },
          select: { id: true },
        });

        for (const student of students) {
          await dispatchProactiveNotification({
            userId: student.id,
            eventId: announcement.id,
            tipe: 'ANNOUNCEMENT_ALERT',
            prioritas: extracted.isUrgent ? NotificationPriority.URGENT : NotificationPriority.HIGH,
            source: source === 'LLM' ? NotificationSource.LLM : NotificationSource.RULE,
            judul: `📢 Pengumuman Penting: ${announcement.judul}`,
            pesan: `${extracted.summary}\n\n👉 Aksi: ${extracted.action || 'Periksa detail pengumuman di portal SIAKAD.'}${extracted.deadline ? `\n⏳ Batas Waktu: ${new Date(extracted.deadline).toLocaleDateString('id-ID')}` : ''}`,
            payload: {
              announcementId: announcement.id,
              extracted,
              sourceType: source,
            },
          });
        }

        return { announcementId, extracted, source };
      }

      console.warn(`[BullMQ Worker] Unknown job name: ${job.name}`);
    },
    {
      connection: redis,
      concurrency: 5,
    }
  );

  worker.on('completed', (job) => {
    console.log(`[BullMQ Worker] ✅ Job "${job.name}" (${job.id}) completed successfully.`);
  });

  worker.on('failed', (job, err) => {
    console.error(`[BullMQ Worker] ❌ Job "${job?.name}" (${job?.id}) failed:`, err.message);
  });

  return worker;
}
