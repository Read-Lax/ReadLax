import 'dart:io';
import "package:flutter/material.dart";
import "package:readlex/shared/global.dart";
import "package:flutter/cupertino.dart";

// ignore: must_be_immutable
class UninsallingHizbAlert extends StatefulWidget {
  int hizbIndex;
  // ignore: prefer_typing_uninitialized_variables
  var hizbDataRef;
  UninsallingHizbAlert(
      {super.key, required this.hizbIndex, required this.hizbDataRef});

  @override
  State<UninsallingHizbAlert> createState() => _UninsallingHizbAlertState();
}

class _UninsallingHizbAlertState extends State<UninsallingHizbAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: SizedBox(
          height: 60,
          child: ListTile(
            leading: const Icon(
              Icons.warning_amber_rounded,
              size: 30,
            ),
            title: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: "Are you sure you want to uninstall ",
                  style: TextStyle(
                    fontFamily: "VareLaRound",
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextSpan(
                  text: "\n${hizbTitle(widget.hizbIndex)}",
                  style: TextStyle(
                    fontFamily: "VareLaRound",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " ?",
                  style: TextStyle(
                    fontFamily: "VareLaRound",
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ]),
            ),
          )),
      actions: [
        CupertinoButton(
          child: const Text(
            "No",
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: "VareLaRound",
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoButton(
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.redAccent,
              fontFamily: "VareLaRound",
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Map data = widget.hizbDataRef.get(widget.hizbIndex);
            widget.hizbDataRef.delete(widget
                .hizbIndex); // deleting the data from database before the images
            for (var path in data["images"]) {
              try {
                File(path).delete(); // deleting the images
                // ignore: empty_catches
              } catch (e) {}
            }
            File(data["audio"]).deleteSync(); // deleting the hizb audio
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
