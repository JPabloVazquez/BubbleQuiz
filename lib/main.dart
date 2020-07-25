/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */
import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import 'src/homepage.dart';
import 'src/modelos/appstate.dart';
import 'src/modelos/tema.dart';


void main() => runApp(App());

class App extends StatelessWidget {
  final appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider<AppState>(
      appState: appState,
      child: MaterialPage(),
    );
  }
}

class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppStateProvider.of<AppState>(context).currentTheme;

    return ValueBuilder<MiTema>(
        streamed: theme,
        builder: (context, snapshot) {
          return MaterialApp(
              title: 'Bubble Quiz',
              theme: _buildThemeData(snapshot.data),
              home: HomePage());
        });
  }

  ThemeData _buildThemeData(MiTema appTheme) {
    return ThemeData(
      brightness: appTheme.brightness,
      backgroundColor: appTheme.backgroundColor,
      scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
      primaryColor: appTheme.primaryColor,
      primaryColorBrightness: appTheme.primaryColorBrightness,
      accentColor: appTheme.accentColor,
    );
  }
}
