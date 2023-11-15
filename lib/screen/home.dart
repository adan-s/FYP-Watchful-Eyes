

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext){
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.asset("assets/images.png",
                fit: BoxFit.contain),

              ),
              Text("Name",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),),
              SizedBox(
                height: 20,
              ),
              Text("Email",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),)
            ],
          ),
        ),
      ),
    );
  }
}