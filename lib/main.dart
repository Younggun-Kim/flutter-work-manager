import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/bloc/bloc.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  CounterWorkManager.instance.init();

  runApp(
    MainBlocProvider(
      create: (BuildContext context) => MainBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainBlocBuilder(
        builder:
            (context, state) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${state.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    InkWell(
                      onTap: () async {
                        context.read<MainBloc>().add(MainBlocEvent.updated());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('업데이트됨')),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 60,
                        color: Colors.amber,
                        child: Text('업데이트'),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed:
                    () => context.read<MainBloc>().add(
                      MainBlocEvent.increased(),
                    ),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
      ),
    );
  }
}
