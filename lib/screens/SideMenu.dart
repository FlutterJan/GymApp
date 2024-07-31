import 'package:flutter/material.dart';
import 'package:ucze_sie_swiry/screens/creatingPartsFilterPage.dart';
import 'package:ucze_sie_swiry/main.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';


List<String> ENG() {
  return [
    "Home",
    "Shoulders",
    "Chest",
    "Glutes",
    "Biceps",
    "Lats",
    "Abdominals",
    "Hamstrings",
    "Triceps",
    "Traps",
    "Obliques",
    "Calves",
    "Quadriceps"
  ];
}

List<String> PL() {
  return [
    "Dom",
    "Barki",
    "Klatka Piersiowa",
    "Pośladki",
    "Biceps",
    "Plecy",
    "Brzuch",
    "Dwugłowe uda",
    "Triceps",
    "Kaptury",
    "Skośne brzucha",
    "Łydki",
    "Czworogłowe uda"
  ];
}

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  bool isSidebarOpen = false;

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }


  Future<String> Jezyk(int i) async {
    String language = await getLanguage();
    if (language == "English") {
      return ENG()[i];
    } else {
      return PL()[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(20, 0, 0, 0),
      extendBodyBehindAppBar: true,
      body: Drawer(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            //0
            ListTile(
              leading: Container(
                margin:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                child: const Icon(
                  Icons.home_rounded,
                  size: 50,
                  color: Color.fromARGB(160, 251, 76, 28),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(210, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(MyStatefulWidget()),
              ),
            ),
            //1
            ListTile(
              leading: Image.asset('images/barkiDoListy.png', height: 38),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(1),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                  context, _createRoute(FilteredPage("Shoulders"))),
            ),
            //2
            ListTile(
              leading: Image.asset('images/photo1.png', height: 42.5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(2),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Chest")),
              ),
            ),
            //3
            ListTile(
              leading: Image.asset('images/AssDoListy.png', height: 43),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(3),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Glutes")),
              ),
            ),
            //4
            ListTile(
              leading:
                  Image.asset('images/Biceps.png', height: 70.5, width: 67),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(4),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Biceps")),
              ),
            ),
            //5
            ListTile(
              leading: Image.asset(
                'images/lats.png',
                height: 60,
                width: 60,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(5),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Lats")),
              ),
            ),
            //6
            ListTile(
              leading: Image.asset('images/Abdominals.png', height: 50),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(6),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Abdominals")),
              ),
            ),
            //7
            ListTile(
              leading:
                  Image.asset('images/Hamstrings.png', height: 90, width: 60),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(7),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Hamstrings")),
              ),
            ),
            //8
            ListTile(
              leading: Image.asset(
                'images/triceps.png',
                height: 90,
                width: 70,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(8),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Triceps")),
              ),
            ),
            //9
            ListTile(
              leading: Image.asset(
                'images/traps.png',
                height: 80,
                width: 62,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(9),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Traps")),
              ),
            ),
            //10
            ListTile(
              leading: Image.asset(
                'images/Obliques.png',
                height: 90,
                width: 70,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(10),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                _createRoute(FilteredPage("Obliques")),
              ),
            ),

            ListTile(
              leading: Image.asset(
                'images/Calves.png',
                height: 80,
                width: 62,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(11),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () =>
                  Navigator.push(context, _createRoute(FilteredPage("Calves"))),
            ),
            ListTile(
              leading: Image.asset(
                'images/Quadriceps.png',
                height: 80,
                width: 62,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Jezyk(12),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return Text(snapshot.data ?? '',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Color.fromARGB(200, 49, 49, 49)));
                        } else {
                          return const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 49, 49));
                        }
                      }),
                ],
              ),
              onTap: () => Navigator.push(
                  context, _createRoute(FilteredPage("Quadriceps"))),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    
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
