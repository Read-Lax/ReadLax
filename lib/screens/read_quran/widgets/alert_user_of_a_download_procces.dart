import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertOfAnOtherDownloadProccess extends StatefulWidget {
  const AlertOfAnOtherDownloadProccess({super.key});

  @override
  State<AlertOfAnOtherDownloadProccess> createState() =>
      _AlertOfAnOtherDownloadProccessState();
}

class _AlertOfAnOtherDownloadProccessState
    extends State<AlertOfAnOtherDownloadProccess> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: const ListTile(
        leading: Icon(
          Icons.warning_amber_rounded,
          size: 30,
          color: Colors.redAccent,
        ),
        title: Text(
          "Can't start downloading an other hizb, please wait until the other one get installed",
          style: TextStyle(
            fontFamily: "VareLaRound",
          ),
        ),
      ),
      actions: [
        CupertinoButton(
            child:  Text(
              "Ok",
              style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  color: Colors.green[200]),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
