import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[900],
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.orangeAccent,
          size: 50.0,
        ),
      ),
    );
  }
}
