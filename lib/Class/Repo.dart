
import 'package:flutter/cupertino.dart';

class Repo with ChangeNotifier{
  bool isFinished = true;
  String city = "Hello World";
  //var list = "";
  List mylist = ["","","","","","","","",""];


   void changeValue(String newValue){
    city = newValue;
    notifyListeners();
  }
  changeText(int index){
    mylist[index] = "X";
    notifyListeners();
  }
}