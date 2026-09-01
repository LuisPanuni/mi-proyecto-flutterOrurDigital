import 'package:flutter/material.dart';

import 'data/oruro_zone.dart';
import 'urban_intelligence.dart';

part 'data/demo_data.dart';
part 'home_page.dart';
part 'navigation/app_destination.dart';
part 'screens/admin_page.dart';
part 'screens/login_page.dart';
part 'screens/map_page.dart';
part 'screens/my_reports_page.dart';
part 'screens/problems_page.dart';
part 'screens/report_page.dart';
part 'utils/ui_helpers.dart';
part 'widgets/city_map.dart';
part 'widgets/common_widgets.dart';
part 'widgets/guard_panel.dart';
part 'widgets/problem_widgets.dart';

const Color _oruroCrimson = Color(0xFF8A1538);
const Color _oruroCrimsonDark = Color(0xFF5A1024);
const Color _oruroGold = Color(0xFFC49A2C);
const Color _oruroSky = Color(0xFF1D6F8F);
const Color _oruroGreen = Color(0xFF2F7D5C);
const Color _oruroBackground = Color(0xFFF7F1E8);
const Color _oruroSurface = Color(0xFFFFFCF7);
const Color _oruroBorder = Color(0xFFE6D8C8);
const Color _oruroStone = Color(0xFF6B6258);

class OruroDigitalApp extends StatelessWidget {
  const OruroDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oruro Digital',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: _oruroCrimson,
              brightness: Brightness.light,
            ).copyWith(
              primary: _oruroCrimson,
              secondary: _oruroGold,
              tertiary: _oruroSky,
              surface: _oruroSurface,
            ),
        scaffoldBackgroundColor: _oruroBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: _oruroSurface,
          foregroundColor: _oruroCrimsonDark,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: _oruroSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: _oruroBorder),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          prefixIconConstraints: BoxConstraints(minWidth: 38, minHeight: 38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _oruroSurface,
          selectedColor: _oruroCrimson.withValues(alpha: 0.12),
          side: const BorderSide(color: _oruroBorder),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          labelStyle: const TextStyle(fontSize: 12),
          secondaryLabelStyle: const TextStyle(fontSize: 12),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            minimumSize: const Size(36, 36),
            padding: const EdgeInsets.all(8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _oruroCrimson,
          foregroundColor: Colors.white,
          extendedPadding: EdgeInsets.symmetric(horizontal: 12),
          extendedTextStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 58,
          indicatorColor: _oruroCrimson.withValues(alpha: 0.12),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: _oruroSurface,
          indicatorColor: Color(0x1F8A1538),
          minWidth: 72,
          selectedIconTheme: IconThemeData(color: _oruroCrimson),
          selectedLabelTextStyle: TextStyle(
            color: _oruroCrimson,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelTextStyle: TextStyle(fontSize: 12),
        ),
      ),
      home: const OruroDigitalHomePage(),
    );
  }
}
