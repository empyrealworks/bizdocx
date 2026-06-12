// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BizDocx';

  @override
  String get appSubtitle => 'Your AI document hub.';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign Out?';

  @override
  String get signOutMessage =>
      'Are you sure you want to sign out of your account?';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get system => 'System';

  @override
  String get systemSubtitle => 'Follow device setting';

  @override
  String get light => 'Light';

  @override
  String get lightSubtitle => 'Always light';

  @override
  String get dark => 'Dark';

  @override
  String get darkSubtitle => 'Always dark';

  @override
  String get subscription => 'Subscription';

  @override
  String get plansAndCredits => 'Plans & Credits';

  @override
  String get storage => 'Storage';

  @override
  String get localCache => 'Local Cache';

  @override
  String get clear => 'Clear';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheConfirm => 'Clear Local Cache?';

  @override
  String get clearCacheMessage =>
      'This will remove all locally stored PDF and image previews. They will be re-downloaded or re-generated as needed.';

  @override
  String get supportAndLegal => 'Support & Legal';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get account => 'Account';

  @override
  String get deleteMyData => 'Delete My Data';

  @override
  String get deleteAccount => 'Delete Account?';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account and all associated portfolios and documents. This action cannot be undone.';

  @override
  String get deleteEverything => 'Delete Everything';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get app => 'App';

  @override
  String get aiEngine => 'AI Engine';

  @override
  String get aiEngineSubtitle => 'Advanced Structural + Neural Image';

  @override
  String get generate => 'Generate';

  @override
  String get generateAsset => 'Generate Asset';

  @override
  String get category => 'Category';

  @override
  String get styleTemplate => 'Style Template';

  @override
  String get orientation => 'Orientation';

  @override
  String get documentFormat => 'Document Format';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get assetTitle => 'Asset Title';

  @override
  String get prompt => 'Prompt';

  @override
  String get promptDescription =>
      'Describe specific details. The style and context are applied automatically.';

  @override
  String generateWithCredits(int cost) {
    return 'Generate ($cost Credits)';
  }

  @override
  String runningLow(int balance) {
    return 'Running low! ($balance credits remaining). Top up to avoid interruptions.';
  }

  @override
  String get topUp => 'Top Up';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get viewPlans => 'View Plans';

  @override
  String get error => 'Error';

  @override
  String deletionFailed(Object error) {
    return 'Deletion failed: $error';
  }

  @override
  String get generationFailed => 'Generation Failed';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String get generationCancelled => 'Generation Cancelled';

  @override
  String get operationCancelled => 'The operation was cancelled by the user.';

  @override
  String get newBusiness => 'New Business';

  @override
  String get noBusinesses => 'No businesses yet';

  @override
  String get createPortfolioPrompt =>
      'Create a portfolio to start generating AI-powered documents.';

  @override
  String get createFirstBusiness => 'Create First Business';

  @override
  String activePlan(String tier) {
    return 'ACTIVE PLAN: $tier';
  }

  @override
  String creditsAvailable(int credits) {
    return '$credits Credits Available';
  }

  @override
  String get offlineBanner => 'You are currently offline';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get restore => 'Restore';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get welcomeTitle => 'Welcome to BizDocx';

  @override
  String get welcomeHeadline => 'Business documents,\nbeautifully made.';

  @override
  String get welcomeBody =>
      'Generate professional invoices, proposals, logos, and more — powered by AI and tailored to your brand.';

  @override
  String get invoice => 'Invoice';

  @override
  String get proposal => 'Proposal';

  @override
  String get logo => 'Logo';

  @override
  String get contract => 'Contract';

  @override
  String get portfolioTitle => 'Business Portfolios';

  @override
  String get portfolioHeadline => 'Multi-entity management.';

  @override
  String get portfolioBody =>
      'Run multiple businesses? Create dedicated portfolios for each to keep your documents and brand contexts separate.';

  @override
  String get myCreativeStudio => 'My Creative Studio';

  @override
  String get studioSubtitle => 'Design & Branding';

  @override
  String get luxeRetail => 'Luxe Retail Ltd';

  @override
  String get retailSubtitle => 'E-commerce';

  @override
  String docsCount(int count) {
    return '$count docs';
  }

  @override
  String get scanTitle => 'Scan & Digitize';

  @override
  String get scanHeadline => 'Paper to Digital in seconds.';

  @override
  String get scanBody =>
      'Scan physical invoices or receipts. Our AI extracts the data and digitizes them into your business folder instantly.';

  @override
  String get scanning => 'Scanning...';

  @override
  String get extractingData => 'Extracting Data...';

  @override
  String get genTitle => 'AI Generation';

  @override
  String get genHeadline => 'Smart templates, zero effort.';

  @override
  String get genBody =>
      'Just describe what you need. AI handles the layout, calculations, and styling based on your business profile.';

  @override
  String get docEngine => 'Document Engine';

  @override
  String get visualEngine => 'Visual Engine';

  @override
  String get illustration => 'Illustration';

  @override
  String get badge => 'Badge';

  @override
  String get filingTitle => 'Autonomous Filing';

  @override
  String get filingHeadline => 'Organization on autopilot.';

  @override
  String get filingBody =>
      'BizDocx automatically routes documents to the right folders, identifies clients, and tags versions without you lifting a finger.';

  @override
  String get assetsTitle => 'Brand Identity';

  @override
  String get assetsHeadline => 'Your brand, everywhere.';

  @override
  String get assetsBody =>
      'Upload your logo once. AI intelligently places it and applies your brand colors to every document you generate.';

  @override
  String get uploadLogo => 'Upload Logo';

  @override
  String get refineTitle => 'Iterative Refinement';

  @override
  String get refineHeadline => 'Perfect every detail.';

  @override
  String get refineBody =>
      'Not quite right? Ask the AI to \'add a signature line\' or \'make it more formal\'. Refine until it\'s perfect.';

  @override
  String get smartTitle => 'Smart Fields';

  @override
  String get smartHeadline => 'Actionable document data.';

  @override
  String get smartBody =>
      'AI automatically detects totals, tax, clients, and dates. Get insights across your entire business portfolio.';

  @override
  String get totalDue => 'TOTAL DUE';

  @override
  String get client => 'CLIENT';

  @override
  String get finalTitle => 'Ready to Scale?';

  @override
  String get finalHeadline => 'Level up your workflow.';

  @override
  String get finalBody =>
      'Join thousands of businesses using BizDocx to save hours on administration and focus on what matters.';

  @override
  String get ready => 'READY';

  @override
  String get getStartedHeadline => 'Let\'s build something\nbeautiful.';

  @override
  String get getStartedBody =>
      'Sign in or create a free account to start generating documents for your business in seconds.';

  @override
  String get alreadyHaveAccount => 'I already have an account  →';

  @override
  String get phaseLoadingContext => 'Loading Context';

  @override
  String get phaseGenerating => 'Generating Document';

  @override
  String get phaseRendering => 'Rendering Asset';

  @override
  String get phaseSaving => 'Saving to Cloud';

  @override
  String get phaseSavingVersion => 'Saving Version';

  @override
  String get phaseWorking => 'Working...';

  @override
  String get phaseLoadingContextSub =>
      'Retrieving your business context for personalisation.';

  @override
  String get phaseGeneratingSub =>
      'Crafting your document using your business profile.';

  @override
  String get phaseRenderingSub => 'Processing and caching the generated asset.';

  @override
  String get phaseSavingSub => 'Saving to Cloud and caching locally.';

  @override
  String get phaseSavingVersionSub => 'Archiving this version in your history.';

  @override
  String get success => 'Success';

  @override
  String get pleaseEnterTitleAndPrompt => 'Please enter a title and prompt.';

  @override
  String get topUpMessage =>
      'Upgrade now to unlock professional designs and remove watermarks.';

  @override
  String get premiumTemplate => 'Premium Template';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get businessName => 'Business Name *';

  @override
  String get shortDescription =>
      'Short Description (e.g. Creative Design Agency)';

  @override
  String get missionStatement => 'Mission Statement';

  @override
  String get contactAndIdentity => 'Contact & Identity';

  @override
  String get physicalAddress => 'Physical Address';

  @override
  String get businessEmail => 'Business Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get website => 'Website (e.g. www.empyreal.works)';

  @override
  String get localization => 'Localization';

  @override
  String get country => 'Country';

  @override
  String get defaultCurrency => 'Default Currency (e.g. NGN)';

  @override
  String get branding => 'Branding';

  @override
  String get brandColors => 'Brand Colors (comma-separated hex)';

  @override
  String get targetAudience => 'Target Audience (e.g. Small business owners)';

  @override
  String get createPortfolio => 'Create Portfolio';

  @override
  String get createPortfolioDescription =>
      'Provide more details to help the AI generate smarter, localized documents.';

  @override
  String get editBusiness => 'Edit Business';

  @override
  String get updatePortfolio => 'Update Portfolio';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailForReset =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String resetLinkSent(String email) {
    return 'We\'ve sent a password reset link to $email. Please check your inbox (and spam folder).';
  }

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get all => 'All';

  @override
  String get allTypes => 'All types';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get groupByClient => 'Group by Client';

  @override
  String get groupByType => 'Group by Type';

  @override
  String get moveToFolder => 'Move to Folder';

  @override
  String get rootNoFolder => 'Root / No Folder';

  @override
  String get newFolder => 'New Folder';

  @override
  String get folderName => 'Folder name';

  @override
  String get create => 'Create';

  @override
  String get deleteSelected => 'Delete Selected?';

  @override
  String get deleteSelectedMessage =>
      'Are you sure you want to delete all selected documents? This cannot be undone.';

  @override
  String get deleteFolder => 'Delete Folder?';

  @override
  String get deleteFolderMessage =>
      'Deleting a folder will not delete the documents inside; they will move to the root.';

  @override
  String get noMatchingDocuments => 'No matching documents';

  @override
  String get noDocumentsYet => 'No documents yet';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get clearFiltersPrompt => 'Try clearing filters to see all documents.';

  @override
  String get generatePrompt => 'Tap Generate to create your first AI document.';

  @override
  String get scan => 'Scan';

  @override
  String get unknownClient => 'Unknown Client';

  @override
  String get files => 'Files';

  @override
  String get aiOrganizationMode => 'AI Organization Mode Enabled';

  @override
  String get manualOrganizationMode => 'Manual Organization Mode Enabled';

  @override
  String get aiRoutingEnabled => 'AI Routing Enabled';

  @override
  String get manualModeEnabled => 'Manual Mode Enabled';

  @override
  String get sortOptions => 'Sort options';

  @override
  String get manageAssets => 'Manage assets & logo';

  @override
  String get editBusinessInfo => 'Edit business info';

  @override
  String get scanDocument => 'Scan Document';

  @override
  String get scanPrompt =>
      'Take a photo or upload an existing document to digitize it with AI.';

  @override
  String get analyzingDocument => 'Analyzing document...';

  @override
  String get analyzingSub =>
      'AI is extracting data and merging with your brand...';

  @override
  String get analysisFailed => 'Analysis Failed';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get scanComplete => 'Scan Complete';

  @override
  String get discard => 'Discard';

  @override
  String get saveDocument => 'Save Document';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get type => 'Type';

  @override
  String get total => 'Total';

  @override
  String get date => 'Date';

  @override
  String get portfolioAssets => 'Portfolio Assets';

  @override
  String get removeLogo => 'Remove logo?';

  @override
  String get remove => 'Remove';

  @override
  String get replace => 'Replace';

  @override
  String get upload => 'Upload';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get tapToAddLogo => 'Tap to add logo';

  @override
  String get companyLogo => 'COMPANY LOGO';

  @override
  String get logoHelp =>
      'Appears in invoices, proposals, letterheads, and business cards.';

  @override
  String get assetsHelp =>
      'Assets here are automatically included in relevant generated documents.';

  @override
  String get logoUploaded =>
      'Logo uploaded. New documents will include it automatically.';

  @override
  String get removeLogoConfirm =>
      'The logo will be removed from future documents. Existing documents are unaffected.';

  @override
  String get signedAndLocked => 'DOCUMENT SIGNED & LOCKED';

  @override
  String lowBalance(int balance) {
    return 'Low balance: $balance credits remaining.';
  }

  @override
  String get preparingPdf => 'Preparing your PDF...';

  @override
  String get convertingLayout => 'Converting high-fidelity layout';

  @override
  String freeRevision(int count) {
    return 'FREE REVISION $count/3';
  }

  @override
  String get describeAChange => 'Describe a change...';

  @override
  String get free => 'FREE';

  @override
  String couldNotLoad(String error) {
    return 'Could not load: $error';
  }

  @override
  String get noPreviewAvailable => 'No preview available.';

  @override
  String edited(String date) {
    return 'edited $date';
  }

  @override
  String get operationFailed => 'Operation Failed';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get newDocumentDetails => 'New Document Details';

  @override
  String get quickLocalEdit => 'Quick Local Edit';

  @override
  String get smartFieldsHelp =>
      'Modify the smart fields below to update the document layout locally.';

  @override
  String get noSmartFields => 'No smart fields found in this document.';

  @override
  String get saveAndPreview => 'Save & Preview';

  @override
  String get newDocumentCreated => 'New document created successfully.';

  @override
  String get documentUpdated => 'Document updated successfully.';

  @override
  String errorSaving(String error) {
    return 'Error saving: $error';
  }

  @override
  String enterField(String key) {
    return 'Enter $key';
  }

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get contactHelp =>
      'Have a question, feedback, or need help with a document? Reach out to our team.';

  @override
  String get emailSupport => 'Email Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get sendFeedback => 'Send us your thoughts';

  @override
  String get lastUpdated => 'Last updated: July 2024';

  @override
  String get noTemplates => 'No templates available for this category.';

  @override
  String get premium => 'PREMIUM';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get security => 'Security';

  @override
  String get appLock => 'App Lock';

  @override
  String get appLockDescription => 'Require PIN or Biometrics to open the app.';

  @override
  String get lockTimeout => 'Lock Timeout';

  @override
  String get immediate => 'Immediate';

  @override
  String get after1Min => 'After 1 minute';

  @override
  String get after30Min => 'After 30 minutes';

  @override
  String get changePin => 'Change PIN';

  @override
  String get setPin => 'Set PIN';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get authenticateToContinue => 'Please authenticate to continue';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get pinAuth => 'PIN Authentication';

  @override
  String get unlock => 'Unlock';

  @override
  String get wrongPin => 'Incorrect PIN. Please try again.';

  @override
  String get errorUserNotFound => 'User not found.';

  @override
  String get errorWrongPassword => 'Incorrect password.';

  @override
  String get errorEmailInUse => 'Email already in use.';

  @override
  String get errorWeakPassword => 'Password is too weak.';

  @override
  String get errorInvalidEmail => 'Invalid email address.';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get required => 'Required';

  @override
  String get min4Chars => 'Min 4 characters';

  @override
  String get min6Chars => 'Min 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get paperSizeA4 => 'A4 Standard';

  @override
  String get paperSizeA3 => 'A3 Large';

  @override
  String get paperSizeA5 => 'A5 Small';

  @override
  String get paperSizeLetter => 'US Letter';

  @override
  String get paperSizeLegal => 'US Legal';

  @override
  String get paperSizeExecutive => 'Executive';

  @override
  String get paperSizeTabloid => 'Tabloid';

  @override
  String get paperSizeContinuous => 'Continuous (Long)';

  @override
  String get docTypeInvoice => 'Invoice';

  @override
  String get docTypeProposal => 'Proposal';

  @override
  String get docTypeLetterhead => 'Letterhead';

  @override
  String get docTypeBusinessCard => 'Business Card';

  @override
  String get docTypeContract => 'Contract';

  @override
  String get docTypeLogo => 'Logo';

  @override
  String get docTypeIcon => 'Icon';

  @override
  String get docTypeOther => 'Other';

  @override
  String get structural => 'Structural';

  @override
  String get graphical => 'Graphical';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Landscape';

  @override
  String suggestedFields(String type) {
    return 'Suggested fields for $type';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get original => 'Original';

  @override
  String get refined => 'Refined';

  @override
  String get signed => 'Signed';

  @override
  String get versionHistory => 'Version History';

  @override
  String get restoreVersion => 'Restore Version?';

  @override
  String restoreVersionMessage(int number) {
    return 'This will set the current document to Version $number.';
  }

  @override
  String get current => 'CURRENT';

  @override
  String get noPreviousVersions => 'No previous versions available.';

  @override
  String get signDocument => 'Sign Document';

  @override
  String get documentSigned => 'Document signed successfully.';

  @override
  String errorSigning(String error) {
    return 'Error signing: $error';
  }

  @override
  String get signatureInstructions =>
      'Draw your signature below. Once applied, this document will be locked for further AI edits.';

  @override
  String get applySignature => 'Apply Signature';

  @override
  String versionNumber(int number) {
    return 'Version $number';
  }

  @override
  String get originalGeneration => 'Original Generation';

  @override
  String get privacyIntroTitle => 'Introduction';

  @override
  String get privacyIntroBody =>
      'At BizDocx, we are committed to protecting your privacy. This policy explains how we collect, use, and safeguard your information when you use our AI-powered document hub.';

  @override
  String get privacyCollectionTitle => 'Data Collection';

  @override
  String get privacyCollectionBody =>
      'We collect information necessary to provide our services, including account details (name, email) and the business context you provide (company name, mission, brand colors) to generate documents.';

  @override
  String get privacyAiTitle => 'AI and Your Content';

  @override
  String get privacyAiBody =>
      'Your document prompts and business context are processed by our secure AI generation partners to create high-quality business assets. We do not use your data to train our own models without explicit consent.';

  @override
  String get privacySecurityTitle => 'Data Security';

  @override
  String get privacySecurityBody =>
      'Your data is stored securely using enterprise-grade cloud infrastructure. We implement industry-standard security measures to protect against unauthorized access or disclosure.';

  @override
  String get privacyRightsTitle => 'User Rights';

  @override
  String get privacyRightsBody =>
      'You have the right to access, correct, or delete your data at any time through the app settings. Deleting your account will remove all associated portfolios, documents, and profile information.';
}
