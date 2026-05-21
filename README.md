# BizDocx

AI-powered business document hub. Generate professional invoices, proposals, logos, and more — tailored to your brand.

## Features

- **Portfolios**: Manage separate identities for each of your businesses.
- **Paper-to-Digital Bridge**: Scan physical documents using multimodal AI (**Gemini 3.1 Pro**) to extract data and digitize them with your brand's styling.
- **Autonomous Organization**: AI automatically categorizes and routes documents into type-specific folders (Invoices, Proposals, etc.).
- **Manual Mode Toggle**: Take full administrative control over your filing cabinet with a dedicated manual organization mode.
- **Batch Productivity**: Multi-select documents to move, delete, or export in bulk.
- **AI Generation**: Powered by Gemini 3.1 Pro for structural documents and Imagen 4.0 for graphical assets.
- **Responsive Design**: Standardized A4 layouts for professional print-ready results.
- **Offline First**: Documents are cached locally for zero-latency viewing and offline access.
- **Cloud Sync**: Seamlessly sync your portfolios and documents across devices using Firebase.
- **Version History**: Iterate on your documents and restore any previous version with ease.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase Account
- Google AI Studio API Key (for Gemini/Imagen)
- Camera Access (for scanning features)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/empyrealworks/bizdocx.git
   cd bizdocx
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment**
   Create a `.env` file in the project root with the following keys:
   ```env
   GEMINI_API_KEY=your_api_key
   GEMINI_TEXT_MODEL=gemini-3.1-pro-preview
   GEMINI_VISION_MODEL=gemini-3.1-pro-preview
   GOOGLE_WEB_CLIENT_ID=your_web_client_id
   ```

4. **Generate Code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Firebase Setup**
   Ensure you have configured Firebase for Android and iOS using the Firebase CLI or `google-services.json`/`GoogleService-Info.plist` files.

6. **Run the app**
   ```bash
   flutter run
   ```

## Architecture

- **State Management**: Flutter Riverpod 3.x
- **Multimodal AI**: Gemini 3.1 Pro (Vision & Text)
- **Navigation**: GoRouter
- **Database**: Cloud Firestore (with Offline Persistence)
- **Storage**: Firebase Storage
- **Authentication**: Firebase Auth (Email/Password + Google Sign-In)
- **Local Caching**: SharedPreferences + path_provider

## Contributing

Contributions are welcome! Please read our contributing guidelines for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
