import 'package:flutter/material.dart';
import 'package:flutterdeneme/Class/Repo.dart';
import 'package:flutterdeneme/Utils/ConstantStyles.dart';
import 'package:provider/provider.dart';

import 'Screens/GridviewBuilder.dart';


void main() {
  runApp(ChangeNotifierProvider<Repo>(
      create: (create) => Repo(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "gg",
      home: MyHomePage(
        title: 'Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {


    var finished = Provider.of<Repo>(context,listen: false).isFinished;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            GridviewBuilder(),
          ],
        ),
      ),
    );
  }
}
