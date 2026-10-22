export const STRINGS = {
  AUTH: {
    LOGIN_SUCCESS: 'Login berhasil.',
    INVALID_CREDENTIALS: 'NIM atau password salah.',
    UNAUTHORIZED: 'Sesi kedaluwarsa atau token tidak valid.',
    USER_NOT_FOUND: 'Data pengguna tidak ditemukan.',
  },
  ACADEMIC: {
    ANNOUNCEMENT_CREATED: 'Pengumuman berhasil diposting dan diproses oleh sistem proaktif.',
    VALIDATION_FAILED: 'Data masukan tidak valid.',
  },
  NOTIFICATIONS: {
    FCM_REGISTERED: 'Perangkat berhasil didaftarkan untuk menerima notifikasi.',
  },
  SIMULATION: {
    CYCLE_SUCCESS: 'Siklus evaluasi proaktif selesai dijalankan.',
    COLLISION_TRIGGERED: 'Simulasi 3 tenggat bertabrakan berhasil dipicu.',
    ATTENDANCE_TRIGGERED: 'Simulasi peringatan kritis presensi berhasil dipicu.',
    PAYMENT_TRIGGERED: 'Simulasi tagihan mendesak berhasil dipicu.',
  },
} as const;
