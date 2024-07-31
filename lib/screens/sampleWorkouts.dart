import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';



class Workout {
  String tytulPol;
  String titleEng;
  String imageCode;
  List<int> listOfExercises;

  Workout(this.tytulPol, this.titleEng, this.imageCode, this.listOfExercises);
}

List<Workout> _Workouts = [
  Workout("Push", "Push", "images/pushTraining.jpeg", [12, 3, 4]),
  Workout("Pull", "Pull", "images/pull.jpeg", [1, 20, 17, 16, 2])
];

class sampleWorkouts extends StatelessWidget {
  sampleWorkouts({super.key});
  final ConnectionState _connectionState = ConnectionState.none;
  final controler = ScrollController();
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

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _Workouts[index].titleEng;
    } else {
      return _Workouts[index].tytulPol;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
         surfaceTintColor: Colors.transparent,
        title: const Text(
          "Trainings: ",
          style: TextStyle(fontFamily: "Satoshi"),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(240, 5, 5, 5),
                Color.fromARGB(230, 10, 10, 10),
              ],
              tileMode: TileMode.mirror),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: controler,
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final itemOffset = index * 155;
                    final difference = controler.offset - itemOffset;
                    final percent = 1 - (difference / (155 / 2));
                    double scale = percent;
                    double opacity = percent;
                    if (opacity > 1.0) opacity = 1.0;
                    if (opacity < 0.0) opacity = 0.0;
                    if (scale > 1.0) scale = 1.0;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context, _createRoute(EveryTrainingPage(index)));
                      },
                      child: Opacity(
                        opacity: opacity,
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
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..scale(scale, 1.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        _Workouts[index].imageCode,
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(175, 0, 0, 0),
                                    Color.fromARGB(120, 0, 0, 0),
                                    Color.fromARGB(90, 0, 0, 0),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 15, 0, 0),
                                        child: FutureBuilder(
                                          future: Tytul(index),
                                          builder: (context, snapshot) {
                                            if (_connectionState ==
                                                ConnectionState.none) {
                                              return Text(
                                                snapshot.data ?? '',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'Satoshi',
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                ),
                                              );
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _Workouts.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EveryTrainingPage extends StatelessWidget {
  int workout;
  EveryTrainingPage(this.workout, {super.key});
  final ConnectionState _connectionState = ConnectionState.none;
  final controler = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return Exercises[_Workouts[workout].listOfExercises[index]].title;
    } else {
      return Exercises[_Workouts[workout].listOfExercises[index]].titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "${_Workouts[workout].titleEng}: ",
          style: const TextStyle(fontFamily: "Satoshi"),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(240, 5, 5, 5),
                    Color.fromARGB(230, 10, 10, 10),
                  ],
                  tileMode: TileMode.mirror),
            ),
            child: SafeArea(
              child: CustomScrollView(
                controller: controler,
                slivers: <Widget>[
                  SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final itemOffset = index * 155;
                        final difference = controler.offset - itemOffset;
                        final percent = 1 - (difference / (155 / 2));
                        double scale = percent;
                        double opacity = percent;
                        if (opacity > 1.0) opacity = 1.0;
                        if (opacity < 0.0) opacity = 0.0;
                        if (scale > 1.0) scale = 1.0;
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                _createRoute(Exercises[index].namePage));
                          },
                          child: Opacity(
                            opacity: opacity,
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
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..scale(scale, 1.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            Exercises[_Workouts[workout]
                                                    .listOfExercises[index]]
                                                .gifCode,
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(175, 0, 0, 0),
                                        Color.fromARGB(120, 0, 0, 0),
                                        Color.fromARGB(90, 0, 0, 0),
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
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 15, 0, 0),
                                            child: FutureBuilder(
                                              future: Tytul(index),
                                              builder: (context, snapshot) {
                                                if (_connectionState ==
                                                    ConnectionState.none) {
                                                  return Text(
                                                    snapshot.data ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: 'Satoshi',
                                                      color: Color.fromARGB(
                                                          180, 255, 255, 255),
                                                    ),
                                                  );
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _Workouts[workout].listOfExercises.length,
                    ),
                    itemExtent: 155,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(Widget page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page2,
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
