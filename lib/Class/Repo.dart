
import 'package:flutter/cupertino.dart';

class Repo with ChangeNotifier{
  bool isFinished = false;
  List? board = ["","","","","","","","",""];
  var gameCode;
  var id;
  var firstPlayer;
  var firstPlayerImage;
  var secondPlayerImage;
  var secondPlayer;
  bool gamestarted = false;
  var move;

  changeText(int index,move){
    board![index] = move;
    notifyListeners();
  }
  updateboard(int index){
  }
}