/**
 * autor: Juan Pablo Vázquez Redondo
 * TFG: Gamificación
 * Director: Javier Bravo
 * Año: Septiembre 2020
 */

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../modelos/modelos.dart';

/**
 * Clase widget de la cuenta atras
 */
class WidgetTiempo extends StatefulWidget {
  const WidgetTiempo(
      {@required this.width, Key key, this.duration, this.triviaState})
      : assert(width != null),
        super(key: key);

  final double width;
  final int duration; // Milliseconds
  final TriviaState triviaState;

  @override
  WidgetTiempoState createState() {
    return WidgetTiempoState();
  }
}

class WidgetTiempoState extends State<WidgetTiempo>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Color color;
  final double countdownBarHeight = 24.0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animation = Tween<double>(begin: widget.width, end: 0).animate(controller)
      ..addListener(() {
        setState(() {
          // Animate the countdown bar from green to red
          final value = (animation.value ~/ 2).toInt();
          color = Color.fromRGBO(255 - value, value > 255 ? 255 : value, 0, 1);
        });

        // Stop the animation if an anwser is chosen
        if (widget.triviaState.isAnswerChosen) {
          controller.stop();
        }
      });

    color = Colors.green;
  }

  /**
   * Metodo que actualiza el widget
   */
  @override
  void didUpdateWidget(WidgetTiempo oldWidget) {
    super.didUpdateWidget(oldWidget);
    color = Colors.green;

    // If the user click on an anwser the countdown animation
    // will stop.
    if (widget.triviaState.isAnswerChosen) {
      controller.stop();
    }
    // Otherwise, when a new question appears on the screen and
    // the widget rebuilds, then reset and play the countdown bar
    // animation.
    else {
      controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /**
   * Metodo que construye el widget de la cuenta atras
   */
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: countdownBarHeight,
          width: animation.value,
          child: BlurWidget(
            sigmaX: 12.0,
            sigmaY: 13.0,
            child: Container(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
