export interface ApiResponseMeta {
  timestamp: string;
  requestId?: string;
}

export interface ApiSuccessEnvelope<T> {
  success: true;
  code: string;
  message: string;
  data: T;
  meta: ApiResponseMeta;
}

export interface ApiErrorEnvelope {
  success: false;
  code: string;
  message: string;
  errors: Record<string, string[]> | null;
  meta: ApiResponseMeta;
}

export function buildSuccessResponse<T>(
  data: T,
  message = 'Request completed successfully.',
  code = 'OK'
): ApiSuccessEnvelope<T> {
  return {
    success: true,
    code,
    message,
    data,
    meta: {
      timestamp: new Date().toISOString(),
    },
  };
}
