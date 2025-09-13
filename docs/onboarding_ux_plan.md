# Onboarding UX Plan - International Fintech Grade

## Overview
Transform Pocketa's onboarding from MVP to world-class, emotionally resonant user experience that builds trust and engagement through a 5-screen flow.

## Screen Flow Architecture

### Screen 1: Emotional Opener (Welcome)
**Goal**: Create emotional connection and establish value proposition
**Psychology Hook**: "You're in control of your money" - empowerment and security
**Layout Wireframe**:
- Hero illustration (Pocketa logo with subtle animation)
- Bold headline: "Starting today, money is in your control"
- Subtitle: "Small expenses create big gaps—now they'll be easy to track"
- Feature chips: Secure, Simple, Smart (interactive with tooltips)
- Primary CTA: "Continue →"

**Motion Spec**:
- Hero illustration: FadeSlide (0ms delay)
- Headline: FadeSlide (80ms delay)
- Subtitle: FadeSlide (120ms delay)
- Feature chips: FadeSlide (160ms delay, staggered)
- CTA: FadeSlide (200ms delay)

**Success Criteria**:
- User understands value proposition within 3 seconds
- Feature chips provide helpful context without overwhelming
- Clear path forward with prominent CTA

**Analytics Events**:
- `onb_step_viewed {step: "welcome"}`
- `onb_option_selected {step: "welcome", key: "feature_chip", value: "secure|simple|smart"}`

### Screen 2: Personalization
**Goal**: Make the app feel personal and relevant to user's context
**Psychology Hook**: "This is your app" - customization builds ownership
**Layout Wireframe**:
- Headline: "Tell us about you"
- Subtitle: "Language, income type, currency—make it yours"
- Three option groups:
  - Currency: USD, EUR, BDT (with flags)
  - Language: English, বাংলা
  - Theme: Light, Dark, System
- Primary CTA: "Continue →"

**Motion Spec**:
- Headline: FadeSlide (0ms delay)
- Subtitle: FadeSlide (80ms delay)
- Currency options: FadeSlide (120ms delay)
- Language options: FadeSlide (160ms delay)
- Theme options: FadeSlide (200ms delay)
- CTA: FadeSlide (240ms delay)

**Success Criteria**:
- User can quickly select their preferences
- Visual feedback on selection
- No overwhelming choice paralysis

**Analytics Events**:
- `onb_step_viewed {step: "personalization"}`
- `onb_option_selected {step: "personalization", key: "currency", value: "USD|EUR|BDT"}`
- `onb_option_selected {step: "personalization", key: "language", value: "en|bn"}`
- `onb_option_selected {step: "personalization", key: "theme", value: "light|dark|system"}`

### Screen 3: Interactive Demo Add
**Goal**: Prove the app works with immediate, satisfying interaction
**Psychology Hook**: "See how easy it is" - demonstration builds confidence
**Layout Wireframe**:
- Headline: "Add an expense in 5 seconds"
- Subtitle: "One tap to add the demo—edit if you want"
- Demo transaction card:
  - Amount: ৳৫০ (prominent)
  - Category: Tea/Snacks
  - Note: With friends
  - Category icon (coffee cup)
  - "Add now" button
- Success state: Checkmark + "Added! You've got this"

**Motion Spec**:
- Headline: FadeSlide (0ms delay)
- Subtitle: FadeSlide (80ms delay)
- Demo card: FadeSlide (120ms delay) + ScaleTap on button
- Success state: FadeSlide (160ms delay) + confetti animation
- Confetti: RepaintBoundary + 500ms duration

**Success Criteria**:
- User successfully adds demo transaction
- Immediate positive feedback
- User understands the core interaction pattern

**Analytics Events**:
- `onb_step_viewed {step: "demo"}`
- `onb_demo_added {amount: 50, category: "snacks", edited: false}`

### Screen 4: Trust Reassurance
**Goal**: Address privacy concerns and build trust
**Psychology Hook**: "Your data stays yours" - security and control
**Layout Wireframe**:
- Security icon (shield with checkmark)
- Headline: "Your data stays on your device"
- Three trust points:
  - Offline-first—works without internet
  - We can't see your data unless you choose cloud backup
  - Lock PIN and biometric support
- Primary CTA: "I understand"
- Secondary CTA: "Learn more" (placeholder deep-link)

**Motion Spec**:
- Security icon: FadeSlide (0ms delay)
- Headline: FadeSlide (80ms delay)
- Trust points: FadeSlide (120ms, 200ms, 280ms delays)
- CTAs: FadeSlide (360ms delay)

**Success Criteria**:
- User feels confident about data security
- Clear understanding of privacy model
- Optional deeper learning available

**Analytics Events**:
- `onb_step_viewed {step: "trust"}`
- `onb_trust_ack {learn_more_clicked: true|false}`

### Screen 5: Habit Nudge
**Goal**: Set up daily engagement and habit formation
**Psychology Hook**: "Today is Day 1" - fresh start and momentum
**Layout Wireframe**:
- Day 1 badge (prominent, animated)
- Headline: "Today is Day 1—see you tomorrow?"
- Subtitle: "10 seconds a day—keep your streak, invest in your dreams"
- Streak visualization (progress bar from 0→1)
- Daily reminder toggle
- Primary CTA: "Start now"

**Motion Spec**:
- Day 1 badge: FadeSlide (0ms delay) + scale animation
- Headline: FadeSlide (80ms delay)
- Subtitle: FadeSlide (120ms delay)
- Streak bar: FadeSlide (160ms delay) + progress animation
- Toggle: FadeSlide (200ms delay)
- CTA: FadeSlide (240ms delay)

**Success Criteria**:
- User commits to daily engagement
- Clear understanding of habit formation
- Optional reminder setup

**Analytics Events**:
- `onb_step_viewed {step: "habit"}`
- `onb_habit_started {reminder_enabled: true|false}`

## Accessibility Requirements

### Touch Targets
- Minimum 44dp for all interactive elements
- Adequate spacing between touch targets (8dp minimum)

### Text Scaling
- Support text scale 0.85–1.3
- No text overflow at maximum scale
- Maintain readability at all scales

### Color Contrast
- AA contrast ratio (4.5:1) for normal text
- AAA contrast ratio (7:1) for large text
- Color not the only means of conveying information

### Screen Reader Support
- Semantic labels for all interactive elements
- Logical reading order
- Descriptive alt text for images

## Motion Guidelines

### Timing
- Entrance animations: 200-250ms
- Stagger delays: 80-120ms between elements
- Success animations: 500-700ms
- Micro-interactions: 150-200ms

### Easing
- Entrance: easeOutCubic
- Success: easeOutBack (bouncy)
- Micro-interactions: easeOutQuart

### Performance
- RepaintBoundary around confetti/success widgets
- Avoid heavy animations during scroll
- 60fps target on mid-tier Android devices

## Success Metrics

### Completion Rate
- Target: >85% completion rate
- Measure: Step progression analytics

### Time to Value
- Target: <30 seconds to first transaction
- Measure: Time from start to demo add

### User Satisfaction
- Target: >4.5/5 rating for onboarding
- Measure: Post-onboarding survey

### Retention
- Target: >70% day-1 retention
- Measure: User returns within 24 hours
