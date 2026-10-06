"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
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
            nim: '20220801001',
            nama: 'Ahmad Fauzi',
            password: 'password123',
            role: client_1.Role.MAHASISWA,
        },
    });
    const lecturer = await prisma.user.create({
        data: {
            nim: '198501012010',
            nama: 'Dr. Ir. Budi Santoso, M.Kom.',
            password: 'password123',
            role: client_1.Role.DOSEN,
        },
    });
    console.log(`Created user: ${student.nama} (${student.nim})`);
    // 2. Create Courses (SIAKAD Esa Unggul structure)
    const c1 = await prisma.course.create({
        data: {
            kodeMatkul: 'INF401',
            namaMatkul: 'Kecerdasan Buatan',
            sks: 3,
            dosen: 'Dr. Ir. Budi Santoso, M.Kom.',
        },
    });
    const c2 = await prisma.course.create({
        data: {
            kodeMatkul: 'INF402',
            namaMatkul: 'Rekayasa Perangkat Lunak',
            sks: 3,
            dosen: 'Siti Rahmawati, S.Kom., M.T.',
        },
    });
    const c3 = await prisma.course.create({
        data: {
            kodeMatkul: 'INF403',
            namaMatkul: 'Pemrograman Web Lanjut',
            sks: 3,
            dosen: 'Eko Prasetyo, M.Cs.',
        },
    });
    const c4 = await prisma.course.create({
        data: {
            kodeMatkul: 'INF404',
            namaMatkul: 'Sistem Informasi Manajemen',
            sks: 2,
            dosen: 'Dewi Lestari, S.T., M.M.',
        },
    });
    // 3. Enroll Student
    for (const c of [c1, c2, c3, c4]) {
        await prisma.enrollment.create({
            data: {
                userId: student.id,
                courseId: c.id,
                semester: '2026/2027 Ganjil',
            },
        });
    }
    // 4. Schedules
    await prisma.schedule.createMany({
        data: [
            { courseId: c1.id, hari: 'Senin', jamMulai: '08:00', jamSelesai: '10:30', ruang: 'Lab Komputer 3' },
            { courseId: c2.id, hari: 'Selasa', jamMulai: '10:45', jamSelesai: '13:15', ruang: 'R. 402' },
            { courseId: c3.id, hari: 'Rabu', jamMulai: '13:30', jamSelesai: '16:00', ruang: 'Lab Basis Data' },
            { courseId: c4.id, hari: 'Kamis', jamMulai: '08:00', jamSelesai: '09:40', ruang: 'R. 301' },
        ],
    });
    // 5. Assignments (Include Collision Scenario: 3 assignments due on the same date/near)
    const now = new Date();
    const dueIn2Days = new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000);
    const dueIn2DaysPM = new Date(now.getTime() + (2 * 24 + 4) * 60 * 60 * 1000);
    const dueIn2DaysNight = new Date(now.getTime() + (2 * 24 + 10) * 60 * 60 * 1000);
    const dueIn5Days = new Date(now.getTime() + 5 * 24 * 60 * 60 * 1000);
    await prisma.assignment.createMany({
        data: [
            {
                courseId: c1.id,
                judul: 'Implementasi Algoritma A* & BFS Search',
                deskripsi: 'Buat implementasi pencarian rute terpendek dengan GUI sederhana dan analisis kompleksitas waktu.',
                deadline: dueIn2Days,
                jenis: client_1.AssignmentType.TUGAS,
            },
            {
                courseId: c2.id,
                judul: 'Dokumen SRS & Diagram UML Sistem Kasir',
                deskripsi: 'Susun Software Requirement Specification (SRS) lengkap dengan Use Case, Activity Diagram, dan Class Diagram.',
                deadline: dueIn2DaysPM,
                jenis: client_1.AssignmentType.TUGAS,
            },
            {
                courseId: c3.id,
                judul: 'Kuis Online 02: RESTful API Security & JWT',
                deskripsi: 'Kuis online 20 soal pilihan ganda & studi kasus token expiry di LMS.',
                deadline: dueIn2DaysNight,
                jenis: client_1.AssignmentType.KUIS,
            },
            {
                courseId: c4.id,
                judul: 'Analisis Studi Kasus ERP PT Semen Indonesia',
                deskripsi: 'Buat makalah 5 halaman terkait implementasi modul SAP/ERP pada perusahaan manufaktur.',
                deadline: dueIn5Days,
                jenis: client_1.AssignmentType.TUGAS,
            },
        ],
    });
    // 6. Attendance (Simulate nearing threshold: e.g. 2 absences in INF401)
    await prisma.attendance.createMany({
        data: [
            { userId: student.id, courseId: c1.id, status: client_1.AttendanceStatus.ABSEN, totalAbsenRunning: 1 },
            { userId: student.id, courseId: c1.id, status: client_1.AttendanceStatus.ABSEN, totalAbsenRunning: 2 },
            { userId: student.id, courseId: c2.id, status: client_1.AttendanceStatus.HADIR, totalAbsenRunning: 0 },
            { userId: student.id, courseId: c3.id, status: client_1.AttendanceStatus.HADIR, totalAbsenRunning: 0 },
        ],
    });
    // 7. Payments (Upcoming UKT due date in 3 days)
    const duePayment = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);
    await prisma.payment.create({
        data: {
            userId: student.id,
            jenis: 'UKT / Biaya Kuliah Semester Ganjil 2026/2027',
            nominal: 7500000,
            jatuhTempo: duePayment,
            status: client_1.PaymentStatus.BELUM_LUNAS,
        },
    });
    // 8. Announcements (Unstructured text simulating official SIAKAD announcement)
    await prisma.announcement.create({
        data: {
            judul: 'Pemberitahuan Pendaftaran Ujian Remedial / Susulan UTS Semester Ganjil',
            isiTeks: `Diberitahukan kepada seluruh mahasiswa Universitas Esa Unggul yang belum mengikuti UTS atau bermaksud mengajukan Remedial/Ujian Susulan, batas akhir pendaftaran dan pembayaran administrasi susulan adalah tanggal 15 Oktober 2026 pukul 16:00 WIB melalui loket BAP / DAAK. Mahasiswa wajib melampirkan surat keterangan sakit atau dinas resmi. Lewat dari tenggat tersebut tidak akan dilayani.`,
            tanggalTerbit: now,
            source: client_1.AnnouncementSource.MANUAL,
        },
    });
    console.log('✅ Seed data successfully loaded!');
}
main()
    .catch((e) => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
