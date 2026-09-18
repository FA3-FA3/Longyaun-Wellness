import { getResendClient, CONTACT_TO_EMAIL, CONTACT_FROM_EMAIL } from '../config/email.js';

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_LEN = { name: 200, email: 320, message: 5000 };

// Public — no auth. Anyone visiting the site can send a message; there is
// no account behind a contact form submission.
export async function contactRoutes(fastify) {
  fastify.post('/contact', async (request, reply) => {
    const body = request.body ?? {};
    const name = typeof body.name === 'string' ? body.name.trim() : '';
    const email = typeof body.email === 'string' ? body.email.trim() : '';
    const message = typeof body.message === 'string' ? body.message.trim() : '';

    if (!name || !email || !message) {
      return reply.code(400).send({ error: 'name, email, and message are all required' });
    }
    if (!EMAIL_RE.test(email)) {
      return reply.code(400).send({ error: 'email is not a valid address' });
    }
    if (name.length > MAX_LEN.name || email.length > MAX_LEN.email || message.length > MAX_LEN.message) {
      return reply.code(400).send({ error: 'one or more fields exceed the maximum length' });
    }

    const resend = getResendClient();
    if (!resend) {
      request.log.error('RESEND_API_KEY is not set — cannot send contact email');
      return reply.code(503).send({ error: 'Contact form is not configured yet — please try again later' });
    }

    try {
      await resend.emails.send({
        from: `Longyuan Wellness Website <${CONTACT_FROM_EMAIL}>`,
        to: CONTACT_TO_EMAIL,
        replyTo: email,
        subject: `New contact form message from ${name}`,
        text: `From: ${name} <${email}>\n\n${message}`,
      });
    } catch (error) {
      request.log.error({ error }, 'Failed to send contact email');
      return reply.code(502).send({ error: 'Failed to send message — please try again later' });
    }

    return { sent: true };
  });
}
