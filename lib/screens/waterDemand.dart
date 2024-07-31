import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';

class WaterDemand extends StatefulWidget {
  const WaterDemand({super.key});

  @override
  State<WaterDemand> createState() => _WaterDemandState();
}

class _WaterDemandState extends State<WaterDemand> {
  String data =
      "${DateTime.now().day} : ${DateTime.now().month} : ${DateTime.now().year}";
  double waterNow = 0;
  double waterGoal = 3;

  Future<String> Cel() async {
    String language = await getLanguage();
    if (language == "English") {
      return "Goal: ";
    } else {
      return "Cel: ";
    }
  }

  void saveUserData(double waterGoal, double waterNow) async {
    try {
      String userCollection = 'Water'; // Consistent collection name
      await firestore.collection(userCollection).doc(user.email).set({
        'waterGoal': waterGoal,
        'waterDemand': waterNow,
        'data': data,
      });
    } catch (e) {}
    setState(() {});
  }

  Future<double> getWaterGoal() async {
    try {
      String userCollection = 'Water';
      DocumentSnapshot document =
          await firestore.collection(userCollection).doc(user.email).get();

      if (document.exists) {
        var data = document.data() as Map<String, dynamic>;
        var waterGoal = data['waterGoal'];

        if (waterGoal != null) {
          return waterGoal.toDouble();
        }
      }

      return 4; // or any default value if 'waterGoal' is not found
    } catch (e) {
      return 0; // or any default value indicating an error
    }
  }

  Future<double> getWaterDemand() async {
    try {
      String userCollection = 'Water';
      DocumentSnapshot document =
          await firestore.collection(userCollection).doc(user.email).get();

      if (document.exists) {
        var data = document.data() as Map<String, dynamic>;
        double waterDemand = data['waterDemand'];
        return waterDemand;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<String> getData() async {
    try {
      String newData = "";
      String userCollection = 'Water';
      DocumentSnapshot document =
          await firestore.collection(userCollection).doc(user.email).get();

      if (document.exists) {
        var data = document.data() as Map<String, dynamic>;
        String newData = data['data'];
        return newData;
      }
      return newData;
    } catch (e) {
      return "";
    }
  }

  @override
  void initState() {
    fetchWaterValues();
    super.initState();
  }

  void fetchWaterValues() async {
    String newData = await getData();
    double retrievedWaterGoal = await getWaterGoal();
    double retrievedWaterDemand = await getWaterDemand();

    setState(() {
      if (newData == data) {
        waterGoal = retrievedWaterGoal;
        waterNow = retrievedWaterDemand;
      } else {
        waterGoal = retrievedWaterGoal;
        waterNow = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentage;
    if (waterNow == 0) {
      percentage = 0;
    } else {
      percentage = waterNow / waterGoal;
    }
    ConnectionState connectionState = ConnectionState.none;
    return Scaffold(
      backgroundColor: const Color.fromARGB(205, 0, 0, 0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/waterBackground.jpg"),
            fit: BoxFit.cover,
            opacity: 0.45,
          ),
          color: Color.fromARGB(160, 255, 255, 255),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const MaxGap(20),
              Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: Text(
                          "${waterNow.toString()}L  /  ${waterGoal}L",
                          style: const TextStyle(
                              fontFamily: "Satoshi",
                              fontSize: 36,
                              color: Color.fromARGB(180, 14, 28, 131)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        strokeAlign:
                            CircularProgressIndicator.strokeAlignCenter,
                        value: percentage,
                        strokeWidth: 5.5,
                        backgroundColor: const Color.fromARGB(20, 7, 43, 220),
                        valueColor: const AlwaysStoppedAnimation(
                          Color.fromARGB(180, 60, 77, 164),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 120,),
              FutureBuilder(
                future: Cel(),
                builder: (context, snapshot) {
                  if (connectionState == ConnectionState.none) {
                    return Text(
                      snapshot.data ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "Satoshi",
                          fontSize: 32,
                          color: Color.fromARGB(200, 14, 28, 131)),
                    );
                  } else if (connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Color.fromARGB(180, 255, 255, 255),
                    );
                  }
                  return const Text("");
                },
              ),
              const MaxGap(12),
              SizedBox(
                width: 350,
                child: Slider(
                  inactiveColor: const Color.fromARGB(120, 60, 77, 164),
                  activeColor: const Color.fromARGB(200, 60, 77, 164),
                  value: waterGoal,
                  max: 12,
                  min: 1,
                  divisions: 22,
                  label: waterGoal.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      waterGoal = value;
                      saveUserData(waterGoal, waterNow);
                    });
                  },
                ),
              ),
              const MaxGap(
                40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    style: const ButtonStyle(
                        iconSize: MaterialStatePropertyAll(40),
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(140, 255, 0, 0))),
                    onPressed: () {
                      setState(() {
                        waterNow -= 0.25;
                        saveUserData(waterGoal, waterNow);
                      });
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                    // color: Color.fromARGB(255, 255, 0, 0),
                  ),
                  
                  IconButton(
                    style: const ButtonStyle(
                      iconSize: MaterialStatePropertyAll(40),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(139, 63, 216, 7)),
                    ),
                    onPressed: () {
                      setState(() {
                        waterNow += 0.25;
                        saveUserData(waterGoal, waterNow);
                      });
                    },
                    icon: const Icon(
                      color: Color.fromARGB(150, 0, 0, 0),
                      Icons.add,
                    ),
                  ),
                ],
              ),
              MaxGap(20)
            ],
          ),
        ),
      ),
    );
  }
}
