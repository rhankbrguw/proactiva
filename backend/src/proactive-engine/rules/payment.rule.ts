import { NotificationPriority, NotificationSource, PaymentStatus } from '@prisma/client';
import { prisma } from '../../lib/prisma.js';
import { ProactiveNotificationPayload } from '../types.js';
import { NUMBERS } from '../../constants/numbers.js';

export async function evaluatePaymentRules(userId: string): Promise<ProactiveNotificationPayload[]> {
  const notifications: ProactiveNotificationPayload[] = [];
  const unpaidPayments = await prisma.payment.findMany({
    where: { userId, status: PaymentStatus.BELUM_LUNAS },
  });

  const now = new Date();

  for (const payment of unpaidPayments) {
    const dueDate = new Date(payment.jatuhTempo);
    const diffMs = dueDate.getTime() - now.getTime();
    const diffDays = Math.ceil(diffMs / (1000 * 60 * 60 * 24));
    const nominalRupiah = new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(payment.nominal);

    if (diffDays < 0) {
      notifications.push({
        userId,
        eventId: payment.id,
        tipe: 'PAYMENT_DUE',
        prioritas: NotificationPriority.URGENT,
        source: NotificationSource.RULE,
        judul: `🚨 Tagihan Melewati Jatuh Tempo: ${payment.jenis}`,
        pesan: `Tagihan ${payment.jenis} sebesar ${nominalRupiah} telah melewati batas jatuh tempo (${dueDate.toLocaleDateString('id-ID')}).`,
        payload: { paymentId: payment.id, nominal: payment.nominal, diffDays, rule: 'RULE_PAYMENT_OVERDUE' },
      });
    } else if (diffDays <= NUMBERS.PAYMENT_REMINDER_H1) {
      notifications.push({
        userId,
        eventId: payment.id,
        tipe: 'PAYMENT_DUE',
        prioritas: NotificationPriority.URGENT,
        source: NotificationSource.RULE,
        judul: `⚠️ Jatuh Tempo Pembayaran Hari Ini / Besok: ${payment.jenis}`,
        pesan: `Batas akhir pembayaran tagihan ${payment.jenis} sebesar ${nominalRupiah} adalah ${dueDate.toLocaleDateString('id-ID')}.`,
        payload: { paymentId: payment.id, nominal: payment.nominal, diffDays, rule: 'RULE_PAYMENT_H1_H0' },
      });
    } else if (diffDays <= NUMBERS.PAYMENT_REMINDER_H3) {
      notifications.push({
        userId,
        eventId: payment.id,
        tipe: 'PAYMENT_DUE',
        prioritas: NotificationPriority.HIGH,
        source: NotificationSource.RULE,
        judul: `💳 Pengingat Jatuh Tempo (H-3): ${payment.jenis}`,
        pesan: `Tagihan ${payment.jenis} sebesar ${nominalRupiah} akan jatuh tempo dalam ${diffDays} hari lagi (${dueDate.toLocaleDateString('id-ID')}).`,
        payload: { paymentId: payment.id, nominal: payment.nominal, diffDays, rule: 'RULE_PAYMENT_H3' },
      });
    } else if (diffDays <= NUMBERS.PAYMENT_REMINDER_H7) {
      notifications.push({
        userId,
        eventId: payment.id,
        tipe: 'PAYMENT_DUE',
        prioritas: NotificationPriority.MEDIUM,
        source: NotificationSource.RULE,
        judul: `🗓️ Pengingat Pembayaran (H-7): ${payment.jenis}`,
        pesan: `Tagihan ${payment.jenis} sebesar ${nominalRupiah} akan jatuh tempo pada tanggal ${dueDate.toLocaleDateString('id-ID')}.`,
        payload: { paymentId: payment.id, nominal: payment.nominal, diffDays, rule: 'RULE_PAYMENT_H7' },
      });
    }
  }

  return notifications;
}
