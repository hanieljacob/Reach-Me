import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Loading',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 18),
          )
        ],
      ),
    );
  }
}
