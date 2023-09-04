import 'package:flutter/material.dart';
import 'landing.dart';
import 'splash_screen.dart';
import 'signup_page.dart';
import 'signup_confirm.dart';
import 'bluetooth_connection.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'transmitter_page.dart';
import 'receiver_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => BluetoothProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lifeXlane',
      // home: landing(),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            SplashScreen(), // Set the SplashScreen as the initial route
        '/main': (context) => landing(),
        '/signup': (context) => SignUpPage(), // Sign up page
        '/login': (context) => landing(), // Sign up page
        '/form_submission': (context) => FormSubmissionPage(),
        '/home_page': (context) => HomePage(),
        '/transmitter_page': (context) => TransmitterPage(),
        '/receiver_page': (context) => ReceiverPage(),
      },
    );
  }
}
