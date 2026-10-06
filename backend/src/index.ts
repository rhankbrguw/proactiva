import Fastify from 'fastify';
import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import swagger from '@fastify/swagger';
import swaggerUI from '@fastify/swagger-ui';
import { config } from './config/index.js';
import { API_ROUTES } from './constants/routes.js';
import { STRINGS } from './constants/strings.js';
import { handleGlobalError } from './errors/error.handler.js';
import { AuthException } from './errors/app.exception.js';
import { buildSuccessResponse } from './utils/response.js';
import { authRoutes } from './routes/auth.routes.js';
import { academicRoutes } from './routes/academic.routes.js';
import { notificationRoutes } from './routes/notifications.routes.js';
import { simulationRoutes } from './routes/simulation.routes.js';
import { startProactiveWorker } from './queue/proactive.worker.js';
import { initScheduler } from './queue/scheduler.js';

const app = Fastify({ logger: true });

async function bootstrap() {
  await app.register(cors, { origin: '*' });
  await app.register(jwt, { secret: config.jwtSecret });

  app.setErrorHandler(handleGlobalError);

  app.decorate('authenticate', async (request: any, _reply: any) => {
    try {
      await request.jwtVerify();
    } catch {
      throw new AuthException(STRINGS.AUTH.UNAUTHORIZED);
    }
  });

  await app.register(swagger, {
    openapi: {
      info: {
        title: 'ProActiva Academic Notification API',
        description: 'Hybrid Rule-LLM Proactive Engine API (Universitas Esa Unggul Case Study)',
        version: '1.0.0',
      },
    },
  });

  await app.register(swaggerUI, { routePrefix: '/docs' });

  await app.register(authRoutes);
  await app.register(academicRoutes);
  await app.register(notificationRoutes);
  await app.register(simulationRoutes);

  app.get(API_ROUTES.HEALTH, async (_request, reply) => {
    return reply.send(
      buildSuccessResponse({
        status: 'UP',
        service: 'ProActiva Engine',
        uptimeSeconds: Math.floor(process.uptime()),
      })
    );
  });

  startProactiveWorker();
  await initScheduler();

  try {
    await app.listen({ port: config.port, host: '0.0.0.0' });
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

bootstrap();
