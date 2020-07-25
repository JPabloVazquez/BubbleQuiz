/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import 'pantallas/page_ranking.dart';

import 'modelos/appstate.dart';
import 'modelos/modelos.dart';
import 'pantallas/page_principal.dart';
import 'pantallas/page_configuracion.dart';
import 'pantallas/page_resumen.dart';
import 'pantallas/page_juego.dart';
import 'pantallas/page_log.dart';

/// Estilos
const textStyle = TextStyle(color: Colors.blue);
const iconColor = Colors.blueGrey;

/**
 * Clase de maneja la pagina principal
 */
class HomePage extends StatelessWidget {
  Widget _switchTab(AppTab tab, AppState appState) {
    switch (tab) {
      case AppTab.main:
        return PagPpal();
        break;
      case AppTab.trivia:
        return PagPlay();
        break;
      case AppTab.summary:
        return PagResumen(stats: appState.triviaBloc.stats);
        break;
      default:
        return PagPpal();
    }
  }

  /**
   * Metodo que contruye la pagina principal
   */
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of<AppState>(context);

    return ValueBuilder(
      streamed: appState.tabController,
      builder: (context, snapshot) => Scaffold(
            appBar: snapshot.data != AppTab.main ? null : AppBar(),
            drawer: DrawerWidget(),
            body: _switchTab(snapshot.data, appState),
          ),
    );
  }
}

/**
 * Metodo que dibuja el widget
 */
class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: const Text(
                'BUBBLEQUIZ',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 4.0,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.lightBlueAccent,
                      offset: Offset(3.0, 4.5),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagConfig()),
              );
            },
          ),
          ListTile(
            title: const Text('Ranking'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagRanking()),
              );
            },
          ),
          ListTile(
            title: const Text('Log'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogPage()),
              );
            },
          ),
          const AboutListTile(
            child: Text(''),
          ),
        ],
      ),
    );
  }
}
