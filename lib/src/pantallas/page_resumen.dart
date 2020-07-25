/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import '../db/DBHelper.dart';

import '../modelos/appstate.dart';
import '../modelos/modelos.dart';
import '../modelos/estadisticas.dart';
import '../widgets/widget_resumenrespuesta.dart';
import '../estilos.dart';
import '../modelos/user.dart';

/**
 * Clase que gestiona la pantalla de resumen
 */
class PagResumen extends StatelessWidget {
  const PagResumen({this.stats});

  final Estadisticas stats;

  List<Widget> _buildQuestions() {
    var index = 0;

    final widgets = List<Widget>()
      ..add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Text(
            'Puntuación Final: ${stats.score}',
            style: summaryScoreStyle,
          ),
        ),
      );

    if (stats.corrects.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'CORRECTAS: ${stats.corrects.length}',
                  style: correctsHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          stats.corrects.map((question) {
            index++;
            return ResumenRespuestas(
              index: index,
              question: question,
            );
          }),
        );
    }

    if (stats.wrongs.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'INCORRECTAS: ${stats.wrongs.length}',
                  style: wrongsHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          stats.wrongs.map((question) {
            index++;
            return ResumenRespuestas(
              index: index,
              question: question,
            );
          }),
        );
    }

    if (stats.noAnswered.isNotEmpty) {
      widgets
        ..add(
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 32,
            color: Colors.indigo[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'NO RESPONDIDA: ${stats.noAnswered.length}',
                  style: notAnsweredHeaderStyle,
                ),
              ],
            ),
          ),
        )
        ..addAll(
          stats.noAnswered.map((question) {
            index++;
            return ResumenRespuestas(
              index: index,
              question: question,
            );
          }),
        );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of<AppState>(context);

    final List<Widget> widgets = _buildQuestions()
      ..add(Container(
        height: 24,
      ))
      ..add(Container(
        width: 90,
        child: RaisedButton(
          child: const Text('Home'),
          onPressed: () {
             DBHelper dbHelper = DBHelper();
             if (appState.userChosen.value==null){
               User user = User("0",'Usuario',0);
               appState.userChosen.value = user;
             }
             dbHelper.saveUser(appState.userChosen.value.name, stats.score);
             print("usuario: $appState.userChosen.value.name ");
             print("puntuacion $stats.score");
             appState.tabController.value = AppTab.main;
          }
        ),
      ));

    return FadeInWidget(
      duration: 750,
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: widgets,
        ),
      ),
    );
  }
}
