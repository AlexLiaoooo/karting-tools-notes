---
type: idea-backlog
status: active
created: 2026-08-15
tags:
  - karting
  - product-ideas
  - web-app
---

# Karting Tools - Idea Backlog

The selected idea is documented in [[Track Map Notebook - Architecture]]. This note keeps the remaining ideas available for future review.

## Product direction

The strongest differentiator is not another large all-in-one racing platform. It is a collection of small, fast, local-first tools that:

- Work well on an iPhone at the circuit.
- Do not require an account for basic use.
- Continue working with poor connectivity.
- Keep data exportable and owned by the user.
- Solve one real trackside problem at a time.

## Priority shortlist

### 1. Kart Garage - Maintenance and Component Life

**Value:** Very high  
**First-version difficulty:** Low to medium  
**Backend required:** No

Track:

- Engine hours and rebuild history
- Gearbox oil and service intervals
- Tyre Runs and heat cycles
- Chain and sprocket life
- Brake pads, bearings, batteries and spark plugs
- Service cost, photos and notes
- Due soon / overdue reminders

Strong integration opportunity: completing a Run in Kart Data can automatically add usage to the selected engine, tyres and drivetrain components.

Market reference: [LookOver go-kart maintenance](https://lookover.app/go-kart-maintenance-app/)

### 2. Cost per Lap - Racing Expenses and Season Budget

**Value:** Very high  
**First-version difficulty:** Low to medium  
**Backend required:** No

Track:

- Entry and practice fees
- Tyres, fuel and oil
- Engine rebuilds and components
- Team / mechanic fees
- Travel, hotel and food
- Crash damage
- Season budget versus actual cost

Calculate:

- Cost per Event
- Cost per Session and Run
- Cost per lap
- Cost per hour of track time
- Tyre and engine amortisation
- Remaining season budget

### 3. Race Weekend Command Board

**Value:** High  
**First-version difficulty:** Low  
**Backend required:** No

A single screen showing:

- Next Session countdown
- Event timetable
- Driver briefing and live timing links
- Weather
- Current preparation checklist
- Tyres, fuel, battery and transponder status
- Rain equipment readiness
- One urgent action before going to the grid

This could eventually combine with Kart Garage and Kart Packing List.

Reference: [LeadFoot Racing Race Day Ready Pack](https://www.lead-footracing.com/race-day-ready)

### 4. Tyre Pressure Experiment

**Value:** High after enough personal data  
**First-version difficulty:** Medium  
**Backend required:** No

Use personal history rather than generic setup claims:

- Target hot pressure
- Actual cold and hot pressures
- Pressure gain
- Ambient and track temperature
- Run length
- Fastest lap and consistency
- Driver feedback
- Similar historical conditions

The tool should initially describe patterns and comparable Runs. It should not claim to know the correct tyre pressure until enough user data exists.

### 5. Results Card Generator

**Value:** Medium to high  
**First-version difficulty:** Medium  
**Backend required:** No for manual input; maybe for result import

Workflow:

1. Enter or import position, class and best lap.
2. Upload a racing photograph.
3. Add sponsor logos and team colours.
4. Generate Instagram, WeChat and landscape race-summary graphics.
5. Export PNG.

Avoid rebuilding full live timing. Alpha RaceHub and MYLAPS already cover results and lap timing.

- [Alpha RaceHub](https://www.alpharacehub.com/)
- [MYLAPS Speedhive](https://mylaps.com/motorsports/services/speedhive/)

### 6. Gear Ratio Notebook

**Value:** Medium  
**First-version difficulty:** Low  
**Backend required:** No

The differentiator should be saved experiments, not just a ratio calculation:

- Front/rear sprocket combination
- Ratio and percentage change
- Theoretical speed at target RPM
- Maximum RPM actually reached
- Track, weather and best lap
- Previous combinations used at the same track
- What changed after adding or removing one tooth

### 7. Kart Packing List

**Value:** Medium to high  
**First-version difficulty:** Low  
**Backend required:** No

Reusable templates for Practice, Club Race, National Race and Wet Weekend:

- Driver equipment
- Tools
- Spares
- Tyres and wheels
- Fuel, oil and fluids
- Electronics, chargers and transponder
- Documents
- Paddock equipment, food and clothing
- Quantity and packed-box location
- “Forgot last time” notes

### 8. Trailer and Spares Inventory

**Value:** Medium  
**First-version difficulty:** Medium  
**Backend required:** No

- Inventory by toolbox, shelf or trailer box
- Quantity and minimum stock
- Consumable warnings
- Part number and supplier link
- QR label for each box
- Pack/unpack check
- Record where borrowed parts came from or went

### 9. Driver Debrief Recorder

**Value:** High if interaction is extremely fast  
**First-version difficulty:** Medium  
**Backend required:** Optional; AI version requires an API

Record a 30-second voice note immediately after a Run and turn it into:

- Entry / mid-corner / exit feedback
- Handling problem
- Corners mentioned
- Setup change made
- Next Run action
- Uncertain items that need confirmation

An offline version could simply attach audio to the Run. AI structuring can be added later.

### 10. MyChron / Alfano Screen Scanner

**Value:** High  
**First-version difficulty:** Medium to high  
**Backend required:** Depends on OCR approach

Photograph the data logger and extract:

- Best lap
- Lap count
- Maximum RPM
- Water temperature
- EGT
- Session time

The user must confirm recognised values before saving. Existing competitors already advertise dashboard image recognition, so this is useful but not a unique first project.

Market references:

- [Kartwise Pro](https://kartwisepro.com/)
- [Kart Track](https://karttrackapp.com/app)

### 11. Regulation Change Tracker

**Value:** Potentially high  
**First-version difficulty:** High  
**Backend required:** Yes

- Select championship, class, chassis and engine
- Monitor new yearbooks, bulletins and driver packs
- Highlight new or changed clauses
- Save acknowledgement status
- Link every summary back to the original PDF and exact section

This is accuracy-sensitive. It should never replace the official regulations and requires scheduled online monitoring.

### 12. Personal Live Timing Focus View

**Value:** Medium to high  
**First-version difficulty:** High  
**Backend required:** Likely

Show only one selected driver:

- Position
- Last and best lap
- Gap ahead and behind
- Lap number
- Flag status
- Simple trend

The main risk is dependence on timing-provider APIs or fragile page scraping. It should not be started until an official data source or approved export is confirmed.

## Adjacent tools outside karting

### Equipment Life Log

A general version of Kart Garage for bicycles, motorbikes, cameras, tools, trailers and other equipment. Store purchase details, serial numbers, receipts, warranties, runtime, maintenance and consumables.

### Repeat Trip Kit

Reusable packing templates for karting, skiing, camping, photography trips, business travel and moving. Remember quantities, container locations, consumables and what was forgotten last time.

### Personal Experiment Notebook

A generalised version of Event → Session → Run where the user defines fields and compares trials. Possible uses include coffee brewing, fitness, 3D printing, photography, gardening and workshop tests.

### Warranty and Receipt Vault

Local-first equipment records with purchase date, receipt image, serial number, warranty expiry, service history and exportable backup.

## Ideas not recommended as immediate projects

- Another generic all-in-one Setup logger with AI advice
- A basic standalone gear-ratio calculator with no saved history
- A live-results aggregator based on unapproved scraping
- Team accounts, chat, subscription and social networking before a single-user workflow is proven
- Setup recommendations presented as certain before sufficient personal evidence exists

## Suggested future order

1. Track Map Notebook
2. Kart Garage
3. Cost per Lap
4. Race Weekend Command Board
5. Tyre Pressure Experiment
6. Results Card Generator
7. Gear Ratio Notebook

