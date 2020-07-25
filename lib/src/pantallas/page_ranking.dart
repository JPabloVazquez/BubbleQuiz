/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import '../db/DBHelper.dart';

import '../modelos/appstate.dart';
import '../modelos/tema.dart';
import '../modelos/user.dart';

/**
 * Clase que gestiona la pantalla de ranking
 */
class PagRanking extends StatefulWidget {
  @override
  _PagRanking createState() => _PagRanking();
}

class _PagRanking extends State<PagRanking> {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of<AppState>(context);
    List<Widget> _buildThemesList() {
      return appState.themes.map((MiTema appTheme) {
        return DropdownMenuItem<MiTema>(
          value: appTheme,
          child: Text(appTheme.name, style: const TextStyle(fontSize: 14.0)),
        );
      }).toList();
    }

    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('Cargando...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return generateList(snapshot.data);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ranking"),
      ),
      body: futureBuilder,
    );
  }

  Future<List<User>> _getData() async {
    DBHelper dbHelper = DBHelper();
    Future<List<User>> values = dbHelper.getAll();
    return values;
  }

  SingleChildScrollView generateList(List<User> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('NOMBRE',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
              ),
            ),
            DataColumn(
              label: Text('SCORE',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
            ),
          ),
          ],
          rows: users
              .map(
                (user) => DataRow(
              cells: [
                DataCell(
                  Text(user.name),
                ),
                DataCell(
                  Text(user.score.toString()),
                )
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}