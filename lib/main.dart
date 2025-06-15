import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/bloc/main_bloc.dart';
import 'package:flutter_work_manager/work_manager/worker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Worker.init();

  runApp(
    MainBlocProvider(
      create: (BuildContext context) => MainBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainBlocBuilder(
      builder:
          (BuildContext context, MainBlocState state) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('You have pushed the button this many times:'),
                    Text(
                      '${state.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Worker.increase(),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
          ),
    );
  }
}
