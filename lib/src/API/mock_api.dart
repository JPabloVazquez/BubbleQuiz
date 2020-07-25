/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'dart:async';

import 'dart:convert' as convert;

import 'package:frideos_core/frideos_core.dart';

import '../modelos/categoria.dart';
import '../modelos/pregunta.dart';

import 'interfaz_api.dart';
import '../log/logger.dart';

/*
 * Clase de prueba con datos en local que en un futuro podria guardarse en base de datos
 */
class MockAPI implements PreguntasAPI {
  Logger logger = new Logger();
  @override
  Future<bool> getCategories(StreamedList<Category> categories) async {
    logger.log('MockAPI.getCategories',Level.DEBUG, '---------START-----------','');
    categories.value = [];

    categories.addElement(
      Category(id: 0, name: 'Categoria udima'),
    );
    categories.addElement(
      Category(id: 1, name: 'Estructuras de datos'),
    );
    logger.log('MockAPI.getCategories',Level.DEBUG, '---------FIN-----------','');
    return true;
  }

  /*
   * metodo que recupera las preguntas dependiedo de los valores [categoria][number][difficulty][type]
   */
  @override
  Future<bool> getQuestions(
      {StreamedList<Question> questions,
        int number,
        Category category,
        QuestionDifficulty difficulty,
        QuestionType type}) async {
    logger.log('MockAPI.getQuestions',Level.DEBUG, '---------START-----------','');
    var categoria = category.name;
    logger.log('MockAPI.getQuestions',Level.DEBUG, 'categoria: $categoria','');
    DateTime now = new DateTime.now();
    var json;
    switch(categoria) {
      case "Estructuras de datos": {
        json = "{\"response_code\":0,\"results\":[{\"category\":\"Science: Computers\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"¿Cual de los siguientes costes es más deseable en un algoritmo?\",\"correct_answer\":\"Lineal\",\"incorrect_answers\":[\"NlogN\",\"^3\",\"^2\"]},{\"category\":\"Science: Computers\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"¿Cual de los siguientes costes es más deseable en un algoritmo?\",\"correct_answer\":\"Cte\",\"incorrect_answers\":[\"Lineal\",\"Log\",\"^2\"]},{\"category\":\"Science: Computers\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"¿Cual de los siguientes costes es menos deseable en un algoritmo?\",\"correct_answer\":\"Exp\",\"incorrect_answers\":[\"^3\",\"NlogN\",\"^2\"]},{\"category\":\"Science: Computers\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"¿Que accion realiza sobre un elemento la operación desapilar en una pila?\",\"correct_answer\":\"Supr\",\"incorrect_answers\":[\"Ins\",\"Fin\",\"Get\"]},{\"category\":\"Science: Computers\",\"type\":\"multiple\",\"difficulty\":\"easy\",\"question\":\"¿Cual de los siguientes costes es más deseable en un algoritmo?\",\"correct_answer\":\"NlogN\",\"incorrect_answers\":[\"Exp\",\"^3`\",\"^2\"]}]}";
        print("$now Excelent");
      }
      break;
      default: { print("Invalid choice"); }
      break;
    }


    final jsonResponse = convert.jsonDecode(json);

    final result = (jsonResponse['results'] as List)
        .map((question) => ModeloPregunta.fromJson(question));

    questions.value =
        result.map((question) => Question.fromQuestionModel(question)).toList();

    return true;
  }
}
