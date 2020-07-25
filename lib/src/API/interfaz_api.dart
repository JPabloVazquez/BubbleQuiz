/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:frideos_core/frideos_core.dart';

import '../modelos/categoria.dart';
import '../modelos/pregunta.dart';

/*
 * Clase abtracta para recuperar las preguntas
 */
abstract class PreguntasAPI {
  Future<bool> getCategories(StreamedList<Category> categories);
  Future<bool> getQuestions(
      {StreamedList<Question> questions,
      int number,
      Category category,
      QuestionDifficulty difficulty,
        QuestionType type});
}
