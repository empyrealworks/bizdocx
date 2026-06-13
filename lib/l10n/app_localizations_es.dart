// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BizDocx';

  @override
  String get appSubtitle => 'Tu centro de documentos con IA.';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get noAccount => '¿No tienes una cuenta? Regístrate';

  @override
  String get haveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutConfirm => '¿Cerrar sesión?';

  @override
  String get signOutMessage =>
      '¿Estás seguro de que quieres cerrar sesión en tu cuenta?';

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get system => 'Sistema';

  @override
  String get systemSubtitle => 'Seguir ajustes del dispositivo';

  @override
  String get light => 'Claro';

  @override
  String get lightSubtitle => 'Siempre claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get darkSubtitle => 'Siempre oscuro';

  @override
  String get subscription => 'Suscripción';

  @override
  String get plansAndCredits => 'Planes y créditos';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get localCache => 'Caché local';

  @override
  String get clear => 'Borrar';

  @override
  String get clearCache => 'Borrar caché';

  @override
  String get clearCacheConfirm => '¿Borrar caché local?';

  @override
  String get clearCacheMessage =>
      'Esto eliminará todas las vistas previas de PDF e imágenes almacenadas localmente. Se volverán a descargar o generar según sea necesario.';

  @override
  String get supportAndLegal => 'Soporte y legal';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get account => 'Cuenta';

  @override
  String get deleteMyData => 'Eliminar mis datos';

  @override
  String get deleteAccount => '¿Eliminar cuenta?';

  @override
  String get deleteAccountMessage =>
      'Esto eliminará permanentemente tu cuenta y todos los portafolios y documentos asociados. Esta acción no se puede deshacer.';

  @override
  String get deleteEverything => 'Eliminar todo';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get app => 'Aplicación';

  @override
  String get aiEngine => 'Motor de IA';

  @override
  String get aiEngineSubtitle => 'Estructural avanzado + Imagen neuronal';

  @override
  String get generate => 'Generar';

  @override
  String get generateAsset => 'Generar activo';

  @override
  String get category => 'Categoría';

  @override
  String get styleTemplate => 'Plantilla de estilo';

  @override
  String get orientation => 'Orientación';

  @override
  String get documentFormat => 'Formato de documento';

  @override
  String get aspectRatio => 'Relación de aspecto';

  @override
  String get assetTitle => 'Título del activo';

  @override
  String get prompt => 'Indicación (Prompt)';

  @override
  String get promptDescription =>
      'Describe detalles específicos. El estilo y el contexto se aplican automáticamente.';

  @override
  String generateWithCredits(int cost) {
    return 'Generar ($cost créditos)';
  }

  @override
  String runningLow(int balance) {
    return '¡Saldo bajo! (quedan $balance créditos). Recarga para evitar interrupciones.';
  }

  @override
  String get topUp => 'Recargar';

  @override
  String get maybeLater => 'Quizás más tarde';

  @override
  String get viewPlans => 'Ver planes';

  @override
  String get error => 'Error';

  @override
  String deletionFailed(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get generationFailed => 'Error de generación';

  @override
  String get limitReached => 'Límite alcanzado';

  @override
  String get generationCancelled => 'Generación cancelada';

  @override
  String get operationCancelled => 'La operación fue cancelada por el usuario.';

  @override
  String get newBusiness => 'Nuevo negocio';

  @override
  String get noBusinesses => 'Aún no hay negocios';

  @override
  String get createPortfolioPrompt =>
      'Crea un portafolio para empezar a generar documentos con IA.';

  @override
  String get createFirstBusiness => 'Crear primer negocio';

  @override
  String activePlan(String tier) {
    return 'PLAN ACTIVO: $tier';
  }

  @override
  String creditsAvailable(int credits) {
    return '$credits créditos disponibles';
  }

  @override
  String get offlineBanner => 'Actualmente estás sin conexión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get delete => 'Eliminar';

  @override
  String get restore => 'Restaurar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get done => 'Hecho';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Empezar';

  @override
  String get welcomeTitle => 'Bienvenido a BizDocx';

  @override
  String get welcomeHeadline => 'Documentos de negocio,\nbellamente diseñados.';

  @override
  String get welcomeBody =>
      'Genera facturas profesionales, propuestas, logotipos y más, con el poder de la IA y adaptado a tu marca.';

  @override
  String get invoice => 'Factura';

  @override
  String get proposal => 'Propuesta';

  @override
  String get logo => 'Logotipo';

  @override
  String get contract => 'Contrato';

  @override
  String get portfolioTitle => 'Portafolios de negocio';

  @override
  String get portfolioHeadline => 'Gestión multi-entidad.';

  @override
  String get portfolioBody =>
      '¿Diriges varios negocios? Crea portafolios dedicados para cada uno para mantener tus documentos y contextos de marca separados.';

  @override
  String get myCreativeStudio => 'Mi Estudio Creativo';

  @override
  String get studioSubtitle => 'Diseño y Branding';

  @override
  String get luxeRetail => 'Luxe Retail Ltd';

  @override
  String get retailSubtitle => 'E-commerce';

  @override
  String docsCount(int count) {
    return '$count docs';
  }

  @override
  String get scanTitle => 'Escanear y digitalizar';

  @override
  String get scanHeadline => 'De papel a digital en segundos.';

  @override
  String get scanBody =>
      'Escanea facturas o recibos físicos. Nuestra IA extrae los datos y los digitaliza en tu carpeta de negocio al instante.';

  @override
  String get scanning => 'Escaneando...';

  @override
  String get extractingData => 'Extrayendo datos...';

  @override
  String get genTitle => 'Generación con IA';

  @override
  String get genHeadline => 'Plantillas inteligentes, cero esfuerzo.';

  @override
  String get genBody =>
      'Simplemente describe lo que necesitas. La IA se encarga del diseño, los cálculos y el estilo basándose en tu perfil de negocio.';

  @override
  String get docEngine => 'Motor de documentos';

  @override
  String get visualEngine => 'Motor visual';

  @override
  String get illustration => 'Ilustración';

  @override
  String get badge => 'Insignia';

  @override
  String get filingTitle => 'Archivado autónomo';

  @override
  String get filingHeadline => 'Organización en piloto automático.';

  @override
  String get filingBody =>
      'BizDocx dirige automáticamente los documentos a las carpetas correctas, identifica clientes y etiqueta versiones sin que tengas que mover un dedo.';

  @override
  String get assetsTitle => 'Identidad de marca';

  @override
  String get assetsHeadline => 'Tu marca, en todas partes.';

  @override
  String get assetsBody =>
      'Sube tu logotipo una vez. La IA lo coloca de forma inteligente y aplica tus colores de marca a cada documento que generes.';

  @override
  String get uploadLogo => 'Subir logotipo';

  @override
  String get refineTitle => 'Refinamiento iterativo';

  @override
  String get refineHeadline => 'Perfecciona cada detalle.';

  @override
  String get refineBody =>
      '¿No es del todo correcto? Pídele a la IA que «añada una línea de firma» o «lo haga más formal». Refina hasta que sea perfecto.';

  @override
  String get smartTitle => 'Campos inteligentes';

  @override
  String get smartHeadline => 'Datos de documentos accionables.';

  @override
  String get smartBody =>
      'La IA detecta automáticamente totales, impuestos, clientes y fechas. Obtén información de todo tu portafolio de negocios.';

  @override
  String get totalDue => 'TOTAL DEUDO';

  @override
  String get client => 'CLIENTE';

  @override
  String get finalTitle => '¿Listo para escalar?';

  @override
  String get finalHeadline => 'Eleva tu flujo de trabajo.';

  @override
  String get finalBody =>
      'Únete a miles de negocios que usan BizDocx para ahorrar horas en administración y enfocarse en lo que importa.';

  @override
  String get ready => 'LISTO';

  @override
  String get getStartedHeadline => 'Construyamos algo\nhermoso.';

  @override
  String get getStartedBody =>
      'Inicia sesión o crea una cuenta gratuita para empezar a generar documentos para tu negocio en segundos.';

  @override
  String get alreadyHaveAccount => 'Ya tengo una cuenta  →';

  @override
  String get phaseLoadingContext => 'Cargando contexto';

  @override
  String get phaseGenerating => 'Generando documento';

  @override
  String get phaseRendering => 'Renderizando activo';

  @override
  String get phaseSaving => 'Guardando en la nube';

  @override
  String get phaseSavingVersion => 'Guardando versión';

  @override
  String get phaseWorking => 'Trabajando...';

  @override
  String get phaseLoadingContextSub =>
      'Recuperando el contexto de tu negocio para la personalización.';

  @override
  String get phaseGeneratingSub =>
      'Creando tu documento usando tu perfil de negocio.';

  @override
  String get phaseRenderingSub =>
      'Procesando y guardando en caché el activo generado.';

  @override
  String get phaseSavingSub => 'Guardando en la nube y en caché localmente.';

  @override
  String get phaseSavingVersionSub =>
      'Archivando esta versión en tu historial.';

  @override
  String get success => 'Éxito';

  @override
  String get pleaseEnterTitleAndPrompt =>
      'Por favor, introduce un título y una indicación.';

  @override
  String get topUpMessage =>
      'Actualiza ahora para desbloquear diseños profesionales y eliminar marcas de agua.';

  @override
  String get premiumTemplate => 'Plantilla Premium';

  @override
  String get basicInfo => 'Información básica';

  @override
  String get businessName => 'Nombre del negocio *';

  @override
  String get shortDescription =>
      'Descripción corta (ej. Agencia de diseño creativo)';

  @override
  String get missionStatement => 'Declaración de misión';

  @override
  String get contactAndIdentity => 'Contacto e identidad';

  @override
  String get physicalAddress => 'Dirección física';

  @override
  String get businessEmail => 'Correo electrónico del negocio';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get website => 'Sitio web';

  @override
  String get localization => 'Localización';

  @override
  String get country => 'País';

  @override
  String get defaultCurrency => 'Moneda predeterminada (ej. MXN)';

  @override
  String get branding => 'Marca';

  @override
  String get brandColors => 'Colores de marca (hex separados por comas)';

  @override
  String get targetAudience =>
      'Público objetivo (ej. Dueños de pequeños negocios)';

  @override
  String get createPortfolio => 'Crear portafolio';

  @override
  String get createPortfolioDescription =>
      'Proporciona más detalles para ayudar a la IA a generar documentos más inteligentes y localizados.';

  @override
  String get editBusiness => 'Editar negocio';

  @override
  String get updatePortfolio => 'Actualizar portafolio';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get enterEmailForReset =>
      'Introduce tu dirección de correo electrónico y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get sendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get checkYourEmail => 'Revisa tu correo electrónico';

  @override
  String resetLinkSent(String email) {
    return 'Hemos enviado un enlace para restablecer la contraseña a $email. Por favor, revisa tu bandeja de entrada (y la carpeta de spam).';
  }

  @override
  String get backToSignIn => 'Volver al inicio de sesión';

  @override
  String get all => 'Todos';

  @override
  String get allTypes => 'Todos los tipos';

  @override
  String get sortByDate => 'Ordenar por fecha';

  @override
  String get groupByClient => 'Agrupar por cliente';

  @override
  String get groupByType => 'Agrupar por tipo';

  @override
  String get moveToFolder => 'Mover a carpeta';

  @override
  String get rootNoFolder => 'Raíz / Sin carpeta';

  @override
  String get newFolder => 'Nueva carpeta';

  @override
  String get folderName => 'Nombre de la carpeta';

  @override
  String get create => 'Crear';

  @override
  String get deleteSelected => '¿Eliminar seleccionados?';

  @override
  String get deleteSelectedMessage =>
      '¿Estás seguro de que quieres eliminar todos los documentos seleccionados? Esta acción no se puede deshacer.';

  @override
  String get deleteFolder => '¿Eliminar carpeta?';

  @override
  String get deleteFolderMessage =>
      'Eliminar una carpeta no eliminará los documentos de su interior; se moverán a la raíz.';

  @override
  String get noMatchingDocuments => 'No hay documentos coincidentes';

  @override
  String get noDocumentsYet => 'Aún no hay documentos';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get clearFiltersPrompt =>
      'Intenta borrar los filtros para ver todos los documentos.';

  @override
  String get generatePrompt =>
      'Toca Generar para crear tu primer documento con IA.';

  @override
  String get scan => 'Escanear';

  @override
  String get unknownClient => 'Cliente desconocido';

  @override
  String get files => 'Archivos';

  @override
  String get aiOrganizationMode => 'Modo de organización por IA activado';

  @override
  String get manualOrganizationMode => 'Modo de organización manual activado';

  @override
  String get aiRoutingEnabled => 'Enrutamiento por IA activado';

  @override
  String get manualModeEnabled => 'Modo manual activado';

  @override
  String get sortOptions => 'Opciones de ordenación';

  @override
  String get manageAssets => 'Gestionar activos y logotipo';

  @override
  String get editBusinessInfo => 'Editar información del negocio';

  @override
  String get scanDocument => 'Escanear documento';

  @override
  String get scanPrompt =>
      'Toma una foto o sube un documento existente para digitalizarlo con IA.';

  @override
  String get analyzingDocument => 'Analizando documento...';

  @override
  String get analyzingSub =>
      'La IA está extrayendo datos y fusionándolos con tu marca...';

  @override
  String get analysisFailed => 'Error de análisis';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get scanComplete => 'Escaneo completado';

  @override
  String get discard => 'Descartar';

  @override
  String get saveDocument => 'Guardar documento';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get type => 'Tipo';

  @override
  String get total => 'Total';

  @override
  String get date => 'Fecha';

  @override
  String get portfolioAssets => 'Activos del portafolio';

  @override
  String get removeLogo => '¿Eliminar logotipo?';

  @override
  String get remove => 'Eliminar';

  @override
  String get replace => 'Reemplazar';

  @override
  String get upload => 'Subir';

  @override
  String get failedToLoad => 'Error al cargar';

  @override
  String get tapToAddLogo => 'Toca para añadir logotipo';

  @override
  String get companyLogo => 'LOGOTIPO DE LA EMPRESA';

  @override
  String get logoHelp =>
      'Aparece en facturas, propuestas, membretes y tarjetas de presentación.';

  @override
  String get assetsHelp =>
      'Los activos aquí se incluyen automáticamente en los documentos generados relevantes.';

  @override
  String get logoUploaded =>
      'Logotipo subido. Los nuevos documentos lo incluirán automáticamente.';

  @override
  String get removeLogoConfirm =>
      'El logotipo se eliminará de futuros documentos. Los documentos existentes no se verán afectados.';

  @override
  String get signedAndLocked => 'DOCUMENTO FIRMADO Y BLOQUEADO';

  @override
  String lowBalance(int balance) {
    return 'Saldo bajo: quedan $balance créditos.';
  }

  @override
  String get preparingPdf => 'Preparando tu PDF...';

  @override
  String get convertingLayout => 'Convirtiendo diseño de alta fidelidad';

  @override
  String freeRevision(int count) {
    return 'REVISIÓN GRATUITA $count/3';
  }

  @override
  String get describeAChange => 'Describe un cambio...';

  @override
  String get free => 'GRATIS';

  @override
  String couldNotLoad(String error) {
    return 'No se pudo cargar: $error';
  }

  @override
  String get noPreviewAvailable => 'No hay vista previa disponible.';

  @override
  String edited(String date) {
    return 'editado el $date';
  }

  @override
  String get operationFailed => 'Operación fallida';

  @override
  String get dismiss => 'Descartar';

  @override
  String get newDocumentDetails => 'Detalles del nuevo documento';

  @override
  String get quickLocalEdit => 'Edición local rápida';

  @override
  String get smartFieldsHelp =>
      'Modifica los campos inteligentes a continuación para actualizar el diseño del documento localmente.';

  @override
  String get noSmartFields =>
      'No se encontraron campos inteligentes en este documento.';

  @override
  String get saveAndPreview => 'Guardar y previsualizar';

  @override
  String get newDocumentCreated => 'Nuevo documento creado correctamente.';

  @override
  String get documentUpdated => 'Documento actualizado correctamente.';

  @override
  String errorSaving(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String enterField(String key) {
    return 'Introduce $key';
  }

  @override
  String get howCanWeHelp => '¿Cómo podemos ayudarte?';

  @override
  String get contactHelp =>
      '¿Tienes alguna pregunta, comentario o necesitas ayuda con un documento? Ponte en contacto con nuestro equipo.';

  @override
  String get emailSupport => 'Soporte por correo electrónico';

  @override
  String get feedback => 'Comentarios';

  @override
  String get sendFeedback => 'Envíanos tus ideas';

  @override
  String get visitWebsite => 'Visita nuestro sitio web';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get browseFaqs => 'Explora preguntas frecuentes y guías';

  @override
  String get followUs => 'Síguenos';

  @override
  String get lastUpdated => 'Última actualización: julio de 2024';

  @override
  String get noTemplates =>
      'No hay plantillas disponibles para esta categoría.';

  @override
  String get premium => 'PREMIUM';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get security => 'Seguridad';

  @override
  String get appLock => 'Bloqueo de aplicación';

  @override
  String get appLockDescription =>
      'Requiere PIN o biometría para abrir la aplicación.';

  @override
  String get lockTimeout => 'Tiempo de bloqueo';

  @override
  String get immediate => 'Inmediato';

  @override
  String get after1Min => 'Después de 1 minuto';

  @override
  String get after30Min => 'Después de 30 minutos';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String get setPin => 'Establecer PIN';

  @override
  String get enterPin => 'Introduce el PIN';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String get pinsDoNotMatch => 'Los PIN no coinciden';

  @override
  String get authenticateToContinue => 'Por favor, autentícate para continuar';

  @override
  String get biometricAuth => 'Autenticación biométrica';

  @override
  String get pinAuth => 'Autenticación por PIN';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get wrongPin => 'PIN incorrecto. Inténtalo de nuevo.';

  @override
  String get errorUserNotFound => 'Usuario no encontrado.';

  @override
  String get errorWrongPassword => 'Contraseña incorrecta.';

  @override
  String get errorEmailInUse => 'El correo electrónico ya está en uso.';

  @override
  String get errorWeakPassword => 'La contraseña es demasiado débil.';

  @override
  String get errorInvalidEmail => 'Dirección de correo electrónico no válida.';

  @override
  String get errorGeneric => 'Ocurrió un error. Por favor, inténtelo de nuevo.';

  @override
  String get required => 'Requerido';

  @override
  String get min4Chars => 'Mínimo 4 caracteres';

  @override
  String get min6Chars => 'Mínimo 6 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get paperSizeA4 => 'A4 Estándar';

  @override
  String get paperSizeA3 => 'A3 Grande';

  @override
  String get paperSizeA5 => 'A5 Pequeño';

  @override
  String get paperSizeLetter => 'Carta US';

  @override
  String get paperSizeLegal => 'Legal US';

  @override
  String get paperSizeExecutive => 'Ejecutivo';

  @override
  String get paperSizeTabloid => 'Tabloide';

  @override
  String get paperSizeContinuous => 'Continuo (Largo)';

  @override
  String get docTypeInvoice => 'Factura';

  @override
  String get docTypeProposal => 'Propuesta';

  @override
  String get docTypeLetterhead => 'Membrete';

  @override
  String get docTypeBusinessCard => 'Tarjeta de presentación';

  @override
  String get docTypeContract => 'Contrato';

  @override
  String get docTypeLogo => 'Logo';

  @override
  String get docTypeIcon => 'Icono';

  @override
  String get docTypeOther => 'Otro';

  @override
  String get structural => 'Estructural';

  @override
  String get graphical => 'Gráfico';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisaje';

  @override
  String suggestedFields(String type) {
    return 'Campos sugeridos para $type';
  }

  @override
  String exportFailed(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get original => 'Original';

  @override
  String get refined => 'Refinado';

  @override
  String get signed => 'Firmado';

  @override
  String get versionHistory => 'Historial de versiones';

  @override
  String get restoreVersion => '¿Restaurar versión?';

  @override
  String restoreVersionMessage(int number) {
    return 'Esto establecerá el documento actual en la Versión $number.';
  }

  @override
  String get current => 'ACTUAL';

  @override
  String get noPreviousVersions => 'No hay versiones anteriores disponibles.';

  @override
  String get signDocument => 'Firmar documento';

  @override
  String get documentSigned => 'Documento firmado correctamente.';

  @override
  String errorSigning(String error) {
    return 'Error al firmar: $error';
  }

  @override
  String get signatureInstructions =>
      'Dibuja tu firma a continuación. Una vez aplicada, este documento quedará bloqueado para futuras ediciones de la IA.';

  @override
  String get applySignature => 'Aplicar firma';

  @override
  String versionNumber(int number) {
    return 'Versión $number';
  }

  @override
  String get originalGeneration => 'Generación original';

  @override
  String get privacyIntroTitle => 'Introducción';

  @override
  String get privacyIntroBody =>
      'En BizDocx, nos comprometemos a proteger tu privacidad. Esta política explica cómo recopilamos, usamos y protegemos tu información cuando utilizas nuestro centro de documentos con IA.';

  @override
  String get privacyCollectionTitle => 'Recopilación de datos';

  @override
  String get privacyCollectionBody =>
      'Recopilamos la información necesaria para proporcionar nuestros servicios, incluidos los detalles de la cuenta (nombre, correo electrónico) y el contexto de negocio que proporcionas (nombre de la empresa, misión, colores de marca) para generar documentos.';

  @override
  String get privacyAiTitle => 'La IA y tu contenido';

  @override
  String get privacyAiBody =>
      'Tus indicaciones de documentos y el contexto de negocio son procesados por nuestros socios seguros de generación de IA para crear activos de negocio de alta calidad. No utilizamos tus datos para entrenar nuestros propios modelos sin tu consentimiento explícito.';

  @override
  String get privacySecurityTitle => 'Seguridad de los datos';

  @override
  String get privacySecurityBody =>
      'Tus datos se almacenan de forma segura utilizando una infraestructura en la nube de clase empresarial. Implementamos medidas de seguridad estándar de la industria para proteger contra el acceso o la divulgación no autorizados.';

  @override
  String get privacyRightsTitle => 'Derechos del usuario';

  @override
  String get privacyRightsBody =>
      'Tienes derecho a acceder, corregir o eliminar tus datos en cualquier momento a través de los ajustes de la aplicación. Eliminar tu cuenta eliminará todos los portafolios, documentos e información de perfil asociados.';
}
