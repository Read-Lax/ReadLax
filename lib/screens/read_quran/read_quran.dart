import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiver/iterables.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:readlex/screens/read_quran/functions/download_hizb_data.dart';
import 'package:readlex/screens/read_quran/widgets/alert_user_of_a_download_procces.dart';
import 'package:readlex/screens/read_quran/widgets/delete_installed_hizb.dart';
import 'package:readlex/shared/global.dart';
import 'package:readlex/shared/hizb_background_config.dart';

class ReadQuranPage extends StatefulWidget {
  const ReadQuranPage({Key? key}) : super(key: key);

  @override
  State<ReadQuranPage> createState() => _ReadQuranPageState();
}

class _ReadQuranPageState extends State<ReadQuranPage> {
  int numberOfCards = 60;
  bool isPlayingQuran = false;
  final _hizbDataRef = Hive.box("hizbData");
  final _backgroundProcess = Hive.box("backgroundProcess");

  writeData(hizbIndex, data) async {
    await _hizbDataRef.put(hizbIndex, data);
  }

  readData(hizbIndex) {
    return _hizbDataRef.get(hizbIndex);
  }

  deleteData(hizbIndex) {
    _hizbDataRef.delete(hizbIndex);
  }

  isHizbInstalled(hizbIndex) {
    if (_hizbDataRef.containsKey(hizbIndex) == false) {
      return false;
    } else {
      Map hizbData = _hizbDataRef.get(hizbIndex);
      for (var imagePath in hizbData["images"]) {
        if (File(imagePath).existsSync()) {
          return true;
        } else {
          deleteData(hizbIndex);
          return false;
        }
      }
    }
  }

  late bool isItDownloading =
      false; // check if user pressed download icon to install Quran
  String hizbIndexThatIsGettingInstalling = "";
  @override
  void initState() {
    super.initState();
    try {
      hizbIndexThatIsGettingInstalling =
          _backgroundProcess.get("hizbIndexThatIsGettingInstalling");
      isItDownloading = _backgroundProcess.get("isItDownloading");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            bool isTheHizbInstalled = isHizbInstalled(index);
            var hizbAudioUrl =
                "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/audioQuran%2F${index + 1}.mp3?alt=media";
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  // color: ,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadQuran(
                                ahzabData[index],
                                index + 1,
                                isTheHizbInstalled,
                                _hizbDataRef,
                                // readData(index)
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          index.isOdd
                              ? Icons.chrome_reader_mode_outlined
                              : Icons.chrome_reader_mode_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 35,
                        ),
                        title: Text(
                          hizbTitle(index),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          ahzabInfos[index],
                          style: TextStyle(
                            color: Colors.green[300],
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        trailing: hizbIndexThatIsGettingInstalling ==
                                index.toString()
                            ? const CircularProgressIndicator(
                                color: Colors.greenAccent,
                                strokeWidth: 2.0,
                              )
                            : IconButton(
                                onPressed: () async {
                                  if (isItDownloading) {
                                    showDialog(
                                        context: context,
                                        builder: ((context) =>
                                            const AlertOfAnOtherDownloadProccess()));
                                  } else {
                                    if (isTheHizbInstalled == false) {
                                      List ahzabToUse = [];
                                      List imageUrls = [];
                                      FlutterBackgroundAndroidConfig
                                          backgroundDownloadConfig =
                                          backgroundConfig(index + 1);
                                      await FlutterBackground.initialize(
                                          androidConfig: backgroundDownloadConfig);
                                      _backgroundProcess.put(
                                          "hizbIndexThatIsGettingInstalling",
                                          index.toString());
                                      _backgroundProcess.put(
                                          "isItDownloading", true);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => setState(() {
                                                    isItDownloading =
                                                        _backgroundProcess.get(
                                                            "isItDownloading");
                                                    hizbIndexThatIsGettingInstalling =
                                                        _backgroundProcess.get(
                                                            "hizbIndexThatIsGettingInstalling");
                                                  }));
                                      FlutterBackground
                                          .enableBackgroundExecution();
                                      var downloadedImagesData = {
                                        "images": [],
                                        "audio": ""
                                      };
                                      for (var i in range(ahzabData[index][0],
                                          ahzabData[index][1])) {
                                        ahzabToUse.add(i);
                                      }
                                      for (int imageName in ahzabToUse) {
                                        imageUrls.add(
                                            "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/quran%2F$imageName.png?alt=media");
                                      }
                                      List installedImagesPaths = [];
                                      for (var url in imageUrls) {
                                        var imagePath =
                                            await download_image(url);
                                        installedImagesPaths.add(imagePath);
                                      }
                                      final currentInstalledHizbAudioPath =
                                          await download_audio(
                                              hizbAudioUrl,
                                              index.toString(),
                                              _backgroundProcess); // hizb audio's path
                                      downloadedImagesData["images"] =
                                          installedImagesPaths;
                                      downloadedImagesData["audio"] =
                                          currentInstalledHizbAudioPath;
                                      writeData(index,
                                          downloadedImagesData); // writing data into the database

                                      _backgroundProcess.put(
                                          "hizbIndexThatIsGettingInstalling",
                                          "");
                                      _backgroundProcess.put(
                                          "isItDownloading", false);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => setState(() {
                                                    isItDownloading =
                                                        _backgroundProcess.get(
                                                            "isItDownloading");
                                                    hizbIndexThatIsGettingInstalling =
                                                        _backgroundProcess.get(
                                                            "hizbIndexThatIsGettingInstalling");
                                                  }));
                                      FlutterBackground
                                          .disableBackgroundExecution();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: ((context) =>
                                              UninsallingHizbAlert(
                                                hizbIndex: index,
                                                hizbDataRef: _hizbDataRef,
                                              )));
                                    }
                                  }
                                },
                                // check for the hizb if it installed if yes display the download done icon
                                icon: isTheHizbInstalled == true
                                    ? const Icon(
                                        Icons.download_done_rounded,
                                        size: 30,
                                        color: Colors.greenAccent,
                                      )
                                    : const Icon(
                                        Icons.download_outlined,
                                        color: Colors.greenAccent,
                                        size: 30,
                                      )),
                      )
                    ],
                  )),
            );
          },
          physics: const ScrollPhysics(parent: null),
          shrinkWrap: true,
          itemCount: numberOfCards,
        ),
      ),
    );
  }
}

class ReadQuran extends StatefulWidget {
  ReadQuran(
      this.ahzabData, this.hizbIndex, this.isHizbInstalled, this.hizbDataRef,
      {super.key});
  List ahzabData;
  int hizbIndex;
  bool isHizbInstalled;
  var hizbDataRef;
  // List dbHizbData;

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  List imagesToDesplayUrls = [];
  late List ahzabToUse = [];
  bool isPlayingQuran = false;
  String appBarTitle = "";
  AudioPlayer audioPlayer = AudioPlayer();
  int index = 0;
  void getImagesUrlData() {
    for (var i in range(widget.ahzabData[0], widget.ahzabData[1])) {
      ahzabToUse.add(i);
    }
    for (int imageName in ahzabToUse) {
      imagesToDesplayUrls.add(
          "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/quran%2F$imageName.png?alt=media");
    }
    appBarTitle = "حزب / Hizb${widget.hizbIndex}";
    index = widget.hizbIndex;
  }

  @override
  void initState() {
    super.initState();
    getImagesUrlData();
  }

  @override
  Widget build(BuildContext context) {
    // loading current hizb data from database (if it exists)
    Map currentHizbData = widget.isHizbInstalled
        ? widget.hizbDataRef.get(widget.hizbIndex - 1)
        : {};

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (isPlayingQuran) {
                  await pausePlayingQuran();
                } else {
                  await playQuran(index);
                }
              },
              icon: isPlayingQuran
                  ? const Icon(
                      Icons.stop_rounded,
                      size: 27,
                      // color: Colors.black54,
                    )
                  : const Icon(
                      Icons.play_arrow_rounded,
                      size: 27,
                      // color: Colors.black54,
                    ))
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: Colors.green[200],
            fontFamily: "VareLaRound",
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: widget.isHizbInstalled
                ? Image.file(File(currentHizbData["images"][index]))
                : CachedNetworkImage(
                    imageUrl: imagesToDesplayUrls[index],
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: Colors.greenAccent,
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: imagesToDesplayUrls.length,
      ),
    );
  }

  playQuran(index) async {
    final currentHizbData = widget.hizbDataRef.get(index - 1);
    var url =
        "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/audioQuran%2F$index.mp3?alt=media";
    // Source u = Source(url);
    await audioPlayer.play(
        UrlSource(widget.isHizbInstalled ? currentHizbData["audio"] : url));
    setState(() {
      isPlayingQuran = true;
    });
  }

  pausePlayingQuran() async {
    await audioPlayer.pause();
    setState(() {
      isPlayingQuran = false;
    });
  }
}
