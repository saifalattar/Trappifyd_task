import 'dart:async';
import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Registeration/registeration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  runApp(BlocProvider(
    create: (context) => ChatServiceBloc(),
    child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
                titleSmall: TextStyle(fontSize: 10, color: Colors.grey),
                headlineSmall: TextStyle(color: Colors.grey, fontSize: 10),
                titleLarge:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                headlineLarge:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
        home: const Registeration()),
  ));
}
