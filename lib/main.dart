import 'package:flutter/material.dart';
import 'package:flutter_work_manager/bloc/bloc.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';

import 'shared_preferences/shared_preferences_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  CounterWorkManager.instance.init();

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
                    CounterText(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => CounterWorkManager.instance.increase(),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
          ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: SharedPreferencesManager.getCount(),
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      return Text(
        '${snapshot.data}',
        style: Theme.of(context).textTheme.headlineMedium,
      );
    },
  );
}
