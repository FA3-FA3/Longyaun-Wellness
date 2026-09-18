import { Resend } from 'resend';

// Sign up at resend.com, create an API key, and set RESEND_API_KEY. Without
// a verified sending domain, mail must go out from the shared
// onboarding@resend.dev address — verify a real domain in the Resend
// dashboard once one exists for better deliverability.
//
// Constructed lazily (not at import time): the Resend SDK throws
// synchronously if the API key is missing, which would otherwise crash the
// whole server on boot — including routes that have nothing to do with
// email — any time RESEND_API_KEY isn't set yet.
let _resend;
export function getResendClient() {
  if (!process.env.RESEND_API_KEY) return null;
  if (!_resend) _resend = new Resend(process.env.RESEND_API_KEY);
  return _resend;
}

export const CONTACT_TO_EMAIL = 'longyuan.wellness@proton.me';
export const CONTACT_FROM_EMAIL = process.env.CONTACT_FROM_EMAIL || 'onboarding@resend.dev';
