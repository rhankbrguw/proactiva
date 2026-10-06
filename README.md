# ProActiva

Hybrid proactive academic notification system. Handles routine student events with deterministic rules and offloads complex deadline collisions and unstructured announcements to an LLM layer with automatic heuristic fallback.

Case study: Universitas Esa Unggul (simulated academic dataset based on official SIAKAD and LMS structures).

---

## What It Does

Most academic notifications fail because they rely on manual portal polling. ProActiva runs an autonomous evaluation cycle that scans upcoming academic events and dispatches notifications idempotently before students run into issues.

### Routing Logic

```
[ Academic Event / Cron ]
          │
          ├── Routine (Attendance <75%, Bill H-7/3/0, Timetable) ──> [ Rule Engine ] (<5ms)
          │
          └── Complex (≥3 Colliding Deadlines, Raw Announcements)  ──> [ LLM Layer ] (timeout: 8s)
                                                                            │
                                                                    (failed / timeout)
                                                                            │
                                                                            ▼
                                                                   [ Heuristic Fallback ]
```

- **Rule Engine**: Evaluates attendance threshold violations, bill due dates, and daily schedules deterministically. Zero token overhead.
- **LLM Layer**: Structured JSON extraction for free-text campus announcements and priority arbitration when three or more deadlines clash within 72 hours.
- **Fallback**: If the LLM call times out or errors, execution falls back immediately to date-based heuristic sorting. Nothing gets dropped.

---

## System Architecture

Layered clean architecture on both ends. Zero business logic in controllers, zero ORM calls leaking into domain services.

```
proactiva/
├── backend/
│   ├── prisma/             # Schema & Esa Unggul seed dataset
│   └── src/
│       ├── constants/      # Unified tokens, error codes, routes (zero magic strings)
│       ├── controllers/    # Input parsing & standardized envelope serialization
│       ├── services/       # Core business logic
│       ├── repositories/   # Prisma query abstraction
│       ├── schemas/        # Zod request validators
│       ├── proactive-engine/ # Rule evaluators, LLM prioritizer, idempotent dispatcher
│       └── queue/          # BullMQ worker & 15m cron scheduler
└── mobile/                 # Flutter mobile client (5 SIAKAD modules + DevicePreview)
```

---

## Quick Start

### 1. Services (Docker)

```bash
docker compose up -d
```

Starts PostgreSQL 16 on `:5432` and Redis 7 on `:6379`.

### 2. Backend

```bash
cd backend
npm install
cp .env.example .env
npx prisma db push
npx prisma db seed
npm run dev
```

- REST API: `http://localhost:4000`
- OpenAPI / Swagger: `http://localhost:4000/docs`

Seed credentials:
- NIM: `20220801055`
- Password: `password123`
- Student: Raihan Akbar Gunawan (Informatics, Semester 7)

### 3. Mobile App (Flutter)

```bash
cd mobile
flutter run -d linux   # or -d chrome / emulator
```

Preconfigured with DevicePreview for responsive inspection across Android and iOS viewports.

---

## Simulation Endpoints (For Demos & Defense)

Trigger proactive cycles on demand without waiting for scheduled crons:

```bash
# Run full evaluation cycle immediately
curl -X POST http://localhost:4000/api/simulation/run-cycle

# Inject 3 colliding assignments (forces LLM prioritizer)
curl -X POST http://localhost:4000/api/simulation/trigger-deadline-collision

# Simulate 3rd absence on CIE515 (forces UAS disqualification warning)
curl -X POST http://localhost:4000/api/simulation/trigger-attendance-risk

# Inject H-1 tuition due date
curl -X POST http://localhost:4000/api/simulation/trigger-urgent-payment

# Inspect Rule vs LLM dispatch ratio
curl http://localhost:4000/api/notifications/stats
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend Runtime | Node.js 22 (ESM) + TypeScript 5.8 |
| Framework | Fastify 5 |
| Database | PostgreSQL 16 via Prisma ORM |
| Queue & Cron | Redis 7 + BullMQ 5 |
| Client | Flutter 3.49 / Dart 3.13 |
| AI Integration | OpenAI / Gemini Structured Outputs + Deterministic Fallback |

---

## License

Academic research prototype — Universitas Esa Unggul. MIT.
