import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:ucze_sie_swiry/screens/Menu.dart';

class CreatingExercisePage extends StatelessWidget {
  final int i;
  final String image;
  final String opis;
  final String opisPL;
  CreatingExercisePage(this.i, this.image, this.opis, this.opisPL);
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

  Future<String> Opis() async {
    String language = await getLanguage();
    if (language == "English") {
      return opis;
    } else {
      return opisPL;
    }
  }

  Future<String> Miesnie() async {
    String language = await getLanguage();
    if (language == "English") {
      return ("Used muscels: ${Exercises[i - 1].bodyPart}");
    } else {
      return ("Wykorzystwane mięśnie: ${Exercises[i - 1].czesciCiala}");
    }
  }

  Future<String> Tytul() async {
    String language = await getLanguage();
    if (language == "English") {
      return Exercises[i - 1].title;
    } else {
      return Exercises[i - 1].titlePL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: FutureBuilder(
              future: Tytul(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Text(snapshot.data ?? '',
                      softWrap: true,
                       textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 21,
                          fontFamily: 'Satoshi',
                          color: Color.fromARGB(210, 255, 255, 255)));
                } else {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(180, 255, 255, 255),
                  );
                }
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(240, 0, 0, 0),
                  Color.fromARGB(230, 20, 20, 20),
                ],
                tileMode: TileMode.mirror),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(70, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Image.asset(image),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: FutureBuilder(
                        future: Miesnie(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            return Text(snapshot.data ?? '',
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Satoshi',
                                    color:
                                        Color.fromARGB(210, 255, 255, 255)));
                          } else {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: FutureBuilder(
                        future: Opis(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            return ReadMoreText(
                              snapshot.data ?? '',
                              // softWrap: true,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(210, 255, 255, 255)),
                              trimLines: 7,
                              colorClickableText:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '  READ MORE ',
                              trimExpandedText: ' SHOW LESS ',
                              moreStyle: const TextStyle(
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Color.fromARGB(150, 255, 255, 255),
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ],
                                fontSize: 13,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'Satoshi',
                              ),
                              lessStyle: const TextStyle(
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Color.fromARGB(150, 255, 255, 255),
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ],
                                fontSize: 13,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'Satoshi',
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: Color.fromARGB(180, 255, 255, 255),
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      margin: const EdgeInsets.all(10),
                      child: AdWidget(false)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
