/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

/**
 * Clase pojo
 */
class Category {
  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }

  int id;
  String name;
}
