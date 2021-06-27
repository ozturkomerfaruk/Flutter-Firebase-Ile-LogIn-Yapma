import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyButtons extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  const MyButtons({
    Key key,
    @required this.color,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            primary: color,
          ),
        ),
      ),
    );
  }
}
