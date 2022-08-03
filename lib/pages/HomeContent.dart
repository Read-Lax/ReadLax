import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readlex/pages/UserProfilePage.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  double laltitude = 0.0;
  double longtitude = 0.0;
  // get the user location to use it to get the adhan information
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled ');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      laltitude = position.latitude;
      longtitude = position.longitude;
    });
    return await Geolocator.getCurrentPosition();
  }

  Color digitalClockColor = Get.isDarkMode ? Colors.white : Colors.black;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 5,
              ),
              const Center(
                child: Text(
                  "Time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "VareLaRound",
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DigitalClock(
                digitAnimationStyle: Curves.easeInToLinear,
                is24HourTimeFormat: false,
                areaDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                hourMinuteDigitTextStyle: TextStyle(
                  fontFamily: "VareLaRound",
                  fontSize: 50,
                  color: digitalClockColor,
                ),
                amPmDigitTextStyle: TextStyle(
                  color: digitalClockColor,
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 10,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Prayer Time",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              getAdhanTime(laltitude, longtitude),
            ],
          ),
        ),
      ],
    ));
  }

  getAdhanTime(lat, long) {
    final coordinates = Coordinates(lat, long);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTime = PrayerTimes.today(coordinates, params);
    String currentPrayerName = "";
    String upComingPrayer = "";
    List prayersNamesInArabic = [
      "الفجر",
      "شروق الشمس",
      "الظهر",
      "العصر",
      "المغرب",
      "العشاء"
    ];
    // upcomming prayer time
    if (prayerTime.currentPrayer().name == "fajr") {
      currentPrayerName =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.currentPrayer().name}/" + prayersNamesInArabic[0];
    }
    if (prayerTime.currentPrayer().name == "sunrise") {
      currentPrayerName =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.currentPrayer().name}/" + prayersNamesInArabic[1];
    }
    if (prayerTime.currentPrayer().name == "dhuhr") {
      currentPrayerName =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.currentPrayer().name}/" + prayersNamesInArabic[2];
    }
    if (prayerTime.currentPrayer().name == "asr") {
      currentPrayerName =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.currentPrayer().name}/" + prayersNamesInArabic[3];
    }
    if (prayerTime.currentPrayer().name == "maghrib") {
      currentPrayerName =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.currentPrayer().name}/" + prayersNamesInArabic[4];
    }
    if (prayerTime.currentPrayer().name == "isha") {
      currentPrayerName = "isha/" + prayersNamesInArabic[5];
    }
    if (prayerTime.nextPrayer().name == "fajr") {
      currentPrayerName = "isha/" + prayersNamesInArabic[5];
    }
    // current prayer time
    if (prayerTime.nextPrayer().name == "fajr") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[0];
    }
    if (prayerTime.nextPrayer().name == "sunrise") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[1];
    }
    if (prayerTime.nextPrayer().name == "dhuhr") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[2];
    }
    if (prayerTime.nextPrayer().name == "asr") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[3];
    }
    if (prayerTime.nextPrayer().name == "maghrib") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[4];
    }
    if (prayerTime.nextPrayer().name == "isha") {
      upComingPrayer =
          // ignore: prefer_interpolation_to_compose_strings
          "${prayerTime.nextPrayer().name}/" + prayersNamesInArabic[5];
    }
    if (prayerTime.currentPrayer().name == "isha") {
      upComingPrayer = "fajr/ " + prayersNamesInArabic[0];
    }
    return Column(
      children: [
        const Divider(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Text(
                "Fajr\nالفجر",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "Sunrise\nشروق الشمس",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "Dhuhr\nالظهر",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "Asr\nالعصر",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "Maghrib\nالمغرب",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                "isha\nالعشاء",
                style: TextStyle(
                    // color: Colors.black,
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold),
              )),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.fajr),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.sunrise),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.dhuhr),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.asr),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.maghrib),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
                DataCell(Text(
                  DateFormat.jm().format(prayerTime.isha),
                  style: const TextStyle(fontFamily: "VareLaRound"),
                )),
              ]),
            ],
          ),
        ),
        const Divider(),
        Row(
          children: [
            const Text(
              " • Current Prayer: ",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: "VareLaRound",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            Expanded(
                child: Text(
              currentPrayerName,
              style: const TextStyle(
                  fontFamily: "VareLaRound",
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Text(
              " • Up Coming Prayer: ",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: "VareLaRound",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            Expanded(
                child: Text(
              upComingPrayer,
              style: const TextStyle(
                  fontFamily: "VareLaRound",
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
