import 'package:flutter/material.dart';
import 'package:ucze_sie_swiry/lists/ExerciseList.dart';
import 'package:ucze_sie_swiry/screens/Map.dart';
import 'package:ucze_sie_swiry/screens/Menu.dart';
import 'package:ucze_sie_swiry/screens/SideMenu.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';
import 'package:ucze_sie_swiry/screens/progressPage.dart';

class ExerciseList extends StatefulWidget {
  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int currentIndex = 0;
  List pages = [
    ExerciseList(),
    tworzenieTreningu(),
    MapScreen(),
    ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final ConnectionState _connectionState = ConnectionState.none;
  final controler = ScrollController();
  Future<String> Tytul(int index) async {
    String language = await getLanguage();
    if (language == "English") {
      return Exercises[index].title;
    } else {
      return Exercises[index].titlePL;
    }
  }

  void onListenerControler() {
    setState(() {});
  }

  @override
  void initState() {
    controler.addListener(onListenerControler);
    super.initState();
  }

  @override
  void dispose() {
    controler.removeListener(onListenerControler);
    controler.dispose(); // Make sure to dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(205, 0, 0, 0),
      extendBodyBehindAppBar: true,
      drawer: const SideBar(),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(false, false));
              },
              icon: const Icon(Icons.search))
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                              margin: const EdgeInsets.all(7),
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
                                        borderRadius: BorderRadius.circular(25),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            Exercises[index].gifCode,
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
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
                                            //alignment: Alignment.centerRight,
                                            child: FutureBuilder(
                                              future: Tytul(index),
                                              builder: (context, snapshot) {
                                                if (_connectionState ==
                                                    ConnectionState.none) {
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
                      childCount: Exercises.length,
                    ),
                    itemExtent: 155,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -MediaQuery.of(context).size.height * 0.115 - 38,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: const Color.fromARGB(210, 10, 10, 10),
                  //borderRadius: BorderRadius.circular(50),
                ),
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Center(
                  child: ClipRRect(
                    child: BottomNavigationBar(
                      elevation: 0,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: const Color.fromARGB(0, 34, 0, 255),
                      selectedItemColor:
                          const Color.fromARGB(200, 255, 255, 255)
                              .withOpacity(0.85),
                      unselectedItemColor:
                          const Color.fromARGB(120, 255, 255, 255)
                              .withOpacity(0.6),
                      selectedLabelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight
                              .bold), // Set label text color for selected item
                      unselectedLabelStyle: const TextStyle(
                          color: Colors
                              .white), // Set label text color for unselected items

                      showUnselectedLabels: true,
                      onTap: _onItemTapped,
                      //elevation: 0,
                      currentIndex: currentIndex,
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.list),
                          label: 'List',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.sports_gymnastics),
                          label: 'AI Training',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.map),
                          label: 'Map',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
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
