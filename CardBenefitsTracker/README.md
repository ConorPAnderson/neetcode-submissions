# Card Benefits Tracker

A simple iOS app to log the credit cards you hold, track the benefits each one
offers (so you actually use them before they expire), track the points/cash
back categories each card rewards, and quickly find which card to use for a
given purchase.

Everything is stored locally on your device with **SwiftData** — no account,
no backend, no network access required.

## Features

- **My Cards** — log each card (name, issuer, network, last 4 digits, annual
  fee, the date you opened it, a color). See total annual fees at a glance and
  how many days until each card's fee renews.
- **Benefits** — log the perks each card offers (e.g. "$300 Travel Credit",
  "Airport Lounge Access", "$10 Streaming Credit") with a dollar value and how
  often it resets (monthly, quarterly, every 6 months, annually, or one-time).
  Tap the checkmark to mark a benefit used — it automatically un-marks itself
  once the next period starts (aligned to your card's opening-date anniversary
  for annual benefits, or the calendar for monthly/quarterly/semi-annual
  ones), so you always see what's still available to claim.
- **Reward Categories** — log each card's bonus categories (Dining, Groceries,
  Travel, etc.), the multiplier or cash back rate, and any annual spending
  cap.
- **Best Card** — pick a spending category and instantly see every card that
  rewards it, ranked best to worst, so you know which card to pull out at
  checkout.
- **Overview** — total annual fees, total tracked benefit value, value used so
  far this period vs. fees paid, and upcoming renewals.

## Requirements

- Xcode 15 or later (Xcode 16 recommended)
- iOS 17.0+ deployment target (uses SwiftData + `NavigationStack`)

## Setup

This repo contains only the Swift source files — no `.xcodeproj` is checked
in, so you create a fresh Xcode project and drop the files in (takes about two
minutes):

1. Open Xcode → **File → New → Project… → iOS → App**.
2. Product Name: `CardBenefitsTracker`. Interface: **SwiftUI**. Language:
   **Swift**. Storage: **None** (this project sets up its own SwiftData
   container). Uncheck "Include Tests" if you don't need them.
3. In the project settings, set the **Minimum Deployment** to **iOS 17.0**.
4. In the Xcode Project Navigator, delete the auto-generated `ContentView.swift`
   and `Item.swift` (if Xcode created one) — keep the file that has `@main`
   (usually `CardBenefitsTrackerApp.swift`); you'll overwrite it with the one
   from this repo.
5. In Finder, open this `CardBenefitsTracker/Sources` folder and drag the
   `Models`, `Views`, `Support` folders plus `CardBenefitsTrackerApp.swift`
   and `RootTabView.swift` into the Xcode Project Navigator (drop them into
   the main app group). In the dialog, check **"Copy items if needed"** and
   make sure the app target's checkbox is ticked.
6. If Xcode already created its own `CardBenefitsTrackerApp.swift`, delete
   that one first so there's only a single `@main` entry point.
7. Select your iPhone (or a simulator) as the run destination. For an on-device
   install, go to the target's **Signing & Capabilities** tab and pick your
   Apple ID under **Team** (a free personal team works for installing on your
   own device).
8. Press **Run** (⌘R).

## Project structure

```
Sources/
  CardBenefitsTrackerApp.swift   # @main entry point, sets up the SwiftData container
  RootTabView.swift              # Cards / Best Card / Overview tabs
  Models/
    CreditCard.swift             # Card model + annual-fee renewal date logic
    Benefit.swift                # Benefit model + per-period usage tracking
    BenefitFrequency.swift       # Reset frequency enum + period-key logic
    RewardCategory.swift         # Reward category model (points/miles/cash back)
    RewardType.swift
    CardPresets.swift            # Preset colors, networks, category names
  Views/
    Cards/                       # List, detail, add/edit card
    Benefits/                    # Benefit row, add/edit benefit
    RewardCategories/            # Reward category row, add/edit
    BestCard/                    # "Which card should I use?" lookup
    Overview/                    # Totals dashboard
  Support/
    ColorHex.swift                # Hex string -> SwiftUI Color helper
```

## Notes on how benefit tracking works

Each benefit stores the "period key" (e.g. `2026-Q1`) it was last marked used
in. A computed property compares that to the *current* period for the
benefit's frequency:

- Monthly / quarterly / semi-annual periods follow the calendar.
- Annual periods follow your card's **opened-date anniversary**, not the
  calendar year — matching how issuers actually reset most annual credits.
- One-time benefits (like a welcome bonus) never auto-reset.

This means you don't need any background jobs or notifications for resets —
the "used" state simply and correctly re-evaluates itself every time you open
the app.
