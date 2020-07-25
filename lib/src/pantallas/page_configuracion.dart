/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../modelos/appstate.dart';
import '../modelos/modelos.dart';
import '../modelos/pregunta.dart';
import '../modelos/tema.dart';
import '../log/logger.dart';

/**
 * Clase que gestiona la pantalla de configuración
 */
class PagConfig extends StatefulWidget {
  @override
  _PagConfig createState() => _PagConfig();
}

class _PagConfig extends State<PagConfig> {
  Logger logger = new Logger();
  final countdownController = TextEditingController();
  final amountController = TextEditingController();

  /**
   * Metodo que contruye la pagina
   */
  @override
  Widget build(BuildContext context) {
    logger.log('SettingsPage',Level.DEBUG, '---------SettingsPage START-----------','');
    final appState = AppStateProvider.of<AppState>(context);

    countdownController.text =
        (appState.triviaBloc.countdown / 1000).toStringAsFixed(0);

    amountController.text = (appState.questionsAmount.value);

    List<Widget> _buildThemesList() {
      return appState.themes.map((MiTema appTheme) {
        return DropdownMenuItem<MiTema>(
          value: appTheme,
          child: Text(appTheme.name, style: const TextStyle(fontSize: 14.0)),
        );
      }).toList();
    }

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Configuración',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Elije un tema:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ValueBuilder<MiTema>(
                    streamed: appState.currentTheme,
                    builder: (context, snapshot) {
                      return DropdownButton<MiTema>(
                        hint: const Text('Status'),
                        value: snapshot.data,
                        items: _buildThemesList(),
                        onChanged: appState.setTheme,
                      );
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Quiz database:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ValueBuilder<ApiType>(
                    streamed: appState.apiType,
                    builder: (context, snapshot) {
                      return DropdownButton<ApiType>(
                          value: snapshot.data,
                          onChanged: appState.setApiType,
                          items: [
                            const DropdownMenuItem<ApiType>(
                              value: ApiType.mock,
                              child: Text('Udima'),
                            ),
                            const DropdownMenuItem<ApiType>(
                              value: ApiType.remote,
                              child: Text('opentdb.com'),
                            ),
                          ]);
                    }),
              ],
            ),
            ValueBuilder<ApiType>(
                streamed: appState.apiType,
                builder: (context, snapshot) {
                  return snapshot.data == ApiType.mock
                      ? Container()
                      : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'N. de preguntas:',
                              style:
                              TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            child: StreamBuilder<String>(
                                stream: appState
                                    .questionsAmount.outTransformed,
                                builder: (context, snapshot) {
                                  return Expanded(
                                    child: TextField(
                                      controller: amountController,
                                      onChanged: appState
                                          .questionsAmount.inStream,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                        'Introduce un valor entre 2 y 15.',
                                        errorText: snapshot.error,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Dificultad:',
                              style:
                              TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          ValueBuilder<QuestionDifficulty>(
                              streamed: appState.questionsDifficulty,
                              builder: (context, snapshot) {
                                return DropdownButton<QuestionDifficulty>(
                                    value: snapshot.data,
                                    onChanged: appState.setDifficulty,
                                    items: [
                                      const DropdownMenuItem<
                                          QuestionDifficulty>(
                                        value: QuestionDifficulty.easy,
                                        child: Text('Facil'),
                                      ),
                                      const DropdownMenuItem<
                                          QuestionDifficulty>(
                                        value: QuestionDifficulty.medium,
                                        child: Text('Medio'),
                                      ),
                                      const DropdownMenuItem<
                                          QuestionDifficulty>(
                                        value: QuestionDifficulty.hard,
                                        child: Text('Dificil'),
                                      ),
                                    ]);
                              }),
                        ],
                      ),
                    ],
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Tiempo:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: StreamBuilder<String>(
                      stream: appState.countdown.outTransformed,
                      builder: (context, snapshot) {
                        return Expanded(
                          child: TextField(
                            controller: countdownController,
                            onChanged: appState.countdown.inStream,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Introduce un valor en segundos (max 60).',
                              errorText: snapshot.error,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
