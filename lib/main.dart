import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Configs/appTheme.dart';
import 'Screens/wrapper.dart';

Future<void> main() async{
  await initializeDateFormatting('ja_JP').then(
    (_) => runApp(const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: appTheme,
      home: const Wrapper(),
    );
  }
}
