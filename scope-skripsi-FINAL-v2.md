# Scope Skripsi (FINAL v2): Sistem Notifikasi Akademik Proaktif dengan Arsitektur Hybrid Rule-Based dan LLM

> Revisi setelah arahan dosbing: hapus framing perbandingan (akurasi/biaya/latensi vs sistem lain) dari rumusan masalah, scope difokuskan ke kegiatan mahasiswa, data harus dari BAP + kuesioner (bukan preferensi pribadi).

---

## 0. Judul

**ID:** Sistem Notifikasi Akademik Proaktif dengan Arsitektur Hybrid Rule-Based dan Large Language Model untuk Prioritisasi Tenggat Mahasiswa: Studi Kasus Prototipe Aplikasi Mobile Universitas Esa Unggul

**EN:** A Proactive Academic Notification System with a Hybrid Rule-Based and Large Language Model Architecture for Student Deadline Prioritization: A Case Study of a Mobile Application Prototype at Universitas Esa Unggul

**Topik (form sempro):** Kecerdasan Buatan dan Otomatisasi Mobile / AI and Mobile Automation

**Studi kasus:** Universitas Esa Unggul (struktur data mengacu pada SIAKAD + LMS kampus, data pengujian simulasi/dummy)

---

## 1. Identifikasi Masalah (dari observasi SIAKAD asli, bukan asumsi pribadi)

| Temuan di SIAKAD Esa Unggul | Masalah |
|---|---|
| Menu Pengumuman berisi daftar campur (susulan UTS/UAS, wisuda, registrasi semester, remedial) sebagai teks/list biasa | Tenggat administratif mudah terlewat karena tidak ada penanda urgensi |
| Banner "Kuliah berikutnya X hari lagi" hanya untuk jadwal kelas | Mekanisme proaktif sudah ada tapi terbatas pada 1 jenis event |
| Tagihan/Pembayaran adalah menu terpisah, harus dibuka manual | Tidak ada dorongan aktif menjelang jatuh tempo |
| Nilai & Presensi menampilkan data kehadiran, tapi pasif (mahasiswa harus cek sendiri) | Risiko baru sadar setelah kehadiran sudah di bawah ambang minimum, saat sudah terlambat untuk memperbaiki |
| LMS (tugas, kuis, UAS take-home) terpisah total dari SIAKAD | Mahasiswa harus memantau lebih dari satu portal untuk semua tenggat |

**Catatan penting:** identifikasi masalah ini harus diperkuat dengan data BAP (observasi struktur data resmi) dan kuesioner (validasi bahwa mahasiswa lain memang mengalami hal serupa) — bukan disajikan sebagai keluhan/preferensi pribadi penulis.

---

## 2. Rumusan Masalah (versi deskriptif, tanpa framing perbandingan)

1. Bagaimana arsitektur hybrid *rule-based* dan LLM dirancang agar dapat secara otomatis menentukan jalur pemrosesan pada sistem notifikasi akademik proaktif, termasuk mekanisme *fallback* saat komponen LLM gagal?
2. Bagaimana mekanisme LLM diterapkan untuk memprioritaskan tenggat yang bertabrakan dan mengekstraksi informasi tenggat dari teks pengumuman yang tidak terstruktur?
3. Bagaimana arsitektur ini dirancang agar tetap efisien secara biaya dan andal dalam pengiriman notifikasi?

**Dihindari secara sengaja:** kata "dibandingkan", "akurasi vs heuristik", "hybrid vs all-LLM" — pengukuran semacam ini boleh tetap dilakukan secara internal di BAB IV sebagai evaluasi teknis, tapi tidak dijanjikan di rumusan masalah/tujuan agar tidak dituntut membangun sistem pembanding terpisah.

---

## 3. Scope Modul — 5 Modul, Fokus Kegiatan Mahasiswa

| # | Modul | Sumber Data | Jalur Pemrosesan | Peran |
|---|-------|-------------|-------------------|-------|
| 1 | **Tenggat Tugas/Kuis** | LMS (simulasi) | Rule (reminder H-3/H-1/H-0) → **LLM** saat ≥3 tenggat bertabrakan (prioritisasi) | Inti riset — kasus LLM #1 |
| 2 | **Pengumuman Akademik** | SIAKAD (teks bebas: susulan UTS/UAS, registrasi, wisuda, remedial) | **LLM** ekstraksi tanggal & aksi dari teks tidak terstruktur, divalidasi rule | Inti riset — kasus LLM #2 |
| 3 | **Tagihan (UKT/SPP)** | SIAKAD | Rule (reminder H-7/H-3/H-0, eskalasi saat lewat jatuh tempo) | Volume event rule-based, uji delivery reliability |
| 4 | **Jadwal Kuliah** | SIAKAD | Rule (reminder + notifikasi perubahan real-time) | Uji latency event-driven |
| 5 | **Presensi (Ambang Kehadiran)** | SIAKAD — menu Nilai & Presensi | Rule (hitung jumlah absen per matkul vs ambang minimum, mis. 75%) | Volume event rule-based, urgensi tinggi (risiko tidak boleh UTS/UAS) |

**Di luar scope (future work):** KRS, Ekivalensi, Program Akademik (KKN/KKP/Project Based/Kampus Berdampak), Tugas Akhir (sudah ada tracking sendiri di SIAKAD), Konseling, Dokumen, Referensi/Kurikulum, ringkasan tren IPK/IPS (sudah divisualisasikan SIAKAD), integrasi payment gateway asli, integrasi live ke basis data kampus, multi-tenant.

**Catatan presensi:** angka ambang (75%) masih asumsi berdasarkan standar umum kampus Indonesia — **wajib diverifikasi saat BAP** ke pedoman akademik resmi Esa Unggul (ada menu "Pedoman Akademik Mahasiswa" di SIAKAD) sebelum dikunci di BAB III.

---

## 4. AI Automation Layer

| Trigger Event | Rule-Based (default) | LLM (dipanggil selektif) |
|---|---|---|
| Tenggat tugas/kuis mendekat | Reminder H-3/H-1/H-0 | Jika ≥3 tenggat bertabrakan → LLM tentukan urutan prioritas + alasan (function calling) |
| Pengumuman baru masuk | — | LLM ekstrak tanggal, jenis aksi, siapa yang terkena → divalidasi rule (format tanggal, rentang wajar) sebelum dikirim sebagai notifikasi |
| Tagihan jatuh tempo | Reminder H-7/H-3/H-0, eskalasi | — |
| Jadwal berubah | Push instan | — |
| Kehadiran mendekati/melewati ambang | Peringatan bertingkat (absen ke-2, absen ke-3) | — |

**Fallback/Graceful Degradation:** jika LLM API timeout/gagal, sistem tetap kirim notifikasi rule-based (tenggat, tagihan, jadwal, presensi tidak terganggu). Untuk pengumuman dan prioritisasi, sistem menahan notifikasi non-kritis atau memakai fallback sederhana (urutan berdasar tanggal terdekat) sampai LLM kembali tersedia.

---

## 5. Pengumpulan Data

| Tahap | Isi | Tujuan |
|---|---|---|
| 1. Surat izin penelitian | Sudah selesai, ke BAP | Dasar legal observasi & kuesioner |
| 2. Observasi BAP | Struktur data resmi: field SIAKAD, aturan presensi resmi, alur tagihan | Memastikan skema dummy dan aturan (mis. ambang presensi) sesuai kondisi nyata kampus, bukan tebakan |
| 3. Kuesioner ke mahasiswa lain | Seberapa sering melewatkan tenggat karena harus cek banyak sumber/menu; pengalaman dengan notifikasi SIAKAD saat ini | Validasi bahwa masalah ini nyata dialami banyak mahasiswa, bukan preferensi pribadi penulis |

**Penting:** kuesioner TIDAK bertanya "apakah kamu mau aplikasi seperti ini" — itu preferensi, ditolak dosbing. Fokus ke pengalaman aktual mereka dengan sistem yang ada.

---

## 6. Tech Stack (tidak berubah)

- **Backend:** Bun + Elysia (alternatif: Fastify)
- **Database:** PostgreSQL
- **Queue/Scheduler:** Redis + BullMQ
- **Delivery:** Firebase Cloud Messaging (FCM); WebSocket opsional untuk real-time saat app dibuka
- **LLM:** Claude Haiku atau GPT-4o-mini, function calling
- **Mobile:** React Native atau Flutter
- **Auth:** JWT

---

## 7. Skeleton Database (update: tambah tabel presensi)

```
users (id, nama, nim, role)
courses (id, nama_matkul, sks, dosen)
enrollments (user_id, course_id, semester)
schedules (course_id, hari, jam, ruang)
assignments (id, course_id, judul, deadline, jenis: tugas/kuis)
attendance (id, user_id, course_id, tanggal, status: hadir/absen, total_absen_running)
payments (user_id, jenis, nominal, jatuh_tempo, status)
announcements (id, judul, isi_teks, tanggal_terbit, extracted_deadline, extracted_action, source: manual/llm_extracted)
notifications (id, event_id, user_id, tipe, prioritas, source: rule/llm, payload, status: sent/delivered/failed, sent_at)
```

- `attendance.total_absen_running` → dipakai trigger peringatan bertingkat (absen ke-2, ke-3).
- `announcements.extracted_deadline/extracted_action` → hasil ekstraksi LLM, divalidasi sebelum jadi notifikasi.
- `notifications.source` dan `event_id` tetap seperti scope sebelumnya (rasio rule/LLM, idempotency).

---

## 8. Batasan Masalah (final)

1. Sistem adalah prototipe/proof-of-concept, bukan pengganti atau bagian resmi SIAKAD Universitas Esa Unggul.
2. Data pengujian bersifat simulasi (dummy), menyerupai struktur data hasil observasi BAP, bukan data mahasiswa sesungguhnya.
3. Modul yang diuji: tenggat tugas/kuis (LMS), pengumuman akademik, tagihan, jadwal kuliah, dan presensi (ambang kehadiran). Modul lain (KRS, Tugas Akhir, Konseling, dll) di luar cakupan.
4. Tidak mencakup integrasi payment gateway asli maupun integrasi live ke basis data kampus.
5. Studi kasus terbatas pada satu institusi (Universitas Esa Unggul), tidak diklaim berlaku umum.
6. Ambang presensi mengacu pada pedoman akademik resmi kampus (diverifikasi saat BAP), bukan asumsi pribadi.
7. Evaluasi tren nilai (IPK/IPS) di luar fokus karena sudah tersedia visualisasinya di SIAKAD.
8. Pengembangan lanjut (integrasi live, multi-tenant, rekomendasi strategi belajar) diarahkan sebagai saran BAB V.

---

## 9. Yang Sengaja Dihindari (permintaan dosbing)

- ❌ Rumusan masalah/tujuan berbunyi "dibandingkan dengan heuristik/all-LLM/regex" → dihapus, diganti deskriptif arsitektur.
- ❌ Kuesioner bertanya preferensi/opini pribadi soal aplikasi ini → diganti pertanyaan pengalaman aktual.
- ❌ Latar belakang berbasis klaim pribadi tanpa data → wajib disandingkan BAP + kuesioner.
- ❌ Scope modul di luar "kegiatan mahasiswa" (administratif satu-arah seperti KRS/Ekivalensi) → tidak diadopsi.
