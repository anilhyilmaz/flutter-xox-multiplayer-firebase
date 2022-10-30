import 'package:flutter/material.dart';
import 'package:flutterdeneme/Screens/GridviewBuilder.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text("username"),
        ),
        TextButton(
            onPressed: () => print("joined game"), child: Text("Join Game")),
        Divider(color: Colors.black,),
        TextButton(
            onPressed: () => Navigator
                .of(context)
                .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => GridviewBuilder())), child: Text("Create Game"))
      ],
    );
  }
}
