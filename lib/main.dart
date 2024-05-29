import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcled/app/elevator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/rendering.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  debugPaintSizeEnabled = false;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        ),
        theme: ThemeData(primarySwatch: Colors.grey),
        debugShowCheckedModeBanner: false,
        initialRoute: "/h",
        routes: {
          "/h": (context) => const ElevatorControll(),
          //"/e": (context) => const ElevatorScreen(),
        },
        navigatorObservers: <NavigatorObserver>[RouteObserver<ModalRoute>()],
      );
}