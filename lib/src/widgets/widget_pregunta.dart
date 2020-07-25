/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import '../blocs/trivia_bloc.dart';
import '../modelos/pregunta.dart';

/**
 * Clase widget de las preguntas
 */
class WidgetPregunta extends StatelessWidget {
  const WidgetPregunta({this.bloc, this.question});

  final Question question;
  final TriviaBloc bloc;

  /**
   * Metodo que contruye el widget de preguntas
   */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      alignment: Alignment.center,
      height: 18 * 4.0,
      child: Text(
        '${bloc.triviaState.value.questionIndex} - ${question.question}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
