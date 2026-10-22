# ProActiva

Hybrid proactive academic notification system. Node.js backend with deterministic rule evaluators, BullMQ job queues, and an LLM prioritization layer with heuristic fallback. Flutter mobile client mirroring Universitas Esa Unggul's SIAKAD and LMS modules.

---

Clone it, copy `backend/.env.example` to `backend/.env`, then run with Docker or natively.

Database & Cache: `docker compose up -d` (runs Postgres on `:5432`, Redis on `:6379`).

Backend: `cd backend && npm install && npx prisma db push && npx prisma db seed && npm run dev` (runs on `:4000`, Swagger on `:4000/docs`). Seeds Raihan Akbar Gunawan (`20220801055` / `password123`).

Client (Flutter): `cd mobile && flutter pub get && flutter run` (runs with DevicePreview for responsive device testing).

Simulation Endpoints: `curl -X POST http://localhost:4000/api/simulation/run-cycle` (also supports `/trigger-deadline-collision`, `/trigger-attendance-risk`, and `/trigger-urgent-payment`).

Quality Verification: `cd backend && npm run build` and `cd mobile && flutter analyze && flutter test`.

---

Requires Node 22+, Flutter 3.49+, Docker, PostgreSQL 16, Redis 7.
