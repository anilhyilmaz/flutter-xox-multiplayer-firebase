import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';

class GridviewBuilder extends StatelessWidget {
  const GridviewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var finished = Provider.of<Repo>(context, listen: false).isFinished;

    return Scaffold(
        appBar: AppBar(title: Text("Game Screen")),
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Column(children: [Text("Username1: ggg"),Text("Username2: fff")],),
            ),
            Flexible(
              flex: 4,
              child: Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 20),
                  itemCount: Provider.of<Repo>(context).mylist.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {
                        finished
                            ? print("game finished")
                            : Provider.of<Repo>(context, listen: false)
                                .changeText(index),
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                            Provider.of<Repo>(context).mylist[index] ?? " ",
                            style: TextStyle(fontSize: constOsize.toDouble())),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        )));
  }
}
