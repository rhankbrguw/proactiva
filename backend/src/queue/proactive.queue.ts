import { Queue } from 'bullmq';
import { redis } from '../lib/redis.js';

export const PROACTIVE_QUEUE_NAME = 'proactiva-evaluator-queue';

export const proactiveQueue = new Queue(PROACTIVE_QUEUE_NAME, {
  connection: redis,
  defaultJobOptions: {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000,
    },
    removeOnComplete: 100,
    removeOnFail: 200,
  },
});
