import 'package:demo_firebase/services/auth.dart';
import 'package:demo_firebase/views/email_sign_in.dart';
import 'package:demo_firebase/widgets/myButtons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    final user =
        await Provider.of<Auth>(context, listen: false).signInAnonymously();
    setState(() {
      _isLoading = false;
    });
    print(user.uid);
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    final user =
        await Provider.of<Auth>(context, listen: false).signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    print(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: 24),
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).signOut();
              print("FirebaseAuth tıklandı");
            },
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign IN Page",
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 20),
          MyButtons(
            color: Colors.red,
            child: Text("Sign In Anonmously", style: TextStyle(fontSize: 24)),
            onPressed: _isLoading ? null : _signInAnonymously,
          ),
          SizedBox(height: 20),
          MyButtons(
              color: Colors.yellow,
              child: Text("Sign In Email/Password",
                  style: TextStyle(fontSize: 24)),
              onPressed: _isLoading ? null : () {
                print("asd");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmailSignInPage()));
              }),
          SizedBox(height: 20),
          MyButtons(
            color: Colors.blue,
            child: Text("Sign In with Google", style: TextStyle(fontSize: 24)),
            onPressed: _isLoading ? null : _signInWithGoogle,
          ),
        ],
      )),
    );
  }
}
