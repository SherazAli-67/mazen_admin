import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mazen_admin/src/home_page.dart';
import 'package:mazen_admin/src/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCI0w33x6SUqAmjS3vZifn-KsTt31hQH0g',
          appId: '1:179783412598:web:717a36a2382b85ede8e857',
          messagingSenderId: '179783412598',
          projectId: 'manzenpharmacy'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Manrope'
        ),
        home: const HomePage()
    );
  }
}
