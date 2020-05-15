import 'package:flutter/material.dart';
import 'activitys/LoginActivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '蚯蚓針',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginActivity(),
    );
  }
}
