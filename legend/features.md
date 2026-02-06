# Denda — Feature set

Finance app for individual users. Users register, log in, and manage their own accounts and transactions. This document lists target features and clarified scope.

**Reference:** [general-technical-overview.md](./general-technical-overview.md), [task-list.md](./task-list.md).

---

## Build strategy

1. **Foundation first:** Set up DB and schema for all planned features so migrations support the full product; avoid redoing schema later.
2. **Then by complexity and dependency:** Build features in order of what is needed first to enable more complex features (e.g. categories before budgets and charts, transactions before splits).

---

## Target features

### 1. View all financial data from all accounts

- Single view (dashboard or “all accounts”) showing financial data aggregated from every account/card the user has.
- Filter by account, date range, category, type.

### 2. Automatically differentiate between income and expenses

- System classifies each transaction as income or expense (e.g. by sign, type, or rules).
- UI and reports treat income vs expenses consistently (lists, filters, charts).

### 3. Categories (including recurring) + custom expenses

- **Categories:** Predefined and/or user-defined (e.g. Groceries, Rent, Salary).
- **Recurring expenses:** Recognized and flagged (e.g. monthly rent, subscriptions); can be a category or sub-type.
- **Custom expenses:** User can create one-off or custom expense types/names not tied to a standard category.

### 4. Split transactions between friends (tracking only)

- A transaction can be **split** among multiple people (e.g. shared dinner).
- **Tracking only:** No multi-user accounts; friends do not log in. Track who owes what and who has paid.
- UI shows: total amount, share per person, amount paid so far per person, remaining balance per person.

### 5. Balance per account/card

- For each account (or card), show **current balance**.
- Display per-account (and per-card) in lists and summary views.

### 6. Chart: budget breakdown

- **Both:** (A) Budget vs actual (e.g. bar: budget $500 vs spent $420), and (B) spending by category (e.g. pie).
- User can define budgets (e.g. by category or overall).

### 7. Charts: month-to-month and year-on-year

- **Month-to-month:** Compare spending/income by category (or overall) across consecutive months.
- **Year-on-year:** Compare same period across years (e.g. Jan 2024 vs Jan 2025).
- **Configurable** time range (e.g. last 6 months, last 12 months, 2024 vs 2025).

### 8. Triggers / automations (when/where to move money)

- **Triggers:** Rules that run when conditions are met (e.g. “when deposit hits account X”, “when balance exceeds Y”).
- **Actions:** Move money between accounts, pay a specific account (internal or biller).
- **Live events as well:** Support both manual/imported data and live events (e.g. webhooks or polling from bank/card connections) so automations can run on real-time or near-real-time events.

### 9. Descriptions on payments

- Every payment/transaction can have a **description** (free text or structured).
- Editable, searchable, visible in lists and detail views.

### 10. Detect Zelle/Venmo and assign to transaction / IOU / custom expense

- **Manual assignment:** User matches a bank line (or Zelle/Venmo line) to an existing transaction, IOU, or custom expense. No automatic P2P detection in scope.
- Improves matching of informal transfers to the right transaction or IOU.

### 11. IOU (I owe you) — two-way

- **IOU:** Informal obligation to or from a person (not a formal biller).
- **Two-way:** “I owe you” and “you owe me”; direction tracked.
- User can create IOUs (amount, person, direction, due date, optional description). Track status: pending, partially paid, paid.
- Link payments (e.g. Zelle/Venmo) to IOUs to mark them paid (manual assignment, feature 10).

### 12. Custom expenses: recurrence options

- Custom expenses support **recurrence** with flexible scheduling:
  - **Recurring:** Repeats on a schedule (e.g. weekly, monthly).
  - **Recurring with start in the future:** First occurrence on a future date; then repeats.
  - **Recurring with duration:** End date or number of occurrences (e.g. “every month for 12 months” or “until Dec 2025”).
- **Placeholder/scheduled transactions:** Generate placeholder or scheduled transactions so they appear in “upcoming” and in balance projections.

---

## Clarified scope (summary)

| # | Topic | Decision |
|---|--------|----------|
| 1 | Accounts | Support **bank/card connections** (e.g. Plaid or similar); not only manual entries. |
| 2 | Splits | **Tracking only;** no multi-user accounts; friends do not log in. |
| 3 | Zelle/Venmo | **Manual assignment** of a payment to a transaction/IOU/custom expense. |
| 4 | Triggers | **Live events** as well as manual/imported; automations can run on real-time or near-real-time events. |
| 5 | Pay an account | **Both:** (A) internal transfer between your accounts, (B) pay a bill (e.g. credit card, loan). |
| 6 | Recurring custom expenses | **Placeholder/scheduled transactions** (upcoming view, balance projections). |
| 7 | IOU | **Two-way:** I owe you and you owe me. |
| 8 | Budget chart | **Both** budget vs actual and spending-by-category. |
| 9 | Month-to-month / YoY | **Configurable** time range. |
| 10 | Build order | **DB/schema foundation for all features first;** then build features by complexity and dependency. |

---

## Out of scope (for this document)

- Real banking/payment execution (MVP may use mock data; connections for sync only as decided).
- Multi-user/household accounts (current scope: individual user; splits are tracking-only).
- PCI or other formal compliance (revisit if real payments are added).

---

Last updated: 2025-02-05
