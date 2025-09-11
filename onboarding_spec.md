## Pocketa Onboarding — Bangla‑first, Trust‑building, Habit‑seeding

Audience: Students, Freelancers, Small Families (Bangladesh‑first)
Differentiators: Bangla‑first UI, offline‑first, quick‑add ≤5s, privacy‑first
Onboarding goals: Emotional hook → Personalization → First success demo → Trust reassurance → Habit nudge

---

## Screen‑by‑Screen Flow (max 5)

### 1) Emotional Opener — “Why this matters”
- Goal: Acknowledge pain; create immediate relevance and trust.
- Primary CTA: Continue → Personalization

Copy (bn + en):
- Title: আজ থেকেই নিয়ন্ত্রণ আপনার হাতে।
  - EN: Starting today, money is in your control.
- Subtitle: ছোট ছোট খরচই বড় ফাঁক তৈরি করে—এবার থেকে সবকিছু সহজে ট্র্যাক হবে।
  - EN: Small expenses create big gaps—now they’ll be easy to track.

UX Notes:
- Keep text short, 2 lines max. Add quick bullets as chips if space allows.

Illustration & Motion:
- Visual: Soft gradient card stack with Taka (৳) glyph, student bag, laptop, family home icon; subtle glassmorphism.
- Motion: Slow parallax; slight float on icons; entrance fade‑up (200ms stagger).

---

### 2) Personalization — Language, Income Type, Currency
- Goal: Make it feel tailor‑made; reduce future friction.
- Fields:
  - Language: বাংলা (default), English
  - Income Type: Student, Freelancer, Family (radio/segmented)
  - Currency: BDT (৳) default, optional USD/EUR view‑only
- Primary CTA: Save & continue → Demo

Copy:
- Title: আপনি কেমন ইউজার?
  - EN: Tell us about you.
- Helper: ভাষা, আয় টাইপ, মুদ্রা—সব নিজের মতো।
  - EN: Language, income type, currency—make it yours.

Illustration & Motion:
- Visual: Three friendly character badges (student cap 🎓, laptop 💻, small home 🏠), soft edges.
- Motion: Toggle micro‑bounce; selected badge gets 8% glow.

---

### 3) Interactive Fake Demo — Log First Expense (≤ 5s)
- Goal: Demonstrate speed and delight; create “I can do this” moment.
- Interaction: Pre‑filled demo data; user taps once to confirm.
  - Amount: ৫০
  - Category: চা/স্ন্যাকস
  - Note: বন্ধুদের সাথে
- Primary CTA: Add now (Demo)
- Secondary: Edit fields (optional)

Copy:
- Title: ৫ সেকেন্ডে খরচ যোগ করুন।
  - EN: Add an expense in 5 seconds.
- Helper: এক ট্যাপে ডেমোটি অ্যাড করুন—তারপর চাইলে এডিট করুন।
  - EN: One tap to add the demo—edit if you want.
- Success Toast: যোগ হয়েছে! আপনি পারেন।
  - EN: Added! You’ve got this.

Illustration & Motion:
- Visual: Minimal card with amount “৳৫০” large; chai cup icon.
- Motion: Tap ripple → card compress 96% → success tick; confetti micro‑burst (subtle, 600ms).

---

### 4) Trust Reassurance — Offline + Data Safe
- Goal: Reduce fintech trust gap; address privacy explicitly.
- Primary CTA: I understand → Habit nudge
- Secondary: Learn more (links to privacy page later)

Copy:
- Title: আপনার ডেটা আপনার ডিভাইসে।
  - EN: Your data stays on your device.
- Bullets (3):
  - অফলাইন‑ফার্স্ট—ইন্টারনেট না থাকলেও কাজ করবে।
    - EN: Offline‑first—works without internet.
  - ক্লাউডে না গেলে আমরা দেখতেই পাই না।
    - EN: We can’t see your data unless you choose cloud backup.
  - লক‑পিন ও বায়োমেট্রিক সাপোর্ট।
    - EN: Lock PIN and biometric support.

Illustration & Motion:
- Visual: Lock + shield + phone; green trust palette.
- Motion: Shield draws outline → fills softly; checklist ticks in stagger.

---

### 5) Habit Nudge — Streaks, Day‑1, Confetti
- Goal: Seed discipline; identity framing.
- Primary CTA: Start Day 1
- Secondary: Remind me daily (toggle)

Copy:
- Title: আজ Day 1—কালও দেখা হবে?
  - EN: Today is Day 1—see you tomorrow?
- Helper: প্রতিদিন ১০ সেকেন্ড—স্ট্রিক বজায় রাখুন, স্বপ্নে বিনিয়োগ করুন।
  - EN: 10 seconds a day—keep your streak, invest in your dreams.
- Button: শুরু করুন
  - EN: Start now

Illustration & Motion:
- Visual: Calendar with glowing Day‑1 dot; tiny rocket.
- Motion: Confetti burst on tap; streak bar animates from 0 → 1 with elastic ease.

---

## Microcopy with ARB Keys (bn + en)

Note: snake_case keys; pair bn/en. Use bn as default in Bangladesh build; fall back to en.

```
onb_welcome_title: "আজ থেকেই নিয়ন্ত্রণ আপনার হাতে।"
onb_welcome_title_en: "Starting today, money is in your control."
onb_welcome_subtitle: "ছোট ছোট খরচই বড় ফাঁক তৈরি করে—এবার থেকে সবকিছু সহজে ট্র্যাক হবে।"
onb_welcome_subtitle_en: "Small expenses create big gaps—now they’ll be easy to track."

onb_persona_title: "আপনি কেমন ইউজার?"
onb_persona_title_en: "Tell us about you."
onb_persona_helper: "ভাষা, আয় টাইপ, মুদ্রা—সব নিজের মতো।"
onb_persona_helper_en: "Language, income type, currency—make it yours."
onb_language_label: "ভাষা"
onb_language_label_en: "Language"
onb_income_type_label: "আয় টাইপ"
onb_income_type_label_en: "Income type"
onb_currency_label: "মুদ্রা"
onb_currency_label_en: "Currency"
onb_income_student: "স্টুডেন্ট"
onb_income_student_en: "Student"
onb_income_freelancer: "ফ্রিল্যান্সার"
onb_income_freelancer_en: "Freelancer"
onb_income_family: "ফ্যামিলি"
onb_income_family_en: "Family"
onb_save_continue: "সেভ করে এগোন"
onb_save_continue_en: "Save & continue"

onb_demo_title: "৫ সেকেন্ডে খরচ যোগ করুন।"
onb_demo_title_en: "Add an expense in 5 seconds."
onb_demo_helper: "এক ট্যাপে ডেমোটি অ্যাড করুন—তারপর চাইলে এডিট করুন।"
onb_demo_helper_en: "One tap to add the demo—edit if you want."
onb_demo_amount: "৳৫০"
onb_demo_category: "চা/স্ন্যাকস"
onb_demo_note: "বন্ধুদের সাথে"
onb_demo_cta: "এখনই যোগ করুন"
onb_demo_cta_en: "Add now"
onb_demo_success_toast: "যোগ হয়েছে! আপনি পারেন।"
onb_demo_success_toast_en: "Added! You’ve got this."

onb_trust_title: "আপনার ডেটা আপনার ডিভাইসে।"
onb_trust_title_en: "Your data stays on your device."
onb_trust_bullet_offline: "অফলাইন‑ফার্স্ট—ইন্টারনেট না থাকলেও কাজ করবে।"
onb_trust_bullet_offline_en: "Offline‑first—works without internet."
onb_trust_bullet_privacy: "ক্লাউডে না গেলে আমরা দেখতেই পাই না।"
onb_trust_bullet_privacy_en: "We can’t see your data unless you choose cloud backup."
onb_trust_bullet_lock: "লক‑পিন ও বায়োমেট্রিক সাপোর্ট।"
onb_trust_bullet_lock_en: "Lock PIN and biometric support."
onb_trust_primary: "বুঝেছি"
onb_trust_primary_en: "I understand"
onb_trust_learn_more: "আরও জানুন"
onb_trust_learn_more_en: "Learn more"

onb_habit_title: "আজ Day 1—কালও দেখা হবে?"
onb_habit_title_en: "Today is Day 1—see you tomorrow?"
onb_habit_helper: "প্রতিদিন ১০ সেকেন্ড—স্ট্রিক বজায় রাখুন, স্বপ্নে বিনিয়োগ করুন।"
onb_habit_helper_en: "10 seconds a day—keep your streak, invest in your dreams."
onb_habit_cta: "শুরু করুন"
onb_habit_cta_en: "Start now"
onb_habit_toggle_reminder: "ডেইলি রিমাইন্ডার"
onb_habit_toggle_reminder_en: "Daily reminder"
onb_habit_day_label: "Day {day}"
onb_habit_day_label_en: "Day {day}"

onb_skip: "স্কিপ"
onb_skip_en: "Skip"
onb_back: "পেছনে"
onb_back_en: "Back"
onb_next: "পরবর্তী"
onb_next_en: "Next"
```

ARB Example (bn):
```json
{
  "onb_welcome_title": "আজ থেকেই নিয়ন্ত্রণ আপনার হাতে।",
  "onb_welcome_subtitle": "ছোট ছোট খরচই বড় ফাঁক তৈরি করে—এবার থেকে সবকিছু সহজে ট্র্যাক হবে।",
  "onb_persona_title": "আপনি কেমন ইউজার?",
  "onb_demo_title": "৫ সেকেন্ডে খরচ যোগ করুন।",
  "onb_trust_title": "আপনার ডেটা আপনার ডিভাইসে।",
  "onb_habit_title": "আজ Day 1—কালও দেখা হবে?",
  "onb_habit_day_label": "Day {day}",
  "@onb_habit_day_label": {"placeholders": {"day": {"type": "int"}}}
}
```

ARB Example (en):
```json
{
  "onb_welcome_title": "Starting today, money is in your control.",
  "onb_welcome_subtitle": "Small expenses create big gaps—now they’ll be easy to track.",
  "onb_persona_title": "Tell us about you.",
  "onb_demo_title": "Add an expense in 5 seconds.",
  "onb_trust_title": "Your data stays on your device.",
  "onb_habit_title": "Today is Day 1—see you tomorrow?",
  "onb_habit_day_label": "Day {day}",
  "@onb_habit_day_label": {"placeholders": {"day": {"type": "int"}}}
}
```

---

## Psychological Hooks (per screen)
- Opener: Identity framing (I am the kind of person who controls money), loss aversion (small leaks cause big loss), social proof via relatable icons.
- Personalization: Ownership bias (my settings), commitment and consistency.
- Demo: Self‑efficacy (I can do this), instant reward (success toast), reduced friction.
- Trust: Risk reduction, transparency, control priming.
- Habit: Streak commitment, future self, minimal daily action.

---

## Illustration & Animation Prompts (Figma / AI tools)
- Style: Soft gradients (emerald/teal, sky, amber), glassmorphism cards, friendly rounded icons, light Bengali cultural cues (cup of chai, rickshaw outline, taka symbol). Avoid clichés; keep modern.
- Prompt (generic): “Friendly fintech onboarding, glassmorphism cards, soft gradient background (teal → sky), minimal Bengali cultural accents (৳, chai cup), vector, clean, high‑contrast typography, inclusive characters (student, freelancer, small family), subtle shadows, iOS/Material hybrid.”
- Motion system:
  - Duration: 200–300ms standard, 100ms delays for stagger lists.
  - Easing: standard, ease‑out for entrances, elastic for success.
  - Confetti: 20–30 particles, 0.6s, colors from brand palette.

---

## A/B Testing Variations

Key Screen 1 — Emotional Opener
- Fear‑driven (loss aversion):
  - BN: ছোট খরচের ফাঁকেই টাকা হারায়। আজই থামান।
  - EN: Money leaks through small spends. Stop it today.
- Hope‑driven (aspiration):
  - BN: ছোট ট্যাক ট্র্যাক, বড় স্বপ্ন পূরণ।
  - EN: Track the small to fund the big dreams.
- Identity‑driven (ownership):
  - BN: আপনার টাকার হিসাব আপনার হাতেই।
  - EN: Your money, your rules.

Key Screen 3 — Demo CTA
- Speed‑cue:
  - BN: ১ ট্যাপে যোগ করুন
  - EN: Add in one tap
- Mastery‑cue:
  - BN: দেখুন কত সহজ
  - EN: See how easy it is

Key Screen 5 — Habit Nudge
- Streak‑cue:
  - BN: স্ট্রিক শুরু করুন—আজ Day 1
  - EN: Start your streak—Today is Day 1
- Future‑self:
  - BN: আজ ১০ সেকেন্ড, কাল বড় সেভিংস
  - EN: 10 seconds today, bigger savings tomorrow

Experiment Metrics
- Activation: Completed demo add
- Trust: Reached trust screen and tapped “I understand”
- Habit: Enabled reminder; returned Day‑2
- Time to complete onboarding

---

## Dev Notes / Implementation Handoff
- Keep to 5 screens, each with skip/back. Persist choices immediately.
- Demo add writes to a sandbox store; on finish, persist as first real item (flagged ‘demo=true’), or discard if user cancels.
- Confetti and success toasts are non‑blocking; 600–800ms max.
- Default language: bn; provide in‑flow language toggle on Screen 2.
- Accessibility: Minimum 14pt BN text; button 44px height; color contrast AA.

---

## Localization Key List (snake_case)

```text
onb_welcome_title
onb_welcome_subtitle
onb_persona_title
onb_persona_helper
onb_language_label
onb_income_type_label
onb_currency_label
onb_income_student
onb_income_freelancer
onb_income_family
onb_save_continue
onb_demo_title
onb_demo_helper
onb_demo_amount
onb_demo_category
onb_demo_note
onb_demo_cta
onb_demo_success_toast
onb_trust_title
onb_trust_bullet_offline
onb_trust_bullet_privacy
onb_trust_bullet_lock
onb_trust_primary
onb_trust_learn_more
onb_habit_title
onb_habit_helper
onb_habit_cta
onb_habit_toggle_reminder
onb_habit_day_label
onb_skip
onb_back
onb_next
```

All set for import to ARB files and UI wiring.


