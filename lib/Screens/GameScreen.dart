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
      secondPlayerImage;

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
                  flex: 1,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
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
                  flex: 6,
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
                          return Container(
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
                                    controlofGameFinished(index, snapshot)
                                    //update board at index doesnt work atm.
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
                                            fontSize: constOsize.toDouble())),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      })),
              //second player information widget
              Flexible(
                  flex: 1,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.end,children: [
                    secondPlayer != null
                        ? Row(children: [Image.network(
                      "$secondPlayerImage",
                      height: 50,
                      width: 50,
                    ),Text("${secondPlayer}")],) : Text("Second player is  waiting")
        ])),
            ])));
  }




  changeboardIndex(int index) async {
    if (mounted) {
      Provider.of<Repo>(context, listen: false).changeText(index);
      return await Firestore.collection("games")
          .doc(gameCode)
          .update({"board": board});
    }
  }
  controlofGameFinished(index,snapshot) async{
   if(mounted){
     await snapshot.data!["gameFinish"] == "true"
         ? await Alert(context: context, title: "Game Finished", desc: "Game Finished.").show()
         : changeboardIndex(index);
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
  }
}
