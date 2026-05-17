# Scam Message Detector — Gen Digital Internship Prototype

A professional-grade, privacy-first mobile security assistant inspired by **Norton Genie**. This app uses a local, human-in-the-loop adaptive classifier to detect phishing and smishing patterns in SMS and emails.

## Project Overview
- **Option Chosen**: Option B — Scam Message Detector
- **Core Vision**: Create a trustworthy, AI-First security dashboard that empowers users to identify scams locally on their device, ensuring 100% data privacy.
- **Key Feature**: **Adaptive Learning Loop**. The app doesn't just use static rules; it learns from user feedback (confirmations and corrections) to refine its scoring weights and recognize specific message "fingerprints" locally.

## Setup Instructions

### Prerequisites
- Flutter SDK (3.x recommended)
- Android Studio / VS Code with Flutter plugins
- A mobile emulator or physical device

### Build & Run
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/rufatazizzade/norton-aifirst-intern-rufat-azizzade.git
    cd norton-aifirst-intern-rufat-azizzade
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```
4.  **Run automated tests**:
    ```bash
    flutter test
    ```

## App Demo with video

https://drive.google.com/file/d/1e_z9rP5uTFRSoIm4ilRuT7P4mkGvzbsV/view?usp=sharing

## AI Interaction Log

Here are 5 key interactions with Antigravity (AI Coding Assistant) that shaped this project:

1.  **UI Overhaul**: 
    - *Prompt*: "Improve the Flutter UI to look closer to a modern mobile security app inspired by Norton 360, but avoid exact branding."
    - *AI Response*: Restructured the app into a "Security Dashboard" with high-visibility status cards and premium Material 3 styling.
    - *Commentary*: This transformed a simple text checker into a professional-feeling security product, significantly improving the "Trust Factor."

2.  **Responsibility & Layout**:
    - *Prompt*: "Fix the Flutter RenderFlex overflow in scam_detector_screen.dart."
    - *AI Response*: Introduced `SingleChildScrollView` and `Wrap` layouts.
    - *Commentary*: Essential fix that ensured the app works perfectly on small Android phones and large desktop windows/web browsers.

3.  **Precision Heuristics**:
    - *Prompt*: "Improve ScamAnalyzerService to detect account restriction phrases like 'account has been limited' and suspicious banking domain patterns."
    - *AI Response*: Added a robust `FeatureExtractorService` with regex-based keyword and URL analysis.
    - *Commentary*: This moved the app from a basic keyword checker to a specialized phishing detector that handles common bank impersonation tactics.

4.  **Adaptive Learning Logic**:
    - *Prompt*: "Add a user feedback system so the classifier can improve locally over time without a backend."
    - *AI Response*: Implemented `FeedbackLearningService` using `shared_preferences` to adjust feature weights.
    - *Commentary*: This implemented the "AI-First" requirement, creating a local intelligence loop that respects privacy.

5.  **Feedback Loop Correction**:
    - *Prompt*: "When I repeatedly mark the same message as 'Actually scam', it still shows as Safe. Fix the learning system."
    - *AI Response*: Added **Message Fingerprinting**. The app now hashes message content and applies specific boosts to exact matches.
    - *Commentary*: This solved the "persistence" problem, making the app's learning feel immediate and tangible to the user.

## AI Code Review Summary

- **Asynchronous Optimization**: The AI identified that moving to `shared_preferences` required refactoring the analysis engine from synchronous to asynchronous. It provided a clean pattern for "loading weights -> analyzing -> returning results."
- **Feature Key Centralization**: During the feedback loop fix, the AI suggested creating `FeatureKeys` constants. This prevented "magic string" bugs where the learning service was updating different keys than the classifier was reading.
- **Responsive Architecture**: The AI suggested using `ConstrainedBox` with a max-width of 720px for the dashboard. This ensures the mobile-first design doesn't look "stretched" when running on a web browser or tablet.

## Reflection

### What did I learn?
I learned how to build a **Privacy-First AI** loop. In many modern apps, data is sent to a cloud for processing. Here, we proved that you can create an intelligent, adaptive system that stays entirely on the user's device. I also deepened my understanding of Material 3's premium aesthetics and how to manage complex reactive state with `Provider`.

### What would I do differently?
If I had more time, I would integrate a lightweight **TFLite (TensorFlow Lite)** model for Natural Language Processing alongside the heuristic engine. While our "weighted heuristic + fingerprinting" approach is deterministic and stable, a transformer-based model could detect "tone" and "sentiment" (like excessive urgency) even better than keyword lists. I would also add **Multilingual Support**, as phishing is a global problem and often targets non-English speakers with specific local language nuances.

---
**Author**: Rufat Azizzade  
**Submission Date**: May 15, 2026
