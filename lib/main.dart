import 'package:flutter/material.dart';
import 'app_screens/main_calculator _screen.dart';
import 'app_screens/admob_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdmobHelper.initialization();
  runApp(MyNoteCalculator());
}

class MyNoteCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note Calculator",
      debugShowCheckedModeBanner: false,
      home: MainCalculatorScreen(""),
    );
  }
}
