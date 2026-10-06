import { Role } from '@prisma/client';
import { prisma } from '../lib/prisma.js';
import { evaluateAttendanceRules } from './rules/attendance.rule.js';
import { evaluatePaymentRules } from './rules/payment.rule.js';
import { evaluateScheduleRules } from './rules/schedule.rule.js';
import { evaluateAssignmentDeadlines } from './rules/deadline.rule.js';
import { dispatchProactiveNotification } from './dispatcher.js';

export async function runProactiveCycleForUser(userId: string) {
  const allNotifications = [];

  // 1. Evaluate Attendance (Rule-based)
  const attendanceAlerts = await evaluateAttendanceRules(userId);
  allNotifications.push(...attendanceAlerts);

  // 2. Evaluate Payments (Rule-based)
  const paymentAlerts = await evaluatePaymentRules(userId);
  allNotifications.push(...paymentAlerts);

  // 3. Evaluate Schedules (Rule-based)
  const scheduleAlerts = await evaluateScheduleRules(userId);
  allNotifications.push(...scheduleAlerts);

  // 4. Evaluate Assignment Deadlines (Hybrid Rule & LLM)
  const assignmentAlerts = await evaluateAssignmentDeadlines(userId);
  allNotifications.push(...assignmentAlerts);

  // Dispatch all triggered notifications
  const dispatched = [];
  for (const notif of allNotifications) {
    const result = await dispatchProactiveNotification(notif);
    dispatched.push(result);
  }

  return {
    userId,
    totalEvaluated: allNotifications.length,
    dispatched,
  };
}

export async function runGlobalProactiveCycle() {
  console.log('[Proactive Engine] 🔄 Running global proactive cycle for all active students...');
  const students = await prisma.user.findMany({
    where: { role: Role.MAHASISWA },
    select: { id: true, nama: true, nim: true },
  });

  const results = [];
  for (const student of students) {
    const res = await runProactiveCycleForUser(student.id);
    results.push({ student: student.nama, nim: student.nim, ...res });
  }

  console.log(`[Proactive Engine] ✅ Completed cycle for ${students.length} students.`);
  return results;
}
