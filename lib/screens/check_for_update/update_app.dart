import 'package:flutter/material.dart';
import 'package:readlex/screens/check_for_update/functions/check_for_update.dart';

class ShowNewUpdateAlert extends StatefulWidget {
  const ShowNewUpdateAlert({Key? key}) : super(key: key);

  @override
  State<ShowNewUpdateAlert> createState() => _ShowNewUpdateAlertState();
}

class _ShowNewUpdateAlertState extends State<ShowNewUpdateAlert> {
  Future<String> updateVersion = newUpdateName();
  String updateVersionString = "";

  Future updateFeatures = newUpdateFeaturs();
  List updateFeaturesList = [];
  void convertToString(data) async {
    String newData = await data;
    setState(() {
      updateVersionString = newData;
    });
  }

  void convertToList(data) async {
    List newData = await data;
    // print(newData);
    setState(() {
      updateFeaturesList.addAll(newData);
    });
  }

  @override
  void initState() {
    convertToString(updateVersion);
    convertToList(updateFeatures);
    // print(updateFeatures);
    // _features(updateFeaturesList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        builder: (context, scrollController) {
          return SingleChildScrollView(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: Image.asset("assets/app_logo.png").image,
                    radius: 30.0,
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    "New Update $updateVersionString",
                    style: TextStyle(
                      fontFamily: "VareLaRound",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  // _features(updateFeaturesList)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _features(List ListOfFeatures) {
    print(ListOfFeatures);
  }
}
