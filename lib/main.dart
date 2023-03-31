import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:flutter/material.dart';
import 'core/services/routing.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //default configs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //setting up login providers
  FirebaseUIAuth.configureProviders([
    FacebookProvider(
      clientId: '1376809642892853',
      redirectUri: 'https://productview-a8b21.firebaseapp.com/__/auth/handler',
    ),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes,
    );
  }
}
