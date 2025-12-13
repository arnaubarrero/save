import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';

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

final NumberFormat moneyFormat = NumberFormat('#,##0.00', 'es_ES');

void main() {
  runApp(const MyApp());
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
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Patrimonio',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AssetManagerPage(),
    );
  }
}

class AssetManagerPage extends StatefulWidget {
  const AssetManagerPage({super.key});

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

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _saveTimer?.cancel();
    // Flush any pending saves
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
    // Precompute formatted strings to avoid repeated formatting during build
    _totalAmountStr = '€${moneyFormat.format(_totalAmount)}';
    _liquidAmountStr = '€${moneyFormat.format(_liquidAmount)}';
    _assetAmountStr = '€${moneyFormat.format(_assetAmount)}';
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
        // Update totals incrementally instead of recalculating whole list
        _totalAmount += amount;
        if (_isLiquid) {
          _liquidAmount += amount;
        } else {
          _assetAmount += amount;
        }
        _totalAmountStr = '€${moneyFormat.format(_totalAmount)}';
        _liquidAmountStr = '€${moneyFormat.format(_liquidAmount)}';
        _assetAmountStr = '€${moneyFormat.format(_assetAmount)}';
      });
      _scheduleSave();
      _nameController.clear();
      _amountController.clear();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name añadido correctamente'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un nombre y monto válidos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeAsset(int index) {
    final asset = _assets[index];
    setState(() {
      _assets.removeAt(index);
      // Adjust totals incrementally
      _totalAmount -= asset.amount;
      if (asset.isLiquid) {
        _liquidAmount -= asset.amount;
      } else {
        _assetAmount -= asset.amount;
      }
      _totalAmountStr = '€${moneyFormat.format(_totalAmount)}';
      _liquidAmountStr = '€${moneyFormat.format(_liquidAmount)}';
      _assetAmountStr = '€${moneyFormat.format(_assetAmount)}';
    });
    _scheduleSave();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${asset.name} eliminado'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              _assets.insert(index, asset);
              // Reapply totals incrementally
              _totalAmount += asset.amount;
              if (asset.isLiquid) {
                _liquidAmount += asset.amount;
              } else {
                _assetAmount += asset.amount;
              }
              _totalAmountStr = '€${moneyFormat.format(_totalAmount)}';
              _liquidAmountStr = '€${moneyFormat.format(_liquidAmount)}';
              _assetAmountStr = '€${moneyFormat.format(_assetAmount)}';
              _scheduleSave();
            });
          },
        ),
      ),
    );
  }

  void _showAddAssetDialog() {
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
                      'Añadir Activo',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del activo',
                        hintText: 'ej. Cuenta bancaria, Bitcoin...',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        hintText: '0,00',
                        prefixIcon: Icon(Icons.euro),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Tipo de activo',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _TypeChip(
                            label: 'Líquido',
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
                            label: 'Activo',
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
                            child: const Text('Cancelar'),
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
                            child: const Text('Guardar'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mi Patrimonio'),
        actions: [
          IconButton(
            tooltip: _showDetails ? 'Ocultar detalles' : 'Mostrar detalles',
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
                            'PATRIMONIO TOTAL',
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
                                label: 'Líquido',
                                amountStr: _liquidAmountStr,
                                icon: Icons.water_drop,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SummaryItem(
                                label: 'Activos',
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
                    Text('Mis Activos', style: theme.textTheme.titleLarge),
                    Text(
                      '${_assets.length} ${_assets.length == 1 ? 'item' : 'items'}',
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
                              'No hay activos',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Presiona el botón + para añadir',
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
                                          asset.isLiquid ? 'Líquido' : 'Activo',
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
                                    '€${moneyFormat.format(asset.amount)}',
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
        label: const Text('Añadir'),
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
