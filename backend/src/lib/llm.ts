import OpenAI from 'openai';
import { config } from '../config/index.js';

export const openai = new OpenAI({
  apiKey: config.llm.apiKey,
  baseURL: config.llm.baseURL,
  timeout: 8000, // 8s timeout to ensure responsive fallback
});

export const isLLMConfigured = (): boolean => {
  return (
    !!config.llm.apiKey &&
    config.llm.apiKey !== 'dummy_key' &&
    config.llm.apiKey !== 'your_openai_or_gemini_api_key_here'
  );
};
