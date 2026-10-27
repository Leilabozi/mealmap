# MealMap App Store submission checklist

MealMap can be archived and uploaded after you complete the items below that only you can do in Apple Developer / App Store Connect.

## Still required before a public listing

1. **Apple Developer Program** membership ($99/year).
2. **TheMealDB reply.** Their API page says test key `"1"` is for development/education and a supporter key is required for a public App Store app. Keep using the current URL until they answer. If they send a production key, change only `baseURL` in `MealService`.
3. **App Store Connect privacy nutrition labels** (see below).
4. **Screenshots** on a recent iPhone size (and iPad if you keep iPad in the target).
5. **Review notes** explaining there is no account, data is on-device, and recipes come from TheMealDB.

## App Privacy (App Store Connect)

MealMap does not sign in, does not use analytics, and does not collect accounts.

Declare:

- **Data used to track you:** No
- **Data linked to you:** No
- **Data not linked to you:** optionally **Other User Content** (recipe search text) sent to TheMealDB, used for App Functionality, not used for tracking

Search queries leave the device only to `themealdb.com`. Meal plans and groceries stay on the iPhone.

## Permissions

No camera, photos, location, contacts, or notifications. Do not add usage-description keys you do not use.

`ITSAppUsesNonExemptEncryption` is `false` (HTTPS only).

## Attribution

The in-app **About** screen (Search tab, info button) credits TheMealDB. Keep that screen.

Support URL / marketing URL can be TheMealDB plus your GitHub or a simple page you control.

## Suggested listing copy

**Name:** MealMap

**Subtitle:** Weekly meals and groceries

**Category:** Food & Drink (secondary: Health & Fitness)

**Description:**

MealMap helps you search recipes, plan Breakfast, Lunch, Dinner, and Snacks from Sunday through Saturday, and keep a grocery list on your iPhone.

Search uses TheMealDB. Your meal plan and groceries are saved on this device. There is no account.

**Keywords:** meal planner, recipes, grocery list, weekly meals, cooking

**Age rating:** 4+ (no user-generated public content, no alcohol-focused social features). Review the recipe catalog; some TheMealDB meals mention alcohol.

## Review notes (paste into App Store Connect)

This app has no login. Testers can search a recipe (for example “chicken”), open it, tap Add to Plan, choose a day and meal, then check Groceries.

Recipe content is provided by TheMealDB (https://www.themealdb.com). Local meal plans and grocery items use SwiftData on device.

## Device testing before submit

1. Search a real recipe, nonsense text, and airplane mode.
2. Add, replace, and remove meals; force-quit; confirm the plan remains.
3. Generated groceries, check/uncheck, add/edit/delete, force-quit, confirm groceries remain.
4. Dark Mode and larger Dynamic Type.
5. VoiceOver on Search, Plan, and Groceries.

## Version

Marketing version `1.0`, build `1` in the Xcode target.
