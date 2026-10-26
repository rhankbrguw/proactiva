import { NotificationPriority, NotificationSource } from '@prisma/client';
import { notificationRepository } from '../repositories/notification.repository.js';
import { userRepository } from '../repositories/user.repository.js';
import { QueryNotificationsInput } from '../schemas/notification.schema.js';

export class NotificationService {
  async getStudentNotifications(userId: string, filters: QueryNotificationsInput) {
    return notificationRepository.findByUserId(userId, filters);
  }

  async getNotificationStatistics(userId: string) {
    const totalCount = await notificationRepository.countTotalByUserId(userId);
    const ruleCount = await notificationRepository.countByUserIdAndSource(userId, NotificationSource.RULE);
    const llmCount = await notificationRepository.countByUserIdAndSource(userId, NotificationSource.LLM);

    const urgentCount = await notificationRepository.countByUserIdAndPriority(userId, NotificationPriority.URGENT);
    const highCount = await notificationRepository.countByUserIdAndPriority(userId, NotificationPriority.HIGH);
    const mediumCount = await notificationRepository.countByUserIdAndPriority(userId, NotificationPriority.MEDIUM);
    const lowCount = await notificationRepository.countByUserIdAndPriority(userId, NotificationPriority.LOW);

    const ratioRulePercent = totalCount > 0 ? ((ruleCount / totalCount) * 100).toFixed(1) : '0';
    const ratioLLMPercent = totalCount > 0 ? ((llmCount / totalCount) * 100).toFixed(1) : '0';

    return {
      totalNotifications: totalCount,
      sourceDistribution: {
        ruleBased: ruleCount,
        llmEnhanced: llmCount,
        ratioRulePercent,
        ratioLLMPercent,
      },
      priorityDistribution: {
        urgent: urgentCount,
        high: highCount,
        medium: mediumCount,
        low: lowCount,
      },
    };
  }

  async registerDeviceToken(userId: string, fcmToken: string) {
    await userRepository.updateFcmToken(userId, fcmToken);
  }
}

export const notificationService = new NotificationService();
