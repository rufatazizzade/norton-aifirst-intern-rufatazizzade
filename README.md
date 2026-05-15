# Norton AI-First Intern Assignment — Scam Message Detector

## Project Overview
This project is **Option B** of the Gen Digital / Norton Mobile Engineering AI-First Intern take-home assignment. It is a Flutter mobile application inspired by **Norton Genie** that helps users identify potential phishing and smishing attempts. 

The app uses a **local ML-inspired hybrid classifier** to estimate scam risk from SMS, email snippets, and URLs. By performing all analysis on the device, it ensures maximum user privacy and deterministic results.

> [!NOTE]
> This application is a prototype that detects common phishing and smishing patterns and estimates risk based on suspicious signals. It does not claim to detect every phishing attack.

## Features
- **Message & URL Analysis**: Analyze text snippets for social engineering and malicious link patterns.
- **ML-Inspired Local Classifier**: A hybrid scoring model that extracts features and applies weighted combination rules.
- **Interactive Scenarios**: 6 pre-loaded examples covering Banking, Delivery, Prize, IRS, and Login scams.
- **Detailed Risk Assessment**:
  - **Risk Level**: Safe, Suspicious, or Dangerous.
  - **Confidence Score**: A percentage-based estimate of risk.
  - **Detected Signals**: Transparency on *why* a message was flagged.
  - **Scam Categories**: Categorizes threats (e.g., Banking, Credential Theft).
- **Actionable Recommendations**: Plain-English advice on how to handle the message.
- **Premium UI/UX**: A modern, Material 3 "assistant-style" interface optimized for non-technical users.
- **Comprehensive Testing**: 20+ unit tests covering detection logic and state management.

## ML-Inspired Detection Approach
The detection engine follows a hybrid machine-learning-style architecture:

1. **Feature Extraction Layer**: Uses regular expressions and keyword analysis to extract features such as shortened URLs, lookalike domains, urgency language, threat patterns, and credential requests.
2. **Weighted Scoring Model**: Each feature is assigned a weight based on its historical significance in phishing attacks.
3. **Combination Rules**: A rule-based engine detects complex patterns (e.g., *Account Restriction + Action Request + URL*) that strongly indicate a coordinated phishing attempt.
4. **Risk Classification Layer**: Map scores into three buckets:
   - **0–24 Safe**: Low confidence of risk.
   - **25–59 Suspicious**: Warning signs present; requires caution.
   - **60–100 Dangerous**: High confidence of a malicious scam.

**Why Local Analysis?**
- **Privacy**: No message data or URLs ever leave the device.
- **Speed**: Instant results without network latency.
- **Determinism**: Facilitates reliable automated testing.
- **Path to ML**: This architecture is designed to be easily replaced by a **TensorFlow Lite** model or a real-time ML API in the future.

## Tech Stack
- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **Design System**: Material 3 (with Google Fonts: Outfit & Inter)
- **State Management**: `ChangeNotifier` (MVVM)
- **Testing**: `flutter_test`

## Setup Instructions
```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run

# 3. Run unit tests
flutter test
```
*Requires Flutter 3.x+. No API keys or environment variables required.*

## Human-in-the-loop Feedback Learning

This prototype includes a **local adaptive classifier** with a human-in-the-loop feedback loop. After each analysis, you can confirm whether the result was correct or flag it as "Actually safe" / "Actually a scam."

### How it works:
- **Local Learning**: Direct user feedback is stored locally using `shared_preferences`.
- **Adaptive Scoring**: The app adjusts small feature weights (+/- 3 to 15 points) based on your corrections.
- **Privacy First**: Feedback and learned weights are stored **only on this device**. No messages or identifiers are ever sent to a server.
- **Dynamic Improvement**: Over time, the app becomes more sensitive to patterns you flag as dangerous and more lenient toward those you flag as safe.

*Note: This is an ML-inspired adaptive scoring prototype, not a fully trained production model. It demonstrates a privacy-friendly approach to local model refinement.*

## Premium Security Dashboard UI/UX

The interface is inspired by modern mobile cybersecurity dashboard patterns, prioritizing trust, clarity, and ease of use for non-technical users.

### Key Design Principles:
- **Visual Safety Status**: A central dashboard-style card communicates risk levels (Safe, Suspicious, Dangerous) instantly using icons, color, and confidence scores.
- **Privacy-First Microcopy**: Reassuring language reinforces that all analysis happens locally on the device.
- **Clean Visual Hierarchy**: Uses rounded cards (24-28px), Material 3 typography, and a "cybersecurity blue" palette to create a professional assistant feel.
- **Responsive & Accessible**: Optimized for mobile phones, desktop windows, and dark mode.
- **Originality**: The design is a custom creation focused on security UX best practices; it does not use any copyrighted branding or assets.

## Project Architecture
- **Models**: Defines `RiskLevel`, `ScamCategory`, `ExtractedFeatures`, `ScamSignal`, and `ScamAnalysisResult`.
- **Services**:
  - `FeatureExtractorService`: Parses raw text into structured features.
  - `MlScamClassifierService`: Applies weighted scoring and combination rules.
  - `ScamAnalyzerService`: Orchestrates the analysis pipeline.
  - `LocalFeedbackStorageService`: Manages persistence of user feedback and adaptive weights.
  - `FeedbackLearningService`: Calculates weight adjustments based on user feedback.
- **ViewModel**: `ScamDetectorViewModel` manages UI state and the analysis lifecycle.
- **Screens/Widgets**: Declarative UI components built with a "premium assistant" aesthetic.

## Screenshots
![Home Screen](screenshots/home.png)
![Dangerous Result](screenshots/dangerous_result.png)
![Safe Result](screenshots/safe_result.png)

## AI Interaction Log

### 1. Architecture Planning
**Prompt:** "Suggest a clean architecture for a local scam detector that mimics an ML pipeline with feature extraction and classification."
**AI Suggestion:** Recommended a three-tier service structure: Extractor -> Classifier -> Analyzer.
**What I Accepted:** The three-tier service separation for better testability.
**What I Changed:** Added a dedicated `ExtractedFeatures` DTO to decouple the layers.

### 2. Feature Extraction Design
**Prompt:** "Create a list of regex and keywords to detect banking scams, delivery scams, and lookalike domains."
**AI Suggestion:** Provided comprehensive lists for urgency, threats, and brand keywords.
**What I Accepted:** Most keyword lists and the URL extraction regex.
**What I Changed:** Refined the domain extraction logic to avoid flagging official Norton/Gen domains as suspicious.

### 3. ML-Style Classifier Design
**Prompt:** "Design a weighted scoring model and combination rules for phishing detection."
**AI Suggestion:** Suggested weights ranging from 10 to 40 and specific pattern rules.
**What I Accepted:** The combination rule for "Problem + Action + Link".
**What I Changed:** Adjusted the thresholds (60 for Dangerous) to ensure the required test cases passed with high confidence.

### 4. Flutter UI/UX Improvement
**Prompt:** "Make the UI look like a premium cybersecurity assistant. Use Material 3, soft gradients, and white rounded cards."
**AI Suggestion:** Suggested using `LinearGradient` for the background and `Sliver`-based scrolling.
**What I Accepted:** The soft indigo gradient and the card-based layout.
**What I Changed:** Customized the "Step 1, 2, 3" indicators to use circular badges for a cleaner look.

### 5. Unit Test Generation
**Prompt:** "Generate unit tests for the classifier covering banking, delivery, and prize scams."
**AI Suggestion:** Provided test templates for `ScamAnalyzerService`.
**What I Accepted:** The `expect` patterns and setup/teardown logic.
**What I Changed:** Added specific category verification and manual review comments to the tests.

## AI Code Review Summary
- **AI suggested** separating feature extraction from classification to allow for future ML model integration.
- **AI suggested** adding combination rules to handle "multi-signal" phishing patterns that single-keyword checks miss.
- **AI suggested** adding edge case tests (empty input, short input) to improve robustness.
- **AI suggested** avoiding absolute claims like "detects all phishing" for ethical and liability reasons.
- **I applied these changes** and refined the logic to meet the Gen Digital intern submission standards.

## Reflection
Building this Scam Message Detector taught me the value of **hybrid thinking** in security products. While heuristics are powerful, structuring them as a local ML-style classifier makes the system much more maintainable and ready for future upgrades (like TensorFlow Lite). I learned that effective phishing detection requires looking at both technical signals (URLs) and social engineering tactics (urgency, threats). Most importantly, I learned how to use AI as a high-velocity pair programmer—leveraging its ability to generate boilerplate and keyword lists while maintaining human oversight for critical logic and UX polish.