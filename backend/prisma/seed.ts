import { PrismaClient, Role, AssignmentType, AttendanceStatus, PaymentStatus, AnnouncementSource } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database for Universitas Esa Unggul dummy dataset...');

  // Clean old data
  await prisma.notification.deleteMany();
  await prisma.announcement.deleteMany();
  await prisma.payment.deleteMany();
  await prisma.attendance.deleteMany();
  await prisma.assignment.deleteMany();
  await prisma.schedule.deleteMany();
  await prisma.enrollment.deleteMany();
  await prisma.course.deleteMany();
  await prisma.user.deleteMany();

  // 1. Create Users
  const student = await prisma.user.create({
    data: {
      nim: '20220801055',
      nama: 'Raihan Akbar Gunawan',
      password: 'password123',
      role: Role.MAHASISWA,
    },
  });

  const lecturer = await prisma.user.create({
    data: {
      nim: '198203152010',
      nama: 'DR. FRANSISKUS ADIKARA, S.Kom., M.MSI',
      password: 'password123',
      role: Role.DOSEN,
    },
  });

  console.log(`Created user: ${student.nama} (${student.nim})`);

  // 2. Create Courses (Authentic Esa Unggul SIAKAD & LMS structure)
  const c1 = await prisma.course.create({
    data: {
      kodeMatkul: 'CIE515',
      namaMatkul: 'Pengembangan Perangkat Lunak',
      sks: 3,
      dosen: 'DR. FRANSISKUS ADIKARA, S.Kom., M.MSI',
    },
  });

  const c2 = await prisma.course.create({
    data: {
      kodeMatkul: 'CIE722',
      namaMatkul: 'Jaringan Komputer Lanjut',
      sks: 3,
      dosen: 'NUGROHO BUDHISANTO SA, ST, MMSI',
    },
  });

  const c3 = await prisma.course.create({
    data: {
      kodeMatkul: 'CIE723',
      namaMatkul: 'Kapita Selekta Informatika',
      sks: 3,
      dosen: 'TRATIANI ARYANI , ST, M.Kom',
    },
  });

  const c4 = await prisma.course.create({
    data: {
      kodeMatkul: 'CIE721',
      namaMatkul: 'Sistem Basis Data Terdistribusi',
      sks: 2,
      dosen: 'ALFIYA HADIFA , S.Kom., M.Kom',
    },
  });

  // 3. Enroll Student
  for (const c of [c1, c2, c3, c4]) {
    await prisma.enrollment.create({
      data: {
        userId: student.id,
        courseId: c.id,
        semester: 'Semester Ganjil 2026 - 2027',
      },
    });
  }

  // 4. Schedules (Rabu & Kamis)
  await prisma.schedule.createMany({
    data: [
      { courseId: c1.id, hari: 'Rabu', jamMulai: '13:00', jamSelesai: '15:30', ruang: 'RE112' },
      { courseId: c3.id, hari: 'Rabu', jamMulai: '15:30', jamSelesai: '18:00', ruang: 'PK207' },
      { courseId: c2.id, hari: 'Kamis', jamMulai: '13:00', jamSelesai: '15:30', ruang: 'RE111' },
      { courseId: c4.id, hari: 'Kamis', jamMulai: '15:30', jamSelesai: '18:00', ruang: 'RE210' },
    ],
  });

  // 5. Assignments (Collision Scenario: 3 assignments due within 3 days -> triggers LLM Prioritizer)
  const now = new Date();
  const dueIn1Day = new Date(now.getTime() + 1 * 24 * 60 * 60 * 1000);
  const dueIn2Days = new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000);
  const dueIn3Days = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);
  const dueIn6Days = new Date(now.getTime() + 6 * 24 * 60 * 60 * 1000);

  await prisma.assignment.createMany({
    data: [
      {
        courseId: c1.id,
        judul: 'Tugas Latihan 1: Agile Manifesto vs RUP Case Study',
        deskripsi: 'Jelaskan 4 nilai Agile Manifesto dan berikan studi kasus implementasi Rational Unified Process pada sistem akademik.',
        deadline: dueIn1Day,
        jenis: AssignmentType.TUGAS,
      },
      {
        courseId: c2.id,
        judul: 'Konfigurasi BGP Routing & Subnetting IPv6',
        deskripsi: 'Simulasi topology jaringan multi-AS menggunakan GNS3/Cisco Packet Tracer dengan dokumentasi routing table.',
        deadline: dueIn2Days,
        jenis: AssignmentType.TUGAS,
      },
      {
        courseId: c3.id,
        judul: 'Kuis Sesi 1: State-of-the-Art Generative AI',
        deskripsi: 'Kuis online 25 butir soal di E-Learning mengenai arsitektur Transformer dan Retrieval-Augmented Generation.',
        deadline: dueIn3Days,
        jenis: AssignmentType.KUIS,
      },
      {
        courseId: c4.id,
        judul: 'Desain Fragmentasi Horizontal Database SIAKAD',
        deskripsi: 'Rancang arsitektur two-phase commit dan replikasi multi-master PostgreSQL untuk skalabilitas SIAKAD.',
        deadline: dueIn6Days,
        jenis: AssignmentType.TUGAS,
      },
    ],
  });

  // 6. Attendance (2 absences on CIE515 -> triggers 75% threshold warning alert)
  await prisma.attendance.createMany({
    data: [
      { userId: student.id, courseId: c1.id, status: AttendanceStatus.ABSEN, totalAbsenRunning: 1 },
      { userId: student.id, courseId: c1.id, status: AttendanceStatus.ABSEN, totalAbsenRunning: 2 },
      { userId: student.id, courseId: c2.id, status: AttendanceStatus.HADIR, totalAbsenRunning: 0 },
      { userId: student.id, courseId: c3.id, status: AttendanceStatus.HADIR, totalAbsenRunning: 0 },
      { userId: student.id, courseId: c4.id, status: AttendanceStatus.HADIR, totalAbsenRunning: 0 },
    ],
  });

  // 7. Payments (Upcoming semester fee due in 3 days)
  const duePayment = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);
  await prisma.payment.create({
    data: {
      userId: student.id,
      jenis: 'Biaya Semester Reguler TA 2026/2027',
      nominal: 2900000,
      jatuhTempo: duePayment,
      status: PaymentStatus.BELUM_LUNAS,
    },
  });

  // 8. Announcements (Official BAP Esa Unggul announcements)
  await prisma.announcement.createMany({
    data: [
      {
        judul: 'Pendaftaran Susulan UTS/UAS Semester Antara Genap TA 2025/2026',
        isiTeks: 'Diberitahukan kepada seluruh mahasiswa Universitas Esa Unggul bahwa batas akhir pendaftaran dan pembayaran ujian susulan/remedial adalah tanggal 15 Oktober 2026 pukul 16:00 WIB di BAP. Mahasiswa wajib melampirkan bukti verifikasi sakit/dinas.',
        tanggalTerbit: now,
        source: AnnouncementSource.MANUAL,
      },
      {
        judul: 'Pendaftaran Wisuda Periode Oktober 2026',
        isiTeks: 'Pendaftaran wisuda dibuka hingga 25 Oktober 2026. Mahasiswa yang telah menyelesaikan sidang skripsi dan bebas pustaka diwajibkan melakukan registrasi kelengkapan toga.',
        tanggalTerbit: now,
        source: AnnouncementSource.MANUAL,
      },
    ],
  });

  console.log('✅ Seed data successfully loaded for Esa Unggul!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
