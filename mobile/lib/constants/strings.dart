class AppStrings {
  static const String appName = 'ProActiva';
  static const String appTagline = 'Sistem Notifikasi Akademik Proaktif';
  static const String caseStudyName = 'Universitas Esa Unggul';
  static const String academicYear = 'Semester Ganjil 2026 - 2027';

  // Auth
  static const String loginTitle = 'Portal Akademik Mahasiswa';
  static const String loginSubtitle = 'Single Sign On Universitas Esa Unggul';
  static const String nimLabel = 'Nomor Induk Mahasiswa (NIM)';
  static const String nimHint = '20220801055';
  static const String passwordLabel = 'Kata Sandi';
  static const String passwordHint = '••••••••';
  static const String loginButton = 'Masuk Portal SIAKAD';

  // Navigation Tabs
  static const String tabHome = 'Beranda';
  static const String tabSchedule = 'Jadwal';
  static const String tabAttendance = 'Presensi';
  static const String tabLms = 'LMS / Tugas';
  static const String tabFinance = 'Tagihan';

  // Dashboard & Proactive Alerts
  static const String alertAttendanceWarning = 'Perhatian! Ada presensi di bawah 75%!';
  static const String alertNextClassPrefix = 'Kuliah berikutnya: ';
  static const String quickAccessTitle = 'Akses Cepat';
  static const String todayClassesTitle = 'Jadwal Kuliah Hari Ini';
  static const String recentAnnouncementsTitle = 'Pengumuman BAP Terbaru';
  static const String emptySchedule = 'Tidak ada perkuliahan untuk hari ini.';

  // Attendance Module
  static const String attendanceTitle = 'Status Presensi & Nilai';
  static const String attendanceSubtitle = 'Ambang batas minimum kehadiran 75% (Pedoman Akademik BAP)';
  static const String absenceQuotaWarning = 'Peringatan: 2 kali alpha lagi tidak memenuhi syarat UTS/UAS.';
  static const String sessionLabel = 'Sesi';

  // Schedule Module
  static const String scheduleTitle = 'Jadwal Perkuliahan';
  static const String weeklyView = 'Jadwal Mingguan';
  static const String dailyView = 'Jadwal Harian';
  static const String roomLabel = 'Ruang';
  static const String faceToFace = 'Tatap Muka';

  // LMS / Assignment Module
  static const String lmsTitle = 'E-Learning & Tugas Kuliah';
  static const String myCoursesTitle = 'Mata Kuliah Semester Ini';
  static const String collidingDeadlinesBadge = '⚡ 3 Tugas Bentrok (Prioritisasi AI)';
  static const String submittedStatus = 'Submitted for grading';
  static const String dueSoonStatus = 'Mendekati Tenggat';

  // Finance Module
  static const String financeTitle = 'Status Tagihan & Keuangan';
  static const String totalBilled = 'Total Tagihan';
  static const String totalPaid = 'Sudah Dibayar';
  static const String totalUnpaid = 'Belum Lunas';
  static const String milestoneH3 = 'Peringatan H-3 Jatuh Tempo';

  // Notifications
  static const String notificationCenterTitle = 'Pusat Notifikasi Proaktif';
  static const String filterAll = 'Semua';
  static const String filterAi = '⚡ LLM Prioritas';
  static const String filterRule = '⚙️ Heuristik / Rule';
  static const String emptyNotifications = 'Belum ada notifikasi proaktif baru.';

  // Announcements
  static const String announcementsTitle = 'Pengumuman Akademik BAP';
  static const String extractedActionLabel = '👉 Rekomendasi Aksi:';
  static const String extractedDeadlineLabel = '⏳ Batas Waktu:';

  // Profile & Dialog
  static const String profileTitle = 'Biodata Mahasiswa';
  static const String changePasswordTitle = 'Ganti Password';
  static const String oldPasswordLabel = 'Password Lama';
  static const String newPasswordLabel = 'Password Baru';
  static const String confirmPasswordLabel = 'Konfirmasi Password Baru';
  static const String savePasswordBtn = 'Simpan Perubahan';
  static const String logoutBtn = 'Keluar dari Akun';
  static const String greetingPrefix = 'Halo, ';
  static const String urgentActionsTitle = 'Rekomendasi Prioritas Mendesak';
  static const String attendanceHealthTitle = 'Status Presensi & Batas Ujian';
  static const String upcomingTuitionTitle = 'Informasi Tagihan & UKT';

  // Simulation Panel
  static const String simulationDrawerTitle = 'Panel Pengujian Sidang Skripsi';
  static const String triggerCollisionBtn = '⚡ Simulasikan 3 Tugas Bentrok (LLM)';
  static const String triggerAttendanceBtn = '⚠️ Simulasikan Absen ke-3 (Batas 75%)';
  static const String triggerPaymentBtn = '💳 Simulasikan Tagihan H-1 Jatuh Tempo';
  static const String triggerCycleBtn = '🔄 Jalankan Evaluasi Proaktif Sekarang';
}
