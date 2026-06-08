import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BizDocx'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI document hub.'**
  String get appSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get signOutConfirm;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account?'**
  String get signOutMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @systemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow device setting'**
  String get systemSubtitle;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @lightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always light'**
  String get lightSubtitle;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @darkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always dark'**
  String get darkSubtitle;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @plansAndCredits.
  ///
  /// In en, this message translates to:
  /// **'Plans & Credits'**
  String get plansAndCredits;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @localCache.
  ///
  /// In en, this message translates to:
  /// **'Local Cache'**
  String get localCache;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear Local Cache?'**
  String get clearCacheConfirm;

  /// No description provided for @clearCacheMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all locally stored PDF and image previews. They will be re-downloaded or re-generated as needed.'**
  String get clearCacheMessage;

  /// No description provided for @supportAndLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportAndLegal;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @deleteMyData.
  ///
  /// In en, this message translates to:
  /// **'Delete My Data'**
  String get deleteMyData;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccount;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all associated portfolios and documents. This action cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete Everything'**
  String get deleteEverything;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aiEngine.
  ///
  /// In en, this message translates to:
  /// **'AI Engine'**
  String get aiEngine;

  /// No description provided for @aiEngineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Structural + Neural Image'**
  String get aiEngineSubtitle;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @generateAsset.
  ///
  /// In en, this message translates to:
  /// **'Generate Asset'**
  String get generateAsset;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @styleTemplate.
  ///
  /// In en, this message translates to:
  /// **'Style Template'**
  String get styleTemplate;

  /// No description provided for @orientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get orientation;

  /// No description provided for @documentFormat.
  ///
  /// In en, this message translates to:
  /// **'Document Format'**
  String get documentFormat;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @assetTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Title'**
  String get assetTitle;

  /// No description provided for @prompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get prompt;

  /// No description provided for @promptDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe specific details. The style and context are applied automatically.'**
  String get promptDescription;

  /// No description provided for @generateWithCredits.
  ///
  /// In en, this message translates to:
  /// **'Generate ({cost} Credits)'**
  String generateWithCredits(int cost);

  /// No description provided for @runningLow.
  ///
  /// In en, this message translates to:
  /// **'Running low! ({balance} credits remaining). Top up to avoid interruptions.'**
  String runningLow(int balance);

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @generationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation Failed'**
  String get generationFailed;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get limitReached;

  /// No description provided for @generationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Generation Cancelled'**
  String get generationCancelled;

  /// No description provided for @operationCancelled.
  ///
  /// In en, this message translates to:
  /// **'The operation was cancelled by the user.'**
  String get operationCancelled;

  /// No description provided for @newBusiness.
  ///
  /// In en, this message translates to:
  /// **'New Business'**
  String get newBusiness;

  /// No description provided for @noBusinesses.
  ///
  /// In en, this message translates to:
  /// **'No businesses yet'**
  String get noBusinesses;

  /// No description provided for @createPortfolioPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a portfolio to start generating AI-powered documents.'**
  String get createPortfolioPrompt;

  /// No description provided for @createFirstBusiness.
  ///
  /// In en, this message translates to:
  /// **'Create First Business'**
  String get createFirstBusiness;

  /// No description provided for @activePlan.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PLAN: {tier}'**
  String activePlan(String tier);

  /// No description provided for @creditsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{credits} Credits Available'**
  String creditsAvailable(int credits);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline'**
  String get offlineBanner;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BizDocx'**
  String get welcomeTitle;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Business documents,\nbeautifully made.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Generate professional invoices, proposals, logos, and more — powered by AI and tailored to your brand.'**
  String get welcomeBody;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @proposal.
  ///
  /// In en, this message translates to:
  /// **'Proposal'**
  String get proposal;

  /// No description provided for @logo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get logo;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @portfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Portfolios'**
  String get portfolioTitle;

  /// No description provided for @portfolioHeadline.
  ///
  /// In en, this message translates to:
  /// **'Multi-entity management.'**
  String get portfolioHeadline;

  /// No description provided for @portfolioBody.
  ///
  /// In en, this message translates to:
  /// **'Run multiple businesses? Create dedicated portfolios for each to keep your documents and brand contexts separate.'**
  String get portfolioBody;

  /// No description provided for @myCreativeStudio.
  ///
  /// In en, this message translates to:
  /// **'My Creative Studio'**
  String get myCreativeStudio;

  /// No description provided for @studioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design & Branding'**
  String get studioSubtitle;

  /// No description provided for @luxeRetail.
  ///
  /// In en, this message translates to:
  /// **'Luxe Retail Ltd'**
  String get luxeRetail;

  /// No description provided for @retailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'E-commerce'**
  String get retailSubtitle;

  /// No description provided for @docsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} docs'**
  String docsCount(int count);

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan & Digitize'**
  String get scanTitle;

  /// No description provided for @scanHeadline.
  ///
  /// In en, this message translates to:
  /// **'Paper to Digital in seconds.'**
  String get scanHeadline;

  /// No description provided for @scanBody.
  ///
  /// In en, this message translates to:
  /// **'Scan physical invoices or receipts. Our AI extracts the data and digitizes them into your business folder instantly.'**
  String get scanBody;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @extractingData.
  ///
  /// In en, this message translates to:
  /// **'Extracting Data...'**
  String get extractingData;

  /// No description provided for @genTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Generation'**
  String get genTitle;

  /// No description provided for @genHeadline.
  ///
  /// In en, this message translates to:
  /// **'Smart templates, zero effort.'**
  String get genHeadline;

  /// No description provided for @genBody.
  ///
  /// In en, this message translates to:
  /// **'Just describe what you need. AI handles the layout, calculations, and styling based on your business profile.'**
  String get genBody;

  /// No description provided for @docEngine.
  ///
  /// In en, this message translates to:
  /// **'Document Engine'**
  String get docEngine;

  /// No description provided for @visualEngine.
  ///
  /// In en, this message translates to:
  /// **'Visual Engine'**
  String get visualEngine;

  /// No description provided for @illustration.
  ///
  /// In en, this message translates to:
  /// **'Illustration'**
  String get illustration;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @filingTitle.
  ///
  /// In en, this message translates to:
  /// **'Autonomous Filing'**
  String get filingTitle;

  /// No description provided for @filingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Organization on autopilot.'**
  String get filingHeadline;

  /// No description provided for @filingBody.
  ///
  /// In en, this message translates to:
  /// **'BizDocx automatically routes documents to the right folders, identifies clients, and tags versions without you lifting a finger.'**
  String get filingBody;

  /// No description provided for @assetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Brand Identity'**
  String get assetsTitle;

  /// No description provided for @assetsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your brand, everywhere.'**
  String get assetsHeadline;

  /// No description provided for @assetsBody.
  ///
  /// In en, this message translates to:
  /// **'Upload your logo once. AI intelligently places it and applies your brand colors to every document you generate.'**
  String get assetsBody;

  /// No description provided for @uploadLogo.
  ///
  /// In en, this message translates to:
  /// **'Upload Logo'**
  String get uploadLogo;

  /// No description provided for @refineTitle.
  ///
  /// In en, this message translates to:
  /// **'Iterative Refinement'**
  String get refineTitle;

  /// No description provided for @refineHeadline.
  ///
  /// In en, this message translates to:
  /// **'Perfect every detail.'**
  String get refineHeadline;

  /// No description provided for @refineBody.
  ///
  /// In en, this message translates to:
  /// **'Not quite right? Ask the AI to \'add a signature line\' or \'make it more formal\'. Refine until it\'s perfect.'**
  String get refineBody;

  /// No description provided for @smartTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Fields'**
  String get smartTitle;

  /// No description provided for @smartHeadline.
  ///
  /// In en, this message translates to:
  /// **'Actionable document data.'**
  String get smartHeadline;

  /// No description provided for @smartBody.
  ///
  /// In en, this message translates to:
  /// **'AI automatically detects totals, tax, clients, and dates. Get insights across your entire business portfolio.'**
  String get smartBody;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'TOTAL DUE'**
  String get totalDue;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'CLIENT'**
  String get client;

  /// No description provided for @finalTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Scale?'**
  String get finalTitle;

  /// No description provided for @finalHeadline.
  ///
  /// In en, this message translates to:
  /// **'Level up your workflow.'**
  String get finalHeadline;

  /// No description provided for @finalBody.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of businesses using BizDocx to save hours on administration and focus on what matters.'**
  String get finalBody;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get ready;

  /// No description provided for @getStartedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build something\nbeautiful.'**
  String get getStartedHeadline;

  /// No description provided for @getStartedBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create a free account to start generating documents for your business in seconds.'**
  String get getStartedBody;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account  →'**
  String get alreadyHaveAccount;

  /// No description provided for @phaseLoadingContext.
  ///
  /// In en, this message translates to:
  /// **'Loading Context'**
  String get phaseLoadingContext;

  /// No description provided for @phaseGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating Document'**
  String get phaseGenerating;

  /// No description provided for @phaseRendering.
  ///
  /// In en, this message translates to:
  /// **'Rendering Asset'**
  String get phaseRendering;

  /// No description provided for @phaseSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving to Cloud'**
  String get phaseSaving;

  /// No description provided for @phaseSavingVersion.
  ///
  /// In en, this message translates to:
  /// **'Saving Version'**
  String get phaseSavingVersion;

  /// No description provided for @phaseWorking.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get phaseWorking;

  /// No description provided for @phaseLoadingContextSub.
  ///
  /// In en, this message translates to:
  /// **'Retrieving your business context for personalisation.'**
  String get phaseLoadingContextSub;

  /// No description provided for @phaseGeneratingSub.
  ///
  /// In en, this message translates to:
  /// **'Crafting your document using your business profile.'**
  String get phaseGeneratingSub;

  /// No description provided for @phaseRenderingSub.
  ///
  /// In en, this message translates to:
  /// **'Processing and caching the generated asset.'**
  String get phaseRenderingSub;

  /// No description provided for @phaseSavingSub.
  ///
  /// In en, this message translates to:
  /// **'Saving to Cloud and caching locally.'**
  String get phaseSavingSub;

  /// No description provided for @phaseSavingVersionSub.
  ///
  /// In en, this message translates to:
  /// **'Archiving this version in your history.'**
  String get phaseSavingVersionSub;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @pleaseEnterTitleAndPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title and prompt.'**
  String get pleaseEnterTitleAndPrompt;

  /// No description provided for @topUpMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now to unlock professional designs and remove watermarks.'**
  String get topUpMessage;

  /// No description provided for @premiumTemplate.
  ///
  /// In en, this message translates to:
  /// **'Premium Template'**
  String get premiumTemplate;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name *'**
  String get businessName;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description (e.g. Creative Design Agency)'**
  String get shortDescription;

  /// No description provided for @missionStatement.
  ///
  /// In en, this message translates to:
  /// **'Mission Statement'**
  String get missionStatement;

  /// No description provided for @contactAndIdentity.
  ///
  /// In en, this message translates to:
  /// **'Contact & Identity'**
  String get contactAndIdentity;

  /// No description provided for @physicalAddress.
  ///
  /// In en, this message translates to:
  /// **'Physical Address'**
  String get physicalAddress;

  /// No description provided for @businessEmail.
  ///
  /// In en, this message translates to:
  /// **'Business Email'**
  String get businessEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website (e.g. www.empyreal.works)'**
  String get website;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default Currency (e.g. NGN)'**
  String get defaultCurrency;

  /// No description provided for @branding.
  ///
  /// In en, this message translates to:
  /// **'Branding'**
  String get branding;

  /// No description provided for @brandColors.
  ///
  /// In en, this message translates to:
  /// **'Brand Colors (comma-separated hex)'**
  String get brandColors;

  /// No description provided for @targetAudience.
  ///
  /// In en, this message translates to:
  /// **'Target Audience (e.g. Small business owners)'**
  String get targetAudience;

  /// No description provided for @createPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Create Portfolio'**
  String get createPortfolio;

  /// No description provided for @createPortfolioDescription.
  ///
  /// In en, this message translates to:
  /// **'Provide more details to help the AI generate smarter, localized documents.'**
  String get createPortfolioDescription;

  /// No description provided for @editBusiness.
  ///
  /// In en, this message translates to:
  /// **'Edit Business'**
  String get editBusiness;

  /// No description provided for @updatePortfolio.
  ///
  /// In en, this message translates to:
  /// **'Update Portfolio'**
  String get updatePortfolio;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get enterEmailForReset;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to {email}. Please check your inbox (and spam folder).'**
  String resetLinkSent(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @groupByClient.
  ///
  /// In en, this message translates to:
  /// **'Group by Client'**
  String get groupByClient;

  /// No description provided for @groupByType.
  ///
  /// In en, this message translates to:
  /// **'Group by Type'**
  String get groupByType;

  /// No description provided for @moveToFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to Folder'**
  String get moveToFolder;

  /// No description provided for @rootNoFolder.
  ///
  /// In en, this message translates to:
  /// **'Root / No Folder'**
  String get rootNoFolder;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolder;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected?'**
  String get deleteSelected;

  /// No description provided for @deleteSelectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all selected documents? This cannot be undone.'**
  String get deleteSelectedMessage;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder?'**
  String get deleteFolder;

  /// No description provided for @deleteFolderMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting a folder will not delete the documents inside; they will move to the root.'**
  String get deleteFolderMessage;

  /// No description provided for @noMatchingDocuments.
  ///
  /// In en, this message translates to:
  /// **'No matching documents'**
  String get noMatchingDocuments;

  /// No description provided for @noDocumentsYet.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get noDocumentsYet;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @clearFiltersPrompt.
  ///
  /// In en, this message translates to:
  /// **'Try clearing filters to see all documents.'**
  String get clearFiltersPrompt;

  /// No description provided for @generatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap Generate to create your first AI document.'**
  String get generatePrompt;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @unknownClient.
  ///
  /// In en, this message translates to:
  /// **'Unknown Client'**
  String get unknownClient;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @aiOrganizationMode.
  ///
  /// In en, this message translates to:
  /// **'AI Organization Mode Enabled'**
  String get aiOrganizationMode;

  /// No description provided for @manualOrganizationMode.
  ///
  /// In en, this message translates to:
  /// **'Manual Organization Mode Enabled'**
  String get manualOrganizationMode;

  /// No description provided for @aiRoutingEnabled.
  ///
  /// In en, this message translates to:
  /// **'AI Routing Enabled'**
  String get aiRoutingEnabled;

  /// No description provided for @manualModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Manual Mode Enabled'**
  String get manualModeEnabled;

  /// No description provided for @sortOptions.
  ///
  /// In en, this message translates to:
  /// **'Sort options'**
  String get sortOptions;

  /// No description provided for @manageAssets.
  ///
  /// In en, this message translates to:
  /// **'Manage assets & logo'**
  String get manageAssets;

  /// No description provided for @editBusinessInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit business info'**
  String get editBusinessInfo;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @scanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload an existing document to digitize it with AI.'**
  String get scanPrompt;

  /// No description provided for @analyzingDocument.
  ///
  /// In en, this message translates to:
  /// **'Analyzing document...'**
  String get analyzingDocument;

  /// No description provided for @analyzingSub.
  ///
  /// In en, this message translates to:
  /// **'AI is extracting data and merging with your brand...'**
  String get analyzingSub;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis Failed'**
  String get analysisFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @scanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan Complete'**
  String get scanComplete;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @saveDocument.
  ///
  /// In en, this message translates to:
  /// **'Save Document'**
  String get saveDocument;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @portfolioAssets.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Assets'**
  String get portfolioAssets;

  /// No description provided for @removeLogo.
  ///
  /// In en, this message translates to:
  /// **'Remove logo?'**
  String get removeLogo;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @tapToAddLogo.
  ///
  /// In en, this message translates to:
  /// **'Tap to add logo'**
  String get tapToAddLogo;

  /// No description provided for @companyLogo.
  ///
  /// In en, this message translates to:
  /// **'COMPANY LOGO'**
  String get companyLogo;

  /// No description provided for @logoHelp.
  ///
  /// In en, this message translates to:
  /// **'Appears in invoices, proposals, letterheads, and business cards.'**
  String get logoHelp;

  /// No description provided for @assetsHelp.
  ///
  /// In en, this message translates to:
  /// **'Assets here are automatically included in relevant generated documents.'**
  String get assetsHelp;

  /// No description provided for @logoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Logo uploaded. New documents will include it automatically.'**
  String get logoUploaded;

  /// No description provided for @removeLogoConfirm.
  ///
  /// In en, this message translates to:
  /// **'The logo will be removed from future documents. Existing documents are unaffected.'**
  String get removeLogoConfirm;

  /// No description provided for @signedAndLocked.
  ///
  /// In en, this message translates to:
  /// **'DOCUMENT SIGNED & LOCKED'**
  String get signedAndLocked;

  /// No description provided for @lowBalance.
  ///
  /// In en, this message translates to:
  /// **'Low balance: {balance} credits remaining.'**
  String lowBalance(int balance);

  /// No description provided for @preparingPdf.
  ///
  /// In en, this message translates to:
  /// **'Preparing your PDF...'**
  String get preparingPdf;

  /// No description provided for @convertingLayout.
  ///
  /// In en, this message translates to:
  /// **'Converting high-fidelity layout'**
  String get convertingLayout;

  /// No description provided for @freeRevision.
  ///
  /// In en, this message translates to:
  /// **'FREE REVISION {count}/3'**
  String freeRevision(int count);

  /// No description provided for @describeAChange.
  ///
  /// In en, this message translates to:
  /// **'Describe a change...'**
  String get describeAChange;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// No description provided for @couldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {error}'**
  String couldNotLoad(String error);

  /// No description provided for @noPreviewAvailable.
  ///
  /// In en, this message translates to:
  /// **'No preview available.'**
  String get noPreviewAvailable;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited {date}'**
  String edited(String date);

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation Failed'**
  String get operationFailed;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @newDocumentDetails.
  ///
  /// In en, this message translates to:
  /// **'New Document Details'**
  String get newDocumentDetails;

  /// No description provided for @quickLocalEdit.
  ///
  /// In en, this message translates to:
  /// **'Quick Local Edit'**
  String get quickLocalEdit;

  /// No description provided for @smartFieldsHelp.
  ///
  /// In en, this message translates to:
  /// **'Modify the smart fields below to update the document layout locally.'**
  String get smartFieldsHelp;

  /// No description provided for @noSmartFields.
  ///
  /// In en, this message translates to:
  /// **'No smart fields found in this document.'**
  String get noSmartFields;

  /// No description provided for @saveAndPreview.
  ///
  /// In en, this message translates to:
  /// **'Save & Preview'**
  String get saveAndPreview;

  /// No description provided for @newDocumentCreated.
  ///
  /// In en, this message translates to:
  /// **'New document created successfully.'**
  String get newDocumentCreated;

  /// No description provided for @documentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Document updated successfully.'**
  String get documentUpdated;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String errorSaving(String error);

  /// No description provided for @enterField.
  ///
  /// In en, this message translates to:
  /// **'Enter {key}'**
  String enterField(String key);

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @contactHelp.
  ///
  /// In en, this message translates to:
  /// **'Have a question, feedback, or need help with a document? Reach out to our team.'**
  String get contactHelp;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send us your thoughts'**
  String get sendFeedback;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: July 2024'**
  String get lastUpdated;

  /// No description provided for @noTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates available for this category.'**
  String get noTemplates;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get min6Chars;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @paperSizeA4.
  ///
  /// In en, this message translates to:
  /// **'A4 Standard'**
  String get paperSizeA4;

  /// No description provided for @paperSizeA3.
  ///
  /// In en, this message translates to:
  /// **'A3 Large'**
  String get paperSizeA3;

  /// No description provided for @paperSizeA5.
  ///
  /// In en, this message translates to:
  /// **'A5 Small'**
  String get paperSizeA5;

  /// No description provided for @paperSizeLetter.
  ///
  /// In en, this message translates to:
  /// **'US Letter'**
  String get paperSizeLetter;

  /// No description provided for @paperSizeLegal.
  ///
  /// In en, this message translates to:
  /// **'US Legal'**
  String get paperSizeLegal;

  /// No description provided for @paperSizeExecutive.
  ///
  /// In en, this message translates to:
  /// **'Executive'**
  String get paperSizeExecutive;

  /// No description provided for @paperSizeTabloid.
  ///
  /// In en, this message translates to:
  /// **'Tabloid'**
  String get paperSizeTabloid;

  /// No description provided for @paperSizeContinuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous (Long)'**
  String get paperSizeContinuous;

  /// No description provided for @docTypeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get docTypeInvoice;

  /// No description provided for @docTypeProposal.
  ///
  /// In en, this message translates to:
  /// **'Proposal'**
  String get docTypeProposal;

  /// No description provided for @docTypeLetterhead.
  ///
  /// In en, this message translates to:
  /// **'Letterhead'**
  String get docTypeLetterhead;

  /// No description provided for @docTypeBusinessCard.
  ///
  /// In en, this message translates to:
  /// **'Business Card'**
  String get docTypeBusinessCard;

  /// No description provided for @docTypeContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get docTypeContract;

  /// No description provided for @docTypeLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get docTypeLogo;

  /// No description provided for @docTypeIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get docTypeIcon;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @structural.
  ///
  /// In en, this message translates to:
  /// **'Structural'**
  String get structural;

  /// No description provided for @graphical.
  ///
  /// In en, this message translates to:
  /// **'Graphical'**
  String get graphical;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// No description provided for @suggestedFields.
  ///
  /// In en, this message translates to:
  /// **'Suggested fields for {type}'**
  String suggestedFields(String type);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @refined.
  ///
  /// In en, this message translates to:
  /// **'Refined'**
  String get refined;

  /// No description provided for @signed.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get signed;

  /// No description provided for @versionHistory.
  ///
  /// In en, this message translates to:
  /// **'Version History'**
  String get versionHistory;

  /// No description provided for @restoreVersion.
  ///
  /// In en, this message translates to:
  /// **'Restore Version?'**
  String get restoreVersion;

  /// No description provided for @restoreVersionMessage.
  ///
  /// In en, this message translates to:
  /// **'This will set the current document to Version {number}.'**
  String restoreVersionMessage(int number);

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get current;

  /// No description provided for @noPreviousVersions.
  ///
  /// In en, this message translates to:
  /// **'No previous versions available.'**
  String get noPreviousVersions;

  /// No description provided for @signDocument.
  ///
  /// In en, this message translates to:
  /// **'Sign Document'**
  String get signDocument;

  /// No description provided for @documentSigned.
  ///
  /// In en, this message translates to:
  /// **'Document signed successfully.'**
  String get documentSigned;

  /// No description provided for @errorSigning.
  ///
  /// In en, this message translates to:
  /// **'Error signing: {error}'**
  String errorSigning(String error);

  /// No description provided for @signatureInstructions.
  ///
  /// In en, this message translates to:
  /// **'Draw your signature below. Once applied, this document will be locked for further AI edits.'**
  String get signatureInstructions;

  /// No description provided for @applySignature.
  ///
  /// In en, this message translates to:
  /// **'Apply Signature'**
  String get applySignature;

  /// No description provided for @versionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version {number}'**
  String versionNumber(int number);

  /// No description provided for @originalGeneration.
  ///
  /// In en, this message translates to:
  /// **'Original Generation'**
  String get originalGeneration;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'At BizDocx, we are committed to protecting your privacy. This policy explains how we collect, use, and safeguard your information when you use our AI-powered document hub.'**
  String get privacyIntroBody;

  /// No description provided for @privacyCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get privacyCollectionTitle;

  /// No description provided for @privacyCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'We collect information necessary to provide our services, including account details (name, email) and the business context you provide (company name, mission, brand colors) to generate documents.'**
  String get privacyCollectionBody;

  /// No description provided for @privacyAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI and Your Content'**
  String get privacyAiTitle;

  /// No description provided for @privacyAiBody.
  ///
  /// In en, this message translates to:
  /// **'Your document prompts and business context are processed by our secure AI generation partners to create high-quality business assets. We do not use your data to train our own models without explicit consent.'**
  String get privacyAiBody;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely using enterprise-grade cloud infrastructure. We implement industry-standard security measures to protect against unauthorized access or disclosure.'**
  String get privacySecurityBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'User Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, correct, or delete your data at any time through the app settings. Deleting your account will remove all associated portfolios, documents, and profile information.'**
  String get privacyRightsBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
