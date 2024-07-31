import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ucze_sie_swiry/main.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';

// ignore: must_be_immutable
class TrainingPace extends StatefulWidget {
  double i1;
  double i2;
  double i3;
  double i4;
  double i5;
  TrainingPace(
      {super.key,
      required this.i2,
      required this.i3,
      required this.i4,
      required this.i5,
      required this.i1});

  @override
  State<TrainingPace> createState() => _TrainingPaceState();
}

class _TrainingPaceState extends State<TrainingPace> {
  int timeIndex = 0;
  int licznik = 0;
  int powtorzenia = 1;
  Future<List<String>> ENG() async {
    String language = await getLanguage();
    if (language == "English") {
      return [
        "Eccentric: ",
        "Isometric (1): ",
        "Concentric: ",
        "Isometric (2): ",
        "Reps: ",
      ];
    } else {
      return [
        "Faza ekscentryczna: ",
        "Faza izometryczna (1): ",
        "Faza koncentryczna: ",
        "Faza izometryczna (2): ",
        "Powtórzenia: ",
      ];
    }
  }

  Future<String> Opis() async {
    String language = await getLanguage();
    if (language == "English") {
      return '''Tempo in strength training refers to the speed at which different phases of movement during exercises are performed. It's defined by a sequence of numbers, each representing the duration of a specific phase of movement. Typically, tempo is expressed in a four-digit format.


An example could be denoted as 4121 x 12, where:

The first digit (4) represents the lowering phase of the movement (eccentric phase) and lasts for 4 seconds.

The second digit (1) signifies the pause at the bottom of the movement (often at the stretched position) and is 1 second.

The third digit (2) represents the lifting phase of the movement (widget.i3 phase) and takes 2 seconds.

The fourth digit (1) indicates the pause at the top of the movement (often at the contracted muscle position) and also lasts for 1 second.

In the case of x 12, it means performing 12 repetitions at that particular tempo.'''
          '';
    } else {
      return '''Tempo w treningu siłowym odnosi się do szybkości wykonywania poszczególnych faz ruchu podczas ćwiczeń. Jest określone za pomocą sekwencji liczb, z których każda reprezentuje czas trwania konkretnej fazy ruchu. Standardowo tempo jest wyrażane w formacie czterech cyfr.


Przykładem może być oznaczenie ćwiczenia jako 4121 x 12, gdzie:

Pierwsza cyfra (4) oznacza czas opuszczania ciężaru (ekscentryczna faza ruchu) i jest to 4 sekundy.

Druga cyfra (1) oznacza pauzę na dole ruchu (często w pozycji rozciągniętej) i jest to 1 sekunda.

Trzecia cyfra (2) reprezentuje podnoszenie ciężaru (koncentryczna faza ruchu) i trwa 2 sekundy.

Czwarta cyfra (1) to pauza na górze ruchu (często w pozycji skurczu mięśniowego) i również trwa 1 sekundę.

W przypadku oznaczenia x 12 oznacza to wykonanie 12 powtórzeń przy takim właśnie tempie.''';
    }
  }

  final ConnectionState _connectionState = ConnectionState.none;
  Future<void> opis() {
    return showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              child: AlertDialog(
            backgroundColor: Color.fromARGB(214, 255, 255, 255),
            title: Container(
              height: 600,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: Opis(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return Text(
                            snapshot.data ??
                                '', // Use the title or a default value
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                                color: Color.fromARGB(200, 30, 30, 30)));
                      } else {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(180, 255, 255, 255),
                        );
                      }
                    }),
              ),
            ),
          ));
        });
  }
  BuildContext? currentContext;
  Future<void> _dialogBuilder(
      BuildContext context, int i1, int i2, int i3, int i4, int i5) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        currentContext = context;
        Color kolor() {
          return const Color.fromARGB(214, 255, 255, 255);
        }

        List<int> lista() {
          return [i1, i2, i3, i4];
        }

        if (lista()[timeIndex] == 0 && timeIndex != 3) {
          timeIndex++;
          licznik++;
        }
        if (timeIndex == 3 && licznik != widget.i5 * 4 && lista()[3] == 0) {
          timeIndex = 0;
          powtorzenia++;
          licznik++;
        }
        if (licznik == widget.i5 * 4) {
          Navigator.of(context).pop();
          timeIndex = 0;
          powtorzenia = 1;
          licznik = 0;
        }
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SizedBox(
            width: 900,
            child: AlertDialog(
              backgroundColor: kolor(),
              title: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '$i1 ',
                        style: timeIndex == 0
                            ? const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                           
                                color: Color.fromARGB(190, 9, 143, 42),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)
                            : const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(215, 5, 5, 5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                      ),
                      TextSpan(
                        text: '$i2 ',
                        style: timeIndex == 1
                            ? const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(190, 9, 143, 42),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)
                            : const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(215, 5, 5, 5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                      ),
                      TextSpan(
                        text: '$i3 ',
                        style: timeIndex == 2
                            ? const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(190, 9, 143, 42),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)
                            : const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(215, 5, 5, 5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                      ),
                      TextSpan(
                        text: '$i4  ',
                        style: timeIndex == 3
                            ? const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(190, 9, 143, 42),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)
                            : const TextStyle(
                               fontSize: 42,
                                 fontFamily: "Satoshi",
                                color: Color.fromARGB(215, 5, 5, 5),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                      ),
                      TextSpan(
                        text: 'x  $powtorzenia',
                        style: const TextStyle(
                           fontSize: 42,
                                 fontFamily: "Satoshi",
                            color: Color.fromARGB(215, 5, 5, 5),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              content: SizedBox(
                height: 280,
                width: 900,
                child: Countdown(
                  seconds: lista()[timeIndex],
                  build: (BuildContext context, double time) => Container(
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 175,
                            width: 175,
                            child: CircularProgressIndicator(
                              strokeAlign:
                                  CircularProgressIndicator.strokeAlignCenter,
                              value: 1 - time / lista()[timeIndex],
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
                   // playSound();
                    licznik++;
                    if (licznik == widget.i5 * 4) {
                      Navigator.of(context).pop();
                      timeIndex = 0;
                      powtorzenia = 1;
                      licznik = 0;
                      return 0;
                    } else if (timeIndex == 3 && licznik != widget.i5 * 4) {
                      powtorzenia++;
                      timeIndex = -1;

                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }

                    _dialogBuilder(context, i1, i2, i3, i4, i5);
                    timeIndex++;
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CrossFadePageRoute(
                        builder: (context) => TrainingPace(
                          i1: widget.i1,
                          i2: widget.i2,
                          i3: widget.i3,
                          i4: widget.i4,
                          i5: widget.i5,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ENG(),
      builder: (context, snapshot) {
        if (_connectionState == ConnectionState.none) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: (() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyStatefulWidget()));
                  }),
                  icon: Icon(Icons.arrow_back_ios)),
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text('Tempo',
                  style: TextStyle(
                      fontSize: 21,
                      fontFamily: 'Satoshi',
                      color: Color.fromARGB(255, 28, 28, 28))),
              backgroundColor: const Color.fromARGB(0, 255, 255, 255),
              elevation: 0,
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("images/tlo18.jpg"),
                    opacity: 0.8,
                    fit: BoxFit.cover,
                  )),
                ),
                SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.i1.toInt()} ${widget.i2.toInt()} ${widget.i3.toInt()} ${widget.i4.toInt()}  x  ${widget.i5.toInt()}",
                            style: const TextStyle(
                             fontSize: 42,
                               
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const MaxGap(50),
                          Text(
                              "${snapshot.data?[0]}${widget.i1.toStringAsFixed(0)} s",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(215, 5, 5, 5))),
                          Slider(
                              activeColor:
                                  const Color.fromARGB(170, 10, 10, 10),
                              inactiveColor:
                                  const Color.fromARGB(120, 35, 34, 34),
                              value: widget.i1,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: widget.i1.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  widget.i1 = value;
                                });
                              }),
                          const MaxGap(40),
                          Text(
                              "${snapshot.data?[1]}${widget.i2.toStringAsFixed(0)} s",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(215, 5, 5, 5))),
                          Slider(
                              activeColor:
                                  const Color.fromARGB(170, 10, 10, 10),
                              inactiveColor:
                                  const Color.fromARGB(120, 35, 34, 34),
                              value: widget.i2,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: widget.i2.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  widget.i2 = value;
                                });
                              }),
                          const MaxGap(40),
                          Text(
                              "${snapshot.data?[2]}${widget.i3.toStringAsFixed(0)} s",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(215, 5, 5, 5))),
                          Slider(
                              activeColor:
                                  const Color.fromARGB(170, 10, 10, 10),
                              inactiveColor:
                                  const Color.fromARGB(120, 35, 34, 34),
                              value: widget.i3,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: widget.i3.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  widget.i3 = value;
                                });
                              }),
                          const MaxGap(40),
                          Text(
                              "${snapshot.data?[3]}${widget.i4.toStringAsFixed(0)} s",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(215, 5, 5, 5))),
                          Slider(
                              activeColor:
                                  const Color.fromARGB(170, 10, 10, 10),
                              inactiveColor:
                                  const Color.fromARGB(120, 35, 34, 34),
                              value: widget.i4,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: widget.i4.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  widget.i4 = value;
                                });
                              }),
                          const MaxGap(40),
                          Text(
                              "${snapshot.data?[4]}${widget.i5.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Satoshi',
                                  color: Color.fromARGB(215, 5, 5, 5))),
                          Slider(
                              activeColor:
                                  const Color.fromARGB(170, 10, 10, 10),
                              inactiveColor:
                                  const Color.fromARGB(120, 35, 34, 34),
                              value: widget.i5,
                              min: 1,
                              max: 30,
                              divisions: 29,
                              label: widget.i5.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  widget.i5 = value;
                                });
                              }),
                          const MaxGap(30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              shadowColor:
                                  const Color.fromARGB(15, 15, 214, 48),
                              backgroundColor:
                                  const Color.fromARGB(60, 8, 104, 24),
                            ),
                            onPressed: () {
                              setState(() {
                                licznik = 0;
                                powtorzenia = 1;
                                timeIndex = 0;
                              });
                              _dialogBuilder(
                                  context,
                                  widget.i1.toInt(),
                                  widget.i2.toInt(),
                                  widget.i3.toInt(),
                                  widget.i4.toInt(),
                                  widget.i5.toInt());
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("START",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'Satoshi',
                                        color: Color.fromARGB(215, 5, 5, 5))),
                                Icon(
                                  Icons.play_arrow,
                                  size: 40,
                                  color: Color.fromARGB(199, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          const MaxGap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                      onPressed: (() {
                                        opis();
                                      }),
                                      icon: const Icon(
                                        Icons.info,
                                        color: Color.fromARGB(199, 0, 0, 0),
                                        size: 30,
                                      )))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                  ],
                )),
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
    );
  }
}

class CrossFadePageRoute<T> extends MaterialPageRoute<T> {
  CrossFadePageRoute({required WidgetBuilder builder})
      : super(
          builder: builder,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = 0.0;
    const end = 1.0;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    var fadeAnimation = animation.drive(tween);

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}