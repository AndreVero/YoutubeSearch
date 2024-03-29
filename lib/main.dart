import 'package:flutter/material.dart';
import 'package:youtubesearch/injection_container.dart';
import 'package:youtubesearch/ui/search/search_page.dart';

void main() {
  initKiwi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red.shade600,
        accentColor: Colors.redAccent.shade400,
      ),
      home: SearchPage(),
    );
  }
}

