import 'package:flutter/material.dart';
import 'package:reach_me/firebase_auth.dart';
import 'package:reach_me/screens/splash.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool loading = false;

  @override
  void initState()
  {
    super.initState();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }
  @override
  Widget build(BuildContext context) {
    return loading==true?SplashPage():Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email"
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter your password"
                ),
              ),
              RaisedButton(
                child: Text('Login'),
                  onPressed: () async{
                    if(_emailController.text.isEmpty || _passwordController.text.isEmpty)
                      print("Please enter your email and password");
                    bool res = await AuthProvider().signInWithEmail(_emailController.text, _passwordController.text);
                    if(!res)
                      print('Login Failed');
                  },
              ),
              RaisedButton(
                color: Color(0xFFdd4b39),
                child: Text('Login with Google'),
                onPressed: () async{
                  setState(() {
                    loading = true;
                  });
                  await AuthProvider().loginWithGoogle();
                  setState(() {
                    loading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
