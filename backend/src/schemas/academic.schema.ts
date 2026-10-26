import { z } from 'zod';

export const createAnnouncementSchema = z.object({
  judul: z.string().min(5, 'Judul pengumuman minimal 5 karakter'),
  isiTeks: z.string().min(10, 'Isi teks pengumuman minimal 10 karakter'),
});

export type CreateAnnouncementInput = z.infer<typeof createAnnouncementSchema>;
