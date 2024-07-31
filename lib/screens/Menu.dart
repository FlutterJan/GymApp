import 'package:blur/blur.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ucze_sie_swiry/lists/SuplementsList.dart';
import 'package:ucze_sie_swiry/screens/DynamicPages.dart';
import 'package:ucze_sie_swiry/screens/calendar.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';
import 'package:ucze_sie_swiry/screens/progressPage.dart';
import 'package:ucze_sie_swiry/screens/sampleWorkouts.dart';
import 'package:ucze_sie_swiry/screens/trainingPace.dart';
import 'package:ucze_sie_swiry/screens/waterDemand.dart';
import 'MaxCalculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'creatingSuplementsPage.dart';

class ProfilePage extends StatefulWidget {
  final GlobalKey<_ProfilePageState> profilePageKey = GlobalKey();

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final GlobalKey<_ProfilePageState> profilePageKey = GlobalKey();

class _ProfilePageState extends State<ProfilePage> {
  bool czyPolski = true;
  Future<String> getLanguage() async {
    var language = "";
    CollectionReference collection =
        firestore.collection(user.email.toString());
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      language = (data['language'].toString());
    }

    return language;
  }

  Future<List<String>> Opis() async {
    String language = await getLanguage();
    if (language == "English") {
      czyPolski = false;
      return ["Language: ", "english ", "🇬🇧", "Sign out"];
    } else {
      czyPolski = true;
      return ["Język: ", "polski ", "🇵🇱", "Wyloguj się"];
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> saveUserData(String language) async {
    try {
      await firestore.collection('${user.email}').doc('language').set({
        'language': language,
      });
    } catch (e) {}
    setState(() {});
  }

  Future<Map<String, dynamic>?> getUserCalendar() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Training')
          .doc(user.email)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = {};
        Map<String, dynamic> snapshotData =
            snapshot.data() as Map<String, dynamic>;

        snapshotData.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            String date = value['date'];
            String name = value['name'];
            userData[date] = name;
          }
        });
        return userData;
      } else {
        return null;
      }
    } catch (e) {
     
      return null;
    }
  }

  Future<void> profile(bool czyPolski) {
    return showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          double screenSize = MediaQuery.of(context).size.width;
          return SizedBox(
              width: double.infinity,
              child: AlertDialog(
                backgroundColor: Color.fromARGB(240, 255, 255, 255),
                title: SingleChildScrollView(
                  child: FutureBuilder(
                      future: Opis(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Image.asset(
                                "images/profile.png",
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Text(user.email.toString(),
                                textAlign: TextAlign.center,
                                  style: TextStyle(

                                      fontSize: screenSize * 0.042,
                                      fontFamily: 'Satoshi',
                                      color: Color.fromARGB(200, 30, 30, 30))),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () async {
                                    czyPolski = !czyPolski;

                                    String language =
                                        czyPolski ? "Polish" : "English";

                                    try {
                                      await saveUserData(language);
                                      setState(() {
                                        Opis();
                                      });
                                    } catch (e) {}

                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data?[0] ?? '',
                                          style: TextStyle(
                                              fontSize: screenSize * 0.042,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  200, 30, 30, 30))),
                                      Text(snapshot.data?[1] ?? '',
                                          style: TextStyle(
                                              fontSize: screenSize * 0.04,
                                              fontFamily: 'Satoshi',
                                              color: const Color.fromARGB(
                                                  185, 30, 30, 30))),
                                      Text(snapshot.data?[2] ?? '',
                                          style: TextStyle(
                                              fontSize: screenSize * 0.045,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  185, 30, 30, 30))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data?[3] ?? '',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  198, 202, 14, 14))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: Color.fromARGB(180, 255, 255, 255),
                          );
                        }
                      }),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    void signOut() async {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Future<String> getLanguage() async {
      try {
        var language = "";
        CollectionReference collection = firestore.collection('${user.email}');
        QuerySnapshot querySnapshot = await collection.get();
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          language = (data['language'].toString());
        }
        return language;
      } catch (e) {}
      return "";
    }

    Future<List<String>> ENG1() async {
      String language = await getLanguage();
      if (language == "English") {
        return ["Training: ", "Rest day"];
      } else {
        return ["Trening: ", "Odpoczynek"];
      }
    }

    Future<List<String>> ENG() async {
      String language = await getLanguage();
      if (language == "English") {
        return [
          "Plan training",
          "Basic metabolism\nBMI calculators",
          "Max calculators",
          "Your progress",
          "Suplements",
          "Language",
          "Sign out",
          "Sample workout",
          "Water",
          "Tempo",
          "Calendar"
        ];
      } else {
        return [
          "Zaplanuj trening",
          "PPM i BMI",
          "Kalkulator maksów",
          "Twój progres",
          "Suplementy",
          "Język",
          "Wyloguj się",
          "Przykładowe treningi",
          "Woda",
          "Tempo",
          "Kalendarz"
        ];
      }
    }

    Future<Widget> Day() async {
      DateTime now = DateTime.now();
      String language = await getLanguage();
      String dayOfWeek = DateFormat('EEEE', 'pl_PL').format(now);
      if (language == "English") {
        dayOfWeek = DateFormat('EEEE', 'en_EN').format(now);
      }
      String formattedDayOfWeek =
          dayOfWeek.substring(0, 1).toUpperCase() + dayOfWeek.substring(1);

      return Text(
        formattedDayOfWeek,
        style: TextStyle(
            color: const Color.fromARGB(245, 45, 45, 45),
            fontFamily: "Satoshi",
            fontSize: 24),
      );
    }

    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            image: DecorationImage(
              image: AssetImage("images/tlo9.jpg"),
              opacity: 0.45,
              fit: BoxFit.cover,
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white.withOpacity(0),
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaxGap(35),
                    FutureBuilder(
                      future: Day(),
                      builder: (context, AsyncSnapshot<Widget?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Color.fromARGB(180, 255, 255, 255),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Wystąpił błąd: ${snapshot.error}");
                        } else {
                          return InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            onTap: () => Navigator.push(
                                context, _createRoute(CalendarScreen())),
                            child: snapshot.data ?? Text(""),
                          ); // Jeśli data jest null, zwróć pusty tekst
                        }
                      },
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          onTap: () => Navigator.push(
                              context, _createRoute(CalendarScreen())),
                          child: FutureBuilder(
                            future: getUserCalendar(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.none ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(180, 255, 255, 255),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error fetching data');
                              } else if (snapshot.hasData) {
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now());
                                if (snapshot.data![formattedDate] != null &&
                                    snapshot.data![formattedDate]!.isNotEmpty) {
                                  return FutureBuilder(
                                    future: ENG1(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                              ConnectionState.none ||
                                          snapshot1.connectionState ==
                                              ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                180, 255, 255, 255),
                                          ),
                                        );
                                      } else if (snapshot1.hasError) {
                                        return Text('Error fetching data');
                                      } else if (snapshot1.hasData) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Text(
                                              snapshot1.data![
                                                  0], // Use the title or a default value
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      180, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              snapshot.data![formattedDate],
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      200, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 14),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text('No data available');
                                      }
                                    },
                                  );
                                } else {
                                  return FutureBuilder(
                                    future: ENG1(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                              ConnectionState.none ||
                                          snapshot1.connectionState ==
                                              ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                180, 255, 255, 255),
                                          ),
                                        );
                                      } else if (snapshot1.hasError) {
                                        return Text('Error fetching data');
                                      } else if (snapshot1.hasData) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Text(
                                              snapshot1.data![
                                                  1], // Use the title or a default value
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      180, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data![formattedDate] ??
                                                  '',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      200, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 12),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return FutureBuilder(
                                          future: ENG1(),
                                          builder: (context, snapshot1) {
                                            if (snapshot1.connectionState ==
                                                    ConnectionState.none ||
                                                snapshot1.connectionState ==
                                                    ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                ),
                                              );
                                            } else if (snapshot1.hasError) {
                                              return Text(
                                                  'Error fetching data');
                                            } else if (snapshot1.hasData) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.015,
                                                  ),
                                                  Text(
                                                    snapshot1.data![
                                                        1], // Use the title or a default value
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            180, 45, 45, 45),
                                                        fontFamily: "Satoshi",
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    snapshot.data![
                                                            formattedDate] ??
                                                        '',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            200, 45, 45, 45),
                                                        fontFamily: "Satoshi",
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  );
                                }
                              } else {
                                return FutureBuilder(
                                    future: ENG1(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.connectionState ==
                                              ConnectionState.none ||
                                          snapshot1.connectionState ==
                                              ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                180, 255, 255, 255),
                                          ),
                                        );
                                      } else if (snapshot1.hasError) {
                                        return Text('Error fetching data');
                                      } else if (snapshot1.hasData) {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now());
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Text(
                                              snapshot1.data![
                                                  1], // Use the title or a default value
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      180, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 12),
                                            ),
                                           Text(snapshot.data?[formattedDate] ?? '',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      200, 45, 45, 45),
                                                  fontFamily: "Satoshi",
                                                  fontSize: 12),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                        );
                                      }
                                    });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(width:80,),

                    MaxGap(9999999999),
                    MaxGap(9999999999),
                    MaxGap(9999999999),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.person,
                          size: 44,
                          color: const Color.fromARGB(170, 0, 0, 0),
                        ),
                        onPressed: () {
                          profile(czyPolski);
                        },
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03)
                  ],
                ),
                FutureBuilder(
                    future: ENG(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.86 - 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(context,
                                          _createRoute(TrainingPage())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/plan12.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Text(
                                                  snapshot.data?[0] ??
                                                      '', // Use the title or a default value
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          180, 20, 20, 20)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(
                                          context, _createRoute(PPMiBMI())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/calculator.png',
                                                  //fit:BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0001,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    snapshot.data?[1] ??
                                                        '', // Use the title or a default value
                                                    textAlign: TextAlign.center,

                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        fontFamily: 'Satoshi',
                                                        color: Color.fromARGB(
                                                            180, 20, 20, 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(context,
                                          _createRoute(MaxCaluclator())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/MaxIcon.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Text(
                                                  snapshot.data?[2] ??
                                                      '', // Use the title or a default value
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          180, 20, 20, 20)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(context,
                                          _createRoute(ProgressPage(0))),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/chart.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    snapshot.data?[3] ??
                                                        '', // Use the title or a default value
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        fontFamily: 'Satoshi',
                                                        color: Color.fromARGB(
                                                            180, 20, 20, 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(context,
                                          _createRoute(sampleWorkouts())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/workout.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                ),
                                                Text(
                                                  snapshot.data?[7] ??
                                                      '', // Use the title or a default value
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          180, 20, 20, 20)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(
                                          context,
                                          _createRoute(TrainingPace(
                                            i1: 4,
                                            i2: 1,
                                            i3: 2,
                                            i4: 1,
                                            i5: 12,
                                          ))),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset('images/timer.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    fit: BoxFit.cover),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.015,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    snapshot.data?[9] ??
                                                        '', // Use the title or a default value
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        fontFamily: 'Satoshi',
                                                        color: Color.fromARGB(
                                                            180, 20, 20, 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(context,
                                          _createRoute(SuplementsPage())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/suplements.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.185,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.017,
                                                ),
                                                Text(
                                                  snapshot.data?[4] ??
                                                      '', // Use the title or a default value
                                                  textAlign: TextAlign.center,

                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          180, 20, 20, 20)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: InkWell(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              right: Radius.circular(40),
                                              left: Radius.circular(40)),
                                      onTap: () => Navigator.push(
                                          context, _createRoute(WaterDemand())),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: Image.asset(
                                                    'images/tlo1.jpg',
                                                    color: Colors.transparent)
                                                .blurred(
                                                    blur: 4,
                                                    blurColor:
                                                        const Color.fromARGB(
                                                            1, 210, 210, 210),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                      right:
                                                          Radius.circular(25),
                                                      left: Radius.circular(25),
                                                    )),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                Image.asset(
                                                  'images/waterIcon.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.005,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    snapshot.data?[8] ??
                                                        '', // Use the title or a default value
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        fontFamily: 'Satoshi',
                                                        color: Color.fromARGB(
                                                            180, 20, 20, 20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox()
                            ],
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(180, 255, 255, 255),
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}

class SuplementsPage extends StatelessWidget {
  SuplementsPage({super.key});
  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return Suplementss[index].title;
    } else {
      return Suplementss[index].titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Suplements',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Satoshi',
              color: Color.fromARGB(220, 30, 30, 30),
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(208, 0, 0, 0),
            image: DecorationImage(
              image: AssetImage("images/tlo16.jpg"),
              opacity: 0.75,
              fit: BoxFit.cover,
            )),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context, _createRoute(Suplementss[index].NamePage)),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Image.asset('images/tlo1.jpg',
                                    color: Colors.transparent)
                                .blurred(
                              blur: 4,
                              blurColor: const Color.fromARGB(1, 180, 180, 180),
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(40),
                                  left: Radius.circular(40)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            padding: const EdgeInsets.symmetric(
                                // vertical: 1,
                                ),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Color.fromRGBO(255, 255, 255, 0.427),
                            ),
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 0, 0),
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: FutureBuilder(
                                                  future: Tytul(index),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      }
                                                      return Text(
                                                        snapshot.data ??
                                                            '', // Use the title or a default value
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Satoshi',
                                                            color:
                                                                Color.fromARGB(
                                                                    220,
                                                                    30,
                                                                    30,
                                                                    30)),
                                                      );
                                                    } else {
                                                      return const CircularProgressIndicator(
                                                          color: Color.fromARGB(
                                                              220, 30, 30, 30));
                                                    }
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Image.asset(
                                            Suplementss[index].pngCode,
                                            height: 115,
                                            width: 90,
                                            scale: 1,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: Suplementss.length,
                ),
                itemExtent: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PPMiBMI extends StatefulWidget {
  const PPMiBMI({super.key});

  @override
  State<PPMiBMI> createState() => _PPMiBMI();
}

class _PPMiBMI extends State<PPMiBMI> {
  Future<List<String>> ENG() async {
    String language = await getLanguage();
    if (language == "English") {
      return [
        "Your basic metabolism: ",
        "BMI Result: ",
        "Weight: ",
        "Height: ",
        "Age: ",
        "Gender: ",
        "Male: ",
        "Female: ",
      ];
    } else {
      return [
        "Twój\npodstawowy metabolizm: ",
        "Wynik BMI: ",
        "Waga: ",
        "Wzrost: ",
        "Wiek: ",
        "Płeć: ",
        "Mężczyzna",
        "Kobieta",
      ];
    }
  }

  String gender = 'male';
  double WeightValue = 70.5;
  double HeightValue = 170.5;
  double AgeValue = 35;
  String getPPM() {
    if (gender == 'male') {
      double ppm =
          66.47 + 13.75 * WeightValue + 5 * HeightValue - 6.76 * AgeValue;
      return ppm.toStringAsFixed(0);
    } else {
      double ppm =
          665.5 + 9.563 * WeightValue + 1.85 * HeightValue - 4.68 * AgeValue;
      return ppm.toStringAsFixed(0);
    }
  }

  String getBmiResult() {
    double bmi = WeightValue / (HeightValue * HeightValue) * 10000;
    return bmi.toStringAsFixed(2);
  }

  String getBmiText() {
    double bmi = WeightValue / (HeightValue * HeightValue) * 10000;
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal weight';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: FutureBuilder(
          future: ENG(),
          builder: (context, snapshot) {
            if (_connectionState == ConnectionState.none) {
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  title: const Text('PPM and BMI calculators',
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'Satoshi',
                          color: Color.fromARGB(255, 30, 30, 30))),
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                body: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("images/tlo15.jpg"),
                        opacity: 0.6,
                        fit: BoxFit.cover,
                      )),
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 2,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(40, 10, 10, 10),
                                          Color.fromARGB(10, 35, 34, 34)
                                        ],
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Center(
                                        child: Text(
                                            "${snapshot.data?[0]}\n${getPPM()} Kcal",
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Satoshi',
                                                color: Color.fromARGB(
                                                    215, 5, 5, 5)))),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 2,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromARGB(40, 10, 10, 10),
                                          Color.fromARGB(10, 35, 34, 34),
                                        ],
                                      )),
                                  child: Center(
                                      child: Text(
                                          "${snapshot.data?[1]}\n${getBmiResult()}\n${getBmiText()}",
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  215, 5, 5, 5)))),
                                ),
                              ],
                            ),
                            Text("${snapshot.data?[2]}$WeightValue",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Satoshi',
                                    color: Color.fromARGB(215, 5, 5, 5))),
                            Slider(
                                activeColor:
                                    const Color.fromARGB(170, 10, 10, 10),
                                inactiveColor:
                                    const Color.fromARGB(120, 35, 34, 34),
                                value: WeightValue,
                                min: 35,
                                max: 155,
                                divisions: 240,
                                label: WeightValue.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    WeightValue = value;
                                  });
                                }),
                            Text("${snapshot.data?[3]}$HeightValue",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Satoshi',
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            Slider(
                                activeColor:
                                    const Color.fromARGB(170, 10, 10, 10),
                                inactiveColor:
                                    const Color.fromARGB(120, 35, 34, 34),
                                value: HeightValue,
                                min: 120,
                                max: 220,
                                divisions: 200,
                                label: HeightValue.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    HeightValue = value;
                                  });
                                }),
                            Text(
                                "${snapshot.data?[4]}${AgeValue.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Satoshi',
                                    color: Color.fromARGB(215, 5, 5, 5))),
                            Slider(
                                activeColor:
                                    const Color.fromARGB(170, 10, 10, 10),
                                inactiveColor:
                                    const Color.fromARGB(120, 35, 34, 34),
                                value: AgeValue,
                                min: 4,
                                max: 100,
                                divisions: 96,
                                label: AgeValue.round().toString(),
                                onChanged: (value) {
                                  setState(() {
                                    AgeValue = value;
                                  });
                                }),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 190,
                                    child: RadioListTile(
                                      activeColor:
                                          const Color.fromARGB(170, 10, 10, 10),
                                      hoverColor:
                                          const Color.fromARGB(120, 35, 34, 34),
                                      title: Text("${snapshot.data?[6]}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  215, 5, 5, 5))),
                                      value: "male",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: RadioListTile(
                                      activeColor:
                                          const Color.fromARGB(170, 10, 10, 10),
                                      hoverColor:
                                          const Color.fromARGB(120, 35, 34, 34),
                                      title: Text("${snapshot.data?[7]}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  215, 5, 5, 5))),
                                      value: "female",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ), // Replace MaxGap with SizedBox
                            AdWidget(true)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (_connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color.fromARGB(180, 255, 255, 255),
              );
            }
            return const Text("");
          },
        ),
      ),
    );
  }
}

class Training {
  String id;
  String title;
  var NamePage;
  Training(this.id, this.title, this.NamePage);
}

final List<Training> _Training = [
  Training('0', 'Training Slot 1', MyDynamicList()),
  Training('1', 'Training Slot 2', MyDynamicList1()),
  Training('2', 'Training Slot 3', MyDynamicList2()),
  Training('3', 'Training Slot 4', MyDynamicList3()),
  Training('4', 'Training Slot 5', MyDynamicList4()),
  Training('5', 'Training Slot 6', const MyDynamicList5()),
  Training('6', 'Training Slot 7', MyDynamicList6()),
  Training('7', 'Training Slot 8', MyDynamicList7()),
  Training('8', 'Training Slot 9', MyDynamicList8()),
  Training('9', 'Training Slot 10', MyDynamicList9()),
];

class TrainingPage extends StatefulWidget {
  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  late ValueNotifier<String> newName;
  late ValueNotifier<String>
      newName1; // add a new ValueNotifier for the second variable
  late ValueNotifier<String> newName2;
  late ValueNotifier<String> newName3;
  late ValueNotifier<String> newName4;
  late ValueNotifier<String> newName5;
  late ValueNotifier<String> newName6;
  late ValueNotifier<String> newName7;
  late ValueNotifier<String> newName8;
  late ValueNotifier<String> newName9;
  @override
  void initState() {
    super.initState();
    newName = ValueNotifier<String>('Name');
    newName1 = ValueNotifier<String>('Name1');
    newName2 = ValueNotifier<String>('Name2');
    newName3 = ValueNotifier<String>('Name3');
    newName4 = ValueNotifier<String>('Name3');
    newName5 = ValueNotifier<String>('Name4');
    newName6 = ValueNotifier<String>('Name5');
    newName7 = ValueNotifier<String>('Name6');
    newName8 = ValueNotifier<String>('Name7');
    newName9 = ValueNotifier<String>('Name8');

    loadNames(); // combine the two load functions into one
  }

  void loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name${user.email}') ?? 'Training 0';
    final name1 = prefs.getString('name1${user.email}') ?? 'Training 1';
    final name2 = prefs.getString('name2${user.email}') ?? 'Training 2';
    final name3 = prefs.getString('name3${user.email}') ?? 'Training 3';
    final name4 = prefs.getString('name4${user.email}') ?? 'Training 4';
    final name5 = prefs.getString('name5${user.email}') ?? 'Training 5';
    final name6 = prefs.getString('name6${user.email}') ?? 'Training 6';
    final name7 = prefs.getString('name7${user.email}') ?? 'Training 7';
    final name8 = prefs.getString('name8${user.email}') ?? 'Training 8';
    final name9 = prefs.getString('name9${user.email}') ?? 'Training 9';
    newName.value = name;
    newName1.value = name1;
    newName2.value = name2;
    newName3.value = name3;
    newName4.value = name4;
    newName5.value = name5;
    newName6.value = name6;
    newName7.value = name7;
    newName8.value = name8;
    newName9.value = name9;
  }

  void saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name${user.email}', name);
    newName.value = name;
  }

  void saveName1(String name1) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name1${user.email}', name1);
    newName1.value = name1; // set the value of the new ValueNotifier
  }

  void saveName2(String name2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name2${user.email}', name2);
    newName2.value = name2; // set the value of the new ValueNotifier
  }

  void saveName3(String name3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name3${user.email}', name3);
    newName3.value = name3; // set the value of the new ValueNotifier
  }

  void saveName4(String name4) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name4${user.email}', name4);
    newName4.value = name4; // set the value of the new ValueNotifier
  }

  void saveName5(String name5) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name5${user.email}', name5);
    newName5.value = name5; // set the value of the new ValueNotifier
  }

  void saveName6(String name6) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name6${user.email}', name6);
    newName6.value = name6; // set the value of the new ValueNotifier
  }

  void saveName7(String name7) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name7${user.email}', name7);
    newName7.value = name7; // set the value of the new ValueNotifier
  }

  void saveName8(String name8) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name8${user.email}', name8);
    newName8.value = name8; // set the value of the new ValueNotifier
  }

  void saveName9(String name9) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name9${user.email}', name9);
    newName9.value = name9; // set the value of the new ValueNotifier
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final TextEditingController _textFieldController = TextEditingController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text('All Trainings',
            style: TextStyle(
                fontSize: 21,
                fontFamily: 'Satoshi',
                color: Color.fromARGB(255, 66, 66, 66))),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/tlo8.jpg"),
                fit: BoxFit.cover,
                opacity: 0.5),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Colors.white,
                  Colors.white,
                ],
                tileMode: TileMode.mirror),
          ),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[0].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[0].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[1].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[1].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName1,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newName1Value1 =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title1${user.email}':
                                                                  newName1Value1,
                                                            });
                                                            saveName1(
                                                                newName1Value1);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[2].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[2].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName2,
                                              builder:
                                                  (context, String value2, _) {
                                                return Text(
                                                  value2,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newName2Value2 =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title2${user.email}':
                                                                  newName2Value2,
                                                            });
                                                            saveName2(
                                                                newName2Value2);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[3].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[3].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName3,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title3${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName3(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[4].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[4].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName4,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title4${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName4(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[5].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[5].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName5,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title5${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName5(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[6].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[6].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName6,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title6${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName6(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[7].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[7].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName7,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue7 =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title7${user.email}':
                                                                  newNameValue7,
                                                            });
                                                            saveName7(
                                                                newNameValue7);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  width: 310,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[8].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[8].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName8,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newNameValue =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title8${user.email}':
                                                                  newNameValue,
                                                            });
                                                            saveName8(
                                                                newNameValue);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 26, right: 26, top: 7, bottom: 15),
                  // width: 200,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(140, 240, 206, 255),
                          Color.fromARGB(140, 213, 242, 253),
                          Color.fromARGB(140, 185, 230, 255),
                        ],
                        tileMode: TileMode.mirror),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context, _createRoute(_Training[9].NamePage)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context, _createRoute(_Training[9].NamePage)),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(6, 9, 6, 9),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 0, 0),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: newName9,
                                              builder:
                                                  (context, String value, _) {
                                                return Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          255, 66, 66, 66)),
                                                );
                                              }),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            focusColor: const Color.fromARGB(
                                                255, 100, 100, 100),
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change name'),
                                                    content: TextField(
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            final String
                                                                newName9Value9 =
                                                                _textFieldController
                                                                    .text;
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'training')
                                                                .doc(
                                                                    'R7DoLEJwhiAefPr7NnrB')
                                                                .update({
                                                              'title9${user.email}':
                                                                  newName9Value9,
                                                            });
                                                            saveName9(
                                                                newName9Value9);
                                                            Navigator.pop(
                                                                context);
                                                          } catch (e) {}
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Change Name'),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}

// ignore: must_be_immutable
class AdWidget extends StatefulWidget {
  bool bialeCzyCzarne = false;
  AdWidget(this.bialeCzyCzarne, {super.key});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Future<String> getLanguage() async {
    var language = "";
    CollectionReference collection = firestore.collection('${user.email}');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      language = (data['language'].toString());
    }
    return language;
  }

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

ConnectionState _connectionState = ConnectionState.none;
Widget tworzenieSloganu(context, String text1, String text2, String text3,
    String text4, String text5, bool kolor) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Future<String> getLanguage() async {
    var language = "";
    CollectionReference collection = firestore.collection('${user.email}');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      language = (data['language'].toString());
    }
    return language;
  }

  Future<String> Tytul() async {
    String language = await getLanguage();
    if (language == "English") {
      return text3;
    } else {
      return text4;
    }
  }

  Future<String> Kup() async {
    String language = await getLanguage();
    if (language == "English") {
      return "Buy";
    } else {
      return "Kup";
    }
  }

  return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(40, 10, 10, 10),
              Color.fromARGB(10, 35, 34, 34),
            ],
            tileMode: TileMode.mirror),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const MaxGap(5),
              SizedBox(width: 120, height: 110, child: Image.asset(text1)),
              const MaxGap(6),
              Container(
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(120, 78, 83, 227),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: InkWell(
                      child: FutureBuilder(
                        future: Kup(),
                        builder: (context, snapshot) {
                          if (_connectionState == ConnectionState.none) {
                            if (kolor) {
                              return Text(snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16.25,
                                      fontFamily: 'Satoshi',
                                      color: Color.fromARGB(255, 41, 41, 41)));
                            }
                            if (!kolor) {
                              return Text(snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16.25,
                                      fontFamily: 'Satoshi',
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)));
                            }
                          } else if (_connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                          return const Text("");
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            _createRoute(
                              WebViewApp(
                                text5,
                                text2,
                              ),
                            ));
                      }),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 115,
                      child: FutureBuilder(
                        future: Tytul(),
                        builder: (context, snapshot) {
                          if (_connectionState == ConnectionState.none) {
                            if (kolor) {
                              return Text(snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Satoshi',
                                      color: Color.fromARGB(255, 41, 41, 41)));
                            }
                            if (!kolor) {
                              return Text(snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Satoshi',
                                      color:
                                          Color.fromARGB(220, 255, 255, 255)));
                            }
                          } else if (_connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                          return const Text("");
                        },
                      ))
                ],
              )
            ],
          )
        ],
      ));
}

class _AdWidgetState extends State<AdWidget> {
  int myCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final myitems = [
      tworzenieSloganu(
          context,
          'images/Creatine.png',
          "https://olimpstore.pl/olimp-creatine-1250-mega-caps-400-capsules-102",
          "Unlock Your Potential with Creatine - Elevate Your Performance Today!",
          "Odblokuj swój potencjał dzięki kreatynie - Podnieś swoją wydajność już dziś!",
          "Kreatyna",
          widget.bialeCzyCzarne),
      tworzenieSloganu(
          context,
          'images/PWR.jpg',
          "https://olimpstore.pl/olimp-extreme-speedr-shot-25-ml-ampulka-szklana-3450",
          "Unlock your potential with PWR - Investing in your future!",
          "Odblokuj swój potencjał dzięki PWR - Inwestuj w swoją przyszłość!",
          "PWR",
          widget.bialeCzyCzarne),
      tworzenieSloganu(
          context,
          'images/Magnes.png',
          "https://olimpstore.pl/olimp-chela-mag-b6-30-capsules-567",
          "Beat the soreness with a sip of relief –  Get your drinkable magnet for post-workout bliss!",
          "Pokonaj ból poprzez łyk ulgi – Zdobądź swój napój-magnes na popołudniową przyjemność po treningu!",
          "Magnez",
          widget.bialeCzyCzarne),
      tworzenieSloganu(
          context,
          'images/zinc.png',
          "https://olimpstore.pl/olimp-chela-cynk-30-capsules-575",
          "Unlock the beauty within – Embrace zinc and let your skin glow!",
          "Odblokuj piękno wewnętrzne – Przyjmij cynk i pozwól swojej skórze błyszczeć!",
          "Cynk",
          widget.bialeCzyCzarne),
      tworzenieSloganu(
          context,
          'images/witC.png',
          "https://olimpstore.pl/olimp-gold-vit-c-1000-sport-edition-60-capsules-182",
          "Elevate your vitality with Vitamin C - A brighter, healthier you awaits!",
          "Wzmocnij swoją witalność dzięki witaminie C - Jasniejsze, zdrowsze ja już na ciebie czeka!",
          "Witamina C",
          widget.bialeCzyCzarne),
      tworzenieSloganu(
          context,
          'images/Omega3.png',
          "https://olimpstore.pl/olimp-gold-omega-3-sport-edition-120-capsules-178",
          "Discover the power of Omega-3 for a healthier you!",
          "Odkryj moc Omega-3 dla zdrowszego ciebie!",
          "Omega 3",
          widget.bialeCzyCzarne),
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: 200,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayInterval: const Duration(seconds: 6),
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: myitems,
          ),
          AnimatedSmoothIndicator(
            activeIndex: myCurrentIndex,
            count: myitems.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 10,
              dotColor: Colors.grey.shade200,
              activeDotColor: Colors.grey.shade900,
              paintStyle: PaintingStyle.fill,
            ),
          )
        ],
      ),
    );
  }
}

Route _createRoute(Widget Page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1200),
  );
}
