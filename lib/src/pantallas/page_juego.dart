/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../estilos.dart';
import '../modelos/appstate.dart';
import '../modelos/modelos.dart';
import '../modelos/pregunta.dart';
import '../widgets/widget_respuestas.dart';
import '../widgets/widget_tiempo.dart';
import '../widgets/widget_pregunta.dart';
import '../log/logger.dart';

/**
 * Clase que gestiona la pantalla del juego
 */
class PagPlay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Logger logger = new Logger();
    final bloc = AppStateProvider.of<AppState>(context).triviaBloc;
    logger.log('TriviaPage',Level.DEBUG, '---------TriviaPage START-----------','');
    return ValueBuilder<TriviaState>(
        streamed: bloc.triviaState,
        builder: (context, snapshotTrivia) {
          return ValueBuilder<Question>(
              streamed: bloc.currentQuestion,
              builder: (context, snapshotQuestion) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 22),
                  child: TriviaMain(
                      triviaState: snapshotTrivia.data,
                      question: snapshotQuestion.data),
                );
              });
        });
  }
}

class TriviaMain extends StatelessWidget {

  const TriviaMain({this.triviaState, this.question});

  final TriviaState triviaState;
  final Question question;

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of<AppState>(context).triviaBloc;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: const Color(0xff283593),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.blue, blurRadius: 3.0, spreadRadius: 1.5),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'PUNTUACION: ${bloc.stats.score}',
                      style: scoreHeaderStyle,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Correctas: ${bloc.stats.corrects.length}',
                    style: questionsHeaderStyle,
                  ),
                  Text(
                    'Incorrectas: ${bloc.stats.wrongs.length}',
                    style: questionsHeaderStyle,
                  ),
                  Text(
                    'Sin responder: ${bloc.stats.noAnswered.length}',
                    style: questionsHeaderStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
        Container(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: WidgetPregunta(
            bloc: bloc,
            question: question,
          ),
        ),
        Container(
          height: 32,
        ),
        Expanded(
          child: ValueBuilder<AnswerAnimation>(
              streamed: bloc.answersAnimation,
              builder: (context, snapshot) {
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: WidgetRespuesta(
                      bloc: bloc,
                      question: question,
                      answerAnimation: snapshot.data,
                      isTriviaEnd: triviaState.isTriviaEnd,
                    ));
              }),
        ),
        ValueBuilder<int>(
            streamed: bloc.currentTime,
            builder: (context, snapshot) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 24,
                    padding: const EdgeInsets.all(22),
                    child: Text(
                      'Tiempo: ${((bloc.countdown - snapshot.data) / 1000)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              );
            }),
        Container(
          height: 18,
        ),
        WidgetTiempo(
          width: MediaQuery.of(context).size.width,
          duration: bloc.countdown,
          triviaState: triviaState,
        ),
      ],
    );
  }
}
