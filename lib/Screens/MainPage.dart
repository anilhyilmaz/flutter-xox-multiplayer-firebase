import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdeneme/Screens/GridviewBuilder.dart';
import 'package:provider/provider.dart';

import '../Class/Repo.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text("username"),
        ),
        TextButton(
            onPressed: () => print("join game"), child: Text("Join Game")),
        Divider(
          color: Colors.black,
        ),
        TextButton(onPressed: () => creategame(), child: Text("Create Game"))
      ],
    );
  }

  creategame() async {
    String id = "123";
    try {
      FirebaseFirestore Firestore = FirebaseFirestore.instance;
      Firestore.collection("news").add({"id": id});
      Provider.of<Repo>(context,listen: false).gameCode = id;
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => GridviewBuilder()));
      print("game created");
    } catch (e) {
      print(e.toString());
    }
  }
}
