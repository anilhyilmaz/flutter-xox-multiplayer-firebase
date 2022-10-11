import 'package:flutter/material.dart';
import 'package:flutterdeneme/Class/Repo.dart';
import 'package:flutterdeneme/Screens/CenterContainer.dart';
import 'package:flutterdeneme/Screens/LeftContainer.dart';
import 'package:flutterdeneme/Utils/ConstantStyles.dart';
import 'package:provider/provider.dart';

import 'Screens/RightContainer.dart';

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
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.all(10),
              child: GridView.builder(gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 20),itemCount: Provider.of<Repo>(context).mylist.length,itemBuilder: (context,index){
                return GestureDetector(
                  onTap: ()=>{
                    finished ? print("oyun bitti") : Provider.of<Repo>(context,listen: false).changeText(index),
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(Provider.of<Repo>(context).mylist[index] ?? " ",style: TextStyle(fontSize: constOsize.toDouble())),
                  ),
                );
              },),
            )
          ],
        ),
      ),
    );
  }
}
