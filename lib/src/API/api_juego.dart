/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'dart:async';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:frideos_core/frideos_core.dart';

import '../modelos/categoria.dart';
import '../modelos/pregunta.dart';

import 'interfaz_api.dart';
import '../log/logger.dart';

/**
 * Clase encargada de llamar a la API de opentdb
 */
class APIJuego implements PreguntasAPI {
  Logger logger = new Logger();

  /*
  * metodo que realiza una conexión para saber el estado
   */
  Future<int> ConexionAPI() async{
    const categoriesURL = 'https://opentdb.com/';
    final response = await http.get(categoriesURL);
    return response.statusCode;
  }
  /*
  * Metodo que recupera las categorias de opentdb elegibles en el juego
   */
  @override
  Future<bool> getCategories(StreamedList<Category> categories) async {
    logger.log('TriviaAPI.getCategories',Level.DEBUG, '---------getCategories START-----------','');
    const categoriesURL = 'https://opentdb.com/api_category.php';
    final response = await http.get(categoriesURL);
    //Si la respuesta es correcta 200
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final result = (jsonResponse['trivia_categories'] as List)
          .map((category) => Category.fromJson(category));

      categories.value = [];
      categories
        ..addAll(result)
        ..addElement(Category(id: 0, name: 'Any category'));
      return true;
    } else {
      logger.log('TriviaAPI.getCategories',Level.DEBUG, 'Request failed with status: ${response.statusCode}.','');
      return false;
    }
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
    logger.log('TriviaAPI.getQuestions',Level.DEBUG, '---------getQuestions START-----------','');
    var qdifficulty;
    var qtype;
    switch (difficulty) {
      case QuestionDifficulty.easy:
        qdifficulty = 'easy';
        break;
      case QuestionDifficulty.medium:
        qdifficulty = 'medium';
        break;
      case QuestionDifficulty.hard:
        qdifficulty = 'hard';
        break;
      default:
        qdifficulty = 'medium';
        break;
    }
    logger.log('TriviaAPI.getQuestions',Level.DEBUG, 'Dificultad','$qdifficulty');
    switch (type) {
      case QuestionType.multiple:
        qtype = 'multiple';
        break;
      default:
        qtype = 'multiple';
        break;
    }
    logger.log('TriviaAPI.getQuestions',Level.DEBUG, 'tipo','$qtype');
    final url =
        'https://opentdb.com/api.php?amount=$number&difficulty=$qdifficulty&type=multiple&category=${category.id}';

    final response = await http.get(url);
    logger.log('TriviaAPI.getQuestions',Level.DEBUG, 'status code','$response.statusCode');
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final result = (jsonResponse['results'] as List)
          .map((question) => ModeloPregunta.fromJson(question));

      questions.value = result
          .map((question) => Question.fromQuestionModel(question))
          .toList();

      return true;
    } else {
      logger.log('TriviaAPI.getQuestions',Level.ERROR, 'Error al conectarse con la API status code','$response.statusCode');
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }
}
