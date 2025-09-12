# PocketA Component Showcase
## Visual Design System Examples & Usage Patterns

---

## 🎨 Color Palette Showcase

### Light Theme Colors
```
Primary Colors
┌─────────────────────────────────────────────────────────────┐
│  #0EA5E9  │  #FFFFFF  │  #E0F2FE  │  #0B6A8F              │
│  Primary   │  OnPrimary│  Primary  │  OnPrimary            │
│           │           │ Container │ Container             │
└─────────────────────────────────────────────────────────────┘

Secondary Colors
┌─────────────────────────────────────────────────────────────┐
│  #10B981  │  #062D20  │  #D1FAE5  │  #064E3B              │
│ Secondary  │ OnSecondary│ Secondary│ OnSecondary           │
│           │           │ Container │ Container             │
└─────────────────────────────────────────────────────────────┘

Surface Colors
┌─────────────────────────────────────────────────────────────┐
│  #FFFFFF  │  #121417  │  #F3F5F7  │  #344055              │
│  Surface   │ OnSurface │ Surface   │ OnSurface             │
│           │           │ Variant   │ Variant               │
└─────────────────────────────────────────────────────────────┘

Background & Error
┌─────────────────────────────────────────────────────────────┐
│  #F7F9FB  │  #0F172A  │  #EF4444  │  #FFFFFF              │
│ Background │ OnBackground│ Error    │ OnError               │
└─────────────────────────────────────────────────────────────┘
```

### Dark Theme Colors
```
Primary Colors
┌─────────────────────────────────────────────────────────────┐
│  #38BDF8  │  #0B1220  │  #0B3A53  │  #E0F2FE              │
│  Primary   │  OnPrimary│  Primary  │  OnPrimary            │
│           │           │ Container │ Container             │
└─────────────────────────────────────────────────────────────┘

Secondary Colors
┌─────────────────────────────────────────────────────────────┐
│  #34D399  │  #061A14  │  #065F46  │  #A7F3D0              │
│ Secondary  │ OnSecondary│ Secondary│ OnSecondary           │
│           │           │ Container │ Container             │
└─────────────────────────────────────────────────────────────┘

Surface Colors
┌─────────────────────────────────────────────────────────────┐
│  #0B0F14  │  #E5EAF0  │  #121821  │  #C7D1DE              │
│  Surface   │ OnSurface │ Surface   │ OnSurface             │
│           │           │ Variant   │ Variant               │
└─────────────────────────────────────────────────────────────┘

Background & Error
┌─────────────────────────────────────────────────────────────┐
│  #070A0F  │  #E6EDF5  │  #F87171  │  #1C0C0C              │
│ Background │ OnBackground│ Error    │ OnError               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔤 Typography Scale

### Display Styles
```
Display Large
┌─────────────────────────────────────────────────────────────┐
│ 57px / 64px line-height / 400 weight                       │
│ Welcome to PocketA                                         │
└─────────────────────────────────────────────────────────────┘

Display Medium
┌─────────────────────────────────────────────────────────────┐
│ 45px / 52px line-height / 400 weight                       │
│ Take Control of Your Finances                              │
└─────────────────────────────────────────────────────────────┘

Display Small
┌─────────────────────────────────────────────────────────────┐
│ 36px / 44px line-height / 400 weight                       │
│ Dashboard Overview                                          │
└─────────────────────────────────────────────────────────────┘
```

### Headline Styles
```
Headline Large
┌─────────────────────────────────────────────────────────────┐
│ 32px / 40px line-height / 400 weight                       │
│ Monthly Summary                                             │
└─────────────────────────────────────────────────────────────┘

Headline Medium
┌─────────────────────────────────────────────────────────────┐
│ 28px / 36px line-height / 400 weight                       │
│ Recent Transactions                                         │
└─────────────────────────────────────────────────────────────┘

Headline Small
┌─────────────────────────────────────────────────────────────┐
│ 24px / 32px line-height / 400 weight                       │
│ Add New Transaction                                         │
└─────────────────────────────────────────────────────────────┘
```

### Title Styles
```
Title Large
┌─────────────────────────────────────────────────────────────┐
│ 22px / 28px line-height / 500 weight                       │
│ Transaction Details                                         │
└─────────────────────────────────────────────────────────────┘

Title Medium
┌─────────────────────────────────────────────────────────────┐
│ 16px / 24px line-height / 500 weight                       │
│ Category: Food & Dining                                     │
└─────────────────────────────────────────────────────────────┘

Title Small
┌─────────────────────────────────────────────────────────────┐
│ 14px / 20px line-height / 500 weight                       │
│ Amount: ৳1,234.56                                          │
└─────────────────────────────────────────────────────────────┘
```

### Body Styles
```
Body Large
┌─────────────────────────────────────────────────────────────┐
│ 16px / 24px line-height / 400 weight                       │
│ This is a longer description that explains the transaction │
│ details and provides context for the user.                 │
└─────────────────────────────────────────────────────────────┘

Body Medium
┌─────────────────────────────────────────────────────────────┐
│ 14px / 20px line-height / 400 weight                       │
│ This is a medium description that provides additional      │
│ information about the transaction.                          │
└─────────────────────────────────────────────────────────────┘

Body Small
┌─────────────────────────────────────────────────────────────┐
│ 12px / 16px line-height / 400 weight                       │
│ This is a small description for secondary information.     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧩 Button Components

### Primary Button (FilledButton)
```
┌─────────────────────────────────────────────────────────────┐
│                    [ Continue ]                             │
│  Background: #0EA5E9 (Primary)                             │
│  Text: #FFFFFF (OnPrimary)                                 │
│  Border Radius: 8px                                         │
│  Padding: 16px horizontal, 12px vertical                   │
│  Min Height: 48px                                           │
└─────────────────────────────────────────────────────────────┘

With Icon
┌─────────────────────────────────────────────────────────────┐
│                [ + Add Transaction ]                        │
│  Icon: Plus icon                                            │
│  Spacing: 8px between icon and text                        │
└─────────────────────────────────────────────────────────────┘

Loading State
┌─────────────────────────────────────────────────────────────┐
│                [ ⟳ Loading... ]                            │
│  Spinner: 16px circular progress indicator                 │
│  Disabled: No interaction allowed                          │
└─────────────────────────────────────────────────────────────┘
```

### Secondary Button (OutlinedButton)
```
┌─────────────────────────────────────────────────────────────┐
│                    [ Cancel ]                               │
│  Background: Transparent                                    │
│  Text: #0EA5E9 (Primary)                                   │
│  Border: 1px solid #E5EAF0 (Outline)                       │
│  Border Radius: 8px                                         │
│  Padding: 16px horizontal, 12px vertical                   │
└─────────────────────────────────────────────────────────────┘

With Icon
┌─────────────────────────────────────────────────────────────┐
│                [ ← Back ]                                   │
│  Icon: Arrow back icon                                      │
│  Spacing: 8px between icon and text                        │
└─────────────────────────────────────────────────────────────┘
```

### Tertiary Button (TextButton)
```
┌─────────────────────────────────────────────────────────────┐
│                    [ Learn More ]                           │
│  Background: Transparent                                    │
│  Text: #0EA5E9 (Primary)                                   │
│  Border Radius: 8px                                         │
│  Padding: 8px horizontal, 8px vertical                     │
│  Min Height: 40px                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🃏 Card Components

### Standard Card
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  💳  Transaction Details                             │    │
│  │                                                     │    │
│  │  Amount: ৳1,234.56                                  │    │
│  │  Category: Food & Dining                             │    │
│  │  Date: 15 Dec 2023                                   │    │
│  │                                                     │    │
│  │  [ Edit ] [ Delete ]                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│  Background: #FFFFFF (Surface)                             │
│  Border Radius: 12px                                        │
│  Elevation: 1px                                             │
│  Padding: 16px                                              │
│  Margin: 8px                                                │
└─────────────────────────────────────────────────────────────┘
```

### Glass Card (Footer)
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  [ Back ]                    [ Continue ]            │    │
│  └─────────────────────────────────────────────────────┘    │
│  Background: Surface with 85% opacity                      │
│  Backdrop Filter: blur(8px, 8px)                           │
│  Border: 1px solid outline with 8%/16% opacity             │
│  Border Radius: 16px                                        │
│  Shadow: 16px blur, 6px offset                             │
└─────────────────────────────────────────────────────────────┘
```

### Transaction Card
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍕  Pizza Palace                    -৳450.00        │    │
│  │      Food & Dining                  15 Dec 2023      │    │
│  └─────────────────────────────────────────────────────┘    │
│  Icon: 48x48px with colored background                     │
│  Title: Bold, 16px                                          │
│  Category: Muted, 12px                                      │
│  Amount: Bold, 16px, right-aligned                         │
│  Date: Muted, 12px, right-aligned                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Input Components

### Text Input Field
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Transaction Title                                   │    │
│  │  ┌─────────────────────────────────────────────────┐ │    │
│  │  │ Enter transaction description...                │ │    │
│  │  └─────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
│  Label: 14px, medium weight                                 │
│  Input: 16px, 14px vertical padding                         │
│  Border: 1px solid outline, 12px radius                    │
│  Focus: 1.8px primary border                               │
└─────────────────────────────────────────────────────────────┘
```

### Amount Input Field
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Amount                                             │    │
│  │  ┌─────────────────────────────────────────────────┐ │    │
│  │  │ ৳ 1,234.56                                     │ │    │
│  │  └─────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
│  Prefix: Currency symbol (৳, $, €)                         │
│  Format: Thousands separator, 2 decimal places             │
│  Keyboard: Numeric with decimal point                      │
└─────────────────────────────────────────────────────────────┘
```

### Dropdown Input
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Category                                           │    │
│  │  ┌─────────────────────────────────────────────────┐ │    │
│  │  │ Food & Dining                            ▼     │ │    │
│  │  └─────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
│  Options: Scrollable list with icons                       │
│  Selection: Highlighted with primary color                 │
│  Search: Optional search functionality                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧭 Navigation Components

### App Bar
```
┌─────────────────────────────────────────────────────────────┐
│  ←  Dashboard                                    ⋮         │
│  Background: Transparent (over gradient)                   │
│  Title: 20px, bold weight                                  │
│  Icons: 24px, onSurface color                              │
│  Scrolled: Surface background, 3px elevation               │
└─────────────────────────────────────────────────────────────┘
```

### Bottom Navigation
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────┬─────────┬─────────┬─────────┬─────────┐        │
│  │   🏠    │   📊    │   ➕    │   📋    │   ⚙️    │        │
│  │  Home   │  Stats  │  Add    │  List   │ Settings│        │
│  └─────────┴─────────┴─────────┴─────────┴─────────┘        │
│  Selected: Primary color, bold text                         │
│  Unselected: Muted color, regular text                      │
│  Background: Surface color                                  │
└─────────────────────────────────────────────────────────────┘
```

### Footer CTA Bar
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  [ ← Back ]                    [ Continue ]          │    │
│  └─────────────────────────────────────────────────────┘    │
│  Max Width: 840px (desktop) / 640px (mobile)               │
│  Height: 68-72px                                            │
│  Background: Glass effect with blur                         │
│  Buttons: Flexible width, consistent height                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎭 Motion & Animation

### Page Transitions
```
Enter Animation (220ms)
┌─────────────────────────────────────────────────────────────┐
│  Opacity: 0 → 1                                            │
│  Scale: 0.95 → 1.0                                         │
│  Slide: 20px up → 0                                        │
│  Curve: fastOutSlowIn                                      │
└─────────────────────────────────────────────────────────────┘

Exit Animation (180ms)
┌─────────────────────────────────────────────────────────────┐
│  Opacity: 1 → 0                                            │
│  Scale: 1.0 → 0.95                                         │
│  Slide: 0 → 20px down                                      │
│  Curve: easeOut                                            │
└─────────────────────────────────────────────────────────────┘
```

### Button Interactions
```
Press Feedback (120ms)
┌─────────────────────────────────────────────────────────────┐
│  Scale: 1.0 → 0.98                                         │
│  Elevation: +2px                                            │
│  Curve: easeInOut                                          │
└─────────────────────────────────────────────────────────────┘

Hover States (150ms)
┌─────────────────────────────────────────────────────────────┐
│  Scale: 1.0 → 1.02                                         │
│  Elevation: +1px                                            │
│  Background: Slight opacity change                          │
└─────────────────────────────────────────────────────────────┘
```

### Confetti Animation
```
Particle Configuration
┌─────────────────────────────────────────────────────────────┐
│  Count: 18-28 particles                                     │
│  Duration: 600ms                                            │
│  Colors: [Primary, Secondary]                               │
│  Spread: 45 degrees                                         │
│  Gravity: 0.5                                               │
│  Fade: Opacity 1.0 → 0.0                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📱 Responsive Layouts

### Mobile Layout (320px - 599px)
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  App Bar                                            │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Content (1 column)                                │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │  Card 1                                     │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │  Card 2                                     │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │  Card 3                                     │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Footer CTA                                        │    │
│  └─────────────────────────────────────────────────────┘    │
│  Gutter: 16px                                               │
│  Touch Targets: ≥ 44px                                      │
└─────────────────────────────────────────────────────────────┘
```

### Tablet Layout (600px - 839px)
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  App Bar                                            │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Content (2 columns)                               │    │
│  │  ┌─────────────────┐  ┌─────────────────────────┐  │    │
│  │  │  Card 1         │  │  Card 2                 │  │    │
│  │  └─────────────────┘  └─────────────────────────┘  │    │
│  │  ┌─────────────────┐  ┌─────────────────────────┐  │    │
│  │  │  Card 3         │  │  Card 4                 │  │    │
│  │  └─────────────────┘  └─────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Footer CTA                                        │    │
│  └─────────────────────────────────────────────────────┘    │
│  Gutter: 24px                                               │
│  Column Gap: 16px                                           │
└─────────────────────────────────────────────────────────────┘
```

### Desktop Layout (840px+)
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  App Bar                                            │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────┬─────────────────────────────────────────────┐  │
│  │ Sidebar │  Content (3+ columns)                      │  │
│  │ 280px   │  ┌─────────┬─────────┬─────────┐          │  │
│  │         │  │  Card 1 │  Card 2 │  Card 3 │          │  │
│  │         │  └─────────┴─────────┴─────────┘          │  │
│  │         │  ┌─────────┬─────────┬─────────┐          │  │
│  │         │  │  Card 4 │  Card 5 │  Card 6 │          │  │
│  │         │  └─────────┴─────────┴─────────┘          │  │
│  └─────────┴─────────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Footer CTA                                        │    │
│  └─────────────────────────────────────────────────────┘    │
│  Gutter: 32px                                               │
│  Max Width: 840px                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🌍 Internationalization Examples

### English (en)
```
┌─────────────────────────────────────────────────────────────┐
│  Welcome to PocketA                                        │
│  Take control of your finances                             │
│                                                             │
│  [ Continue ]                                               │
└─────────────────────────────────────────────────────────────┘
```

### Bengali (bn)
```
┌─────────────────────────────────────────────────────────────┐
│  পকেটএ-তে স্বাগতম                                          │
│  আপনার আর্থিক অবস্থা নিয়ন্ত্রণ করুন                        │
│                                                             │
│  [ চালিয়ে যান ]                                            │
└─────────────────────────────────────────────────────────────┘
```

### Currency Formatting
```
┌─────────────────────────────────────────────────────────────┐
│  BDT: ৳1,234.56                                            │
│  USD: $1,234.56                                            │
│  EUR: €1,234.56                                            │
│                                                             │
│  Date Format (en): 12/15/2023                              │
│  Date Format (bn): 15-12-2023                              │
└─────────────────────────────────────────────────────────────┘
```

---

## ♿ Accessibility Features

### Focus Indicators
```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │  [ Continue ] ← Focus ring (2px primary)            │    │
│  └─────────────────────────────────────────────────────┘    │
│  Offset: 2px from element                                  │
│  Color: Primary color                                      │
│  Width: 2px                                                │
└─────────────────────────────────────────────────────────────┘
```

### Screen Reader Labels
```
┌─────────────────────────────────────────────────────────────┐
│  Semantic Labels:                                          │
│  • "Add transaction button"                                │
│  • "Enter amount in Bangladeshi Taka"                      │
│  • "Current balance: ৳1,234.56"                           │
│  • "Transaction added successfully"                        │
└─────────────────────────────────────────────────────────────┘
```

### Touch Targets
```
┌─────────────────────────────────────────────────────────────┐
│  Minimum Size: 44x44px                                     │
│  Recommended: 48x48px                                      │
│  Spacing: 8px minimum between targets                      │
│                                                             │
│  ┌─────┐ 8px ┌─────┐ 8px ┌─────┐                          │
│  │ 44px│     │ 44px│     │ 44px│                          │
│  └─────┘     └─────┘     └─────┘                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Usage Guidelines

### Do's
- ✅ Use design tokens for all colors, spacing, and typography
- ✅ Maintain consistent 8px grid spacing
- ✅ Follow accessibility guidelines (WCAG 2.1 AA)
- ✅ Test on multiple screen sizes
- ✅ Respect reduced motion preferences
- ✅ Use semantic HTML elements
- ✅ Provide clear focus indicators

### Don'ts
- ❌ Use hardcoded colors or spacing values
- ❌ Mix different border radius values randomly
- ❌ Create touch targets smaller than 44px
- ❌ Ignore color contrast requirements
- ❌ Use full-screen blur overlays
- ❌ Apply gradients over text cards
- ❌ Skip accessibility testing

---

*This component showcase provides visual examples and usage patterns for the PocketA design system. Use these examples as reference when implementing components to ensure consistency and quality across the application.*
