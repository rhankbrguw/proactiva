# AGENTS.md

> Read this file before every task. The global `engineering-standards` skill applies
> to all code. This file provides project-specific context that overrides or extends it.

---

## Project

```
name    : ProActiva (Proactive Academic Notification System)
stack   : TypeScript (Node.js 22 + Fastify) + Flutter / Dart (Mobile App)
arch    : Layered Hybrid (REST API + Rule Engine + LLM Layer + BullMQ Worker + Mobile App)
db      : PostgreSQL 16 (Prisma ORM) + Redis 7 (BullMQ)
```

## Active Stack Rules

```
stacks: [typescript, flutter]
```

## Folder Structure

```
proactiva/
├── docker-compose.yml             # PostgreSQL 16 & Redis 7
├── README.md                      # Project overview & running instructions
├── AGENTS.md                      # Project guidelines & AI rules
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma          # 9 academic data tables
│   │   └── seed.ts                # Esa Unggul dummy dataset
│   ├── src/
│   │   ├── config/                # Validated environment configuration
│   │   ├── lib/                   # Database & client singletons (Prisma, Redis, LLM)
│   │   ├── constants/             # Unified constants (errors, messages, routes)
│   │   ├── proactive-engine/      # Core hybrid proactive intelligence
│   │   │   ├── types.ts           # Type definitions for events & payloads
│   │   │   ├── evaluator.ts       # Central orchestration evaluator
│   │   │   ├── dispatcher.ts      # Idempotent notification dispatcher
│   │   │   ├── rules/             # Rule-based modules (Attendance, Payment, Schedule, Deadline)
│   │   │   └── llm/               # LLM automation layer (Prioritizer, Extractor, Fallback)
│   │   ├── queue/                 # BullMQ queue, worker, and cron scheduler
│   │   ├── routes/                # Fastify REST endpoints (Auth, Academic, Notifications, Simulation)
│   │   └── index.ts               # Server startup & plugin registration
│   ├── package.json
│   └── tsconfig.json
└── mobile/                        # Flutter mobile application prototype
```

## Error Code Registry

| Code               | Status | Meaning                                 |
| ------------------ | ------ | --------------------------------------- |
| `VALIDATION_ERROR` | 422    | Input validation failed                 |
| `UNAUTHENTICATED`  | 401    | Missing or invalid JWT token            |
| `UNAUTHORIZED`     | 403    | Insufficient role permissions           |
| `NOT_FOUND`        | 404    | Academic resource / user does not exist |
| `CONFLICT`         | 409    | Duplicate record or constraint violated |
| `LLM_FALLBACK`     | 200    | LLM failed; degraded gracefully to rule |
| `INTERNAL_ERROR`   | 500    | Unexpected system or worker failure     |

## ProActiva Domain Rules (Hybrid Architecture)

1. **Rule vs LLM Boundary**:
   - Routine & high-volume events (Attendance thresholds $\ge 75\%$, Payment H-7/H-3/H-0, Daily Schedules, Single Assignment reminders) MUST be processed via Rule-Based engine.
   - LLM is invoked strictly for: (1) Colliding deadlines ($\ge 3$ tasks in 3 days), (2) Unstructured announcement text extraction.
2. **Graceful Degradation**:
   - If LLM API times out (>8s) or errors, system MUST immediately fallback to heuristic rule sorting/parsing. Never fail a notification cycle.
3. **Idempotency**:
   - Never send duplicate notifications for the same event and state within 24 hours.
4. **Data Isolation**:
   - All tests and seeds use simulated Esa Unggul academic data structures; no direct campus network integration.

## Agent Constraints

Must:
- Adhere to `engineering-standards` (max 150 lines per file, max 30 lines per function, 3 nesting levels max).
- Add new strings/colors/routes to constants layer before referencing.
- Propose approach before touching more than one file.
- Follow standardized API response envelope (`{ success, code, message, data, meta }`).

Must not:
- Hardcode magic numbers, strings, or inline colors.
- Leave TODOs, placeholders, or debug console logs in final code.
- Exceed 150 lines per file or 30 lines per function.
