import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GridviewBuilder extends StatefulWidget {



  const GridviewBuilder({Key? key}) : super(key: key);

  @override
  State<GridviewBuilder> createState() => _GridviewBuilderState();
}

class _GridviewBuilderState extends State<GridviewBuilder> {

  FirebaseFirestore Firestore = FirebaseFirestore.instance;
  var finished,gameCode,id,firstPlayer,secondPlayer;


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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        OutlinedButton(onPressed: getdatafromfirebase,
                            child: Text("get data")),
                        Text("code: $id"),
                        Text("Username1: $firstPlayer"),
                        Text("Username2: $secondPlayer")
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 4,
                      child: StreamBuilder(
                          stream: Firestore.collection("games").doc(
                              gameCode).snapshots(),
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
                                      onTap: () =>
                                      {
                                        finished
                                            ? print("game finished")
                                            // : Firestore.collection("games").doc(gameCode).update({"board[$index]":"X"}),
                                            : print(index),
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
                                                fontSize: constOsize
                                                    .toDouble())),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }))
                ])));
  }

  getdatafromfirebase() async {
    FirebaseFirestore Firestore = FirebaseFirestore.instance;
    var ggg = Firestore.collection("games").snapshots();
    ggg.forEach((element) {
      print(element.docs[1].data()["XorO"]);
      print(element.docs[1].data()["XorO"]);
    });
    ggg.forEach((element) {
      print(element.docs.length);
    });
  }
  providerLoad(){
    finished = Provider
        .of<Repo>(context, listen: false)
        .isFinished;
    gameCode = Provider
        .of<Repo>(context, listen: false)
        .gameCode;
    id = Provider
        .of<Repo>(context, listen: false)
        .id;
    firstPlayer = Provider
        .of<Repo>(context, listen: false)
        .firstPlayer;
    secondPlayer = Provider
        .of<Repo>(context, listen: false)
        .secondPlayer;
  }
}
