# BonePay Demo

A **simulated** multi-currency digital wallet built with Flutter and Firebase. BonePay Demo is a portfolio project that demonstrates a realistic fintech application flow — a wallet dashboard, money transfers, QR payments, transaction history, KYC/profile, and a Cloud Functions backend — using **demo data only**.

> **This is NOT a real financial service.**
> All balances, payments, transfers, QR requests, KYC records, and transactions are **simulated**. No real money moves and no real customer data is used or stored.

---

## What is BonePay Demo?

BonePay Demo is a recruiter-inspectable example of mobile/web app development for financial services. It models the user experience of a multi-currency wallet (USD, GHS, NGN, KES) common in cross-border payment products, with a clean, professional UI and a small Firebase backend.

It intentionally looks and behaves like a real wallet app, while everything beneath the surface is clearly **demo/simulated** — every screen carries a visible "DEMO" marker.

## Technologies

| Layer | Technology |
| --- | --- |
| Frontend | Flutter / Dart (Material 3) |
| Backend | Firebase |
| Auth infrastructure | `firebase_auth` (dependency wired; no real auth flow used in demo) |
| Database | Cloud Firestore (`demo_transactions`, `demo_fees`) |
| Server logic | Cloud Functions (`calculateDemoFee`) |
| QR codes | `qr_flutter` (payment-request QR generation) |
| State management | `provider` |

## Main Demo Features

- **Multi-currency wallet dashboard** — total balance + USD, GHS, NGN, KES balances
- **Send Money** — recipient/amount validation, demo fee calculation, confirmation screen, simulated transfer
- **Receive Money** — demo receive address and one-tap simulated top-up
- **Demo fee calculation** — simple flat-percentage fee, computed locally and mirrored by a Cloud Function
- **Firestore transaction records** — simulated transfers write a record to Firestore
- **QR payment requests** — select an amount and currency, generate a scan-able (simulated) payment QR
- **Transaction history & details** — full list with status, type, and copyable references
- **Demo KYC / profile** — simulated "Demo Verified" identity status with mock documents
- **Cloud Functions backend** — a single, small `calculateDemoFee` function demonstrating server-side processing

## Important: It's All Simulated

- Balances are hard-coded demo values.
- Transfers validate locally and update an in-memory wallet — no money moves.
- QR codes represent demo payment requests only.
- KYC is a simulated status screen with mock documents — **no real identity documents, selfies, or government IDs are collected or transmitted**.
- No real payment credentials, API keys, or customer data are used.
- Wallet state is demo-level: it does not persist real account balances and resets on app restart.

## Running Locally

Prerequisites: Flutter SDK (stable), an internet connection for Firebase.

```sh
flutter pub get
flutter run -d chrome        # web
flutter run                  # mobile device/emulator
```

Useful commands:

```sh
flutter analyze              # static analysis
flutter test                 # run tests
flutter build web            # production web build
```

> The demo uses the `bonepay-demo` Firebase project. If the Cloud Function
> `calculateDemoFee` is not deployed, Send Money transparently falls back to
> the local demo fee calculation.

## Project Structure

```text
lib/
├── main.dart                  # App entry, Firebase init, navigation shell
├── firebase_options.dart      # FlutterFire config (bonepay-demo)
├── models/
│   ├── wallet.dart            # DemoWallet, CurrencyBalance
│   └── transaction.dart       # DemoTransaction
├── services/
│   ├── demo_data.dart         # Seed demo balances, transactions, fee calc
│   └── wallet_service.dart    # Wallet state + simulated transfer logic
├── widgets/
│   ├── balance_card.dart
│   ├── currency_balance_tile.dart
│   ├── quick_action_button.dart
│   ├── transaction_tile.dart
│   └── bonepay_logo.dart
└── screens/
    ├── home/                  # Wallet dashboard
    ├── send/                  # Send Money (validation + confirmation)
    ├── receive/               # Receive Money (simulated top-up)
    ├── qr/                    # QR payment request generator
    ├── transactions/          # History + details
    └── profile/               # Profile + demo KYC
functions/
├── index.js                   # calculateDemoFee Cloud Function (demo)
└── package.json
```

## Portfolio Purpose

This project showcases practical Flutter and Firebase application development:

- **Clean architecture for a real-world UI** — a professional, Material 3 fintech interface with reusable widgets and typed models.
- **Firebase integration** — Firestore reads/writes, Cloud Functions, and FlutterFire configuration across web, Android, and iOS.
- **State management** — a `ChangeNotifier` + `provider` wallet service that keeps balances and transactions in sync across screens.
- **Form flows** — validation, demo fee calculation, and a review/confirm step before completing a transfer.
- **Judgment on scope** — hard web-only problems (e.g. camera QR scanning) were solved with clean, explainable alternatives rather than platform-specific hacks.

BonePay Demo is a learning/portfolio artifact. It is not production software, and it should not be treated as one.