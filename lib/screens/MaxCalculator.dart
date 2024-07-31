import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:ucze_sie_swiry/screens/Menu.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';

class MaxCaluclator extends StatefulWidget {
  MaxCaluclator({super.key});
  @override
  State<MaxCaluclator> createState() => _MaxCaluclatorState();
}

class _MaxCaluclatorState extends State<MaxCaluclator> {
  double Reps = 6;
  double Weight = 52.5;
  String getResult() {
    double Result = Weight * Reps * 0.0333 + Weight;
    return Result.toStringAsFixed(0);
  }

  Future<List<String>> ENG() async {
    String language = await getLanguage();
    if (language == "English") {
      return [
        "Your one rep max: ",
        "Weight: ",
        "Reps: ",
        "*this calcualtor works for every exercise*",
      ];
    } else {
      return [
        "Twój max na powtórzenie: ",
        "Ciężar: ",
        "Powtórzenia: ",
        "*ten kalkulator działa dla każdego ćwiczenia*",
      ];
    }
  }

  ConnectionState _connectionState = ConnectionState.none;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ENG(),
      builder: (context, snapshot) {
        if (_connectionState == ConnectionState.none) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text('Max calcuator',
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
                    image: AssetImage("images/tlo14.jpg"),
                    opacity: 0.75,
                    fit: BoxFit.cover,
                  )),
                ),
                SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const MaxGap(30),
                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color.fromARGB(70, 10, 10, 10),
                              Color.fromARGB(30, 20, 20, 20),
                            ],
                            tileMode: TileMode.mirror),
                      ),
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('${snapshot.data?[0]}',
                            
                              textAlign: TextAlign.center,
                                  style:  TextStyle(
                                      fontSize: MediaQuery.of(context).size.width*0.044,
                                      fontFamily: 'Satoshi',
                                      color: Color.fromARGB(215, 5, 5, 5))),
                            ),
                             Center(
                              child: Text('${getResult()}Kg',
                            
                              textAlign: TextAlign.center,
                                  style:  TextStyle(
                                      fontSize: MediaQuery.of(context).size.width*0.05,
                                      fontFamily: 'Satoshi',
                                      color: Color.fromARGB(240, 5, 5, 5))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const MaxGap(30),
                    Text("${snapshot.data?[1]}${Weight.toStringAsFixed(1)} Kg",
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(215, 5, 5, 5))),
                    Slider(
                        activeColor: const Color.fromARGB(170, 10, 10, 10),
                        inactiveColor: const Color.fromARGB(120, 35, 34, 34),
                        value: Weight,
                        min: 15,
                        max: 300,
                        divisions: 114,
                        label: Weight.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            Weight = value;
                          });
                        }),
                    Text("${snapshot.data?[2]}${Reps.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(215, 5, 5, 5))),
                    Slider(
                        activeColor: const Color.fromARGB(170, 10, 10, 10),
                        inactiveColor: const Color.fromARGB(120, 35, 34, 34),
                        value: Reps,
                        min: 1,
                        max: 14,
                        divisions: 13,
                        label: Reps.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            Reps = value;
                          });
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("${snapshot.data?[3]}",
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(255, 91, 91, 91))),
                    const MaxGap(130),
                    AdWidget(true),
                    SizedBox(height: 10,)
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
