/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

/**
 * Clase pojo
 */
class User {
  String _id;
  String _name;
  int _score;

  User(
      this._id,
      this._name,
      this._score,
      );
  String get id => _id;
  String get name => _name;
  int get score => _score;
}