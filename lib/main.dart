import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:restart_app/restart_app.dart';
import 'package:ucze_sie_swiry/notifications.dart';
import 'package:ucze_sie_swiry/screens/Auth.dart';
import 'package:ucze_sie_swiry/screens/Map.dart';
import 'package:ucze_sie_swiry/screens/Menu.dart';
import 'package:ucze_sie_swiry/screens/Utils.dart';
import 'package:ucze_sie_swiry/screens/creatingTrainingManual.dart';
import 'package:ucze_sie_swiry/screens/profilePage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pl_PL', null);

  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB_FoCedoYFhgSh-1NdB8OpwecNwaxMf7E",
        appId: "1:836709147921:ios:5ff1ea2c738250737818b0",
        messagingSenderId: "836709147921",
        projectId: "olimpapp-ff429",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCcy8NSSgzVqpJS0XBJCdfb3pv4yoTxbYA",
        appId: "1:836709147921:android:56189b96381241c37818b0",
        messagingSenderId: "836709147921",
        projectId: "olimpapp-ff429",
      ),
    );
  }

  FirebaseApi().initNotifications();

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Satoshi',
    ),
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

final navigatorKey = GlobalKey<NavigatorState>();

class LoginPage extends StatefulWidget {
  final VoidCallback onclickedSignUp;

  const LoginPage({
    Key? key,
    required this.onclickedSignUp,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Satoshi',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0x44000000).withOpacity(0),
        elevation: 0,
      ),
      body: Theme(
        data: ThemeData(
          fontFamily: 'Satoshi',
        ),
        child: Container(
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color.fromARGB(120, 255, 255, 255),
                ),
                margin: const EdgeInsets.only(right: 30, left: 30),
                child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ),
              const MaxGap(50),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color.fromARGB(120, 255, 255, 255),
                ),
                margin: const EdgeInsets.only(right: 30, left: 30),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              const MaxGap(50),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(190, 255, 255, 255))),
                    onPressed: signIn,
                    child: const SizedBox(
                        height: 70,
                        width: 290,
                        child: Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 30, 30, 30),
                          ),
                        )))),
              ),
              const MaxGap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(190, 255, 255, 255))),
                        onPressed: widget.onclickedSignUp,
                        child: const SizedBox(
                            height: 35,
                            width: 105,
                            child: Center(
                                child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 30, 30, 30),
                              ),
                            )))),
                  ),
                  const MaxGap(14),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(190, 255, 255, 255))),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage()),
                            ),
                        child: const SizedBox(
                            height: 35,
                            width: 105,
                            child: Center(
                                child: Text(
                              'Reset password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 30, 30, 30),
                              ),
                            )))),
                  ),
                ],
              ),
              const MaxGap(10),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromARGB(255, 254, 198, 198),
                          Color.fromARGB(255, 251, 99, 99),
                        ])),
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                    focusColor: Colors.redAccent,
                    onTap: _signInWithGoogle,
                    child: SizedBox(
                        height: 65,
                        width: 325,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                              width: 45,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              child: const Text(
                                'Google sign in',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                ),
                              ),
                            ),
                          ],
                        )))),
              ),
              const MaxGap(40),
            ]),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future _signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Reset password',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Satoshi',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0x44000000).withOpacity(0),
        elevation: 0,
      ),
      body: Theme(
        data: ThemeData(fontFamily: 'Satoshi'),
        child: Container(
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color.fromARGB(120, 255, 255, 255),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.only(right: 30, left: 30),
              child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    labelText: 'Email',
                  )),
            ),
            const MaxGap(20),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(190, 255, 255, 255))),
                  onPressed: ResetPassword,
                  child: const SizedBox(
                      height: 70,
                      width: 230,
                      child: Center(
                          child: Text(
                        'Reset passwword',
                        style: TextStyle(
                          fontSize: 21,
                          color: Color.fromARGB(255, 30, 30, 30),
                        ),
                      )))),
            ),
          ]),
        ),
      ),
    );
  }

  Future ResetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isActive);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    } finally {
      _createRoute(const HomePage());
    }
  }
}

class MyApp extends StatelessWidget {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Olimp',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Future<bool> isGoogleSignIn() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    final providerData = user.providerData;
    if (providerData.isNotEmpty) {
      for (final userInfo in providerData) {
        if (userInfo.providerId == 'google.com') {
          return true;
        }
      }
    }

    return false;
  }

  int currentIndex = 3;
  List pages = [
    ExerciseList(),
    tworzenieTreningu(),
    Map(),
    ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  FirebaseAuth.instance.currentUser != null) {
                return const VerifyEmailPage();
              } else {
                return AuthPage();
              }
            }),
      );
}

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid)
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
        ),
      );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Utils.showSnackBar('Signed Up Properly');
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    } finally {}
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Sign up',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Satoshi',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      body: Theme(
        data: ThemeData(
          fontFamily: 'Satoshi',
        ),
        child: Container(
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
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color.fromARGB(120, 255, 255, 255),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    labelText: 'Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
              ),
              const SizedBox(height: 10),
              const MaxGap(20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color.fromARGB(120, 255, 255, 255),
                ),
                margin: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      labelText: 'Password'),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Too short password min. 6 charachters'
                      : null,
                ),
              ),
              const MaxGap(65),
              Container(
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(190, 255, 255, 255))),
                    onPressed: signUp,
                    child: const SizedBox(
                        height: 70,
                        width: 250,
                        child: Center(
                            child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 30, 30, 30),
                          ),
                        )))),
              ),
              const MaxGap(20),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(190, 255, 255, 255))),
                    onPressed: widget.onClickedSignIn,
                    child: const SizedBox(
                        height: 70,
                        width: 250,
                        child: Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 30, 30, 30),
                          ),
                        )))),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool canResendEmail = false;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationMail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationMail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  bool isEmailVeried = false;
  int currentIndex = 3;
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

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? Container(
            child: Scaffold(
              backgroundColor: const Color.fromARGB(205, 0, 0, 0),
              body: Stack(
                children: [
                  pages[currentIndex],
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -MediaQuery.of(context).size.height * 0.098 - 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: const Color.fromARGB(210, 10, 10, 10),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 0),
                        child: Center(
                          child: ClipRRect(
                            child: Theme(
                              data: ThemeData(
                                fontFamily: 'Satoshi',
                              ),
                              child: BottomNavigationBar(
                                elevation: 0,
                                type: BottomNavigationBarType.fixed,
                                backgroundColor:
                                    const Color.fromARGB(0, 34, 0, 255),
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
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 207, 226, 241),
                  Color.fromARGB(255, 210, 215, 255),
                ],
              )),
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Verify Email'),
                  ),
                  body: Center(
                      child: Column(
                    children: [
                      Container(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              'Verification eMail has been sent, if you have allready clicked the link in your mail, click cancel and sign in.'),
                        ),
                      ),
                      Container(
                          color: const Color.fromARGB(255, 206, 237, 250),
                          child: TextButton(
                              onPressed: sendVerificationMail,
                              child: const Text('Resent Email'))),
                      Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                              child: const Text('Cancel')))
                    ],
                  ))),
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

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          ConnectivityResult? result = snapshot.data;
          if (result != ConnectivityResult.none) {
            return MyApp();
          } else {
            return noInternet(
              context,
              result!,
            );
          }
        } else if (snapshot.hasError) {
          return errorWidget();
        } else {
          return loading();
        }
      },
    );
  }

  Widget errorWidget() {
    return const Center(
      child: Text(
        'Error loading connectivity state',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }

  Widget noInternet(BuildContext context, ConnectivityResult result) {
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(239, 60, 60, 60),
              Color.fromARGB(230, 20, 20, 20),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/no_internet.png',
              color: Colors.red,
              height: 130,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: const Text(
                "No Internet connection",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(220, 255, 255, 255),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                "Check your connection, then refresh the page.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(220, 255, 255, 255),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                Restart.restartApp;
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Refresh",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(220, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
