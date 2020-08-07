import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Loading', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
