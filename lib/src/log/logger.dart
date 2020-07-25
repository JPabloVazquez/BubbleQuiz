/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import '../db/DBHelper.dart';
enum Level { DEBUG, ERROR, WARNING, INFO, SEVERE }

/**
 * Clase que compone el mensaje que se va a guardar en base de datos
 */
class Logger {
String mensaje="";

/**
 * Metodo que configura el mensaje
 */
  void log (clase,Level,String msg, String exception){
    DateTime now = new DateTime.now();
    DBHelper dbHelper = new DBHelper();
    mensaje = now.toIso8601String() + ' - [' + clase + '] - '+ Level.toString() + ' --  '+ msg + ' -- ' + exception;
    dbHelper.setLogger(mensaje);
    print(mensaje);
  }
}