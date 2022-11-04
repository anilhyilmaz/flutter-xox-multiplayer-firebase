import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Class/Repo.dart';
import 'GridviewBuilder.dart';


class CreateJoinGameScreen extends StatefulWidget {
  const CreateJoinGameScreen({Key? key}) : super(key: key);

  @override
  State<CreateJoinGameScreen> createState() => _CreateJoinGameScreenState();
}

class _CreateJoinGameScreenState extends State<CreateJoinGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Create or Join Game Screen"),centerTitle: true,),body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("ggg"),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 45,right: 45),
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type room number',
              ),
            ),
          ),
          TextButton(
              onPressed: () => print("join game"), child: Text("Join Game")),
          const Divider(
            color: Colors.black,
          ),
          TextButton(onPressed: () => creategame(), child: Text("Create Game"))
        ],
      ),
    ));
  }

  creategame() async {
    String id = "123";
    try {
      FirebaseFirestore Firestore = FirebaseFirestore.instance;
      Firestore.collection("news").add({"id": id});
      Provider.of<Repo>(context,listen: false).gameCode = id;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const GridviewBuilder()));
      print("game created");
    } catch (e) {
      print(e.toString());
    }
  }
}
