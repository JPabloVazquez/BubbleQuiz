/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:bubble_quiz/src/log/logger.dart';
import '../modelos/user.dart';
import '../modelos/log.dart';

/**
 * clase que se encarga de la conexion con la base de datos Sqllite, integrada
 * en android
 */
class DBHelper {
  Logger logger = new Logger();
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() => _instance;
  static Database _db;

  /**
   * Metodo que recupera la base de datos
   */
  Future<Database> get db async{
    if (_db!=null) return _db;
    _db= await initDB();
    return _db;
  }

  /**
   * Clase que inicializa la base de datos
   */
  Future<Database> initDB() async{
      io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'fworkout.db');
      Database db = await openDatabase(
        path,
        version: 1,
        onCreate: _createTables,
      );
      print('[DBHelper] initDB: Success');
    return db;
  }

  /**
   * Metodo que crea las tablas de la base de datos
   */
  void _createTables(Database db, int version) async{
    await db.execute('CREATE TABLE User (Id	INTEGER, name	TEXT,score	INTEGER,   PRIMARY KEY("Id" AUTOINCREMENT))');
    await db.execute('CREATE TABLE Logger (id	INTEGER, log	TEXT,   PRIMARY KEY("id" AUTOINCREMENT))');
    print('[DBHelper] _createTables: Success');
  }

  /**
   * Metodo que guarda las puntuaciones de los usuarios para el ranking
   */
  void saveUser(String name, int score) async{
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawInsert(''
          'INSERT INTO User (name, score) VALUES (\'$name\', \'$score\')'
      );
    });
    print('[DBHelper] saveUser: success | $name, $score');
  }

  /**
   * Metodo que inserta en base de datos los logs de la aplicación
   */
  void setLogger(String msg) async{
    var dbClient = await db;
    await dbClient.transaction((trans) async {
      return await trans.rawInsert(''
          'INSERT INTO Logger (log) VALUES (\'$msg\')'
      );
    });
    print('[DBHelper] setLogger: success | $msg');
  }

  /**
   * Metodo que recupera la puntuación de un jugador
   */
  Future<List<User>> getUser(String name) async{
    var dbClient = await db;
    List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
        'SELECT * FROM User where name=\'$name\''
    );
    print('[DBHelper] getUser: ${queryList.length} users');
    if (queryList !=null && queryList.length > 0){
      for (int i=0;i<queryList.length;i++){
        usersList.add(User(
          queryList[i]['id'].toString(),
            queryList[i]['name'],
            queryList[i]['score'],
        ));
      }
      print('[DBHelper] getUser: ${usersList[0].name}');
      return usersList;
    }else{
      print('[DBHelper] getUser: Usuario es nulo');
      return null;
    }
  }

  /**
   * Metodo que recupera el  ranking de los 10 mejores puntuaciones del juego
   */
  Future<List<User>> getAll() async{
    var dbClient = await db;
    List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
        'SELECT * FROM User ORDER by score DESC LIMIT 0, 10'
    );
    print('[DBHelper] getAll: ${queryList.length} usuario');
    if (queryList !=null && queryList.length > 0){
      for (int i=0;i<queryList.length;i++){
        usersList.add(User(
          queryList[i]['id'].toString(),
          queryList[i]['name'],
          queryList[i]['score'],
        ));
      }
      print('[DBHelper] getUser: ${usersList[0].name}');
      return usersList;
    }else{
      print('[DBHelper] getUser: Usuario es nulo');
      return null;
    }
  }

  /**
   * Metodo que recupera los registros del log para presentarlos por pantalla
   */
  Future<List<Log>> getLogger() async{
    var dbClient = await db;
    List<Log> logsList = List();
    List<Map> queryList = await dbClient.rawQuery(
        'SELECT * FROM Logger'
    );
    print('[DBHelper] getLogger: ${queryList.length} usuario');
    if (queryList !=null && queryList.length > 0){
      for (int i=0;i<queryList.length;i++){
        logsList.add(Log(
          queryList[i]['id'].toString(),
          queryList[i]['log'],
        ));
      }
      print('[DBHelper] getLog: ${logsList[0].msg}');
      return logsList;
    }else{
      print('[DBHelper] getLog: Log es nulo');
      return null;
    }
  }
}

