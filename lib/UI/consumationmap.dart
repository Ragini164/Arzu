import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConsumationMap extends StatefulWidget {
  const ConsumationMap({super.key});

  @override
  State<ConsumationMap> createState() => _ConsumationMapState();
}

class _ConsumationMapState extends State<ConsumationMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
            color: Color(0xffF5591F),
            gradient: LinearGradient(colors: [
              (Color.fromARGB(255, 248, 155, 201)),
              Color.fromARGB(255, 46, 1, 26),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
    ]));
  }
}
