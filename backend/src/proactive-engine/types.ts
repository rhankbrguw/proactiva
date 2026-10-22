import { NotificationPriority, NotificationSource } from '@prisma/client';

export type EventType =
  | 'ASSIGNMENT_REMINDER'
  | 'DEADLINE_COLLISION_PRIORITY'
  | 'ATTENDANCE_WARNING'
  | 'PAYMENT_DUE'
  | 'SCHEDULE_ALERT'
  | 'ANNOUNCEMENT_ALERT';

export interface ProactiveNotificationPayload {
  userId: string;
  eventId?: string;
  tipe: EventType;
  prioritas: NotificationPriority;
  source: NotificationSource;
  judul: string;
  pesan: string;
  payload?: Record<string, any>;
}

export interface AssignmentCollisionItem {
  id: string;
  judul: string;
  namaMatkul: string;
  deadline: string;
  jenis: string;
  deskripsi?: string | null;
}

export interface PrioritizedAssignmentResult {
  assignmentId: string;
  priorityRank: number;
  reason: string;
}

export interface ExtractedAnnouncementResult {
  deadline: string | null; // ISO string or null
  action: string | null;
  targetAudience: string | null;
  summary: string;
  isUrgent: boolean;
}
