import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoadingCircule extends StatelessWidget {
  const LoadingCircule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: SpinKitCircle(
            color: Colors.greenAccent,
          ),
        ),
      ],
    ));
  }
}

// simple loading with no background
Widget simpleLoading() {
  return const SpinKitCircle(
    color: Colors.greenAccent,
    size: 10.0,
  );
}
