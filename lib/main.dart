import 'package:flutter/material.dart';
import 'login.dart';
import 'reg_trabalho.dart';
import 'home.dart';
import 'submeter_trabalho.dart';
import 'editar_tema.dart';
import 'submeter_monografia.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => login(),
      '/home': (context) => home(),
      '/reg_trabalho': (contex) => reg_trabalho(),
      '/submeter_trabalho': (context) => submeter_trabalho(),
      '/editar_tema': (context) => editar_tema(),
      '/submeter_monografia' : (context) => submeter_monografia()
    },
  ));
}
