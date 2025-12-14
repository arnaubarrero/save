import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AssetEntry {
  final String name;
  final double amount;
  final bool isLiquid;
  final DateTime dateAdded;

  AssetEntry({
    required this.name,
    required this.amount,
    required this.isLiquid,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'isLiquid': isLiquid,
    'dateAdded': dateAdded.toIso8601String(),
  };

  factory AssetEntry.fromJson(Map<String, dynamic> json) => AssetEntry(
    name: json['name'] as String,
    amount: json['amount'] as double,
    isLiquid: json['isLiquid'] as bool,
    dateAdded: DateTime.parse(json['dateAdded'] as String),
  );
}

// Clase para manejar las traducciones
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'appTitle': 'Mi Patrimonio',
      'totalAssets': 'PATRIMONIO TOTAL',
      'liquid': 'Líquido',
      'assets': 'Activos',
      'myAssets': 'Mis Activos',
      'noAssets': 'No hay activos',
      'addPrompt': 'Presiona el botón + para añadir',
      'addAsset': 'Añadir Activo',
      'assetName': 'Nombre del activo',
      'assetNameHint': 'ej. Cuenta bancaria, Bitcoin...',
      'amount': 'Monto',
      'amountHint': '0,00',
      'assetType': 'Tipo de activo',
      'liquidType': 'Líquido',
      'assetTypeLabel': 'Activo',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'items': 'items',
      'item': 'item',
      'addedSuccessfully': 'añadido correctamente',
      'enterValidData': 'Ingresa un nombre y monto válidos',
      'removed': 'eliminado',
      'undo': 'Deshacer',
      'hideDetails': 'Ocultar detalles',
      'showDetails': 'Mostrar detalles',
      'add': 'Añadir',
    },
    'en': {
      'appTitle': 'My Assets',
      'totalAssets': 'TOTAL ASSETS',
      'liquid': 'Liquid',
      'assets': 'Assets',
      'myAssets': 'My Assets',
      'noAssets': 'No assets',
      'addPrompt': 'Press the + button to add',
      'addAsset': 'Add Asset',
      'assetName': 'Asset name',
      'assetNameHint': 'e.g. Bank account, Bitcoin...',
      'amount': 'Amount',
      'amountHint': '0.00',
      'assetType': 'Asset type',
      'liquidType': 'Liquid',
      'assetTypeLabel': 'Asset',
      'cancel': 'Cancel',
      'save': 'Save',
      'items': 'items',
      'item': 'item',
      'addedSuccessfully': 'added successfully',
      'enterValidData': 'Enter valid name and amount',
      'removed': 'removed',
      'undo': 'Undo',
      'hideDetails': 'Hide details',
      'showDetails': 'Show details',
      'add': 'Add',
    },
    'fr': {
      'appTitle': 'Mon Patrimoine',
      'totalAssets': 'PATRIMOINE TOTAL',
      'liquid': 'Liquide',
      'assets': 'Actifs',
      'myAssets': 'Mes Actifs',
      'noAssets': 'Aucun actif',
      'addPrompt': 'Appuyez sur le bouton + pour ajouter',
      'addAsset': 'Ajouter un Actif',
      'assetName': 'Nom de l\'actif',
      'assetNameHint': 'ex. Compte bancaire, Bitcoin...',
      'amount': 'Montant',
      'amountHint': '0,00',
      'assetType': 'Type d\'actif',
      'liquidType': 'Liquide',
      'assetTypeLabel': 'Actif',
      'cancel': 'Annuler',
      'save': 'Sauvegarder',
      'items': 'éléments',
      'item': 'élément',
      'addedSuccessfully': 'ajouté avec succès',
      'enterValidData': 'Entrez un nom et un montant valides',
      'removed': 'supprimé',
      'undo': 'Annuler',
      'hideDetails': 'Masquer les détails',
      'showDetails': 'Afficher les détails',
      'add': 'Ajouter',
    },
  };

  String? get appTitle => _localizedValues[locale.languageCode]?['appTitle'];
  String? get totalAssets =>
      _localizedValues[locale.languageCode]?['totalAssets'];
  String? get liquid => _localizedValues[locale.languageCode]?['liquid'];
  String? get assets => _localizedValues[locale.languageCode]?['assets'];
  String? get myAssets => _localizedValues[locale.languageCode]?['myAssets'];
  String? get noAssets => _localizedValues[locale.languageCode]?['noAssets'];
  String? get addPrompt => _localizedValues[locale.languageCode]?['addPrompt'];
  String? get addAsset => _localizedValues[locale.languageCode]?['addAsset'];
  String? get assetName => _localizedValues[locale.languageCode]?['assetName'];
  String? get assetNameHint =>
      _localizedValues[locale.languageCode]?['assetNameHint'];
  String? get amount => _localizedValues[locale.languageCode]?['amount'];
  String? get amountHint =>
      _localizedValues[locale.languageCode]?['amountHint'];
  String? get assetType => _localizedValues[locale.languageCode]?['assetType'];
  String? get liquidType =>
      _localizedValues[locale.languageCode]?['liquidType'];
  String? get assetTypeLabel =>
      _localizedValues[locale.languageCode]?['assetTypeLabel'];
  String? get cancel => _localizedValues[locale.languageCode]?['cancel'];
  String? get save => _localizedValues[locale.languageCode]?['save'];
  String? get items => _localizedValues[locale.languageCode]?['items'];
  String? get item => _localizedValues[locale.languageCode]?['item'];
  String? get addedSuccessfully =>
      _localizedValues[locale.languageCode]?['addedSuccessfully'];
  String? get enterValidData =>
      _localizedValues[locale.languageCode]?['enterValidData'];
  String? get removed => _localizedValues[locale.languageCode]?['removed'];
  String? get undo => _localizedValues[locale.languageCode]?['undo'];
  String? get hideDetails =>
      _localizedValues[locale.languageCode]?['hideDetails'];
  String? get showDetails =>
      _localizedValues[locale.languageCode]?['showDetails'];
  String? get add => _localizedValues[locale.languageCode]?['add'];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Clase para manejar el cambio de idioma
class LanguageManager {
  static const String _languageKey = 'selected_language';

  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    if (languageCode != null && ['es', 'en', 'fr'].contains(languageCode)) {
      return Locale(languageCode);
    }

    // Por defecto español
    return const Locale('es');
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double blurSigma;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
    this.blurSigma = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.05),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.black87,
    surface: Colors.white,
    background: Color(0xFFF5F5F5),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: const Color(0xFF0A0A0A),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.white70,
    surface: Color(0xFF1A1A1A),
    background: Color(0xFF0A0A0A),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
  ),
  useMaterial3: true,
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LanguageManager.getLocale();
    setState(() {
      _locale = locale;
    });
  }

  void _changeLanguage(String languageCode) async {
    await LanguageManager.setLocale(languageCode);
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Patrimonio',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
        Locale('fr', 'CH'),
      ],
      home: _locale == null
          ? const Center(child: CircularProgressIndicator())
          : PinLockPage(onUnlocked: () => AssetManagerPage(onLanguageChanged: _changeLanguage)),
    );
  }
}

class PinLockPage extends StatefulWidget {
  final Widget Function() onUnlocked;

  const PinLockPage({super.key, required this.onUnlocked});

  @override
  State<PinLockPage> createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  static const String _requiredPin = '7951';

  @override
  void initState() {
    super.initState();
    // Autofocus the PIN field shortly after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _tryUnlock() {
    if (_pinController.text.trim() == _requiredPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.onUnlocked()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN incorrecto')),
      );
      _pinController.clear();
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F5F5), const Color(0xFFE8E8E8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(24),
                blurSigma: 6.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Introduce tu PIN',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pinController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      obscureText: true,
                      obscuringCharacter: '•',
                      maxLength: 4,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: '••••',
                        counterText: '',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      textAlign: TextAlign.center,
                      onSubmitted: (_) => _tryUnlock(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pinController.clear(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Borrar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _tryUnlock,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Entrar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssetManagerPage extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const AssetManagerPage({super.key, required this.onLanguageChanged});

  @override
  State<AssetManagerPage> createState() => _AssetManagerPageState();
}

class _AssetManagerPageState extends State<AssetManagerPage> {
  List<AssetEntry> _assets = [];
  double _totalAmount = 0.0;
  double _liquidAmount = 0.0;
  double _assetAmount = 0.0;
  String _totalAmountStr = '€0.00';
  String _liquidAmountStr = '€0.00';
  String _assetAmountStr = '€0.00';
  bool _showDetails = true;
  final String _storageKey = 'asset_entries';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLiquid = true;
  Timer? _saveTimer;

  NumberFormat? _moneyFormat;
  String? _currencySymbol;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  void _initializeNumberFormat() {
    final locale = AppLocalizations.of(context)?.locale.languageCode ?? 'es';

    switch (locale) {
      case 'en':
        _moneyFormat = NumberFormat('#,##0.00', 'en_US');
        _currencySymbol = '€';
        break;
      case 'fr':
        _moneyFormat = NumberFormat('#,##0.00', 'fr_CH');
        _currencySymbol = 'CHF';
        break;
      default: // 'es'
        _moneyFormat = NumberFormat('#,##0.00', 'es_ES');
        _currencySymbol = '€';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeNumberFormat();
    _calculateTotals(); // Recalcular con el formato correcto
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _saveTimer?.cancel();
    _performSave();
    super.dispose();
  }

  Future<void> _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? assetsString = prefs.getString(_storageKey);

    if (assetsString != null) {
      final List<dynamic> jsonList = jsonDecode(assetsString);
      setState(() {
        _assets = jsonList.map((json) => AssetEntry.fromJson(json)).toList();
        _calculateTotals();
      });
    }
  }

  Future<void> _performSave() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = _assets
        .map((asset) => asset.toJson())
        .toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  void _scheduleSave([Duration delay = const Duration(milliseconds: 300)]) {
    _saveTimer?.cancel();
    _saveTimer = Timer(delay, () async {
      await _performSave();
      _saveTimer?.cancel();
    });
  }

  void _calculateTotals() {
    _totalAmount = 0.0;
    _liquidAmount = 0.0;
    _assetAmount = 0.0;

    for (var asset in _assets) {
      _totalAmount += asset.amount;
      if (asset.isLiquid) {
        _liquidAmount += asset.amount;
      } else {
        _assetAmount += asset.amount;
      }
    }

    if (_moneyFormat != null) {
      _totalAmountStr = '$_currencySymbol${_moneyFormat!.format(_totalAmount)}';
      _liquidAmountStr =
          '$_currencySymbol${_moneyFormat!.format(_liquidAmount)}';
      _assetAmountStr = '$_currencySymbol${_moneyFormat!.format(_assetAmount)}';
    }
  }

  void _addAsset() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (name.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _assets.insert(
          0,
          AssetEntry(
            name: name,
            amount: amount,
            isLiquid: _isLiquid,
            dateAdded: DateTime.now(),
          ),
        );
        _totalAmount += amount;
        if (_isLiquid) {
          _liquidAmount += amount;
        } else {
          _assetAmount += amount;
        }
        if (_moneyFormat != null) {
          _totalAmountStr =
              '$_currencySymbol${_moneyFormat!.format(_totalAmount)}';
          _liquidAmountStr =
              '$_currencySymbol${_moneyFormat!.format(_liquidAmount)}';
          _assetAmountStr =
              '$_currencySymbol${_moneyFormat!.format(_assetAmount)}';
        }
      });
      _scheduleSave();
      _nameController.clear();
      _amountController.clear();
      Navigator.of(context).pop();

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name ${l10n!.addedSuccessfully!}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n!.enterValidData!),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeAsset(int index) {
    final asset = _assets[index];
    final l10n = AppLocalizations.of(context);

    setState(() {
      _assets.removeAt(index);
      _totalAmount -= asset.amount;
      if (asset.isLiquid) {
        _liquidAmount -= asset.amount;
      } else {
        _assetAmount -= asset.amount;
      }
      if (_moneyFormat != null) {
        _totalAmountStr =
            '$_currencySymbol${_moneyFormat!.format(_totalAmount)}';
        _liquidAmountStr =
            '$_currencySymbol${_moneyFormat!.format(_liquidAmount)}';
        _assetAmountStr =
            '$_currencySymbol${_moneyFormat!.format(_assetAmount)}';
      }
    });
    _scheduleSave();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${asset.name} ${l10n!.removed!}'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n.undo!,
          onPressed: () {
            setState(() {
              _assets.insert(index, asset);
              _totalAmount += asset.amount;
              if (asset.isLiquid) {
                _liquidAmount += asset.amount;
              } else {
                _assetAmount += asset.amount;
              }
              if (_moneyFormat != null) {
                _totalAmountStr =
                    '$_currencySymbol${_moneyFormat!.format(_totalAmount)}';
                _liquidAmountStr =
                    '$_currencySymbol${_moneyFormat!.format(_liquidAmount)}';
                _assetAmountStr =
                    '$_currencySymbol${_moneyFormat!.format(_assetAmount)}';
              }
              _scheduleSave();
            });
          },
        ),
      ),
    );
  }

  void _showAddAssetDialog() {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      l10n!.addAsset!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.assetName,
                        hintText: l10n.assetNameHint,
                        prefixIcon: const Icon(Icons.label_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        hintText: l10n.amountHint,
                        prefixIcon: const Icon(Icons.euro),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      l10n.assetType!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _TypeChip(
                            label: l10n.liquidType!,
                            icon: Icons.water_drop,
                            selected: _isLiquid,
                            onTap: () {
                              setStateDialog(() {
                                _isLiquid = true;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TypeChip(
                            label: l10n.assetTypeLabel!,
                            icon: Icons.trending_up,
                            selected: !_isLiquid,
                            onTap: () {
                              setStateDialog(() {
                                _isLiquid = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(l10n.cancel!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addAsset,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              foregroundColor: isDark
                                  ? Colors.black
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(l10n.save!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageDropdown() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white30
                : Colors.black26,
          ),
        ),
        child: Image.asset(
          _getCurrentFlag(),
          width: 24,
          height: 16,
          fit: BoxFit.cover,
        ),
      ),
      onSelected: (String languageCode) {
        widget.onLanguageChanged(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'es',
          child: Row(
            children: [
              Image.asset('assets/es.png', width: 24, height: 16),
              const SizedBox(width: 12),
              const Text('Español'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Image.asset('assets/uk.png', width: 24, height: 16),
              const SizedBox(width: 12),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'fr',
          child: Row(
            children: [
              Image.asset('assets/sw.png', width: 24, height: 16),
              const SizedBox(width: 12),
              const Text('Français'),
            ],
          ),
        ),
      ],
    );
  }

  String _getCurrentFlag() {
    final locale = AppLocalizations.of(context)?.locale.languageCode ?? 'es';
    switch (locale) {
      case 'en':
        return 'assets/uk.png';
      case 'fr':
        return 'assets/sw.png';
      default:
        return 'assets/es.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: _buildLanguageDropdown(),
        title: Text(l10n.appTitle!),
        actions: [
          IconButton(
            tooltip: _showDetails ? l10n.hideDetails : l10n.showDetails,
            icon: Icon(_showDetails ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F5F5), const Color(0xFFE8E8E8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(24),
                  blurSigma: 6.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.totalAssets!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _totalAmountStr,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_showDetails)
                        Row(
                          children: [
                            Expanded(
                              child: _SummaryItem(
                                label: l10n.liquid!,
                                amountStr: _liquidAmountStr,
                                icon: Icons.water_drop,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SummaryItem(
                                label: l10n.assets!,
                                amountStr: _assetAmountStr,
                                icon: Icons.trending_up,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.myAssets!, style: theme.textTheme.titleLarge),
                    Text(
                      '${_assets.length} ${_assets.length == 1 ? l10n.item : l10n.items}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: _assets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 80,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noAssets!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.addPrompt!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: _assets.length,
                        itemBuilder: (context, index) {
                          final asset = _assets[index];
                          return Dismissible(
                            key: Key(asset.dateAdded.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) => _removeAsset(index),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            child: GlassmorphicCard(
                              blurSigma: 0.0,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          (asset.isLiquid
                                                  ? Colors.blue
                                                  : Colors.amber)
                                              .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      asset.isLiquid
                                          ? Icons.water_drop
                                          : Icons.trending_up,
                                      color: asset.isLiquid
                                          ? Colors.blue
                                          : Colors.amber,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asset.name,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          asset.isLiquid
                                              ? l10n.liquid!
                                              : l10n.assets!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: isDark
                                                    ? Colors.white54
                                                    : Colors.black54,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$_currencySymbol${_moneyFormat?.format(asset.amount) ?? asset.amount.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAssetDialog,
        icon: const Icon(Icons.add),
        label: Text(l10n.add!),
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 4,
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String amountStr;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amountStr,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amountStr,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white24 : Colors.grey[300]!),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: selected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
