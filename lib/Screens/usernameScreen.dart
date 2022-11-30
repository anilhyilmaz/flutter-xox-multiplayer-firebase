import "package:flutter/material.dart";
import 'package:flutterdeneme/Screens/createJoinGameScreen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Class/Repo.dart';


class usernameScreen extends StatefulWidget {
  const usernameScreen({Key? key}) : super(key: key);

  @override
  State<usernameScreen> createState() => _usernameScreenState();
}

class _usernameScreenState extends State<usernameScreen> {

  var usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Column(children: [Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
      controller: usernamecontroller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type your nickname',
      ),
    ),
        ),ElevatedButton(onPressed: () { signin(); },
          child: Text("Sign in"),)],)),
      ],
    );
  }

  signin() async {
    var username = usernamecontroller.text.replaceAll(" ", "");
    if(username.length > 0){
      print("nickname ${usernamecontroller.text} signed in");
      Provider
          .of<Repo>(context, listen: false)
          .username = username;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CreateJoinGameScreen()));
    }
    else{
      print("boş olamaz");
      return Alert(
          context: context,
          title: "Game",
          desc: "username can not be null").show();
    }
  }
}
