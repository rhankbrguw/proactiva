export const API_ROUTES = {
  HEALTH: '/api/health',
  AUTH: {
    LOGIN: '/api/auth/login',
    ME: '/api/auth/me',
  },
  ACADEMIC: {
    COURSES: '/api/courses',
    SCHEDULES: '/api/schedules',
    ASSIGNMENTS: '/api/assignments',
    ATTENDANCE: '/api/attendance',
    PAYMENTS: '/api/payments',
    ANNOUNCEMENTS: '/api/announcements',
  },
  NOTIFICATIONS: {
    LIST: '/api/notifications',
    STATS: '/api/notifications/stats',
    FCM_TOKEN: '/api/notifications/fcm-token',
  },
  SIMULATION: {
    RUN_CYCLE: '/api/simulation/run-cycle',
    COLLISION: '/api/simulation/trigger-deadline-collision',
    ATTENDANCE_RISK: '/api/simulation/trigger-attendance-risk',
    URGENT_PAYMENT: '/api/simulation/trigger-urgent-payment',
  },
} as const;
