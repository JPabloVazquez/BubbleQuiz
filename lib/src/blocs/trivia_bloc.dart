/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'dart:async';

import 'package:frideos_core/frideos_core.dart';

import '../modelos/modelos.dart';
import '../modelos/pregunta.dart';
import '../modelos/estadisticas.dart';
import '../log/logger.dart';
const refreshTime = 100;

/*
 * Clase bloc donde esta la logica de negocio de la aplicación
 */
class TriviaBloc {
  Logger logger = new Logger();

  TriviaBloc({this.countdownStream, this.questions, this.tabController}) {
    logger.log('TriviaBloc',Level.DEBUG, '---------s START-----------','');
    // Recupera las preguntas del API
    questions.onChange((data) {
      if (data.isNotEmpty) {
        final questions = data..shuffle();
        _startTrivia(questions);
      }
    });

    countdownStream.outTransformed.listen((data) {
      countdown = int.parse(data) * 1000;
    });
  }

  // STREAMS
  final StreamedValue<AppTab> tabController;
  final triviaState = StreamedValue<TriviaState>(initialData: TriviaState());
  final StreamedList<Question> questions;
  final currentQuestion = StreamedValue<Question>();
  final currentTime = StreamedValue<int>(initialData: 0);
  final countdownBar = StreamedValue<double>();
  final answersAnimation = StreamedValue<AnswerAnimation>(
      initialData: AnswerAnimation(chosenAnswerIndex: 0, startPlaying: false));

  // PREGUNTAS, RESPUESTAS, ESTADISTICAS
  int index = 0;
  String chosenAnswer;
  final stats = Estadisticas();

  // TIEMPO, CUENTA ATRAS
  final StreamedTransformed<String, String> countdownStream;
  int countdown; // Milisegundos
  Timer timer;

  void _startTrivia(List<Question> data) {
    index = 0;
    triviaState.value.questionIndex = 1;

    // Para mostrar la página principal y los botones de resumen
    triviaState.value.isTriviaEnd = false;

    // Resetea las estadisticas
    stats.reset();

    // Para establecer la pregunta inicial (en este caso la animación de la
    // barra de cuenta atrás no comenzará).
    currentQuestion.value = data.first;

    Timer(Duration(milliseconds: 1000), () {
      //Al cambiar la pregunta, la animación de la barra de
      // cuenta atrás comienza.
      triviaState.value.isTriviaPlaying = true;

      // Vuelve a emitir la primera pregunta con la animación de
      // la barra de cuenta atrás.
      currentQuestion.value = data[index];

      playTrivia();
    });
  }

  /*
   * metodo donde inicializa el juego de Bubble Quiz
   */
  void playTrivia() {
    timer = Timer.periodic(Duration(milliseconds: refreshTime), (Timer t) {
      currentTime.value = refreshTime * t.tick;

      if (currentTime.value > countdown) {
        currentTime.value = 0;
        timer.cancel();
        notAnswered(currentQuestion.value);
        _nextQuestion();
      }
    });
  }

  /*
   * Metodo que finaliza el juego del bubble quiz reiniciando los valores
   */
  void _endTrivia() {
    // RESET
    timer.cancel();
    currentTime.value = 0;
    triviaState.value.isTriviaEnd = true;
    triviaState.refresh();
    stopTimer();

    Timer(Duration(milliseconds: 1500), () {
      //esto se reajusta aquí para no disparar el inicio de la animación
      // de la cuenta atrás mientras se espera la página de resumen.
      triviaState.value.isAnswerChosen = false;
      // Mostrar la página de resumen después de 1.5s
      tabController.value = AppTab.summary;

      // Despeja la última pregunta para que no aparezca en el próximo juego
      currentQuestion.value = null;
    });
  }

  /*
   * Metodo que añade las preguntas no respondidas
   */
  void notAnswered(Question question) {
    stats.addNoAnswer(question);
  }

  /*
   * metodo que compruebas las respuestas
   */
  void checkAnswer(Question question, String answer) {
    int extraScore = 10 - (currentTime.value/1000).round();
    if (!triviaState.value.isTriviaEnd) {
      question.chosenAnswerIndex = question.answers.indexOf(answer);
      if (question.isCorrect(answer)) {
        stats.addCorrect(question, extraScore);
      } else {
        stats.addWrong(question);
      }

      timer.cancel();
      currentTime.value = 0;
      //Siguiente pregunta
      _nextQuestion();
    }
  }

  /*
   * Metodo que recupera la siguiente pregunta
   */
  void _nextQuestion() {
    index++;

    if (index < questions.length) {
      triviaState.value.questionIndex++;
      currentQuestion.value = questions.value[index];
      playTrivia();
    } else {
      _endTrivia();
    }
  }

  //Metodo que detiene el tiempo
  void stopTimer() {
    // Stop the timer
    timer.cancel();
    // By setting this flag to true the countdown animation will stop
    triviaState.value.isAnswerChosen = true;
    triviaState.refresh();
  }

  /*
   * Metodo que elige la respuesta
   */
  void onChosenAnswer(String answer) {
    chosenAnswer = answer;

    stopTimer();

    // Ponga la respuesta elegida de manera que el widget de respuesta
    // pueda ponerla en último lugar en la pila.
    answersAnimation.value.chosenAnswerIndex =
        currentQuestion.value.answers.indexOf(answer);
    answersAnimation.refresh();
  }

  /*
   * Metodo que elige las respuestas cuando la animación termina
   */
  void onChosenAnwserAnimationEnd() {
    // Reajustar el flag para que la animación de la
    // cuenta atrás pueda comenzar
    triviaState.value.isAnswerChosen = false;
    triviaState.refresh();

    checkAnswer(currentQuestion.value, chosenAnswer);
  }

  void dispose() {
    answersAnimation.dispose();
    countdownBar.dispose();
    countdownStream.dispose();
    currentQuestion.dispose();
    currentTime.dispose();
    questions.dispose();
    tabController.dispose();
    triviaState.dispose();
  }
}
