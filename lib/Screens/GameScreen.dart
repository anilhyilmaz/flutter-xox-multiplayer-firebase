import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'createJoinGameScreen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;
  var gameCode,
      id,
      firstPlayer,
      secondPlayer,
      board,
      firstPlayerImage,
      secondPlayerImage,
      gamestarted;
  final AdSize adSize = AdSize(height: 300, width: 50);
  late final BannerAd myBanner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    providerLoad();
    myBanner = BannerAd(
      adUnitId: "_ca-app-pub-4109178583091990/6357354391",
      size: adSize,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Game Screen")),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text("Game code: $id"),
                  ],
                ),
              ),
              //board flexible widget
              Flexible(
                flex: 8,
                child: StreamBuilder(
                    stream:
                        Firestore.collection("games").doc(gameCode).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          'Loading',
                        );
                      } else {
                        return Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Player1: $firstPlayer"),
                                loadsecondPlayer(snapshot),
                              ],
                            ),
                            Container(child: winner(snapshot)),
                            Container(
                              child: Flexible(
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CreateJoinGameScreen()));
                                          },
                                          child: Text("New Game")))
                            ),
                            Flexible(
                              flex: 6,
                              child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 3,
                                children: <Widget>[
                                  gamebuttoncontainer(snapshot, 0),
                                  gamebuttoncontainer(snapshot, 1),
                                  gamebuttoncontainer(snapshot, 2),
                                  gamebuttoncontainer(snapshot, 3),
                                  gamebuttoncontainer(snapshot, 4),
                                  gamebuttoncontainer(snapshot, 5),
                                  gamebuttoncontainer(snapshot, 6),
                                  gamebuttoncontainer(snapshot, 7),
                                  gamebuttoncontainer(snapshot, 8),
                                ],
                              ),
                            ),
                            Flexible(child: Container(
                              alignment: Alignment.center,
                              child: AdWidget(ad: myBanner,),
                              width: 300,
                              height: 50,
                            ),)
                          ],
                        );
                      }
                    }),
              ),
            ])));
  }

  changeboardIndex(int index, move) async {
    if (mounted) {
      //this provider is used to understand that the game is over
      Provider.of<Repo>(context, listen: false).changeText(index, move);
      print("clicked button");
      await Firestore.collection("games")
          .doc(gameCode)
          .update({index.toString(): move});
    }
  }

  loadsecondPlayer(snapshot) {
    if (mounted) {
      return Text("Player2: " + snapshot.data!["secondPlayer"].toString());
    }
  }

  winner(snapshot) {
    if (mounted) {
      if (snapshot.data!["winner"].toString() == null) {}
    }
  }

  gamebuttoncontainer(snapshot, var index) {
    return GestureDetector(
      onTap: () async => {
        print("clicked"),
        controlofGameFinished(index, snapshot),
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(15)),
        child: Text(snapshot.data![index.toString()].toString(),
            style: TextStyle(fontSize: constOsize.toDouble())),
      ),
    );
  }

  controlofGameFinished(index, snapshot) async {
    if (mounted) {
      if (await snapshot.data!["gameFinish"] == "true") {
        return Alert(context: context, title: "Game", desc: "Game Finished.")
            .show();
      }
      if (await snapshot.data!["gamestarted"] == false) {
        return Alert(
                context: context,
                title: "Game did not start",
                desc: "waiting opponent")
            .show();
      }
      if (mounted &&
          await snapshot.data!["order"] == "firstplayer" &&
          username == await snapshot.data!["firstPlayer"] &&
          snapshot.data![index.toString()] == "") {
        var move = "X";
        await boardcontrol(index, move);
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"order": "secondplayer"});
      } else if (mounted &&
          await snapshot.data!["order"] == "secondplayer" &&
          username == await snapshot.data!["secondPlayer"] &&
          snapshot.data![index.toString()] == "") {
        var move = "O";
        await boardcontrol(index, move);
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"order": "firstplayer"});
      }
    }
  }

  providerLoad() {
    if (mounted) {
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
  }

  boardcontrol(int index, var move) async {
    if (mounted) {
      await changeboardIndex(index, move);
      if (board[0] == "X" && board[1] == "X" && board[2] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      }
      if (board[0] == "O" && board[1] == "O" && board[2] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      }

      if (board[3] == "X" && board[4] == "X" && board[5] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      }
      if (board[3] == "O" && board[4] == "O" && board[5] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      }
      if (board[6] == "X" && board[7] == "X" && board[8] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      }
      if (board[6] == "O" && board[7] == "O" && board[8] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      } else if (board[0] == "X" && board[3] == "X" && board[6] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      } else if (board[0] == "O" && board[3] == "O" && board[6] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      } else if (board[1] == "X" && board[4] == "X" && board[7] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      } else if (board[1] == "O" && board[4] == "O" && board[7] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      } else if (board[2] == "X" && board[5] == "X" && board[8] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      } else if (board[2] == "O" && board[5] == "O" && board[8] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      } else if (board[0] == "X" && board[4] == "X" && board[8] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      } else if (board[0] == "O" && board[4] == "O" && board[8] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      } else if (board[2] == "X" && board[4] == "X" && board[6] == "X") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player1"});
      } else if (board[2] == "O" && board[4] == "O" && board[6] == "O") {
        print("game finished");
        await Firestore.collection("games")
            .doc(gameCode)
            .update({"gameFinish": "true", "winner": "Player2"});
      }
    }
  }
}
