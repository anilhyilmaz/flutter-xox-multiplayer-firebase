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
    if(mounted){
      var len;
      String id = createRoomID();
      final now = DateTime.now();
      try {
        FirebaseFirestore Firestore = FirebaseFirestore.instance;
        await Firestore.collection("games").add({"gamestarted":false,"firstPlayerImage":_auth.currentUser?.photoURL,"secondPlayerImage":"","order":"firstplayer","0":"","1":"","2":"","3":"","4":"","5":"","6":"","7":"","8":"","firstplayer_move":"X","secondplayer_move":"O","id": id,"created_time":now,"firstPlayer":_auth.currentUser?.email.toString(),"secondPlayer":"","gameFinish":"false"});
        var gamesSnapshots = await Firestore.collection("games").snapshots();
        gamesSnapshots.forEach((element) {
          len = element.docs.length;
        });
        gamesSnapshots.forEach((element) async {
          for(int i=0;i<len;i++){
            if(id == await element.docs[i].data()["id"]){
              print(element.docs[i].data()["id"]);
              Provider
                  .of<Repo>(context, listen: false)
                  .id = await element.docs[i].data()["id"];
              // Provider
              //     .of<Repo>(context, listen: false)
              //     .board = await element.docs[i].data()["board"];
              Provider
                  .of<Repo>(context, listen: false)
                  .gamestarted = await element.docs[i].data()["gamestarted"];
              Provider
                  .of<Repo>(context, listen: false)
                  .firstPlayerImage = await element.docs[i].data()["firstPlayerImage"];
              Provider
                  .of<Repo>(context, listen: false)
                  .gameCode = await element.docs[i].id;
              Provider
                  .of<Repo>(context, listen: false)
                  .firstPlayer =await element.docs[i].data()["firstPlayer"];

              print("gameCodeProvider: ${Provider
                  .of<Repo>(context, listen: false)
                  .gameCode}");
              print("gameIDProvider ${Provider
                  .of<Repo>(context, listen: false)
                  .id}");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>  GridviewBuilder()));
              print("game created");

            }
          }
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }
  joingame() async{
    if(mounted){
      var len;
      FirebaseFirestore Firestore = FirebaseFirestore.instance;
      var gamesSnapshots = Firestore.collection("games").snapshots();
      gamesSnapshots.forEach((element){
        len = element.docs.length;
      });
      await gamesSnapshots.forEach((element) async {
        for(int i=0;i<len;i++){
          if(gameIdController.text == await element.docs[i].data()["id"]){
            print("uyuştu");
            print(element.docs[i].data()["id"]);
            if(_auth.currentUser != await element.docs[i].data()["firstPlayer"] && await element.docs[i].data()["secondPlayer"] == ""){
              await Firestore.collection("games").doc(element.docs[i].id).update({"gamestarted":true,"secondPlayer":_auth.currentUser?.email.toString(),"secondPlayerImage":_auth.currentUser?.photoURL});
              print("eklendi");
              Provider
                  .of<Repo>(context, listen: false)
                  .id = await element.docs[i].data()["id"];

              Provider
                  .of<Repo>(context, listen: false)
                  .gameCode =element.docs[i].id;
              Provider
                  .of<Repo>(context, listen: false)
                  .gamestarted =await element.docs[i].data()["gamestarted"];
              Provider
                  .of<Repo>(context, listen: false)
                  .firstPlayerImage =await element.docs[i].data()["firstPlayerImage"];
              Provider
                  .of<Repo>(context, listen: false)
                  .secondPlayerImage =_auth.currentUser?.photoURL;
              Provider
                  .of<Repo>(context, listen: false)
                  .firstPlayer =await element.docs[i].data()["firstPlayer"];
              Provider
                  .of<Repo>(context, listen: false)
                  .secondPlayer =_auth.currentUser?.email;
              print(Provider
                  .of<Repo>(context, listen: false)
                  .secondPlayer);

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => GridviewBuilder()));
            }
          }
        }
      });
    }
  }
}
