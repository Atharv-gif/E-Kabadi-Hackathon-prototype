# ♻️ E-Kabadi

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38.3-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Riverpod-State%20Management-00BFA6?style=for-the-badge" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/GoRouter-Navigation-02569B?style=for-the-badge" alt="GoRouter"/>
  <img src="https://img.shields.io/badge/AI-Powered-8E44AD?style=for-the-badge" alt="AI"/>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/Atharv-gif/E-Kabadi-Hackathon-prototype?style=flat-square" alt="Stars"/>
  <img src="https://img.shields.io/github/forks/Atharv-gif/E-Kabadi-Hackathon-prototype?style=flat-square" alt="Forks"/>
  <img src="https://img.shields.io/github/last-commit/Atharv-gif/E-Kabadi-Hackathon-prototype?style=flat-square" alt="Last Commit"/>
</p>

<h3 align="center">
  AI-Powered Smart Scrap Collection & Reward Ecosystem
</h3>

<p align="center">
  <b>Turning waste into value through AI, digital collection, transparent pricing and sustainable rewards.</b>
</p>

<p align="center">
  🌱 <b>Identify</b> &nbsp;→&nbsp;
  💰 <b>Estimate</b> &nbsp;→&nbsp;
  📍 <b>Connect</b> &nbsp;→&nbsp;
  🚛 <b>Collect</b> &nbsp;→&nbsp;
  💳 <b>Pay</b> &nbsp;→&nbsp;
  ♻️ <b>Reward</b>
</p>

---

# 🌍 Overview

**E-Kabadi** is a smart scrap collection platform designed to digitally connect **citizens, scrap collectors and administrators** in one ecosystem.

The platform addresses the traditional problems of scrap collection by introducing:

* 🤖 AI-assisted scrap identification
* 💰 Intelligent value estimation
* 📍 Location-based collector discovery
* 🚛 Digital pickup management
* 💳 Digital transaction workflows
* 🎁 Citizen Eco Points
* 🪙 Collector Eco Coins
* 🖥️ Administrative management
* 📊 A scalable digital ecosystem for waste collection

The objective is simple:

> ### Make selling recyclable waste as simple as ordering a service.

Instead of the traditional process:

```text
Find a Kabadi
      ↓
Call / Negotiate
      ↓
Wait for Collection
      ↓
Manual Weighing
      ↓
Manual Price Calculation
      ↓
Cash Payment
```

E-Kabadi proposes:

```text
Capture Scrap
      ↓
AI Identification
      ↓
Value Estimation
      ↓
Request Pickup
      ↓
Collector Assignment
      ↓
Scrap Collection
      ↓
Digital Transaction
      ↓
Rewards
```

---

# 🚨 Problem Statement

The informal scrap collection process faces several challenges.

### 1. Lack of convenience

Citizens often have no simple digital way to request a scrap pickup.

### 2. Manual identification

Different recyclable materials can have significantly different values, making manual identification and estimation difficult.

### 3. Price uncertainty

Citizens may not know the approximate value of their recyclable materials before collection.

### 4. Unorganized collection

Collectors often depend on calls, local contacts and manual coordination.

### 5. Limited transparency

The transaction journey from pickup request to payment is difficult to track.

### 6. Lack of incentives

There is limited digital motivation for citizens and collectors to consistently participate in organized recycling.

### 7. Missed economic value

Recyclable materials can enter mixed-waste streams instead of being efficiently routed toward recycling.

---

# 💡 Our Solution

E-Kabadi creates a digital ecosystem connecting:

```text
        👤 CITIZENS
             │
             ▼
       ♻️ E-KABADI
             │
      ┌──────┴──────┐
      ▼             ▼
 🚛 COLLECTORS   🖥️ ADMIN
      │
      ▼
 ♻️ RECYCLING ECOSYSTEM
```

The platform provides separate experiences for:

### 👤 Citizen

Upload scrap → Identify → Estimate → Request pickup → Track → Get paid → Earn rewards

### 🚛 Collector

Go online → Receive request → Accept → Navigate → Collect → Complete transaction → Earn Eco Coins

### 🖥️ Admin

Manage and monitor the ecosystem through the administrative interface.

---

# ✨ Core Features

## 👤 Citizen Mode

### 📸 1. Scrap Identification

Citizens can capture or upload an image of scrap.

The AI-assisted workflow can help identify the material category and support the valuation process.

Example categories may include:

* 📰 Paper
* 🥤 Plastic
* 🔩 Metal
* 📦 Cardboard
* 🔌 E-waste
* 🧴 Other recyclable materials

---

### 💰 2. Scrap Value Estimation

After identifying the material, the application can provide an estimated value based on the pricing logic used by the prototype.

This gives the citizen a clearer idea of the expected transaction value.

---

### 📍 3. Collector Discovery

Citizens can request scrap collection and connect with available collectors.

---

### 🚛 4. Pickup Workflow

The citizen can follow the pickup process from request to collection.

```text
Request
   ↓
Pending
   ↓
Accepted
   ↓
Collector Arriving
   ↓
Collected
   ↓
Completed
```

---

### 💳 5. Digital Transaction

Once the scrap collection is completed, the transaction can be recorded digitally.

This creates a more transparent experience compared with purely cash-based informal transactions.

---

### 🎁 6. Citizen Eco Points

Citizens become eligible for Eco Points when their scrap bill reaches the defined threshold.

### Reward Rule

```text
If Bill >= ₹500

Eco Points = 10% of Bill Value
```

Example:

```text
Scrap Bill = ₹800

Eco Points
= 10% × ₹800
= ₹80 worth of Eco Points
```

This creates an incentive for citizens to participate in organized recycling.

---

# 🚛 Collector Mode

Collectors have a separate workflow optimized for pickup operations.

## 🟢 1. Online / Offline Status

Collectors can indicate their availability to receive pickup requests.

---

## 📦 2. Pickup Requests

Available collectors can receive collection requests from nearby citizens.

---

## 🤖 3. AI-Assisted Scrap Identification

The collector workflow can use the same AI-assisted identification concept to understand the material involved in the transaction.

---

## 📍 4. Navigation

Location-based functionality helps collectors reach the citizen's pickup location.

---

## 💰 5. Transaction Management

Collectors can complete the transaction after the scrap has been collected.

---

## 🪙 6. Eco Coins

Collectors receive Eco Coins from **every completed transaction**.

Unlike citizen rewards, collectors have **no minimum transaction threshold**.

```text
Every Completed Transaction
             ↓
          10%
             ↓
        Eco Coins
```

Example:

```text
Transaction = ₹300

Collector Eco Coins
= 10% × ₹300
= 30 Eco Coins
```

---

## 🎁 7. Eco Coin Redemption

Collected Eco Coins can be used within the proposed reward ecosystem for supported benefits such as:

* 🛒 Ration-related benefits
* 🏥 Medical facilities
* 🎁 Other supported rewards

---

# 🖥️ Admin Panel

E-Kabadi also contains a dedicated **Admin Panel**.

The administration layer is designed to provide centralized control over the platform ecosystem.

Potential administrative responsibilities include:

* 👤 User management
* 🚛 Collector management
* ♻️ Scrap category management
* 💰 Pricing management
* 📦 Transaction monitoring
* 🎁 Reward management
* 📊 Platform analytics
* 🛡️ Operational oversight

The admin layer allows the platform to move beyond a simple mobile application toward a complete ecosystem.

---

# 🔄 Complete User Journey

## 👤 Citizen Flow

```text
┌──────────────┐
│    LOGIN     │
└──────┬───────┘
       ↓
┌──────────────┐
│  DASHBOARD   │
└──────┬───────┘
       ↓
┌──────────────┐
│ CAPTURE SCRAP│
└──────┬───────┘
       ↓
┌──────────────┐
│ AI DETECTION │
└──────┬───────┘
       ↓
┌──────────────┐
│   ESTIMATE   │
└──────┬───────┘
       ↓
┌──────────────┐
│REQUEST PICKUP│
└──────┬───────┘
       ↓
┌──────────────┐
│  COLLECTOR   │
│   ACCEPTS    │
└──────┬───────┘
       ↓
┌──────────────┐
│    PICKUP    │
└──────┬───────┘
       ↓
┌──────────────┐
│   PAYMENT    │
└──────┬───────┘
       ↓
┌──────────────┐
│ ECO POINTS   │
└──────────────┘
```

---

## 🚛 Collector Flow

```text
┌──────────────┐
│    LOGIN     │
└──────┬───────┘
       ↓
┌──────────────┐
│  DASHBOARD   │
└──────┬───────┘
       ↓
┌──────────────┐
│   GO ONLINE  │
└──────┬───────┘
       ↓
┌──────────────┐
│   REQUESTS   │
└──────┬───────┘
       ↓
┌──────────────┐
│ ACCEPT PICKUP│
└──────┬───────┘
       ↓
┌──────────────┐
│   NAVIGATE   │
└──────┬───────┘
       ↓
┌──────────────┐
│ COLLECT SCRAP│
└──────┬───────┘
       ↓
┌──────────────┐
│   COMPLETE   │
│ TRANSACTION  │
└──────┬───────┘
       ↓
┌──────────────┐
│  ECO COINS   │
└──────────────┘
```

---

# 🧠 AI Integration

AI is a key component of the E-Kabadi concept.

The AI workflow is designed to assist with:

### ♻️ Material Identification

Analyze the uploaded/captured scrap image and determine its likely material category.

### 💰 Valuation Assistance

Use the detected material as an input to the pricing workflow.

### 🧠 Intelligent Assistance

The AI layer can be extended to provide additional information about recyclable materials and collection decisions.

### Future AI Improvements

The production version can introduce:

* Multi-material detection
* Confidence scores
* Quantity estimation
* Image quality validation
* Contamination detection
* Automated price recommendations
* Historical price learning
* AI-powered demand prediction

---

# 📍 Geospatial Collection

Location is an important part of the E-Kabadi ecosystem.

The platform can use geospatial information to connect:

```text
Citizen
   │
   │ Pickup Request
   ▼
Nearby Collectors
   │
   ▼
Available Collector
   │
   ▼
Navigation
   │
   ▼
Collection
```

This can reduce unnecessary travel and improve the efficiency of scrap collection.

---

# 🪙 Reward Ecosystem

E-Kabadi uses two different reward mechanisms.

| User         | Reward     | Eligibility                 |
| ------------ | ---------- | --------------------------- |
| 👤 Citizen   | Eco Points | Bill ≥ ₹500                 |
| 🚛 Collector | Eco Coins  | Every completed transaction |

### Citizen

```text
Bill >= ₹500
      ↓
10%
      ↓
Eco Points
```

### Collector

```text
Every Transaction
      ↓
10%
      ↓
Eco Coins
```

This creates two complementary incentive loops:

```text
Citizen
   ↓
More Scrap Collection
   ↓
More Recycling
   ↓
Eco Points
```

and

```text
Collector
   ↓
More Completed Pickups
   ↓
More Eco Coins
   ↓
More Incentives
```

---

# 🏗️ High-Level Architecture

```text
                         ┌──────────────────────┐
                         │      E-KABADI        │
                         │      PLATFORM        │
                         └──────────┬───────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
             ┌────────────┐ ┌────────────┐ ┌────────────┐
             │   CITIZEN  │ │ COLLECTOR  │ │   ADMIN    │
             │    APP     │ │    APP     │ │   PANEL    │
             └─────┬──────┘ └─────┬──────┘ └─────┬──────┘
                   │              │              │
                   └──────────────┼──────────────┘
                                  ▼
                       ┌────────────────────┐
                       │ APPLICATION LOGIC  │
                       └─────────┬──────────┘
                                 │
            ┌────────────────────┼────────────────────┐
            │                    │                    │
            ▼                    ▼                    ▼
      ┌───────────┐       ┌────────────┐       ┌────────────┐
      │ AI ENGINE │       │  LOCATION  │       │ TRANSACTION│
      │           │       │  SERVICES  │       │   SYSTEM   │
      └───────────┘       └────────────┘       └────────────┘
            │                    │                    │
            └────────────────────┼────────────────────┘
                                 ▼
                       ┌────────────────────┐
                       │ DATA / CLOUD LAYER │
                       └────────────────────┘
```

---

# 🛠️ Technology Stack

## 📱 Application

| Technology          | Usage                                  |
| ------------------- | -------------------------------------- |
| **Flutter**         | Cross-platform application development |
| **Dart**            | Application programming language       |
| **Riverpod**        | State management                       |
| **GoRouter**        | Application navigation                 |
| **Google Fonts**    | Typography                             |
| **Flutter Animate** | UI animations                          |
| **Lucide Icons**    | Interface icons                        |
| **Intl**            | Formatting & localization utilities    |

The current project dependencies are defined in `pubspec.yaml`.

---

# 📂 Repository Structure

```text
E-Kabadi-Hackathon-prototype/
│
├── 📱 lib/
│   ├── Application source code
│   ├── Screens
│   ├── Widgets
│   ├── Models
│   ├── Providers
│   └── Application logic
│
├── 🖥️ admin-panel/
│   └── Administrative interface
│
├── 🎨 assets/
│   └── images/
│
├── 🤖 android/
│   └── Android platform configuration
│
├── 🍎 ios/
│   └── iOS platform configuration
│
├── 🌐 web/
│   └── Web platform configuration
│
├── 🪟 windows/
│   └── Windows platform configuration
│
├── 🐧 linux/
│   └── Linux platform configuration
│
├── 🍎 macos/
│   └── macOS platform configuration
│
├── 🧪 test/
│   └── Test files
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── analyze_out.txt
├── test_out.txt
└── README.md
```

The repository currently contains the Flutter source, assets, admin panel, platform targets and test directory.

---

# 🚀 Getting Started

## Prerequisites

Install the following before running the project:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android SDK
* Git
* Android emulator or physical Android device

Verify Flutter:

```bash
flutter doctor
```

---

# 📥 Installation

### 1. Clone the repository

```bash
git clone https://github.com/Atharv-gif/E-Kabadi-Hackathon-prototype.git
```

### 2. Enter the project

```bash
cd E-Kabadi-Hackathon-prototype
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Check connected devices

```bash
flutter devices
```

### 5. Run the application

```bash
flutter run
```

---

# 📱 Running on Android

Connect an Android device through USB with **Developer Options** and **USB Debugging** enabled.

Check:

```bash
flutter devices
```

Then:

```bash
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

The generated APK can be found under:

```text
build/app/outputs/flutter-apk/
```

---

# 🧪 Testing

Run Flutter tests with:

```bash
flutter test
```

Analyze the project with:

```bash
flutter analyze
```

The repository also contains generated analysis/test output files for development reference.

---

# 🎨 Design Philosophy

E-Kabadi follows a modern, clean and approachable visual direction.

### Design principles

* 🌱 Eco-friendly visual identity
* 🧼 Clean interface
* 📱 Mobile-first experience
* 🎯 Simple user flows
* 🧩 Modular components
* ✨ Meaningful animations
* ♿ Accessible interaction patterns
* 📊 Information presented progressively

The goal is to make waste management feel like a **modern digital service**, rather than a traditional manual process.

---

# 🔐 Security & Privacy Considerations

A production deployment should implement:

* 🔐 Secure authentication
* 🛡️ Role-based authorization
* 🔒 Encrypted communication
* 👤 Identity verification
* 💳 Secure payment processing
* 📍 Controlled location access
* 🗄️ Secure data storage
* 🚨 Fraud detection
* 📜 Privacy policies and consent management

The current repository should be considered a **hackathon prototype**, not a production-ready financial or identity-verification system.

---

# 🎯 Prototype Scope

This repository represents the **hackathon prototype of E-Kabadi**.

The objective is to demonstrate the product concept, user experience and core workflows.

Some components may use prototype implementations, simulated data, predefined logic or demonstration flows.

Production deployment would require additional engineering, infrastructure, verification and security work.

---

# 🔮 Future Roadmap

## Phase 1 — Hackathon Prototype

* [x] Citizen experience
* [x] Collector experience
* [x] AI-assisted scrap identification concept
* [x] Scrap valuation workflow
* [x] Pickup workflow
* [x] Reward mechanism
* [x] Eco Points
* [x] Eco Coins
* [x] Admin interface
* [x] Responsive application structure

---

## Phase 2 — Production Platform

* [ ] Production backend
* [ ] Secure authentication
* [ ] Collector verification
* [ ] Real-time scrap prices
* [ ] Secure payment gateway
* [ ] Real-time pickup tracking
* [ ] Automated collector assignment
* [ ] Advanced analytics
* [ ] Fraud detection
* [ ] Notification system

---

## Phase 3 — Intelligent Waste Network

* [ ] 🧠 Advanced AI material recognition
* [ ] 📦 Quantity estimation
* [ ] 🚛 AI route optimization
* [ ] 📊 Waste-generation analytics
* [ ] 📈 Predictive scrap pricing
* [ ] 🌱 Carbon-credit integration
* [ ] 📡 IoT-enabled collection tracking
* [ ] 🏭 B2B recycling marketplace
* [ ] 🏛️ Municipal waste-management integration
* [ ] 🌍 Regional recycling intelligence

---

# 🌱 Environmental Impact

E-Kabadi aims to contribute to a circular waste ecosystem by encouraging recyclable materials to move through organized collection channels.

The proposed ecosystem can help:

```text
More Organized Collection
          ↓
Better Material Segregation
          ↓
Higher Recycling Participation
          ↓
Reduced Valuable Waste Loss
          ↓
More Efficient Resource Recovery
```

The platform's long-term vision is to connect citizens, collectors, recyclers and institutions into a digitally coordinated ecosystem.

---

# 💡 Future Expansion Opportunities

E-Kabadi can eventually expand beyond individual household scrap collection.

### 🏢 Businesses

Businesses could schedule bulk recyclable-material pickups.

### 🏫 Educational Institutions

Schools and universities could run organized recycling campaigns.

### 🏘️ Residential Communities

Apartment complexes and housing societies could have dedicated collection schedules.

### 🏭 Recycling Facilities

Recyclers could receive structured information about material availability.

### 🏛️ Municipal Bodies

Municipalities could use aggregated data to understand local waste-generation patterns.

---

# 🏆 Why E-Kabadi?

The platform brings multiple parts of the recycling process together:

```text
             ♻️ E-KABADI
                  │
     ┌────────────┼────────────┐
     │            │            │
     ▼            ▼            ▼
    AI       COLLECTION     REWARDS
     │            │            │
     └────────────┼────────────┘
                  ▼
          DIGITAL ECOSYSTEM
                  │
                  ▼
          ♻️ CIRCULAR ECONOMY
```

Instead of solving only one part of scrap management, E-Kabadi attempts to connect:

**Identification + Valuation + Collection + Location + Payment + Incentives**

into a single user experience.

---

# 📸 Screenshots

> Add your final application screenshots here before the hackathon submission.

Recommended structure:

```markdown
## 📱 Application Preview

| Citizen Dashboard | Scrap Detection |
|:---:|:---:|
| ![Citizen Dashboard](assets/images/citizen_dashboard.png) | ![Scrap Detection](assets/images/scrap_detection.png) |

| Collector Dashboard | Pickup Tracking |
|:---:|:---:|
| ![Collector Dashboard](assets/images/collector_dashboard.png) | ![Pickup Tracking](assets/images/pickup_tracking.png) |
```

Replace the filenames with the **actual filenames inside `assets/images/`**.

---

# 🎥 Demo

If you have a demo video, add it here:

```markdown
## 🎥 Demo

[▶️ Watch E-Kabadi Demo](YOUR_VIDEO_LINK)
```

You can use:

* YouTube
* Google Drive
* Loom
* GitHub-hosted video
* Any public demo URL

---

# 📊 Project Highlights

| Area                    | Implementation          |
| ----------------------- | ----------------------- |
| 📱 Mobile Application   | Flutter                 |
| 👤 Citizen Experience   | ✅                       |
| 🚛 Collector Experience | ✅                       |
| 🖥️ Admin Panel         | ✅                       |
| 🤖 AI Integration       | AI-assisted workflow    |
| 💰 Scrap Valuation      | ✅                       |
| 📍 Pickup Workflow      | ✅                       |
| 🎁 Citizen Rewards      | Eco Points              |
| 🪙 Collector Rewards    | Eco Coins               |
| 🧭 Navigation           | Location-based workflow |
| 🧪 Testing              | Flutter test structure  |
| 🎨 Modern UI            | Flutter UI + animations |

---

# 🤝 Contributing

This project was created as a hackathon prototype.

If you would like to contribute:

```bash
git fork
```

Create a feature branch:

```bash
git checkout -b feature/your-feature
```

Make your changes and commit:

```bash
git add .
git commit -m "feat: add your feature"
```

Push your branch:

```bash
git push origin feature/your-feature
```

Then open a Pull Request.

---

# 📜 License

This project is currently a **hackathon prototype**.

If you intend to open-source the project for public reuse, add an appropriate license such as MIT after confirming the team's preferred licensing terms.

---

# 👥 Team

<p align="center">

## 🚀 Team WeDev

<b>Building technology for a cleaner and smarter future.</b>

<br><br>

♻️   🤖   📍   💳   🌱

</p>

---

# 🏁 Hackathon Submission

### Project Name

# ♻️ E-Kabadi

### One-Line Pitch

> **An AI-powered digital ecosystem that connects citizens and scrap collectors while turning recyclable waste into value and rewards.**

### Core Technologies

**Flutter • Dart • Riverpod • GoRouter • AI • Geospatial Services • Digital Payments • Admin Dashboard**

---

# 🌍 Our Vision

## **Turn Waste Into Value.**

We believe recycling shouldn't be complicated.

It should be:

**Simple. Digital. Transparent. Rewarding. Sustainable.**

E-Kabadi is a step toward building that ecosystem.

---

<p align="center">

# ♻️ E-Kabadi

### <i>Every Scrap Has Value. Let's Unlock It.</i>

<br>

**Made with ❤️ by Team WeDev**

</p>
