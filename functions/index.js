/**
 * BonePay Demo Cloud Function
 * ---------------------------
 * A single, small backend function that demonstrates how the demo transfer fee
 * would be computed server-side. It is intentionally simple and safe:
 *   - No real payment processing
 *   - No real customer PII
 *   - Incoming data is validated and clamped to demo limits
 */

const { onCall } = require('firebase-functions/v2/https');
const { getFirestore } = require('firebase-admin/firestore');
const { initializeApp } = require('firebase-admin/app');

initializeApp();

const MIN_FEE = 1.0;
const FEE_RATE = 0.005; // 0.5% demo fee
const MAX_DEMO_AMOUNT = 100000;

/**
 * Calculates a simple demo transfer fee.
 * Request: { amount: number, currency: string }
 * Response: { fee: number, rate: number, currency: string }
 */
exports.calculateDemoFee = onCall(async (request) => {
  const currency = String(request.data.currency || 'USD');
  const amount = Number(request.data.amount);

  if (!Number.isFinite(amount) || amount <= 0) {
    throw new Error('amount must be a positive number');
  }

  const clamped = Math.min(amount, MAX_DEMO_AMOUNT);
  const fee = Math.max(clamped * FEE_RATE, MIN_FEE);

  // Demo only - log a Firestore record so the sandbox replay shows a backend hit.
  try {
    await getFirestore().collection('demo_fees').add({
      amount: clamped,
      currency,
      fee: Math.round(fee * 100) / 100,
      rate: FEE_RATE,
      createdAt: new Date().toISOString(),
    });
  } catch (_) {
    // Firestore writes are best-effort in demo mode.
  }

  return {
    fee: Math.round(fee * 100) / 100,
    rate: FEE_RATE,
    currency,
    demo: true,
  };
});