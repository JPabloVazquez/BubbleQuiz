/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

/**
 * Clase pojo
 */
class Log {
  String _id;
  String _msg;

  Log(
      this._id,
      this._msg,
      );
  String get id => _id;
  String get msg => _msg;
}