import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_screen.dart';
import 'package:todo_app/shared/constants.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: HomeScreen(),
    );
  }
}