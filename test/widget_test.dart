// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:async';

import 'package:frideos_core/frideos_core.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'dart:core';

import 'package:bubble_quiz/src/modelos/categoria.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bubble_quiz/src/API/api_juego.dart';
import 'package:bubble_quiz/src/API/interfaz_api.dart';



void main() {
  final categoriesStream = StreamedList<Category>();
  group('QuestionsAPI',(){
    test('Test de conectividad a opentdb', () async {
      APIJuego api = APIJuego();
      expect( await api.ConexionAPI(), 200);
    });
    test('Test de recuperar las categorias', () async {
      APIJuego api = APIJuego();
      expect( await api.getCategories(categoriesStream), true);
    });
    test('Test recuperar preguntas', () async {
      PreguntasAPI api = APIJuego();
      Future<bool> b = (await api.getQuestions()) as Future<bool>;
      expect( b, Future<bool>.value(true));
    });
  });

}
