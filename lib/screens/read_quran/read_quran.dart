import 'package:quiver/iterables.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReadQuranPage extends StatefulWidget {
  const ReadQuranPage({Key? key}) : super(key: key);

  @override
  State<ReadQuranPage> createState() => _ReadQuranPageState();
}

class _ReadQuranPageState extends State<ReadQuranPage> {
  int numberOfCards = 60;
  List ahzabInfos = [
    "الحزب 1  : من الآية 1 من سورة الفاتحة إلى الآية 74 من سورة البقرة",
    "الحزب 2  : من الآية 75  من سورة البقرة إلى الآية 140 من سورة البقرة",
    "الحزب 3  : من الآية 141  من سورة البقرة إلى الآية 200 من سورة البقرة",
    "الحزب 4  : من الآية 201  من سورة البقرة إلى الآية 250 من سورة البقرة",
    "الحزب 5  : من الآية 251  من سورة البقرة إلى الآية 14 من سورة آل عمران",
    "الحزب 6  : من الآية 15 من سورة آل عمران إلى الآية 90 من سورة آل عمران",
    "الحزب 7  : من الآية 91 من سورة آل عمران إلى الآية 170 من سورة آل عمران",
    "الحزب 8  : من الآية 171 من سورة آل عمران إلى الآية 23 من سورة النساء",
    "الحزب 9  : من الآية 24 من سورة النساء إلى الآية 85 من سورة النساء",
    "الحزب 10 : من الآية 86 من سورة النساء إلى الآية 146 من سورة النساء",
    "الحزب 11 : من الآية 147 من سورة النساء إلى الآية 24 من سورة المائدة",
    "الحزب 12 : من الآية 25 من سورة المائدة إلى الآية 83 من سورة المائدة",
    "الحزب 13 : من الآية 84 من سورة المائدة إلى الآية 36 من سورة الأنعام",
    "الحزب 14 : من الآية 37 من سورة الأنعام إلى الآية 111 من سورة الأنعام",
    "الحزب 15 : من الآية 112 من سورة الأنعام إلى الآية 3 من سورة الأعراف",
    "الحزب 16 : من  الآية 4 من سورة الأعراف إلى الآية 86 من سورة الأعراف",
    "الحزب 17 : من  الآية 87 من سورة الأعراف إلى الآية 170 من سورة الأعراف",
    "الحزب 18 : من  الآية 171 من سورة الأعراف إلى الآية 40 من سورة الأنفال",
    "الحزب 19 : من  الآية 41 من سورة الأنفال إلى الآية 33 من سورة التوبة",
    "الحزب 20 : من  الآية 34 من سورة التوبة إلى الآية 93 من سورة التوبة",
    "الحزب 21 : من  الآية 94 من سورة التوبة إلى الآية 25 من سورة يونس",
    "الحزب 22 : من  الآية 26 من سورة يونس إلى الآية 5 من سورة هود",
    "الحزب 23 : من  الآية 6 من سورة هود إلى الآية 82 من سورة هود",
    "الحزب 24 : من  الآية 83 من سورة هود إلى الآية 52 من سورة يوسف",
    "الحزب 25 : من  الآية 53 من سورة يوسف إلى الآية 20 من سورة الرعد",
    "الحزب 26 : من  الآية 21 من سورة الرعد إلى الآية 54 من سورة إبراهيم",
    "الحزب 27 : من  الآية 1 من سورة الحجر إلى الآية 50 من سورة النحل",
    "الحزب 28 : من  الآية 51 من سورة النحل إلى الآية 128 من سورة النحل",
    "الحزب 29 : من  الآية 1 من سورة الإسراء إلى الآية 98 من سورة الإسراء",
    "الحزب 30 : من  الآية 99 من سورة الإسراء إلى الآية 73 من سورة الكهف",
    "الحزب 31 : من  الآية 74 من سورة الكهف إلى الآية 99 من سورة مريم",
    "الحزب 32 : من  الآية 1 من سورة طه إلى الآية 134 من سورة طه",
    "الحزب 33 : من  الآية 1 من سورة الأنبياء إلى الآية 111 من سورة الأنبياء",
    "الحزب 34 : من  الآية 1 من سورة الحج إلى الآية 76 من سورة الحج",
    "الحزب 35 : من  الآية 1 من سورة المؤمنون إلى الآية 20 من سورة النور",
    "الحزب 36 : من  الآية 21 من سورة النور إلى الآية 20 من سورة الفرقان",
    "الحزب 37 : من  الآية 21 من سورة الفرقان إلى الآية 110 من سورة الشعراء",
    "الحزب 38 : من  الآية 111 من سورة الشعراء إلى الآية 57 من سورة النمل",
    "الحزب 39 : من  الآية 58 من سورة النمل إلى الآية 50 من سورة القصص",
    "الحزب 40 : من  الآية 51 من سورة القصص إلى الآية 45 من سورة العنكبوت",
    "الحزب 41 : من  الآية 46 من سورة العنكبوت إلى الآية 20 من سورة لقمان",
    "الحزب 42 : من  الآية 21 من سورة لقمان إلى الآية 30 من سورة الأحزاب",
    "الحزب 43 : من  الآية 31 من سورة الأحزاب إلى الآية 23 من سورة سبأ",
    "الحزب 44 : من  الآية 24 من سورة سبأ إلى الآية 26 من سورة يس",
    "الحزب 45 : من  الآية 27 من سورة يس إلى الآية 144 من سورة الصافات",
    "الحزب 46 : من  الآية 144 من سورة الصافات إلى الآية 30 من سورة الزمر",
    "الحزب 47 : من  الآية 31 من سورة الزمر إلى الآية 40 من سورة غافر",
    "الحزب 48 : من  الآية 41 من سورة غافر إلى الآية 45 من سورة فصلت",
    "الحزب 49 : من  الآية 46 من سورة فصلت إلى الآية 22 من سورة الزخرف",
    "الحزب 50 : من  الآية 23 من سورة الزخرف إلى الآية 36 من سورة الجاثية",
    "الحزب 51 : من  الآية 1 من سورة الأحقاف إلى الآية 17 من سورة الفتح",
    "الحزب 52 : من  الآية 18 من سورة الفتح إلى الآية 30 من سورة الذاريات",
    "الحزب 53 : من  الآية 31 من سورة الذاريات إلى الآية 55 من سورة القمر",
    "الحزب 54 : من  الآية 1 من سورة الرحمن إلى الآية 28 من سورة الحديد",
    "الحزب 55 : من  الآية 1 من سورة المجادلة إلى الآية 14 من سورة الصف",
    "الحزب 56 : من  الآية 1 من سورة الجمعة إلى الآية 12 من سورة التحريم",
    "الحزب 57 : من  الآية 1 من سورة الملك إلى الآية 28 من سورة نوح",
    "الحزب 58 : من  الآية 1 من سورة الجن إلى الآية 40 من سورة النبأ",
    "الحزب 59 : من  الآية 1 من سورة النازعات إلى الآية 17 من سورة الطارق",
    "الحزب 60 : من  الآية 1 من سورة الأعلى إلى الآية 6 من سورة الناس",
  ];
  List ahzabData = [
    [1, 12],
    [11, 23],
    [22, 33],
    [32, 43],
    [42, 52],
    [51, 63],
    [62, 73],
    [72, 83],
    [82, 93],
    [92, 103],
    [102, 113],
    [112, 122],
    [121, 133],
    [132, 143],
    [142, 153],
    [152, 163],
    [162, 173],
    [172, 183],
    [182, 193],
    [192, 203],
    [202, 213],
    [212, 223],
    [222, 233],
    [232, 243],
    [242, 253],
    [252, 263],
    [262, 273],
    [272, 283],
    [282, 293],
    [292, 303],
    [302, 313],
    [312, 323],
    [322, 333],
    [332, 343],
    [342, 353],
    [352, 363],
    [362, 373],
    [372, 383],
    [382, 393],
    [392, 403],
    [402, 413],
    [412, 423],
    [422, 433],
    [432, 443],
    [442, 453],
    [452, 463],
    [462, 473],
    [472, 483],
    [482, 493],
    [492, 503],
    [502, 513],
    [512, 523],
    [522, 533],
    [532, 543],
    [542, 553],
    [552, 563],
    [562, 573],
    [572, 583],
    [582, 592],
    [592, 605],
  ];
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
      // print("quran/$imageName" + ".png");
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
          return Image.network(
            imagesToDesplayUrls[index],
            fit: BoxFit.cover,
          );
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