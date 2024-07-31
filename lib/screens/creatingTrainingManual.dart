import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:ucze_sie_swiry/main.dart';
import 'package:ucze_sie_swiry/screens/progressPage.dart';

ValueNotifier<double> timeOnTraining1 = ValueNotifier<double>(60);
ValueNotifier<List<String>> selectedGoals = ValueNotifier<List<String>>([]);
ValueNotifier<String> MiejsceTreningu = ValueNotifier<String>("");

class tworzenieTreningu extends StatefulWidget {
  tworzenieTreningu({Key? key}) : super(key: key);

  @override
  State<tworzenieTreningu> createState() => _tworzenieTreninguState();
}

class _tworzenieTreninguState extends State<tworzenieTreningu> {
  final formSlides = [
    formPage0(),
    formPage1(),
    formPage2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(240, 20, 20, 20),
                Color.fromARGB(230, 35, 35, 35),
              ],
              tileMode: TileMode.mirror),
        ),
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: ValueNotifier<bool>(isEverythingChoosen()),
            builder: (context, isChoosen, child) {
              return CarouselSlider.builder(
                itemCount: isEverythingChoosen()
                    ? formSlides.length + 1
                    : formSlides.length,
                itemBuilder: (context, index, realIndex) {
                  if (index < formSlides.length) {
                    final formSlide = formSlides[index];
                    return buildSlide(formSlide, index, formSlides);
                  } else {
                    return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35)),
                        child: Wyniki());
                  }
                },
                options: CarouselOptions(height: 450),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSlide(formSlide, int index, var fromSlides) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color.fromARGB(55, 255, 255, 255),
          ),
          margin: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 40.0,
                  sigmaY: 40.0,
                ),
                child: Container(
                    alignment: Alignment.center, child: formSlides[index])),
          ),
        ),
      );
}

class formPage0 extends StatefulWidget {
  formPage0({Key? key}) : super(key: key);

  @override
  State<formPage0> createState() => _formPage0State();
}

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

Future<String> Pytanie() async {
  String language = await getLanguage();
  if (language == "English") {
    return "How much time do you want to spend on the training:";
  } else {
    return "Ile czasu chcesz poświęcić na trening:";
  }
}

class _formPage0State extends State<formPage0> {
  ConnectionState _connectionState = ConnectionState.none;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: FutureBuilder(
            future: Pytanie(),
            builder: (context, snapshot) {
              if (_connectionState == ConnectionState.none) {
                return Text(
                  snapshot.data ?? '', // Use the title or a default value
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Satoshi',
                    color: Color.fromARGB(170, 255, 255, 255),
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
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "${timeOnTraining1.value.round().toString()} min",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Satoshi',
                color: Color.fromARGB(170, 255, 255, 255)),
          ),
        ),
        Slider(
            inactiveColor: const Color.fromARGB(120, 255, 255, 255),
            activeColor: const Color.fromARGB(170, 255, 255, 255),
            value: timeOnTraining1.value,
            max: 120,
            min: 30,
            divisions: 9,
            label: "${timeOnTraining1.value.round().toString()}",
            onChanged: (double value) {
              setState(() {
                timeOnTraining1.value = value;
              });
            })
      ],
    );
  }
}

class formPage1 extends StatefulWidget {
  formPage1({Key? key}) : super(key: key);

  @override
  State<formPage1> createState() => _formPage1State();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
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
}

Future<String> Pytanie1() async {
  String language = await getLanguage();
  if (language == "English") {
    return "On which parts would you like to focus:";
  } else {
    return "Na których partiach ciała chciałbyś się skupić:";
  }
}

class _formPage1State extends State<formPage1> {
  ConnectionState _connectionState = ConnectionState.none;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: FutureBuilder(
            future: Pytanie1(),
            builder: (context, snapshot) {
              if (_connectionState == ConnectionState.none) {
                return Text(
                  snapshot.data ?? '', // Use the title or a default value
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Satoshi',
                    color: Color.fromARGB(170, 255, 255, 255),
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
        const MaxGap(35),
        SizedBox(
            height: 200,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return buildGoalTile(
                            [
                              "Shoulders",
                              "Chest",
                              "Biceps",
                              "Triceps",
                              "Glutes",
                              "Lats",
                              "Abdominals",
                              "Hamstrings",
                              "Traps",
                              "Obliques",
                              "Calves",
                            ][index],
                            index);
                      },
                      childCount: 11,
                    ),
                  ),
                ),
              ],
            )),
        Container(
          margin: const EdgeInsets.all(5),
          child: const Icon(
            Icons.swipe_down,
            color: Colors.white,
            size: 32,
          ),
        )
      ],
    );
  }

  ListTile buildGoalTile(String goalText, int index) {
    List<String> PL() {
      return [
        "Barki",
        "Klatka Piersiowa",
        "Biceps",
        "Triceps",
        "Pośladki",
        "Plecy",
        "Brzuch",
        "Czworogłowe uda",
        "Kaptury",
        "Skośne brzucha",
        "Łydki",
      ];
    }

    Future<String> Lista() async {
      String language = await getLanguage();
      if (language == "English") {
        return goalText;
      } else {
        return PL()[index];
      }
    }

    ConnectionState _connectionState = ConnectionState.none;
    bool isGoalSelected = selectedGoals.value.contains(goalText);
    return ListTile(
      title: FutureBuilder(
        future: Lista(),
        builder: (context, snapshot) {
          if (_connectionState == ConnectionState.none) {
            return Text(
              snapshot.data ?? '', // Use the title or a default value
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Satoshi',
                color: Color.fromARGB(170, 255, 255, 255),
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
      leading: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.grey),
        child: Checkbox(
          value: isGoalSelected,
          activeColor: const Color.fromARGB(170, 255, 255, 255),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                selectedGoals.value.add(goalText);
              } else {
                selectedGoals.value.remove(goalText);
              }
            });
          },
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const Color.fromARGB(
                    100, 50, 50, 50); // Kolor dla zaznaczonego Checkboxa
              }
              return const Color.fromARGB(
                  70, 158, 158, 158); // Kolor dla niezaznaczonego Checkboxa
            },
          ),
        ),
      ),
    );
  }
}

class formPage2 extends StatefulWidget {
  formPage2({Key? key}) : super(key: key);

  @override
  State<formPage2> createState() => _formPage2State();
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
}

Future<String> pytanie2() async {
  String language = await getLanguage();
  if (language == "English") {
    return "Where are u going to train:";
  } else {
    return "Gdzie planujesz trenować:";
  }
}

Future<String> pytanie3() async {
  String language = await getLanguage();
  if (language == "English") {
    return "Home";
  } else {
    return "Dom";
  }
}

Future<String> pytanie4() async {
  String language = await getLanguage();
  if (language == "English") {
    return "Gym";
  } else {
    return "Siłownia";
  }
}

class _formPage2State extends State<formPage2> {
  ConnectionState _connectionState = ConnectionState.none;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: FutureBuilder(
              future: pytanie2(),
              builder: (context, snapshot) {
                if (_connectionState == ConnectionState.none) {
                  return Text(
                    snapshot.data ?? '', // Use the title or a default value
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Satoshi',
                      color: Color.fromARGB(170, 255, 255, 255),
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
          const SizedBox(
            height: 70,
          ),
          Column(children: [
            ListTile(
              title: FutureBuilder(
                future: pytanie3(),
                builder: (context, snapshot) {
                  if (_connectionState == ConnectionState.none) {
                    return Text(
                      snapshot.data ?? '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Satoshi',
                        color: Color.fromARGB(170, 255, 255, 255),
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
              leading: Radio<String>(
                value: "Home",
                groupValue: MiejsceTreningu.value,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color.fromARGB(200, 255, 255,
                          255); // Kolor dla zaznaczonego Checkboxa
                    }
                    return const Color.fromARGB(150, 255, 255,
                        255); // Kolor dla niezaznaczonego Checkboxa
                  },
                ),
                activeColor: const Color.fromARGB(170, 255, 255, 255),
                onChanged: (String? value) {
                  setState(() {
                    MiejsceTreningu.value = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: FutureBuilder(
                future: pytanie4(),
                builder: (context, snapshot) {
                  if (_connectionState == ConnectionState.none) {
                    return Text(
                      snapshot.data ?? '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Satoshi',
                        color: Color.fromARGB(170, 255, 255, 255),
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
              leading: Radio<String>(
                value: "Gym",
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color.fromARGB(200, 255, 255,
                          255); // Kolor dla zaznaczonego Checkboxa
                    }
                    return const Color.fromARGB(150, 255, 255,
                        255); // Kolor dla niezaznaczonego Checkboxa
                  },
                ),
                groupValue: MiejsceTreningu.value,
                activeColor: const Color.fromARGB(170, 255, 255, 255),
                onChanged: (String? value) {
                  setState(() {
                    MiejsceTreningu.value = value!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () =>
                      Navigator.push(context, _createRoute(Wyniki())),
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(170, 255, 255, 255),
                    size: 50,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
              ],
            )
          ])
        ],
      ),
    );
  }
}

bool isEverythingChoosen() {
  if (selectedGoals.value.isNotEmpty && MiejsceTreningu.value.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

List<Exercise> palnowanieTreningu(ValueNotifier<double> czas,
    ValueNotifier<List<String>> cel, ValueNotifier<String> miejsce) {
  var iloscCwiczen =
      czas.value / 10; // Wychodzi trochę ponad 3 minuty na jedną serię
  List<Exercise> _results = [];
  if (miejsce.toString().contains("Home")) {
    for (int i = 0; i < cel.value.length; i++) {
      _results.addAll(Exercises.where((exercise) =>
          exercise.tier == false && exercise.bodyPart.contains(cel.value[i])));
    }
  } else {
    for (int i = 0; i < cel.value.length; i++) {
      _results.addAll(Exercises.where((exercise) =>
          exercise.tier == true && exercise.bodyPart.contains(cel.value[i])));
    }
  }
  if (_results.length >= iloscCwiczen) {
    _results.shuffle();
    return _results.sublist(0, iloscCwiczen.toInt());
  } else {
    _results.shuffle();
    return _results;
  }
}

class Wyniki extends StatelessWidget {
  Wyniki({super.key});
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
  Widget build(BuildContext context) {
    final wynikiTreningu =
        palnowanieTreningu(timeOnTraining1, selectedGoals, MiejsceTreningu);
    Future<String> Tytul(int index) async {
      String language = await getLanguage();
      if (language == "English") {
        return wynikiTreningu[index].title;
      } else {
        return wynikiTreningu[index].titlePL;
      }
    }

    void losujNowyTrening(BuildContext context) {
      Navigator.pushReplacement(context, _createRoute(Wyniki()));
    }

    return Scaffold(
      appBar: AppBar(
         surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      backgroundColor: const Color.fromARGB(50, 225, 225, 225),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      color: Color.fromARGB(200, 255, 255, 255),
                      Icons.arrow_back_ios_new,
                      size: 28,
                    ),
                  ),
                ),
                const MaxGap(3000),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: InkWell(
                    onTap: () {
                      losujNowyTrening(context);
                    },
                    child: const Icon(
                      color: Color.fromARGB(200, 255, 255, 255),
                      Icons.refresh,
                      size: 35,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, _createRoute(Training1(wynikiTreningu)));
                    },
                    child: const Icon(
                      color: Color.fromARGB(200, 255, 255, 255),
                      Icons.play_arrow,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
            Flexible(
              child: SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  _createRoute(wynikiTreningu[index].namePage));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                              ),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                        decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          wynikiTreningu[index].gifCode,
                                        ),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        Color.fromARGB(175, 0, 0, 0),
                                        Color.fromARGB(125, 0, 0, 0),
                                        Color.fromARGB(15, 0, 0, 0),
                                      ],
                                    ),
                                  )),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 15, 0, 0),
                                              //alignment: Alignment.centerRight,
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
                                                          fontSize: 24,
                                                          fontFamily: 'Satoshi',
                                                          color: Color.fromARGB(
                                                              180,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      );
                                                    } else {
                                                      return const CircularProgressIndicator(
                                                        color: Color.fromARGB(
                                                            180, 255, 255, 255),
                                                      );
                                                    }
                                                  })),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: wynikiTreningu.length,
                      ),
                      itemExtent: 155,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Training1 extends StatefulWidget {
  final List<Exercise> wynikiTreningu;

  Training1(this.wynikiTreningu, {super.key});

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
  State<Training1> createState() => _Training1State();
}

class _Training1State extends State<Training1> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final milliSecond = true;
  int breakSeconds = 90;
  int seriesIndex = 1;
  int currentIndex = 0;
  void changeData(int i) {
    if (currentIndex + i >= 0 &&
        currentIndex + i < widget.wynikiTreningu.length) {
      setState(() {
        currentIndex += i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<String> tytul(int index) async {
      String language = await getLanguage();
      if (language == "English") {
        return widget.wynikiTreningu[index].title;
      } else {
        return widget.wynikiTreningu[index].titlePL;
      }
    }

    Future<String> Series() async {
      String language = await getLanguage();
      if (language == "English") {
        return "Series:";
      } else {
        return "Serie:";
      }
    }

    Future<String> Reps() async {
      String language = await getLanguage();
      if (language == "English") {
        return "Reps:";
      } else {
        return "Repy:";
      }
    }

    @override
    void dispose() {
      super.dispose();
      _stopWatchTimer.dispose();
    }

    ConnectionState _connectionState = ConnectionState.none;

    return Scaffold(
        backgroundColor: const Color.fromARGB(100, 255, 255, 255),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    _stopWatchTimer.onStartTimer();
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Container(
                    key: ValueKey<int>(currentIndex),
                    height: 200 + MediaQuery.of(context).size.height * 0.29,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(220, 0, 0, 0),
                            Color.fromARGB(220, 0, 0, 0),
                            Color.fromARGB(170, 35, 34, 34),
                          ],
                        ),
                        image: DecorationImage(
                            opacity: 0.8,
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                              widget.wynikiTreningu[currentIndex].gifCode,
                            ),
                            fit: BoxFit.fitWidth)),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 45),
                        child: FutureBuilder(
                            future: tytul(currentIndex),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                return Text(snapshot.data ?? '',
                                    textAlign: TextAlign
                                        .center, // Use the title or a default value
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'Satoshi',
                                        color:
                                            Color.fromARGB(200, 255, 255, 255),
                                        overflow: TextOverflow.clip));
                              } else {
                                return const CircularProgressIndicator(
                                  color: Color.fromARGB(180, 255, 255, 255),
                                );
                              }
                            })),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(130, 15, 15, 15),
                            Color.fromARGB(130, 5, 5, 5),
                          ],
                        ),
                      ),
                      margin: const EdgeInsets.only(top: 30, left: 12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: Text(
                          key: ValueKey<int>(currentIndex),
                          "${currentIndex + 1}/${widget.wynikiTreningu.length}",
                          style: const TextStyle(
                              fontSize: 32,
                              fontFamily: 'Satoshi',
                              color: Color.fromARGB(210, 255, 255, 255),
                              overflow: TextOverflow.clip),
                        ),
                      ),
                    ),
                    StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snapshot) {
                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(
                            value!,
                            milliSecond: false,
                            hours: false);

                        return Container(
                          margin: const EdgeInsets.only(top: 30, right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(130, 15, 15, 15),
                                Color.fromARGB(130, 5, 5, 5),
                              ],
                            ),
                          ),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 32,
                                fontFamily: 'Satoshi',
                                color: Color.fromARGB(210, 255, 255, 255),
                                overflow: TextOverflow.clip),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(180, 15, 15, 15),
                                Color.fromARGB(170, 35, 34, 34),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.32,
                                height:
                                    MediaQuery.of(context).size.width * 0.32,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: FutureBuilder(
                                        future: Series(),
                                        builder: (context, snapshot) {
                                          if (_connectionState ==
                                              ConnectionState.none) {
                                            return Text(snapshot.data ?? '',
                                                style: const TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        200, 255, 255, 255),
                                                    overflow:
                                                        TextOverflow.clip));
                                          } else if (_connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            );
                                          }
                                          return const Text("");
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return FadeTransition(
                                              opacity: animation, child: child);
                                        },
                                        child: Text(
                                          key: ValueKey<int>(currentIndex),
                                          "$seriesIndex/${widget.wynikiTreningu[currentIndex].series}",
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              overflow: TextOverflow.clip),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(180, 15, 15, 15),
                                Color.fromARGB(170, 35, 34, 34),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.32,
                                height:
                                    MediaQuery.of(context).size.width * 0.32,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: FutureBuilder(
                                        future: Reps(),
                                        builder: (context, snapshot) {
                                          if (_connectionState ==
                                              ConnectionState.none) {
                                            return Text(
                                                snapshot.data ??
                                                    '', // Use the title or a default value
                                                style: const TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        200, 255, 255, 255),
                                                    overflow:
                                                        TextOverflow.clip));
                                          } else if (_connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            );
                                          }
                                          return const Text("");
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: AnimatedSwitcher(
                                        //key:Key(currentIndex.toString()),
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return FadeTransition(
                                              opacity: animation, child: child);
                                        },
                                        child: Text(
                                          key: ValueKey<int>(currentIndex),
                                          "${widget.wynikiTreningu[currentIndex].reps - 2}-${widget.wynikiTreningu[currentIndex].reps + 2}",
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              overflow: TextOverflow.clip),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                //MaxGap(0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          //margin: EdgeInsets.all(70),
                          width: 85,
                          height: 85,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(100, 218, 6, 6),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30, sigmaY: 30),
                                    child: const Center(
                                        child: Icon(
                                      Icons.square_rounded,
                                      color: Color.fromARGB(190, 255, 255, 255),
                                      size: 55,
                                    )),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 85,
                          height: 85,
                          child: InkWell(
                            onTap: () {
                              changeData(-1);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(100, 218, 6, 6),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30, sigmaY: 30),
                                    child: const Center(
                                        child: Icon(
                                      Icons.skip_previous,
                                      color: Color.fromARGB(230, 255, 255, 255),
                                      size: 80,
                                    )),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          //margin: EdgeInsets.all(70),
                          width: 135,
                          height: 85,
                          child: InkWell(
                            onTap: () {
                              if (currentIndex + 1 ==
                                      widget.wynikiTreningu.length &&
                                  seriesIndex ==
                                      widget.wynikiTreningu[currentIndex]
                                          .series) {
                                EndDialog(context, widget.wynikiTreningu);
                              } else if (seriesIndex <
                                  widget.wynikiTreningu[currentIndex].series) {
                                seriesIndex += 1;
                                TimerDialog(context, 20, widget.wynikiTreningu);
                                changeData(0);
                              } else if (seriesIndex ==
                                  widget.wynikiTreningu[currentIndex].series) {
                                TimerDialog(context, 20, widget.wynikiTreningu);
                                seriesIndex = 1;
                                changeData(1);
                              } else {
                                changeData(1);
                                seriesIndex = 1;
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(180, 6, 218, 24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30, sigmaY: 30),
                                    child: const Center(
                                        child: Icon(
                                      Icons.done_all,
                                      color: Color.fromARGB(230, 255, 255, 255),
                                      size: 80,
                                    )),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

final player = AudioPlayer();
void playSound() {
  player.setVolume(100);
  player.play(AssetSource("alarm.mp3"));
}

void endSound() {
  player.setVolume(0);
  player.pause();
  player.release();
 //player.dispose();
}

Future TimerDialog(BuildContext context, int breakSeconds, var wynikiTreningu) {
  Future.delayed(Duration(seconds: breakSeconds - 10), () {
    playSound();
  });
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: SizedBox(
            width: 300, // Set the width of the dialog
            height: 300, // Set the height of the dialog
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensure the column size is based on its content
              children: [
                SizedBox(
                  width: double
                      .infinity, // Make sure the Stack takes the full width
                  height: 200, // Set the desired height for the Stack
                  child: Countdown(
                    seconds: breakSeconds,
                    build: (BuildContext context, double time) => Container(
                      margin: const EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 175,
                              width: 175,
                              child: CircularProgressIndicator(
                                strokeAlign:
                                    CircularProgressIndicator.strokeAlignCenter,
                                value: 1 - time / breakSeconds,
                                backgroundColor:
                                    const Color.fromARGB(10, 0, 0, 0),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color.fromARGB(210, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(time.toString(),
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Satoshi',
                                    color: Color.fromARGB(220, 0, 0, 0),
                                    overflow: TextOverflow.clip)),
                          ),
                        ],
                      ),
                    ),
                    interval: const Duration(milliseconds: 100),
                    onFinished: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    onPressed: () {
                      endSound();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Satoshi',
                          color: Color.fromARGB(220, 255, 255, 255),
                          overflow: TextOverflow.clip),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future EndDialog(BuildContext context, var wynikiTreningu) {
  ConnectionState _connectionState = ConnectionState.none;
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
      return "It was an awesome training";
    } else {
      return "To był niesamowity trening";
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Use a transparent background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 350,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: Tytul(),
                builder: (context, snapshot) {
                  if (_connectionState == ConnectionState.none) {
                    return Center(
                      child: Text(
                        snapshot.data ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Satoshi',
                          color: Color.fromARGB(220, 0, 0, 0),
                        ),
                      ),
                    );
                  } else if (_connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return const Text("");
                },
              ),
              const SizedBox(height: 65),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(220, 0, 0, 0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, _createRoute(MyStatefulWidget()));
                        },
                        child: const Center(
                          child: Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Satoshi',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(220, 0, 0, 0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, _createRoute(ProgressPage(0)));
                          // Add your logic for navigating to the progress page here
                        },
                        child: const Center(
                          child: Text(
                            "Progress Page",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Satoshi',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
