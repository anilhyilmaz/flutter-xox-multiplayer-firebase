
import 'package:flutter/cupertino.dart';

class Repo with ChangeNotifier{
  bool isFinished = false;
  //var list = "";
  List mylist = ["","","","","","","","",""];
  String? gameCode;

  changeText(int index){
    mylist[index] = "X";
    notifyListeners();
  }
}