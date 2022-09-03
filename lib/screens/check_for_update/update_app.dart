import 'package:flutter/material.dart';

showNewUpdateDialoge() {
  return SizedBox.expand(
    child: DraggableScrollableSheet(
      builder: (context, scrollController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("app_logo.png"),
              const Text("New update", style: TextStyle(
                fontFamily: "VareLaRound",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
        );
      },
    ),
  );
}
