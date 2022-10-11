import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Class/Repo.dart';
import '../Utils/ConstantStyles.dart';

class RightContainer extends StatelessWidget {
  const RightContainer({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => (){
        //Provider.of<Repo>(context, listen: false).changeText();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black))),
        child: Center(
            child: Text(
                style: TextStyle(fontSize: double.parse(constOsize.toString())),
                //Provider.of<Repo>(context).list ?? ""
              "ggg"
            )),
      ),
    );
  }
}
