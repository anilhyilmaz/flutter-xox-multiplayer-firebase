import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GridviewBuilder extends StatelessWidget {
  const GridviewBuilder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var finished = Provider.of<Repo>(context, listen: false).isFinished;
    var gameCode = Provider.of<Repo>(context, listen: false).gameCode;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore Firestore = FirebaseFirestore.instance;
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
                    OutlinedButton(onPressed: deneme, child: Text("deneme")),
                    Text("code: $gameCode"),
                    Text("Username1: ${_auth.currentUser?.email.toString()}"),
                    Text("Username2: ")
                  ],
                ),
              ),
              Flexible(
                  flex: 4,
                  child: StreamBuilder(
                      stream: Firestore.collection("games").doc("R5LOuVA402QpLUCra9QG").snapshots(),
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
                                  onTap: () => {
                                    finished
                                        ? print("game finished")
                                        : Provider.of<Repo>(context,
                                                listen: false)
                                            .changeText(index),
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                        snapshot.data!["board"][index].toString() ??
                                        " ",
                                        style: TextStyle(
                                            fontSize: constOsize.toDouble())),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }))
            ])));
  }

  deneme() async {
    var data;
    FirebaseFirestore Firestore = FirebaseFirestore.instance;
    await Firestore.collection("games")
        .doc("R5LOuVA402QpLUCra9QG")
        .collection("sira")
        .snapshots()
        .first
        .then((value) => print(value.docs));
  }
}
