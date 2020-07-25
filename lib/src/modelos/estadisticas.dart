/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'pregunta.dart';

/**
 * Clase que maneja las estadisiticas del juego
 */
class Estadisticas {
  TriviaStats() {
    corrects = [];
    wrongs = [];
    noAnswered = [];
    score = 0;
  }

  List<Question> corrects;
  List<Question> wrongs;
  List<Question> noAnswered;
  int score;

  void addCorrect(Question question, int extraScore) {
    corrects.add(question);
    score += 10+extraScore;
  }

  void addWrong(Question question) {
    wrongs.add(question);
    score -= 5;
  }

  void addNoAnswer(Question question) {
    noAnswered.add(question);
    score -= 3;
  }

  void reset() {
    corrects = [];
    wrongs = [];
    noAnswered = [];
    score = 0;
  }
}
