import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Class/Repo.dart';
import '../Utils/CreateRandomID.dart';
import 'GameScreen.dart';


class CreateJoinGameScreen extends StatefulWidget {
  const CreateJoinGameScreen({Key? key}) : super(key: key);

  @override
  State<CreateJoinGameScreen> createState() => _CreateJoinGameScreenState();
}


var gameIdController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;


class _CreateJoinGameScreenState extends State<CreateJoinGameScreen> {

  @override
  Widget build(BuildContext context) {



    return Scaffold(appBar: AppBar(title: Text("Create or Join Game Screen"),centerTitle: true,),body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 45,right: 45),
            child: TextField(
              controller: gameIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type room number',
              ),
            ),
          ),
          TextButton(
              onPressed: () => joingame(), child: Text("Join Game")),
          const Divider(
            color: Colors.black,
          ),
          TextButton(onPressed: () => creategame(), child: Text("Create Game"))
        ],
      ),
    ));

  }

  creategame() async {
    String id = createRoomID();
    final now = DateTime.now();
    try {
      FirebaseFirestore Firestore = FirebaseFirestore.instance;
      Firestore.collection("games").add({"sira":"first_player","board":[2,2,2,2,2,2,2,2,2],"XorO":"X","id": id,"created_time":now,"firstPlayer":_auth.currentUser?.email.toString(),"secondPlayer":null,"gameFinish":"false"});
      Provider.of<Repo>(context,listen: false).gameCode = id;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const GridviewBuilder()));
      print("game created");
    } catch (e) {
      print(e.toString());
    }
  }
  joingame() async{
    var len;
    FirebaseFirestore Firestore = FirebaseFirestore.instance;
    var gamesSnapshots = Firestore.collection("games").snapshots();
    gamesSnapshots.forEach((element) {
      len = element.docs.length;
    });
    gamesSnapshots.forEach((element) {
      for(int i=0;i<len;i++){
        if(gameIdController.text == element.docs[i].data()["id"]){
          print("uyuştu");
          print(element.docs[i].data()["id"]);
          // if(_auth.currentUser != element.docs[i].data()["firstPlayer"]){
          if(1==1){
            Firestore.collection("games").doc(element.docs[i].id).update({"secondPlayer":_auth.currentUser?.email.toString()});
            print("eklendi");
            Provider
                .of<Repo>(context, listen: false)
                .id = element.docs[i].data()["id"];
            Provider
                .of<Repo>(context, listen: false)
                .gameCode = element.docs[i].id;
            Provider
                .of<Repo>(context, listen: false)
                .firstPlayer = element.docs[i].data()["firstPlayer"];
            Provider
                .of<Repo>(context, listen: false)
                .secondPlayer = element.docs[i].data()["secondPlayer"];

            print("gameCodeProvider: ${Provider
                .of<Repo>(context, listen: false)
                .gameCode}");
            print("gameIDProvider ${Provider
                .of<Repo>(context, listen: false)
                .id}");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const GridviewBuilder()));
          }
        }
      }
    });
  }
}
