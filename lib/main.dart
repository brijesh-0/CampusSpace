import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: Text(
              "CampusSpace",
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 10,
          shadowColor: Colors.black,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
        ),
        drawer: Drawer(),
        body: Center(
          child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(25),
              child: Icon(
                Icons.favorite,
                size: 64,
              )),
        ),
      ),
    );
  }
}
