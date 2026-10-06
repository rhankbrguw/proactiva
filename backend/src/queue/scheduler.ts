import { proactiveQueue } from './proactive.queue.js';

export async function initScheduler() {
  console.log('[Scheduler] ⏰ Initializing proactive scheduler...');

  // Remove existing repeatable jobs if any to avoid duplication on restart
  const repeatableJobs = await proactiveQueue.getRepeatableJobs();
  for (const job of repeatableJobs) {
    await proactiveQueue.removeRepeatableByKey(job.key);
  }

  // Schedule proactive cycle every 15 minutes (or configurable)
  await proactiveQueue.add(
    'EVALUATE_ALL_STUDENTS',
    {},
    {
      repeat: {
        pattern: '*/15 * * * *', // every 15 minutes
      },
    }
  );

  console.log('[Scheduler] 🚀 Proactive cycle scheduled (every 15 minutes).');
}
