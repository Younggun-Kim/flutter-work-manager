import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work_manager/bloc/bloc.dart';
import 'package:flutter_work_manager/work_manager/work_manager.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    workerDispatcher,
    isInDebugMode: kDebugMode,
  );

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
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'OneOff',
                          bgColor: Colors.greenAccent,
                          onTap: () {
                            context.read<MainBloc>().add(
                              MainBlocEvent.oneOff(),
                            );
                          },
                        ),
                        Button(
                          text: 'Periodic',
                          bgColor: Colors.blueAccent,
                          onTap: () {
                            context.read<MainBloc>().add(
                              MainBlocEvent.periodic(),
                            );
                          },
                        ),
                        Button(
                          text: 'Processing',
                          bgColor: Colors.yellowAccent,
                          onTap: () {
                            context.read<MainBloc>().add(
                              MainBlocEvent.processing(),
                            );
                          },
                        ),
                        Button(
                          text: 'Update',
                          bgColor: Colors.redAccent,
                          onTap: () {
                            context.read<MainBloc>().add(
                              MainBlocEvent.updated(),
                            );
                          },
                        ),
                        Button(
                          text: 'Log',
                          bgColor: Colors.orangeAccent,
                          onTap: () {
                            Worker.log();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.bgColor,
    required this.onTap,
  });

  final String text;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      onTap();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$text 클릭')),
      );
    },
    child: Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor, // 예시 색상
        borderRadius: BorderRadius.circular(
          10,
        ), // 뭉툭한 모서리
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    ),
  );
}
