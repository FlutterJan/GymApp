import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ucze_sie_swiry/main.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic>? _trainingDays = {};
  TextEditingController _trainingNameController = TextEditingController();

  Future<void> saveUserData() async {
    try {
      Map<String, dynamic> dataToSave = {};
      int i = 0;
      _trainingDays?.forEach((key, value) {
        dataToSave['$i'] = {'date': key, 'name': value};
        i++;
      });
      await FirebaseFirestore.instance
          .collection('Training')
          .doc(user.email)
          .set(dataToSave);
    } catch (e) {}
  }

  Future<Map<String, dynamic>?> getUserData() async {
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

  @override
  void dispose() {
    _trainingNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConnectionState _connectionState = ConnectionState.none;
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (_connectionState == ConnectionState.none) {
          _trainingDays = snapshot.data as Map<String, dynamic>?;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TableCalendar(
                            headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(
                                fontFamily: "Satoshi",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                              ),
                              titleCentered: true,
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              formatButtonVisible: false,
                            ),
                            focusedDay: _focusedDay,
                            firstDay: DateTime.now(),
                            lastDay:
                                DateTime.now().add(const Duration(days: 29)),
                            calendarFormat: _calendarFormat,
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDay);
                                if (_trainingDays?.containsKey(formattedDate) ??
                                    false) {
                                  _trainingNameController.text = _trainingDays?[
                                          formattedDate] ??
                                      ''; // Poprawka: Użycie wartości domyślnej w przypadku null
                                } else {
                                  _trainingNameController.text = '';
                                }

                                saveUserData();
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, date, _) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(180, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                              todayBuilder: (context, date, _) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                              markerBuilder: (context, date, events) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(date);
                                if (_trainingDays != null &&
                                    _trainingDays![formattedDate] != null &&
                                    _trainingDays![formattedDate]!.isNotEmpty) {
                                  return const Icon(Icons.check_circle,
                                      color: Colors.green);
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Training days: ",
                            style:
                                TextStyle(fontSize: 24, fontFamily: "Satoshi"),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                (_trainingDays?.values
                                            .where((value) => value != '')
                                            .length ??
                                        0)
                                    .toString(),
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              maxLength: 14,
                              cursorColor: const Color.fromARGB(150, 0, 0, 0),
                              controller: _trainingNameController,
                              decoration: const InputDecoration(
                                labelText: 'Training Name',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(
                                        149, 0, 0, 0)), // Kolor tekstu etykiety
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(120, 0, 0,
                                          0)), // Kolor obwódki w stanie domyślnym
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(170, 0, 0,
                                          0)), // Kolor obwódki podczas interakcji/focusu
                                ),

                                // Kolor kursora
                              ),
                              onChanged: (value) {
                                if (_selectedDay != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(_selectedDay!);
                                  setState(() {
                                    _trainingDays?[formattedDate] = value;
                                    saveUserData(); // Zapisz dane tylko po zmianie
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            onPressed: () {
                              saveUserData();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          MyStatefulWidget())));
                            },
                            icon: const Icon(Icons.arrow_back_ios_new),
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
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
    );
  }
}
