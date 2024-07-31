// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:ucze_sie_swiry/lists/SuplementsList.dart';
import 'package:webview_flutter/webview_flutter.dart';



class SuplementPage extends StatelessWidget {
  int i;
  SuplementPage(this.i, {super.key});
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
      return Suplementss[index].title;
    } else {
      return Suplementss[index].titlePL;
    }
  }

  Future<String> Opis(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return Suplementss[index].text;
    } else {
      return Suplementss[index].textPL;
    }
  }

  Future<String> PrzyciskKup() async {
    String language = await getLanguage();
    if (language == "English") {
      return "Buy";
    } else {
      return "Kup";
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
          title: FutureBuilder(
              future: Tytul(i - 1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Text(
                      snapshot.data ?? '', // Use the title or a default value
                      style: const TextStyle(
                          fontSize: 21,
                          fontFamily: 'Satoshi',
                          color: Color.fromARGB(210, 255, 255, 255)));
                } else {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(255, 66, 66, 66),
                  );
                }
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: double.maxFinite,
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
                      width: 225,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(70, 255, 255, 255),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25))),
                      child: Center(
                          child: Image.asset(Suplementss[i - 1].pngCode))),
                  Container(
                      padding: const EdgeInsets.all(12),
                      child: FutureBuilder(
                          future: Opis(i - 1),
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
                                    color:
                                        Color.fromARGB(210, 255, 255, 255)),
                                trimLines: 13,
                                colorClickableText:
                                    const Color.fromRGBO(255, 255, 255, 1),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '  READ MORE ',
                                trimExpandedText: ' SHOW LESS ',
                                moreStyle: const TextStyle(
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color:
                                          Color.fromARGB(150, 255, 255, 255),
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
                                      color:
                                          Color.fromARGB(150, 255, 255, 255),
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
                                color: Color.fromARGB(255, 159, 159, 159),
                              );
                            }
                          })),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          _createRoute(
                            WebViewApp(
                              Suplementss[i - 1].title,
                              Suplementss[i - 1].url,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                color: Color.fromARGB(170, 225, 68, 11)),
                            width: 155,
                            height: 80,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                      future: PrzyciskKup(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          return Text(
                                              snapshot.data ??
                                                  '', // Use the title or a default value
                                              style: const TextStyle(
                                                  fontSize: 32,
                                                  fontFamily: 'Satoshi',
                                                  color: Color.fromARGB(
                                                      205, 255, 255, 255)));
                                        } else {
                                          return const CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                180, 128, 128, 128),
                                          );
                                        }
                                      }),
                                  const MaxGap(10),
                                  const Icon(Icons.sell_rounded,
                                      color:
                                          Color.fromARGB(205, 255, 255, 255),
                                      size: 25)
                                ],
                              ),
                            )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebViewApp extends StatefulWidget {
  final String title;
  final String selectedUrl;
  const WebViewApp(this.title, this.selectedUrl, {super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.selectedUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Satoshi',
                color: Color.fromARGB(255, 66, 66, 66))),
      ),
      body: WebViewWidget(controller: controller),
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
