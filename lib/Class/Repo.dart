
import 'package:flutter/cupertino.dart';

class Repo with ChangeNotifier{
  bool isFinished = false;
  //var list = "";
  List board = ["","","","","","","","",""];
  var gameCode;
  var id;
  var firstPlayer;
  var secondPlayer;

  changeText(int index){
    board[index] = "X";
    notifyListeners();
  }
}