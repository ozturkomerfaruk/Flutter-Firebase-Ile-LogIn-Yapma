import 'package:demo_firebase/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: 24),
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text("Home Page"),
        ),
      ),
    );
  }
}
