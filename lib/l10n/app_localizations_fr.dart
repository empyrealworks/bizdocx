// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'BizDocx';

  @override
  String get appSubtitle => 'Votre plateforme de documents IA.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ? Inscrivez-vous';

  @override
  String get haveAccount => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get signOutConfirm => 'Déconnexion ?';

  @override
  String get signOutMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?';

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get system => 'Système';

  @override
  String get systemSubtitle => 'Suivre les paramètres de l\'appareil';

  @override
  String get light => 'Clair';

  @override
  String get lightSubtitle => 'Toujours clair';

  @override
  String get dark => 'Sombre';

  @override
  String get darkSubtitle => 'Toujours sombre';

  @override
  String get subscription => 'Abonnement';

  @override
  String get plansAndCredits => 'Forfaits et crédits';

  @override
  String get storage => 'Stockage';

  @override
  String get localCache => 'Cache local';

  @override
  String get clear => 'Effacer';

  @override
  String get clearCache => 'Effacer le cache';

  @override
  String get clearCacheConfirm => 'Effacer le cache local ?';

  @override
  String get clearCacheMessage =>
      'Cela supprimera tous les aperçus PDF et images stockés localement. Ils seront re-téléchargés ou re-générés si nécessaire.';

  @override
  String get supportAndLegal => 'Assistance et mentions légales';

  @override
  String get contactUs => 'Contactez-nous';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get account => 'Compte';

  @override
  String get deleteMyData => 'Supprimer mes données';

  @override
  String get deleteAccount => 'Supprimer le compte ?';

  @override
  String get deleteAccountMessage =>
      'Cela supprimera définitivement votre compte ainsi que tous les portfolios et documents associés. Cette action est irréversible.';

  @override
  String get deleteEverything => 'Tout supprimer';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get app => 'Application';

  @override
  String get aiEngine => 'Moteur IA';

  @override
  String get aiEngineSubtitle => 'Structurel avancé + Image neurale';

  @override
  String get generate => 'Générer';

  @override
  String get generateAsset => 'Générer un actif';

  @override
  String get category => 'Catégorie';

  @override
  String get styleTemplate => 'Modèle de style';

  @override
  String get orientation => 'Orientation';

  @override
  String get documentFormat => 'Format du document';

  @override
  String get aspectRatio => 'Ratio d\'aspect';

  @override
  String get assetTitle => 'Titre de l\'actif';

  @override
  String get prompt => 'Invite (Prompt)';

  @override
  String get promptDescription =>
      'Décrivez les détails spécifiques. Le style et le contexte sont appliqués automatiquement.';

  @override
  String generateWithCredits(int cost) {
    return 'Générer ($cost crédits)';
  }

  @override
  String runningLow(int balance) {
    return 'Solde faible ! ($balance crédits restants). Rechargez pour éviter les interruptions.';
  }

  @override
  String get topUp => 'Recharger';

  @override
  String get maybeLater => 'Plus tard';

  @override
  String get viewPlans => 'Voir les forfaits';

  @override
  String get error => 'Erreur';

  @override
  String deletionFailed(Object error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get generationFailed => 'Échec de la génération';

  @override
  String get limitReached => 'Limite atteinte';

  @override
  String get generationCancelled => 'Génération annulée';

  @override
  String get operationCancelled =>
      'L\'opération a été annulée par l\'utilisateur.';

  @override
  String get newBusiness => 'Nouvelle entreprise';

  @override
  String get noBusinesses => 'Aucune entreprise pour le moment';

  @override
  String get createPortfolioPrompt =>
      'Créez un portfolio pour commencer à générer des documents alimentés par l\'IA.';

  @override
  String get createFirstBusiness => 'Créer la première entreprise';

  @override
  String activePlan(String tier) {
    return 'FORFAIT ACTIF : $tier';
  }

  @override
  String creditsAvailable(int credits) {
    return '$credits crédits disponibles';
  }

  @override
  String get offlineBanner => 'Vous êtes actuellement hors ligne';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Supprimer';

  @override
  String get restore => 'Restaurer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get done => 'Terminé';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get welcomeTitle => 'Bienvenue sur BizDocx';

  @override
  String get welcomeHeadline =>
      'Des documents professionnels,\nmagnifiquement conçus.';

  @override
  String get welcomeBody =>
      'Générez des factures professionnelles, des propositions, des logos et bien plus encore — propulsé par l\'IA et adapté à votre marque.';

  @override
  String get invoice => 'Facture';

  @override
  String get proposal => 'Proposition';

  @override
  String get logo => 'Logo';

  @override
  String get contract => 'Contrat';

  @override
  String get portfolioTitle => 'Portfolios d\'entreprise';

  @override
  String get portfolioHeadline => 'Gestion multi-entités.';

  @override
  String get portfolioBody =>
      'Vous gérez plusieurs entreprises ? Créez des portfolios dédiés pour chacune afin de séparer vos documents et contextes de marque.';

  @override
  String get myCreativeStudio => 'Mon Studio Créatif';

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
  String get scanTitle => 'Scanner et numériser';

  @override
  String get scanHeadline => 'Du papier au numérique en quelques secondes.';

  @override
  String get scanBody =>
      'Scannez des factures ou des reçus physiques. Notre IA extrait les données et les numérise instantanément dans votre dossier d\'entreprise.';

  @override
  String get scanning => 'Numérisation...';

  @override
  String get extractingData => 'Extraction des données...';

  @override
  String get genTitle => 'Génération IA';

  @override
  String get genHeadline => 'Modèles intelligents, effort zéro.';

  @override
  String get genBody =>
      'Décrivez simplement ce dont vous avez besoin. L\'IA s\'occupe de la mise en page, des calculs et du style en fonction de votre profil d\'entreprise.';

  @override
  String get docEngine => 'Moteur de documents';

  @override
  String get visualEngine => 'Moteur visuel';

  @override
  String get illustration => 'Illustration';

  @override
  String get badge => 'Badge';

  @override
  String get filingTitle => 'Classement autonome';

  @override
  String get filingHeadline => 'Organisation en pilote automatique.';

  @override
  String get filingBody =>
      'BizDocx achemine automatiquement les documents vers les bons dossiers, identifie les clients et marque les versions sans que vous ayez à lever le petit doigt.';

  @override
  String get assetsTitle => 'Identité de marque';

  @override
  String get assetsHeadline => 'Votre marque, partout.';

  @override
  String get assetsBody =>
      'Téléchargez votre logo une seule fois. L\'IA le place intelligemment et applique vos couleurs de marque à chaque document que vous générez.';

  @override
  String get uploadLogo => 'Télécharger le logo';

  @override
  String get refineTitle => 'Affinage itératif';

  @override
  String get refineHeadline => 'Perfectionnez chaque détail.';

  @override
  String get refineBody =>
      'Ce n\'est pas tout à fait ça ? Demandez à l\'IA d\'« ajouter une ligne de signature » ou de « rendre le document plus formel ». Affinez jusqu\'à la perfection.';

  @override
  String get smartTitle => 'Champs intelligents';

  @override
  String get smartHeadline => 'Données documentaires exploitables.';

  @override
  String get smartBody =>
      'L\'IA détecte automatiquement les totaux, les taxes, les clients et les dates. Obtenez des informations sur l\'ensemble de votre portfolio d\'activités.';

  @override
  String get totalDue => 'TOTAL DÛ';

  @override
  String get client => 'CLIENT';

  @override
  String get finalTitle => 'Prêt à passer à l\'échelle ?';

  @override
  String get finalHeadline => 'Améliorez votre flux de travail.';

  @override
  String get finalBody =>
      'Rejoignez des milliers d\'entreprises utilisant BizDocx pour gagner des heures sur l\'administration et se concentrer sur l\'essentiel.';

  @override
  String get ready => 'PRÊT';

  @override
  String get getStartedHeadline => 'Créons quelque chose\nde magnifique.';

  @override
  String get getStartedBody =>
      'Connectez-vous ou créez un compte gratuit pour commencer à générer des documents pour votre entreprise en quelques secondes.';

  @override
  String get alreadyHaveAccount => 'J\'ai déjà un compte  →';

  @override
  String get phaseLoadingContext => 'Chargement du contexte';

  @override
  String get phaseGenerating => 'Génération du document';

  @override
  String get phaseRendering => 'Rendu de l\'actif';

  @override
  String get phaseSaving => 'Enregistrement sur le Cloud';

  @override
  String get phaseSavingVersion => 'Enregistrement de la version';

  @override
  String get phaseWorking => 'Travail en cours...';

  @override
  String get phaseLoadingContextSub =>
      'Récupération de votre contexte d\'entreprise pour la personnalisation.';

  @override
  String get phaseGeneratingSub =>
      'Conception de votre document à l\'aide de votre profil d\'entreprise.';

  @override
  String get phaseRenderingSub =>
      'Traitement et mise en cache de l\'actif généré.';

  @override
  String get phaseSavingSub =>
      'Enregistrement sur le Cloud et mise en cache locale.';

  @override
  String get phaseSavingVersionSub =>
      'Archivage de cette version dans votre historique.';

  @override
  String get success => 'Succès';

  @override
  String get pleaseEnterTitleAndPrompt =>
      'Veuillez saisir un titre et une invite.';

  @override
  String get topUpMessage =>
      'Passez au forfait supérieur pour débloquer des designs professionnels et supprimer les filigranes.';

  @override
  String get premiumTemplate => 'Modèle Premium';

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get businessName => 'Nom de l\'entreprise *';

  @override
  String get shortDescription =>
      'Courte description (ex: Agence de design créatif)';

  @override
  String get missionStatement => 'Énoncé de mission';

  @override
  String get contactAndIdentity => 'Contact et identité';

  @override
  String get physicalAddress => 'Adresse physique';

  @override
  String get businessEmail => 'E-mail de l\'entreprise';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get website => 'Site web (ex: www.empyreal.works)';

  @override
  String get localization => 'Localisation';

  @override
  String get country => 'Pays';

  @override
  String get defaultCurrency => 'Devise par défaut (ex: EUR)';

  @override
  String get branding => 'Marque';

  @override
  String get brandColors =>
      'Couleurs de la marque (hex séparés par des virgules)';

  @override
  String get targetAudience =>
      'Public cible (ex: Propriétaires de petites entreprises)';

  @override
  String get createPortfolio => 'Créer le portfolio';

  @override
  String get createPortfolioDescription =>
      'Fournissez plus de détails pour aider l\'IA à générer des documents plus intelligents et localisés.';

  @override
  String get editBusiness => 'Modifier l\'entreprise';

  @override
  String get updatePortfolio => 'Mettre à jour le portfolio';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get enterEmailForReset =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get checkYourEmail => 'Vérifiez votre boîte mail';

  @override
  String resetLinkSent(String email) {
    return 'Nous avons envoyé un lien de réinitialisation du mot de passe à $email. Veuillez vérifier votre boîte de réception (et vos spams).';
  }

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get all => 'Tous';

  @override
  String get allTypes => 'Tous les types';

  @override
  String get sortByDate => 'Trier par date';

  @override
  String get groupByClient => 'Grouper par client';

  @override
  String get groupByType => 'Grouper par type';

  @override
  String get moveToFolder => 'Déplacer vers le dossier';

  @override
  String get rootNoFolder => 'Racine / Aucun dossier';

  @override
  String get newFolder => 'Nouveau dossier';

  @override
  String get folderName => 'Nom du dossier';

  @override
  String get create => 'Créer';

  @override
  String get deleteSelected => 'Supprimer la sélection ?';

  @override
  String get deleteSelectedMessage =>
      'Êtes-vous sûr de vouloir supprimer tous les documents sélectionnés ? Cette action est irréversible.';

  @override
  String get deleteFolder => 'Supprimer le dossier ?';

  @override
  String get deleteFolderMessage =>
      'La suppression d\'un dossier ne supprimera pas les documents qu\'il contient ; ils seront déplacés à la racine.';

  @override
  String get noMatchingDocuments => 'Aucun document correspondant';

  @override
  String get noDocumentsYet => 'Aucun document pour le moment';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get clearFiltersPrompt =>
      'Essayez d\'effacer les filtres pour voir tous les documents.';

  @override
  String get generatePrompt =>
      'Appuyez sur Générer pour créer votre premier document IA.';

  @override
  String get scan => 'Scanner';

  @override
  String get unknownClient => 'Client inconnu';

  @override
  String get files => 'Fichiers';

  @override
  String get aiOrganizationMode => 'Mode d\'organisation IA activé';

  @override
  String get manualOrganizationMode => 'Mode d\'organisation manuel activé';

  @override
  String get aiRoutingEnabled => 'Routage IA activé';

  @override
  String get manualModeEnabled => 'Mode manuel activé';

  @override
  String get sortOptions => 'Options de tri';

  @override
  String get manageAssets => 'Gérer les actifs et le logo';

  @override
  String get editBusinessInfo => 'Modifier les infos de l\'entreprise';

  @override
  String get scanDocument => 'Scanner un document';

  @override
  String get scanPrompt =>
      'Prenez une photo ou téléchargez un document existant pour le numériser avec l\'IA.';

  @override
  String get analyzingDocument => 'Analyse du document...';

  @override
  String get analyzingSub =>
      'L\'IA extrait les données et les fusionne avec votre marque...';

  @override
  String get analysisFailed => 'Échec de l\'analyse';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get scanComplete => 'Numérisation terminée';

  @override
  String get discard => 'Ignorer';

  @override
  String get saveDocument => 'Enregistrer le document';

  @override
  String get camera => 'Appareil photo';

  @override
  String get gallery => 'Galerie';

  @override
  String get type => 'Type';

  @override
  String get total => 'Total';

  @override
  String get date => 'Date';

  @override
  String get portfolioAssets => 'Actifs du portfolio';

  @override
  String get removeLogo => 'Supprimer le logo ?';

  @override
  String get remove => 'Supprimer';

  @override
  String get replace => 'Remplacer';

  @override
  String get upload => 'Télécharger';

  @override
  String get failedToLoad => 'Échec du chargement';

  @override
  String get tapToAddLogo => 'Appuyez pour ajouter un logo';

  @override
  String get companyLogo => 'LOGO DE L\'ENTREPRISE';

  @override
  String get logoHelp =>
      'Apparaît dans les factures, les propositions, les en-têtes de lettre et les cartes de visite.';

  @override
  String get assetsHelp =>
      'Les actifs ici sont automatiquement inclus dans les documents générés pertinents.';

  @override
  String get logoUploaded =>
      'Logo téléchargé. Les nouveaux documents l\'incluront automatiquement.';

  @override
  String get removeLogoConfirm =>
      'Le logo sera supprimé des futurs documents. Les documents existants ne sont pas affectés.';

  @override
  String get signedAndLocked => 'DOCUMENT SIGNÉ ET VERROUILLÉ';

  @override
  String lowBalance(int balance) {
    return 'Solde faible : $balance crédits restants.';
  }

  @override
  String get preparingPdf => 'Préparation de votre PDF...';

  @override
  String get convertingLayout => 'Conversion de la mise en page haute fidélité';

  @override
  String freeRevision(int count) {
    return 'RÉVISION GRATUITE $count/3';
  }

  @override
  String get describeAChange => 'Décrivez un changement...';

  @override
  String get free => 'GRATUIT';

  @override
  String couldNotLoad(String error) {
    return 'Impossible de charger : $error';
  }

  @override
  String get noPreviewAvailable => 'Aucun aperçu disponible.';

  @override
  String edited(String date) {
    return 'modifié le $date';
  }

  @override
  String get operationFailed => 'Échec de l\'opération';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get newDocumentDetails => 'Détails du nouveau document';

  @override
  String get quickLocalEdit => 'Modification locale rapide';

  @override
  String get smartFieldsHelp =>
      'Modifiez les champs intelligents ci-dessous pour mettre à jour la mise en page du document localement.';

  @override
  String get noSmartFields =>
      'Aucun champ intelligent trouvé dans ce document.';

  @override
  String get saveAndPreview => 'Enregistrer et prévisualiser';

  @override
  String get newDocumentCreated => 'Nouveau document créé avec succès.';

  @override
  String get documentUpdated => 'Document mis à jour avec succès.';

  @override
  String errorSaving(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String enterField(String key) {
    return 'Saisir $key';
  }

  @override
  String get howCanWeHelp => 'Comment pouvons-nous vous aider ?';

  @override
  String get contactHelp =>
      'Vous avez une question, un commentaire ou besoin d\'aide pour un document ? Contactez notre équipe.';

  @override
  String get emailSupport => 'Support par e-mail';

  @override
  String get feedback => 'Commentaires';

  @override
  String get sendFeedback => 'Envoyez-nous vos réflexions';

  @override
  String get lastUpdated => 'Dernière mise à jour : juillet 2024';

  @override
  String get noTemplates => 'Aucun modèle disponible pour cette catégorie.';

  @override
  String get premium => 'PREMIUM';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get security => 'Sécurité';

  @override
  String get appLock => 'Verrouillage de l\'application';

  @override
  String get appLockDescription =>
      'Nécessite un code PIN ou la biométrie pour ouvrir l\'application.';

  @override
  String get lockTimeout => 'Délai de verrouillage';

  @override
  String get immediate => 'Immédiat';

  @override
  String get after1Min => 'Après 1 minute';

  @override
  String get after30Min => 'Après 30 minutes';

  @override
  String get changePin => 'Changer le code PIN';

  @override
  String get setPin => 'Définir le code PIN';

  @override
  String get enterPin => 'Entrez le code PIN';

  @override
  String get confirmPin => 'Confirmer le code PIN';

  @override
  String get pinsDoNotMatch => 'Les codes PIN ne correspondent pas';

  @override
  String get authenticateToContinue =>
      'Veuillez vous authentifier pour continuer';

  @override
  String get biometricAuth => 'Authentification biométrique';

  @override
  String get pinAuth => 'Authentification par code PIN';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get wrongPin => 'Code PIN incorrect. Veuillez réessayer.';

  @override
  String get errorUserNotFound => 'Utilisateur non trouvé.';

  @override
  String get errorWrongPassword => 'Mot de passe incorrect.';

  @override
  String get errorEmailInUse => 'E-mail déjà utilisé.';

  @override
  String get errorWeakPassword => 'Le mot de passe est trop faible.';

  @override
  String get errorInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get required => 'Requis';

  @override
  String get min4Chars => '4 caractères minimum';

  @override
  String get min6Chars => '6 caractères minimum';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get paperSizeA4 => 'A4 Standard';

  @override
  String get paperSizeA3 => 'A3 Grand';

  @override
  String get paperSizeA5 => 'A5 Petit';

  @override
  String get paperSizeLetter => 'Lettre US';

  @override
  String get paperSizeLegal => 'Légal US';

  @override
  String get paperSizeExecutive => 'Exécutif';

  @override
  String get paperSizeTabloid => 'Tabloïde';

  @override
  String get paperSizeContinuous => 'Continu (Long)';

  @override
  String get docTypeInvoice => 'Facture';

  @override
  String get docTypeProposal => 'Proposition';

  @override
  String get docTypeLetterhead => 'En-tête de lettre';

  @override
  String get docTypeBusinessCard => 'Carte de visite';

  @override
  String get docTypeContract => 'Contrat';

  @override
  String get docTypeLogo => 'Logo';

  @override
  String get docTypeIcon => 'Icône';

  @override
  String get docTypeOther => 'Autre';

  @override
  String get structural => 'Structurel';

  @override
  String get graphical => 'Graphique';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Paysage';

  @override
  String suggestedFields(String type) {
    return 'Champs suggérés pour $type';
  }

  @override
  String exportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get original => 'Original';

  @override
  String get refined => 'Affiné';

  @override
  String get signed => 'Signé';

  @override
  String get versionHistory => 'Historique des versions';

  @override
  String get restoreVersion => 'Restaurer la version ?';

  @override
  String restoreVersionMessage(int number) {
    return 'Cela définira le document actuel sur la Version $number.';
  }

  @override
  String get current => 'ACTUELLE';

  @override
  String get noPreviousVersions => 'Aucune version précédente disponible.';

  @override
  String get signDocument => 'Signer le document';

  @override
  String get documentSigned => 'Document signé avec succès.';

  @override
  String errorSigning(String error) {
    return 'Erreur lors de la signature : $error';
  }

  @override
  String get signatureInstructions =>
      'Dessinez votre signature ci-dessous. Une fois appliquée, ce document sera verrouillé pour toute modification ultérieure par l\'IA.';

  @override
  String get applySignature => 'Appliquer la signature';

  @override
  String versionNumber(int number) {
    return 'Version $number';
  }

  @override
  String get originalGeneration => 'Génération originale';

  @override
  String get privacyIntroTitle => 'Introduction';

  @override
  String get privacyIntroBody =>
      'Chez BizDocx, nous nous engageons à protéger votre vie privée. Cette politique explique comment nous collectons, utilisons et protégeons vos informations lorsque vous utilisez notre plateforme de documents alimentée par l\'IA.';

  @override
  String get privacyCollectionTitle => 'Collecte de données';

  @override
  String get privacyCollectionBody =>
      'Nous collectons les informations nécessaires pour fournir nos services, y compris les détails du compte (nom, e-mail) et le contexte d\'entreprise que vous fournissez (nom de l\'entreprise, mission, couleurs de marque) pour générer des documents.';

  @override
  String get privacyAiTitle => 'L\'IA et votre contenu';

  @override
  String get privacyAiBody =>
      'Vos invites de documents et votre contexte d\'entreprise sont traités par nos partenaires de génération d\'IA sécurisés pour créer des actifs commerciaux de haute qualité. Nous n\'utilisons pas vos données pour entraîner nos propres modèles sans votre consentement explicite.';

  @override
  String get privacySecurityTitle => 'Sécurité des données';

  @override
  String get privacySecurityBody =>
      'Vos données sont stockées en toute sécurité à l\'aide d\'une infrastructure cloud de classe entreprise. Nous mettons en œuvre des mesures de sécurité conformes aux normes de l\'industrie pour nous protéger contre tout accès ou divulgation non autorisé.';

  @override
  String get privacyRightsTitle => 'Droits de l\'utilisateur';

  @override
  String get privacyRightsBody =>
      'Vous avez le droit d\'accéder, de corriger ou de supprimer vos données à tout moment via les paramètres de l\'application. La suppression de votre compte supprimera tous les portfolios, documents et informations de profil associés.';
}
