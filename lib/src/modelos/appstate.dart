/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frideos_core/frideos_core.dart';

import 'package:frideos/frideos.dart';
import '../API/interfaz_api.dart';
import '../API/api_juego.dart';
import '../API/mock_api.dart';
import '../blocs/trivia_bloc.dart';
import '../modelos/categoria.dart';
import '../modelos/modelos.dart';
import '../modelos/pregunta.dart';
import '../modelos/tema.dart';
import '../modelos/user.dart';
import '../log/logger.dart';

/**
 * Clase que mantien los estados de la aplicación
 */
class AppState extends AppStateModel {
  Logger logger = new Logger();
  factory AppState() => _singletonAppState;

  AppState._internal() {
    logger.log('APPState',Level.DEBUG, '-------APP STATE INICIO--------','');
    _createThemes(themes);
    _loadCategories();

    countdown.value = 10.toString();
    countdown.setTransformer(validateCountdown);

    questionsAmount.value = 10.toString();
    questionsAmount.setTransformer(validateAmount);

    triviaBloc = TriviaBloc(
        countdownStream: countdown,
        questions: questions,
        tabController: tabController);
  }

  static final AppState _singletonAppState = AppState._internal();

  // TEMAS
  final themes = List<MiTema>();
  final currentTheme = StreamedValue<MiTema>();

  // API
  PreguntasAPI api = MockAPI();
  final apiType = StreamedValue<ApiType>(initialData: ApiType.mock);

  // TABS
  final tabController = StreamedValue<AppTab>(initialData: AppTab.main);

  // TRIVIA
  final categoriesStream = StreamedList<Category>();
  final categoryChosen = StreamedValue<Category>();
  final userChosen = StreamedValue<User>();
  final questions = StreamedList<Question>();
  final questionsDifficulty =
      StreamedValue<QuestionDifficulty>(initialData: QuestionDifficulty.medium);

  final questionsAmount = StreamedTransformed<String, String>();

  final validateAmount =
      StreamTransformer<String, String>.fromHandlers(handleData: (str, sink) {
    if (str.isNotEmpty) {
      final amount = int.tryParse(str);
      if (amount > 1 && amount <= 15) {
        sink.add(str);
      } else {
        sink.addError('Introduzca un valor entre 2 y 15..');
      }
    } else {
      sink.addError('Introduzca un valor.');
    }
  });

  // BLOC
  TriviaBloc triviaBloc;

  // CUENTA ATRAS
  final countdown = StreamedTransformed<String, String>();

  final validateCountdown =
      StreamTransformer<String, String>.fromHandlers(handleData: (str, sink) {
    if (str.isNotEmpty) {
      final time = int.tryParse(str);
      if (time >= 3 && time <= 90) {
        sink.add(str);
      } else {
        sink.addError('Insert a value from 3 to 90 seconds.');
      }
    } else {
      sink.addError('Insert a value.');
    }
  });

  @override
  Future<void> init() async {
    final String lastTheme = await Prefs.getPref('apptheme');
    if (lastTheme != null) {
      currentTheme.value = themes.firstWhere((theme) => theme.name == lastTheme,
          orElse: () => themes[0]);
    } else {
      currentTheme.value = themes[0];
    }
  }

  Future _loadCategories() async {
    final isLoaded = await api.getCategories(categoriesStream);
    if (isLoaded) {
      categoryChosen.value = categoriesStream.value.last;
    }
  }

  Future _loadQuestions() async {
    await api.getQuestions(
        questions: questions,
        number: int.parse(questionsAmount.value),
        category: categoryChosen.value,
        difficulty: questionsDifficulty.value,
        type: QuestionType.multiple);
  }

  void setCategory(Category category) => categoryChosen.value = category;

  void setUser(User user) => userChosen.value = user;

  void setDifficulty(QuestionDifficulty difficulty) =>
      questionsDifficulty.value = difficulty;
  void setApiType(ApiType type) {
    if (apiType.value != type) {
      apiType.value = type;
      if (type == ApiType.mock) {
        api = APIJuego();
      } else {
        api = APIJuego();
      }
      _loadCategories();
    }
  }
  void _createThemes(List<MiTema> themes) {
    themes.addAll([
      MiTema(
        name: 'Default',
        brightness: Brightness.dark,
        backgroundColor: const Color(0xff111740),
        scaffoldBackgroundColor: const Color(0xff111740),
        primaryColor: const Color(0xff283593),
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.blue[300],
      ),
      MiTema(
        name: 'Dark',
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueGrey[900],
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.blue[900],
      ),
      MiTema(
        name: 'Cyan',
        brightness: Brightness.dark,
        backgroundColor: const Color(0xff00BCD1),
        scaffoldBackgroundColor: Colors.black12,
        primaryColor: Colors.lightBlue[800],
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.cyan[600],
      ),
    ]);
  }

  void setTheme(MiTema theme) {
    currentTheme.value = theme;
    Prefs.savePref<String>('apptheme', theme.name);
  }

  set _changeTab(AppTab appTab) => tabController.value = appTab;

  void startTrivia() {
    _loadQuestions();
    _changeTab = AppTab.trivia;
  }

  void endTrivia() => tabController.value = AppTab.main;

  void showSummary() => tabController.value = AppTab.summary;

  @override
  void dispose() {

    logger.log('APPState',Level.DEBUG, '---------APP STATE DISPOSE-----------','');
    apiType.dispose();
    categoryChosen.dispose();
    countdown.dispose();
    currentTheme.dispose();
    questions.dispose();
    questionsAmount.dispose();
    questionsDifficulty.dispose();
    tabController.dispose();
    triviaBloc.dispose();
  }
}
