import 'package:cached_network_image/cached_network_image.dart';
import 'package:quiver/iterables.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:readlex/shared/global.dart';

class ReadQuranPage extends StatefulWidget {
  const ReadQuranPage({Key? key}) : super(key: key);

  @override
  State<ReadQuranPage> createState() => _ReadQuranPageState();
}

class _ReadQuranPageState extends State<ReadQuranPage> {
  int numberOfCards = 60;
  bool isPlayingQuran = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
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
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          index.isOdd
                              ? Icons.chrome_reader_mode_outlined
                              : Icons.chrome_reader_mode_rounded,
                          color: Colors.brown[200],
                          size: 35,
                        ),
                        title: Text(
                          "حزب / Hizb" + " ${index + 1}",
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
  ReadQuran(this.ahzabData, this.hizbIndex);
  List ahzabData;
  int hizbIndex;

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
            child: CachedNetworkImage(
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
          // return Image.network(
          //   imagesToDesplayUrls[index],
          //   fit: BoxFit.cover,
          // );
        },
        scrollDirection: Axis.vertical,
        itemCount: imagesToDesplayUrls.length,
      ),
    );
  }

  playQuran(index) async {
    // UrlSource source = audioPlayer.setSourceUrl(url) as UrlSource;
    var url =
        "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/audioQuran%2F$index.mp3?alt=media";
    // Source u = Source(url);
    await audioPlayer.play(UrlSource(url));
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
