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
import '../modelos/log.dart';

/**
 * Clase que gestiona la pantalla de log
 */
class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
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
        title: new Text("Registros de Log"),
      ),
      body: futureBuilder,
    );
  }

  Future<List<Log>> _getData() async {
    DBHelper dbHelper = DBHelper();
    Future<List<Log>> values = dbHelper.getLogger();
    return values;
  }

  SingleChildScrollView generateList(List<Log> logs) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Logs',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
              ),
            ),
          ],
          rows: logs
              .map(
                (log) => DataRow(
              cells: [
                DataCell(
                  Text(log.msg),
                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}