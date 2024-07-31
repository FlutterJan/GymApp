import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ucze_sie_swiry/main.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';
import 'package:ucze_sie_swiry/screens/progressPage.dart';
import 'package:ucze_sie_swiry/screens/trainingPace.dart';

class Training {
  String id;
  String title;
  var namePage;
  Training(this.id, this.title, this.namePage);
}

class MyDynamicList extends StatefulWidget {
  @override
  _MyDynamicListState createState() => _MyDynamicListState();
}

class _MyDynamicListState extends State<MyDynamicList> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  List<String> _selectedExercises1 = [];
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Series'] != null) {
        setState(() {});
        return data['Series'] as int;
      }
    }

    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Reps'] != null) {
        return data['Reps'] as int;
      }
    }
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Break'] != null) {
        return data['Break'] as int;
      }
    }
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises1[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises1[index]))
          .first
          .titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDisable = false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                   borderRadius: BorderRadius.circular(50),
                  onTap: () async {
                    if (!isDisable) {
                      isDisable = true;
                      List<int> series = [];
                      for (int i = 0; i < _selectedExercises1.length; i++) {
                        series.add(await getSeriesFromFirestore(i, 0));
                      }
                      List<int> reps = [];
                      for (int i = 0; i < _selectedExercises1.length; i++) {
                        reps.add(await getRepsFromFirestore(i, 0));
                      }
                      List<int> breakTime = [];
                      for (int i = 0; i < _selectedExercises1.length; i++) {
                        breakTime.add(await getBreakFromFirestore(i, 0));
                      }

                      Navigator.push(
                          context,
                          _createRoute(Training2(
                              _selectedExercises1, series, reps, breakTime)));
                    } else {
                      await Future.delayed(const Duration(seconds: 1));
                      isDisable == false;
                    }
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                  onSecondaryTap: () {},
                  onDoubleTap: () {},
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises1[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 15, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                    InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  0,
                                                  _selectedExercises1[index],
                                                  index,
                                                  _selectedExercises1);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises1.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises1.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises1.removeLast();
    });
    saveList1();
  }

  void _addNewExercise() async {
    var selectedExercise1 =
        await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise1 != null) {
      setState(() {
        _selectedExercises1.add(selectedExercise1);
      });

      saveList1();
    }
  }

  void saveList1() async {
    try {
      await firestore
          .collection('users0')
          .doc(user.email)
          .set({'list0': _selectedExercises1});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users0').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list0'] != null) {
        setState(() {
          _selectedExercises1 = List<String>.from(data['list0']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList1 extends StatefulWidget {
  @override
  _MyDynamicListState1 createState() => _MyDynamicListState1();
}

class _MyDynamicListState1 extends State<MyDynamicList1> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  List<String> _selectedExercises1 = [];
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Series'] != null) {
        setState(() {});
        return data['Series'] as int;
      }
    }

    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Reps'] != null) {
        return data['Reps'] as int;
      }
    }
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Break'] != null) {
        return data['Break'] as int;
      }
    }
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises1[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises1[index]))
          .first
          .titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises1, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises1[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                    InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  1,
                                                  _selectedExercises1[index],
                                                  index,
                                                  _selectedExercises1);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises1.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises1.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises1.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise1 =
        await Navigator.push(context, _createRoute(Wybor()));

    setState(() {
      _selectedExercises1.add(selectedExercise1);
    });

    saveList();
  }

  void saveList() async {
    try {
      await firestore
          .collection('users1')
          .doc(user.email)
          .set({'list1': _selectedExercises1});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users1').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list1'] != null) {
        setState(() {
          _selectedExercises1 = List<String>.from(data['list1']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList2 extends StatefulWidget {
  @override
  _MyDynamicListState2 createState() => _MyDynamicListState2();
}

class _MyDynamicListState2 extends State<MyDynamicList2> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  List<String> _selectedExercises1 = [];
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Series'] != null) {
        setState(() {});
        return data['Series'] as int;
      }
    }

    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Reps'] != null) {
        return data['Reps'] as int;
      }
    }
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Break'] != null) {
        return data['Break'] as int;
      }
    }
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises1[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises1[index]))
          .first
          .titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises1, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises1[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                             InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  2,
                                                  _selectedExercises1[index],
                                                  index,
                                                  _selectedExercises1);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises1.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises1.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises1.removeLast();
    });
    saveList1();
  }

  void _addNewExercise() async {
    var selectedExercise1 =
        await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise1 != null) {
      setState(() {
        _selectedExercises1.add(selectedExercise1);
      });

      saveList1();
    }
  }

  void saveList1() async {
    try {
      await firestore
          .collection('users2')
          .doc(user.email)
          .set({'list2': _selectedExercises1});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users2').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list2'] != null) {
        setState(() {
          _selectedExercises1 = List<String>.from(data['list2']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList3 extends StatefulWidget {
  @override
  _MyDynamicListState3 createState() => _MyDynamicListState3();
}

class _MyDynamicListState3 extends State<MyDynamicList3> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  List<String> _selectedExercises1 = [];
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Series'] != null) {
        setState(() {});
        return data['Series'] as int;
      }
    }

    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Reps'] != null) {
        return data['Reps'] as int;
      }
    }
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    DocumentSnapshot snapshot = await firestore
        .collection('WłasnyTrening$trainingID - ${_selectedExercises1[id]}')
        .doc("${user.email}")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Break'] != null) {
        return data['Break'] as int;
      }
    }
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises1[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises1[index]))
          .first
          .titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises1.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises1, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises1[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises1[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })), InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  3,
                                                  _selectedExercises1[index],
                                                  index,
                                                  _selectedExercises1);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises1.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises1.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises1.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise1 =
        await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise1 != null) {
      setState(() {
        _selectedExercises1.add(selectedExercise1);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users3')
          .doc(user.email)
          .set({'list3': _selectedExercises1});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users3').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list3'] != null) {
        setState(() {
          _selectedExercises1 = List<String>.from(data['list3']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList4 extends StatefulWidget {
  @override
  _MyDynamicListState4 createState() => _MyDynamicListState4();
}

class _MyDynamicListState4 extends State<MyDynamicList4> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }

  List<String> _selectedExercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })), InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  4,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users4')
          .doc(user.email)
          .set({'list4': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users4').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list4'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list4']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList5 extends StatefulWidget {
  const MyDynamicList5({super.key});

  @override
  _MyDynamicListState5 createState() => _MyDynamicListState5();
}

class _MyDynamicListState5 extends State<MyDynamicList5> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  List<String> _selectedExercises = [];
  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                             InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  5,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users5')
          .doc(user.email)
          .set({'list5': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users5').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list5'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list5']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList6 extends StatefulWidget {
  @override
  _MyDynamicListState6 createState() => _MyDynamicListState6();
}

class _MyDynamicListState6 extends State<MyDynamicList6> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }

  List<String> _selectedExercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })), InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  6,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users6')
          .doc(user.email)
          .set({'list6': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users6').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list6'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list6']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList7 extends StatefulWidget {
  @override
  _MyDynamicListState7 createState() => _MyDynamicListState7();
}

class _MyDynamicListState7 extends State<MyDynamicList7> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }

  List<String> _selectedExercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                             InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  7,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users7')
          .doc(user.email)
          .set({'list7': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users7').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list7'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list7']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList8 extends StatefulWidget {
  @override
  _MyDynamicListState8 createState() => _MyDynamicListState8();
}

class _MyDynamicListState8 extends State<MyDynamicList8> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }

  List<String> _selectedExercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                             InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  8,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users8')
          .doc(user.email)
          .set({'list8': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users8').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list8'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list8']);
        });
      }
    } catch (e) {}
  }
}

class MyDynamicList9 extends StatefulWidget {
  @override
  _MyDynamicListState9 createState() => _MyDynamicListState9();
}

class _MyDynamicListState9 extends State<MyDynamicList9> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Future<int> getSeriesFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          setState(() {});
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getRepsFromFirestore(int id, int trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  Future<int> getBreakFromFirestore(int id, trainingID) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('WłasnyTrening$trainingID - ${_selectedExercises[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 5;
  }

  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return _selectedExercises[index];
    } else {
      return Exercises.where(
              (exercise) => exercise.title.contains(_selectedExercises[index]))
          .first
          .titlePL;
    }
  }
void _onReorder(int oldIndex, int newIndex) {
  setState(() {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _selectedExercises.removeAt(oldIndex);
    _selectedExercises.insert(newIndex, item);
  });
  saveList();
}

  List<String> _selectedExercises = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Container(
            //  width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Icon(
                  color: Color.fromARGB(200, 255, 255, 255),
                  Icons.arrow_back_ios,
                  size: 28,
                ),
              ),
            ),
          );
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () async {
                    List<int> series = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      series.add(await getSeriesFromFirestore(i, 0));
                    }
                    List<int> reps = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      reps.add(await getRepsFromFirestore(i, 0));
                    }
                    List<int> breakTime = [];
                    for (int i = 0; i < _selectedExercises.length; i++) {
                      breakTime.add(await getBreakFromFirestore(i, 0));
                    }
                    Navigator.push(
                        context,
                        _createRoute(Training2(
                            _selectedExercises, series, reps, breakTime)));
                  },
                  child: const Icon(
                    color: Color.fromARGB(200, 255, 255, 255),
                    Icons.play_arrow,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final selectedExercise = _selectedExercises[index];
                            final exercise = Exercises.firstWhere(
                              (exercise) =>
                                  exercise.title.contains(selectedExercise),
                            );
                            return exercise.namePage;
                          }),
                        );
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
                                    Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .isEmpty
                                        ? ''
                                        : Exercises.where((exercise) =>
                                                exercise.title.contains(
                                                    _selectedExercises[index]))
                                            .first
                                            .gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })), InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                140, 0, 0, 0),
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 7),
                                          child: InkWell(
                                            onTap: () {
                                              SeriesRepsBreakDialog(
                                                  context,
                                                  9,
                                                  _selectedExercises[index],
                                                  index,
                                                  _selectedExercises);
                                            },
                                            child: const Icon(
                                              size: 40,
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  180, 255, 255, 255),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _selectedExercises.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color.fromARGB(220, 8, 200, 33),
            onPressed: _addNewExercise,
            child: const Icon(Icons.add_rounded,
                color: Color.fromARGB(
                  160,
                  255,
                  255,
                  255,
                ),
                size: 50),
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isNotEmpty)
            FloatingActionButton(
              heroTag: 'remove',
              backgroundColor: const Color.fromARGB(140, 244, 67, 54),
              onPressed: _removeLastExercise,
              child: const Icon(Icons.remove_rounded,
                  color: Color.fromARGB(
                    160,
                    255,
                    255,
                    255,
                  ),
                  size: 55),
            ),
        ],
      ),
    );
  }

  void _removeLastExercise() {
    setState(() {
      _selectedExercises.removeLast();
    });
    saveList();
  }

  void _addNewExercise() async {
    var selectedExercise = await Navigator.push(context, _createRoute(Wybor()));

    if (selectedExercise != null) {
      setState(() {
        _selectedExercises.add(selectedExercise);
      });

      saveList();
    }
  }

  void saveList() async {
    try {
      await firestore
          .collection('users9')
          .doc(user.email)
          .set({'list9': _selectedExercises});
    } catch (e) {}
  }

  void getList() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users9').doc(user.email).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['list9'] != null) {
        setState(() {
          _selectedExercises = List<String>.from(data['list9']);
        });
      }
    } catch (e) {}
  }
}

class Wybor extends StatefulWidget {
  @override
  State<Wybor> createState() => _WyborState();
}

class _WyborState extends State<Wybor> {
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
      return Exercises[index].title;
    } else {
      return Exercises[index].titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Choose exercise to add',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Satoshi',
            color: Color.fromARGB(220, 255, 255, 255),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(false, true));
              },
              icon: const Icon(Icons.search))
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(
              context,
              null,
            );
          },
        ),
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
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.pop(
                        context,
                        Exercises[index].title,
                      ),
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
                                    Exercises[index].gifCode,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
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
                  childCount: Exercises.length,
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

class Training2 extends StatefulWidget {
  final List<String> wynikiTreningu;
  final List<int> series;
  final List<int> reps;
  final List<int> breakTime;

  Training2(this.wynikiTreningu, this.series, this.reps, this.breakTime,
      {super.key});

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
  State<Training2> createState() => _Training2State();
}

class _Training2State extends State<Training2> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final milliSecond = true;
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

  final List<int> _seriesList = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<int> _repsList = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    35
  ];
  final List<int> _breaksList = <int>[
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    120,
    130,
    140,
    150,
    160,
    170,
    180,
    190,
    200,
    210,
    220,
    230,
    240,
    250,
    260,
    270,
    280,
    290,
    300
  ];
  @override
  Widget build(BuildContext context) {
    Future<String> tytul(int index) async {
      String language = await getLanguage();
      if (language == "English") {
        return widget.wynikiTreningu[index];
      } else {
        return Exercises.where((exercise) =>
                exercise.title.contains(widget.wynikiTreningu[index])).isEmpty
            ? ''
            : Exercises.where((exercise) =>
                    exercise.title.contains(widget.wynikiTreningu[index]))
                .first
                .titlePL;
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
                            Exercises.where((exercise) => exercise.title
                                    .contains(widget
                                        .wynikiTreningu[currentIndex])).isEmpty
                                ? ''
                                : Exercises.where((exercise) => exercise.title
                                        .contains(widget
                                            .wynikiTreningu[currentIndex]))
                                    .first
                                    .gifCode,
                          ),
                          fit: BoxFit.fitWidth,
                        )),
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
                                    textAlign: TextAlign.center,
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
                                          "$seriesIndex/${_seriesList[widget.series[currentIndex]]}",
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
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              _createRoute(TrainingPace(
                                  i1: 4, i2: 1, i3: 2, i4: 1, i5: 12))),
                          child: Container(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.width * 0.32,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Center(
                                        child: FutureBuilder(
                                          future: Reps(),
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
                                          //key:Key(currentIndex.toString()),
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return FadeTransition(
                                                opacity: animation,
                                                child: child);
                                          },
                                          child: Text(
                                            key: ValueKey<int>(currentIndex),
                                            "${_repsList[widget.reps[currentIndex]]}",
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
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
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
                        Container(
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
                        Container(
                          //margin: EdgeInsets.all(70),
                          width: 135,
                          height: 85,
                          child: InkWell(
                            onTap: () {
                              if (seriesIndex.toInt() > 0) {
                                final matchingExercises = Exercises.where(
                                        (exercise) => exercise.title.contains(
                                            widget
                                                .wynikiTreningu[currentIndex]))
                                    .toList();

                                if (matchingExercises.isEmpty) {
                                } else {
                                  final exerciseSeries =
                                      _seriesList[widget.series[currentIndex]];
                                  if (currentIndex + 1 ==
                                          widget.wynikiTreningu.length &&
                                      seriesIndex == exerciseSeries) {
                                    EndDialog(context, widget.wynikiTreningu);
                                  } else if (seriesIndex < exerciseSeries) {
                                    seriesIndex += 1;
                                    TimerDialog(
                                      context,
                                      _breaksList[
                                          widget.breakTime[currentIndex]],
                                    );
                                    changeData(0);
                                  } else if (seriesIndex == exerciseSeries) {
                                    TimerDialog(
                                      context,
                                      _breaksList[
                                          widget.breakTime[currentIndex]],
                                    );
                                    seriesIndex = 1;
                                    changeData(1);
                                  } else {
                                    changeData(1);
                                    seriesIndex = 1;
                                  }
                                }
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
Future TimerDialog(BuildContext context, int breakSeconds) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: breakSeconds - 10), () {
        playSound();
      });
      return Dialog(
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
                width:
                    double.infinity, // Make sure the Stack takes the full width
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
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyStatefulWidget(),
                            ),
                          );
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
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgressPage(0),
                            ),
                          );
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

Future SeriesRepsBreakDialog(BuildContext context, int id, String tytul,
    int index, List<String> selectedExercises) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return BreakItpDialog(id, tytul, selectedExercises, index);
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

class BreakItpDialog extends StatefulWidget {
  final List<String> _selectedExercises1;
  final int id;
  final String tytul;
  final int index;
  BreakItpDialog(this.id, this.tytul, this._selectedExercises1, this.index,
      {super.key});

  @override
  State<BreakItpDialog> createState() => _BreakItpDialogState();
}

class _BreakItpDialogState extends State<BreakItpDialog> {
  // ignore: unused_field
  final ConnectionState _connectionState = ConnectionState.none;
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

  late int selectedSeries;
  late int selectedReps;
  late int selectedBreak;

  @override
  void initState() {
    super.initState();

    // Inicjalizacja wartości początkowych
    selectedSeries = 1;
    selectedReps = 5;
    selectedBreak = 5;

    // Pobranie wartości z Firestore i aktualizacja zmiennych stanu
    fetchFirestoreValues();
  }

  Future<void> fetchFirestoreValues() async {
    selectedSeries = await getSeriesFromFirestore(widget.index, widget.id);
    selectedReps = await getRepsFromFirestore(widget.index, widget.id);
    selectedBreak = await getBreakFromFirestore(widget.index, widget.id);

    setState(() {});
  }

  final double _kItemExtent = 32.0;
  final List<int> _seriesList = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<int> _repsList = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    35
  ];
  final List<int> _breaksList = <int>[
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    120,
    130,
    140,
    150,
    160,
    170,
    180,
    190,
    200,
    210,
    220,
    230,
    240,
    250,
    260,
    270,
    280,
    290,
    300
  ];
  Future<String> Series() async {
    int actualSeries = selectedSeries;
    String language = await getLanguage();
    if (language == "English") {
      return "Series: ${_seriesList[actualSeries].toString()}";
    } else {
      return "Serie: ${_seriesList[actualSeries].toString()}";
    }
  }

  Future<String> Reps() async {
    String language = await getLanguage();
    if (language == "English") {
      return "Reps: ${_repsList[selectedReps].toString()}";
    } else {
      return "Powtórzenia: ${_repsList[selectedReps].toString()}";
    }
  }

  Future<List<int>> ListaWyboru() async {
    return [selectedSeries, selectedReps, selectedBreak];
  }

  Future<String> Break() async {
    int actualBreak = selectedBreak;
    String language = await getLanguage();
    if (language == "English") {
      return "Break [s]: ${_breaksList[actualBreak].toString()}";
    } else {
      return "Przerwa [s]: ${_breaksList[actualBreak].toString()}";
    }
  }

  void saveUserDataTraining(
      int id, String tytul, int series, int reps, int breakTime) async {
    try {
      await firestore
          .collection('WłasnyTrening$id - $tytul')
          .doc("${user.email}")
          .set({
        'Series': series,
        'Reps': reps,
        'Break': breakTime,
      });
      setState(() {});
    } catch (e) {}
  }

  Future<int> getSeriesFromFirestore(int id, int IdTraining) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(
              'WłasnyTrening$IdTraining - ${widget._selectedExercises1[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Series'] != null) {
          return data['Series'] as int;
        }
      }
    } catch (e) {}
    return 0;
  }

  Future<int> getRepsFromFirestore(int id, int IdTraining) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(
              'WłasnyTrening$IdTraining - ${widget._selectedExercises1[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Reps'] != null) {
          return data['Reps'] as int;
        }
      }
    } catch (e) {}
    return 1;
  }

  Future<int> getBreakFromFirestore(int id, int IdTraining) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(
              'WłasnyTrening$IdTraining - ${widget._selectedExercises1[id]}')
          .doc("${user.email}")
          .get();

      if (snapshot.exists) {
        // Print debug information
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['Break'] != null) {
          return data['Break'] as int;
        }
      }
    } catch (e) {}
    return 3;
  }

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //MaxGap(60),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(220, 0, 0, 0),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<List<int>>(
                        future: ListaWyboru(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedSeries,
                              ),
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  selectedSeries = selectedItem;
                                  // Zapisanie aktualnych wartości do Firestore lub gdziekolwiek indziej
                                  saveUserDataTraining(
                                      widget.id,
                                      widget.tytul,
                                      selectedSeries,
                                      selectedReps,
                                      selectedBreak);
                                });
                              },
                              children: List<Widget>.generate(
                                _seriesList.length,
                                (int index) {
                                  return Center(
                                    child: Text(_seriesList[index].toString()),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                          return const Text("");
                        },
                      );
                    },
                  );
                },
                child: Center(
                  child: FutureBuilder(
                    future: Series(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(220, 255, 255, 255),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(180, 255, 255, 255),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(220, 0, 0, 0)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder(
                        future: ListaWyboru(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              scrollController: FixedExtentScrollController(
                                initialItem: snapshot.data?[1] ?? 0,
                              ),
                              onSelectedItemChanged: (int selectedItem1) {
                                setState(() {
                                  selectedReps = selectedItem1;
                                  // Zapisanie aktualnych wartości do Firestore lub gdziekolwiek indziej
                                  saveUserDataTraining(
                                      widget.id,
                                      widget.tytul,
                                      selectedSeries,
                                      selectedReps,
                                      selectedBreak);
                                });
                              },
                              children: List<Widget>.generate(_repsList.length,
                                  (int index) {
                                return Center(
                                    child: Text(_repsList[index].toString()));
                              }),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                          return const Text("");
                        },
                      );
                    },
                  );
                },
                child: Center(
                    child: FutureBuilder(
                        future: Reps(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              snapshot.data ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Satoshi',
                                color: Color.fromARGB(220, 255, 255, 255),
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                        })),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(220, 0, 0, 0)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder(
                        future: ListaWyboru(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              scrollController: FixedExtentScrollController(
                                initialItem: snapshot.data != null
                                    ? snapshot.data![2]
                                    : 0,
                              ),
                              onSelectedItemChanged: (int selectedItem2) {
                                setState(() {
                                  selectedBreak = selectedItem2;
                                  // Zapisanie aktualnych wartości do Firestore lub gdziekolwiek indziej
                                  saveUserDataTraining(
                                      widget.id,
                                      widget.tytul,
                                      selectedSeries,
                                      selectedReps,
                                      selectedBreak);
                                });
                              },
                              children: List<Widget>.generate(
                                  _breaksList.length, (int index) {
                                return Center(
                                    child: Text(_breaksList[index].toString()));
                              }),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                          return const Text("");
                        },
                      );
                    },
                  );
                },
                child: Center(
                    child: FutureBuilder(
                        future: Break(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              snapshot.data ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Satoshi',
                                color: Color.fromARGB(220, 255, 255, 255),
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                        })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
