/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../modelos/appstate.dart';
import '../modelos/categoria.dart';
import '../modelos/user.dart';
import '../log/logger.dart';

/**
 * Clase que gestiona la pantalla principal
 */
class PagPpal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Logger logger = new Logger();
    final appState = AppStateProvider.of<AppState>(context);
    final nameController = TextEditingController(text: 'Usuario');
    final _screenSize = MediaQuery.of(context).size;
    logger.log('MainPage',Level.DEBUG, 'Inicio','');
    return FadeInWidget(
      duration: 750,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: ValueBuilder<List<Category>>(
          streamed: appState.categoriesStream,
          noDataChild: const CircularProgressIndicator(),
          builder: (context, snapshot) {
            final categories = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 44.0, vertical: 16.0),
                      child: const Text(
                        'BUBBLE QUIZ',
                        style: TextStyle(
                          fontSize: 46.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.lightBlueAccent,
                              offset: Offset(3.0, 4.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Elije una categoria:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 14.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                    ),
                    ValueBuilder<Category>(
                      streamed: appState.categoryChosen,
                      builder: (context, snapshotCategory) =>
                          DropdownButton<Category>(
                            isExpanded: true,
                            value: snapshotCategory.data,
                            onChanged: appState.setCategory,
                            items: categories
                                .map<DropdownMenuItem<Category>>(
                                  (value) => DropdownMenuItem<Category>(
                                        value: value,
                                        child: Text(
                                          value.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                )
                                .toList(),
                          ),
                    ),
                    TextFormField(
                      onFieldSubmitted:(value){
                        User user = User("0",value,0);
                         appState.setUser(user);
                      },
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Nombre:'),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue,
                              blurRadius: 2.0,
                              spreadRadius: 2.5),
                        ]),
                    child: const Text(
                      'Jugar bubble Quiz',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  onTap: appState.startTrivia,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
