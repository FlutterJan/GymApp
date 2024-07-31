import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';


class CustomSearchDelegate extends SearchDelegate<List<String>> {
  bool czyDodawanie;
  bool czyProgress;
  CustomSearchDelegate(this.czyProgress, this.czyDodawanie);

  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<List<String>> Jezyk() async {
    String language = await getLanguage();
    if (language == "English") {
      return Exercises.map((exercise) => exercise.title).toList();
    } else {
      return Exercises.map((exercise) => exercise.titlePL).toList();
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Color.fromARGB(170, 0, 0, 0),
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Jezyk(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading indicator.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final searchTerms = snapshot.data ?? [];
          List<String> matchQuery = [];

          for (var exercise in searchTerms) {
            if (exercise.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(exercise);
            }
          }

          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              int matchedIndex = findMatchingIndex(result);
              return ListTile(
                leading: Image.asset("${Exercises[matchedIndex].gifCode}",
                    fit: BoxFit.cover, width: 50, height: 50),
                title: Text(
                  result,
                  style: const TextStyle(
                    fontFamily: 'Satoshi',
                  ),
                ),
                onTap: () {
                  if (czyDodawanie == true) {
                    Navigator.pop(
                      context,
                      Exercises[index].title,
                    );
                  }
                  if (matchedIndex != -1) {
                    if (czyProgress == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseProgress(
                            nazwa: Exercises[matchedIndex].title,
                            matchedIndex: matchedIndex,
                            context: context,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Exercises[matchedIndex].namePage),
                      );
                    }
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  int findMatchingIndex(String titleToMatch) {
    for (int i = 0; i < Exercises.length; i++) {
      if (Exercises[i].title == titleToMatch) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Jezyk(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
            width: 165,
            height: 165,
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final searchTerms = snapshot.data ?? [];
          List<String> matchQuery = [];

          for (var exercise in searchTerms) {
            if (exercise.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(exercise);
            }
          }

          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              int matchedIndex = searchTerms.indexOf(result);

              if (matchedIndex != -1) {
                return ListTile(
                  title: Text(
                    result,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      color: Color.fromARGB(170, 0, 0, 0),
                    ),
                  ),
                  onTap: () {
                    if (czyDodawanie == true) {
                      close(
                          context, [Exercises[matchedIndex].title.toString()]);
                      Navigator.pop(
                        context,
                        Exercises[matchedIndex].title.toString(),
                      );
                    } else if (czyProgress == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseProgress(
                            nazwa: Exercises[matchedIndex].title,
                            matchedIndex: matchedIndex,
                            context: context,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Exercises[matchedIndex].namePage),
                      );
                    }
                  },
                );
              } else {
                return ListTile(
                  title: Text(result),
                );
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, []);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }
}

class ProgressPage extends StatelessWidget {
  final int matchedIndex;
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

  ProgressPage(this.matchedIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Progress page',
            style: TextStyle(
                fontSize: 21,
                fontFamily: 'Satoshi',
                color: Color.fromARGB(190, 255, 255, 255))),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(true, false));
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
        iconTheme: const IconThemeData(color: Colors.white),
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
                          MaterialPageRoute(
                              builder: (context) => ExerciseProgress(
                                    nazwa: Exercises[index].title,
                                    matchedIndex: matchedIndex,
                                    context: context,
                                  )),
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
                                  Color.fromARGB(220, 0, 0, 0),
                                  Color.fromARGB(160, 0, 0, 0),
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
                                        //alignment: Alignment.centerRight,
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
                                                  snapshot.data ??
                                                      '', // Use the title or a default value
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

class ExerciseProgress extends StatefulWidget {
  final String nazwa;
  final context;
  final matchedIndex;
  ExerciseProgress(
      {required this.nazwa,
      required this.matchedIndex,
      required this.context,
      Key? key})
      : super(key: key);

  @override
  State<ExerciseProgress> createState() => _ExerciseProgressState();
}

class _ExerciseProgressState extends State<ExerciseProgress> {
  
  late TableDataSource _tableDataSource;
  late List<SalesDataToTable> _tableData = [];
  late ZoomPanBehavior _zoomPanBehavior;
  double _currentWeight = 75.0;
  double _currentReps = 8.0;
  double weight = 0.0;
  int reps = 0;
  DateTime exerciseDate = DateTime.now();

  List<SalesData>? chartData;

  @override
  void initState() {
    _tableDataSource = TableDataSource(
        [], widget.nazwa, _tableData, widget.context, widget.matchedIndex);
    _zoomPanBehavior = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        selectionRectBorderWidth: 2,
        zoomMode: ZoomMode.xy,
        enableMouseWheelZooming: true,
        enablePanning: true,
        selectionRectColor: Colors.black,
        enablePinching: true);

    super.initState();

    _getTableData(widget.nazwa).then((tableData) {
      setState(() {
        _tableData = tableData;
        _tableDataSource = TableDataSource(_tableData, widget.nazwa, _tableData,
            widget.context, widget.matchedIndex);
      });
    });

    getUserData(widget.nazwa).then((data) {
      setState(() {
        chartData = data;
      });
    });
  }

  Future<List<SalesDataToTable>> _getTableData(String nazwa) async {
    var weightList = await getUserDataWeight(nazwa);
    var repList = await getUserDataReps(nazwa);
    var dataList = await getUserDataDate(nazwa);

    List<SalesDataToTable> tableData = [];

    for (int i = weightList.length - 1; i >= 0; i--) {
      String data =
          "${dataList[i].day}-${dataList[i].month}-${dataList[i].year}";
      tableData
          .add(SalesDataToTable(dataList[i], data, weightList[i], repList[i]));
    }
    setState(() {
      _tableData = tableData;
      _tableDataSource = TableDataSource(
          _tableData, nazwa, _tableData, widget.context, widget.matchedIndex);
    });

    return tableData;
  }

  Future<List<int>> getUserDataWeight(String tytul) async {
    List<int> weight = [];
    CollectionReference collection = firestore.collection('Dane - $tytul');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['user'].toString() == user.uid) {
        weight.add(data['weight'].toInt());
      }
    }
    return weight;
  }

  Future<List<int>> getUserDataReps(String tytul) async {
//double weight = 69;
    List<int> Reps = [];
    CollectionReference collection = firestore.collection('Dane - $tytul');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['user'].toString() == user.uid) {
        Reps.add(data['Reps'].toInt());
      }
    }
    return Reps;
  }

  Future<List<DateTime>> getUserDataDate(String tytul) async {
    List<DateTime> Date = [];
    CollectionReference collection = firestore.collection('Dane - $tytul');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['user'].toString() == user.uid) {
        Date.add(data['exerciseDate'].toDate());
      }
    }
    return Date;
  }

  Future<List<SalesData>> getUserData(String tytul) async {
    List<SalesData> userData = [];
    Map<DateTime, bool> addedDates = {};

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('Dane - $tytul').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (doc.id.contains(user.uid)) {
          DateTime date = data['exerciseDate'].toDate();
          date = DateTime(date.year, date.month, date.day);
          if (!addedDates.containsKey(date)) {
            addedDates[date] = true;
            userData.add(SalesData(
                date,
                calculateMax(data['weight']?.toDouble() ?? 0.0,
                        data['Reps']?.toDouble() ?? 0)
                    .round()));
          }
        }
      }
    } catch (e) {}

    return userData;
  }

  void saveUserData(
      tytul, double weight, double reps, DateTime exerciseDate) async {
    try {
      await firestore
          .collection('Dane - $tytul')
          .doc(
              "${user.uid},${DateFormat('yyyy-MM-dd HH:mm:ss').format(exerciseDate)}")
          .set({
        'weight': weight,
        'Reps': reps,
        'exerciseDate': exerciseDate,
        'user': user.uid,
      });
    } catch (e) {}
  }

  void addData(SalesData newData) {
    setState(() {
      chartData?.add(newData);
      _tableData.insert(
          0,
          SalesDataToTable(newData.date, newData.date.toString(),
              _currentWeight.round(), _currentReps.round()));
    });
  }

  int calculateMax(weight, reps) {
    return (weight / (1.0278 - 0.0278 * reps)).round();
  }


  Future<List<String>> ENG() async {
    String language = await getLanguage();
    if (language == "English") {
      return [
        "Weight: ",
        "Reps: ",
        "Add data",
        "Date",
        "Weight",
        "Reps",
      ];
    } else {
      return [
        "Waga: ",
        "Powtórzenia: ",
        "Dodaj dane",
        "Data",
        "Waga",
        "Powtórzenia",
      ];
    }
  }

  final ConnectionState _connectionState = ConnectionState.none;
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(const Duration(days: 7));
    final List<Color> color = <Color>[];
    color.add(const Color.fromARGB(120, 145, 182, 251));
    color.add(const Color.fromARGB(120, 129, 137, 255));
    color.add(const Color.fromARGB(120, 144, 129, 255));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nazwa,
          style: const TextStyle(fontFamily: 'Satoshi', fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 260,
                  width: 500,
                  child: SafeArea(
                    child: Theme(
                      data: ThemeData(
                        fontFamily: 'Satoshi',
                      ),
                      child: SfCartesianChart(
                        zoomPanBehavior: _zoomPanBehavior,
                        series: <ChartSeries>[
                          AreaSeries<SalesData, DateTime>(
                              name: 'Weight',
                              xValueMapper: (SalesData sales, _) => sales.date,
                              yValueMapper: (SalesData sales, _) =>
                                  sales.maxWeight,
                              dataSource: chartData ?? [],
                              dataLabelSettings: const DataLabelSettings(
                                labelAlignment: ChartDataLabelAlignment.top,
                                isVisible: true,
                                useSeriesColor: true,
                              ),
                              enableTooltip: true,
                              borderColor: Colors.green,
                              gradient: gradientColors),
                          LineSeries<SalesData, DateTime>(
                            color: const Color.fromARGB(94, 0, 0, 0),
                            name: 'Weight',
                            dataSource: chartData ?? [],
                            xValueMapper: (SalesData sales, _) => sales.date,
                            yValueMapper: (SalesData sales, _) => sales.maxWeight,
                            dataLabelSettings: const DataLabelSettings(
                              labelAlignment: ChartDataLabelAlignment.top,
                              isVisible: true,
                              useSeriesColor: true,
                            ),
                            enableTooltip: true,
                          ),
                        ],
                        primaryXAxis: DateTimeAxis(
                          interval: 1,
                          visibleMinimum: oneMonthAgo,
                          visibleMaximum: today,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          //title: AxisTitle(text: 'Date'),
                          majorGridLines:
                              const MajorGridLines(color: Colors.grey),
                        ),
                        primaryYAxis: NumericAxis(
                          labelFormat: '{value} Kg',
                          //title: AxisTitle(text: 'Maximum Weight'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: ENG(),
                builder: (context, snapshot) {
                  if (_connectionState == ConnectionState.none) {
                    return Text("${snapshot.data?[0]} ${_currentWeight.round()}",
                        style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(255, 66, 66, 66)));
                  } else if (_connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Color.fromARGB(180, 255, 255, 255),
                    );
                  }
                  return const Text("");
                },
              ),
              Slider(
                activeColor: const Color.fromARGB(170, 10, 10, 10),
                inactiveColor: const Color.fromARGB(120, 35, 34, 34),
                value: _currentWeight,
                min: 1.0,
                max: 300.0,
                divisions: 299,
                onChanged: (value) {
                  setState(() {
                    _currentWeight = value;
                  });
                },
              ),
              FutureBuilder(
                future: ENG(),
                builder: (context, snapshot) {
                  if (_connectionState == ConnectionState.none) {
                    return Text("${snapshot.data?[1]} ${_currentReps.round()}",
                        style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Satoshi',
                            color: Color.fromARGB(255, 66, 66, 66)));
                  } else if (_connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Color.fromARGB(180, 255, 255, 255),
                    );
                  }
                  return const Text("");
                },
              ),
              Slider(
                activeColor: const Color.fromARGB(170, 10, 10, 10),
                inactiveColor: const Color.fromARGB(120, 35, 34, 34),
                value: _currentReps,
                min: 1.0,
                max: 30.0,
                divisions: 29,
                onChanged: (value) {
                  setState(() {
                    _currentReps = value;
                  });
                },
              ),
              InkWell(
                  onTap: () {
                    SalesData newData = SalesData(
                        exerciseDate, calculateMax(_currentWeight, _currentReps));
                    saveUserData(
                        widget.nazwa, _currentWeight, _currentReps, exerciseDate);
                    addData(newData);
                    Navigator.pushReplacement(
                        context,
                        _createRoute(ExerciseProgress(
                          nazwa: widget.nazwa,
                          matchedIndex: widget.matchedIndex,
                          context: context,
                        )));
                  },
                  child: FutureBuilder(
                    future: ENG(),
                    builder: (context, snapshot) {
                      if (_connectionState == ConnectionState.none) {
                        return Container(
                          width: 130,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                Color.fromARGB(80, 12, 153, 224),
                                Color.fromARGB(80, 144, 129, 255),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data?[2] ?? '',
                              style: const TextStyle(
                                fontSize: 21,
                                fontFamily: 'Satoshi',
                                color: Color.fromARGB(255, 25, 25, 25),
                              ),
                            ),
                          ),
                        );
                      } else if (_connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(180, 255, 255, 255),
                        );
                      }
                      return const Text("");
                    },
                  )),
              Container(
                margin: const EdgeInsets.all(20),
                
                width: 330,
                child: Center(
                  child: Column(
                    children: [
                      SfDataGrid(
                        source: _tableDataSource,
                        columns: <GridColumn>[
                          GridColumn(
                              columnName: 'date',
                              label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: FutureBuilder(
                                  future: ENG(),
                                  builder: (context, snapshot) {
                                    if (_connectionState ==
                                        ConnectionState.none) {
                                      return Text(snapshot.data?[3] ?? '',
                                          style: const TextStyle(
                                              fontSize: 16.5,
                                              fontFamily: 'Satoshi',
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66)));
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
                              )),
                          GridColumn(
                              columnName: 'weight',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                    future: ENG(),
                                    builder: (context, snapshot) {
                                      if (_connectionState ==
                                          ConnectionState.none) {
                                        return Text(snapshot.data?[4] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16.5,
                                                fontFamily: 'Satoshi',
                                                color: Color.fromARGB(
                                                    255, 66, 66, 66)));
                                      } else if (_connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          color: Color.fromARGB(
                                              180, 255, 255, 255),
                                        );
                                      }
                                      return const Text("");
                                    },
                                  ))),
                          GridColumn(
                              columnName: 'reps',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Center(
                                      child: FutureBuilder(
                                    future: ENG(),
                                    builder: (context, snapshot) {
                                      if (_connectionState ==
                                          ConnectionState.none) {
                                        return Text(snapshot.data?[5] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16.5,
                                                fontFamily: 'Satoshi',
                                                color: Color.fromARGB(
                                                    255, 66, 66, 66)));
                                      } else if (_connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          color: Color.fromARGB(
                                              180, 255, 255, 255),
                                        );
                                      }
                                      return const Text("");
                                    },
                                  )))),
                          GridColumn(
                            columnName: 'delete',
                            label: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(''),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<SalesData> getChartData() {
    int maxWeight = calculateMax(_currentWeight, _currentReps);
    return [SalesData(exerciseDate, maxWeight)];
  }
}

class TableDataSource extends DataGridSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Future<void> removeData(SalesDataToTable data) async {
    try {
      await firestore
          .collection('Dane - ${tytul}')
          .doc(
              '${user.uid},${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.exactDate)}')
          .delete();
    } catch (e) {}
  }

  final String tytul;
  final List<SalesDataToTable> x;
  final int matchedIndex;
  final context;
  TableDataSource(List<SalesDataToTable> data, this.tytul, this.x, this.context,
      this.matchedIndex) {
    dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'date', value: e.date),
              DataGridCell<int>(columnName: 'weight', value: e.weight),
              DataGridCell<int>(columnName: 'reps', value: e.reps),
              DataGridCell<InkWell>(
                  columnName: 'action',
                  value: InkWell(
                    onTap: () {
                      removeData(e);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseProgress(
                            nazwa: Exercises[matchedIndex].title,
                            matchedIndex: matchedIndex,
                            context: context,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.delete_forever),
                    ),
                  )), // Add 'action' cell
            ]))
        .toList();
  }
  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;

  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((DataGridCell cell) {
        if (cell.columnName == 'action') {
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseProgress(
                    nazwa: Exercises[matchedIndex].title,
                    matchedIndex: matchedIndex,
                    context: context,
                  ),
                ),
              );
              removeData(x[dataGridRows.indexOf(row)]);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.delete_forever),
            ),
          );
        } else if (cell.columnName == 'date') {
          return Center(child: Text(x[dataGridRows.indexOf(row)].date));
        } else if (cell.columnName == 'reps') {
          return Center(child: Text("${x[dataGridRows.indexOf(row)].reps}"));
        } else if (cell.columnName == 'weight') {
          return Center(child: Text("${x[dataGridRows.indexOf(row)].weight}"));
        } else {
          return Container();
        }
      }).toList(),
    );
  }
}

class SalesData {
  final DateTime date;
  final int maxWeight;

  SalesData(this.date, this.maxWeight);

  // Factory constructor to create SalesData from Firestore data
  factory SalesData.fromFirestore(Map<String, dynamic> data) {
    return SalesData(
      data['exerciseDate'].toDate(), // Convert Firestore timestamp to DateTime
      data['weight']?.toDouble() ?? 0.0, // Convert weight to double
    );
  }
}

class SalesDataToTable {
  final DateTime exactDate;
  final String date;
  final int weight;
  final int reps;

  SalesDataToTable(this.exactDate, this.date, this.weight, this.reps);

  // Factory constructor to create SalesData from Firestore data
  factory SalesDataToTable.fromFirestore(Map<String, dynamic> data) {
    return SalesDataToTable(
      data['exerciseDate'].toDate(),
      data['exerciseDate'].toDate(), // Convert Firestore timestamp to DateTime
      data['weight']?.toDouble() ?? 0.0,
      data['Reps']?.toDouble() ?? 0.0, // Convert weight to double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseDate': this.date,
      'weight': this.weight,
      'Reps': this.reps,
    };
  }
}

Route _createRoute(Widget Page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1200),
  );
}
