import { z } from 'zod';
import { ValidationException } from '../errors/app.exception.js';

export const loginInputSchema = z.object({
  nim: z.string().min(3, 'NIM minimal 3 karakter'),
  password: z.string().min(6, 'Password minimal 6 karakter'),
});

export type LoginInput = z.infer<typeof loginInputSchema>;

export function validateSchema<T>(schema: z.ZodSchema<T>, rawData: unknown): T {
  const result = schema.safeParse(rawData);
  if (!result.success) {
    const errorMap: Record<string, string[]> = {};
    for (const issue of result.error.issues) {
      const field = issue.path.join('.') || 'root';
      if (!errorMap[field]) {
        errorMap[field] = [];
      }
      errorMap[field].push(issue.message);
    }
    throw new ValidationException('Data masukan tidak valid.', errorMap);
  }
  return result.data;
}
