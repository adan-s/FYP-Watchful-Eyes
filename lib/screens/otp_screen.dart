

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPSCREEN extends StatelessWidget{
  const OTPSCREEN({Key? key}):super(key:key);
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("CO\nDE", style: TextStyle(
                fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              fontSize: 70.0
            ),),
            Text("Verification",style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40.0),
            Text("Enter the verification code at" )
          ],
        ),
      ),
    );
  }
}