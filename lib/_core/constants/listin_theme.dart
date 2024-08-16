import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/constants/listin_colors.dart';

class ListinTheme {
  static ThemeData mainTheme = ThemeData(
    // Usar Material Design 3
    useMaterial3: true,

    // Paleta de cores principal
    primarySwatch: ListinColors.purple,

    // Cor de fundo em telas que usam Scaffold
    scaffoldBackgroundColor: ListinColors.green,

    // Tema dos FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ListinColors.lavandalight,
    ),

    // Temas dos ListTiles
    listTileTheme: const ListTileThemeData(
      iconColor: ListinColors.graydark,
      contentPadding: EdgeInsets.zero,
    ),

    // Tema das AppBars
    appBarTheme: const AppBarTheme(
      toolbarHeight: 72,
      centerTitle: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
    ),

    // Tema dos Dividers
    dividerTheme: const DividerThemeData(
      color: ListinColors.graydark,
    ),

    // Tema dos TextFormFields
    inputDecorationTheme: const InputDecorationTheme(
      iconColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black),
    ),
  );
}
