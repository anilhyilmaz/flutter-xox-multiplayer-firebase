import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GridviewBuilder extends StatefulWidget {
  const GridviewBuilder({Key? key}) : super(key: key);

  @override
  State<GridviewBuilder> createState() => _GridviewBuilderState();
}

class _GridviewBuilderState extends State<GridviewBuilder> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;
  var gameCode,
      id,
      firstPlayer,
      secondPlayer,
      board,
      firstPlayerImage,
      secondPlayerImage,
      gamestarted;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Game Screen")),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Flexible(
                  flex: 2,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          "$firstPlayerImage",
                          height: 50,
                          width: 50,
                        ),
                        Text("$firstPlayer"),
                      ])),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text("code: $id"),
                  ],
                ),
              ),
              //board flexible widget
              Flexible(
                  flex: 5,
                  child: StreamBuilder(
                      stream: Firestore.collection("games")
                          .doc(gameCode)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'No Data...',
                          );
                        } else {
                          return Column(
                            children: [
                              Flexible(
                                flex: 8,
                                child: Container(
                                  height: 300,
                                  width: 300,
                                  margin: const EdgeInsets.all(10),
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 100,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 20),
                                    itemCount: 9,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async => {
                                          controlofGameFinished(index, snapshot),
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                              snapshot.data!["board"][index]
                                                      .toString() ??
                                                  " ",
                                              style: TextStyle(
                                                  fontSize:
                                                      constOsize.toDouble())),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      loadsecondPlayer(snapshot),
                                    ],
                                  ))
                            ],
                          );
                        }
                      }
                      )
              ),

            ])));
  }

  changeboardIndex(int index,move) async {
    if (mounted) {
      await Provider.of<Repo>(context, listen: false).changeText(index,move);
      return await Firestore.collection("games")
          .doc(gameCode)
          .update({"board": board});
    }
  }

  loadsecondPlayer(snapshot) {
    if (mounted) {
      return Text(snapshot.data!["secondPlayer"].toString());
    }
  }

  controlofGameFinished(index, snapshot) async {
    if (mounted) {

      if (await snapshot.data!["gameFinish"] == "true" ||
          await snapshot.data!["gamestarted"] == false) {
        return await Alert(
            context: context,
            title: "Game Finished",
            desc: "Game Finished.")
            .show();
      }
      else if(await snapshot.data!["order"] == "firstplayer" && _auth.currentUser?.email.toString() ==  await snapshot.data!["firstPlayer"]){

        var move = "X";
        boardcontrol(index,move);
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"order": "secondplayer"});
      }
      else if(await snapshot.data!["order"] == "secondplayer" && _auth.currentUser?.email.toString() ==  await snapshot.data!["secondPlayer"]){
        var move = "O";
        boardcontrol(index,move);
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"order": "firstplayer"});
      }
    }
  }


  providerLoad() {
    gameCode = Provider.of<Repo>(context, listen: false).gameCode;
    id = Provider.of<Repo>(context, listen: false).id;
    firstPlayerImage =
        Provider.of<Repo>(context, listen: false).firstPlayerImage;
    secondPlayerImage =
        Provider.of<Repo>(context, listen: false).secondPlayerImage;
    firstPlayer = Provider.of<Repo>(context, listen: false).firstPlayer;
    secondPlayer = Provider.of<Repo>(context, listen: false).secondPlayer;
    board = Provider.of<Repo>(context, listen: false).board;
    gamestarted = Provider.of<Repo>(context, listen: false).gamestarted;
  }
  boardcontrol(int index,var move) async{
    {
      await changeboardIndex(index,move);
      if((board[0] == "X" && board[1] == "X" && board[2] == "X") || (board[0] == "O" && board[1] == "O" && board[2] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      if((board[3] == "X" && board[4] == "X" && board[5] == "X") || (board[3] == "O" && board[4] == "O" && board[5] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      if((board[6] == "X" && board[7] == "X" && board[8] == "X") || board[6] == "O" && board[7] == "O" && board[8] == "O"){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      else if((board[0] == "X" && board[3] == "X" && board[6] == "X") || board[0] == "O" && board[3] == "O" && board[6] == "O"){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      else if((board[1] == "X" && board[4] == "X" && board[7] == "X") || (board[1] == "O" && board[4] == "O" && board[7] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      else if((board[2] == "X" && board[5] == "X" && board[8] == "X") || (board[2] == "O" && board[5] == "O" && board[8] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      else if((board[0] == "X" && board[4] == "X" && board[8] == "X") || (board[0] == "O" && board[4] == "O" && board[8] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
      else if((board[2] == "X" && board[4] == "X" && board[6] == "X") || (board[2] == "O" && board[4] == "O" && board[6] == "O")){
        print("game finished");
        return await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true"});
      }
    }
  }
}
