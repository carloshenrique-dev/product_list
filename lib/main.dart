import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'core/services/routing.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //default configs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //setting up login providers
  await setUpUiAuth();

  //setting up crashlytics
  await setUpCrashlytics();

  runApp(const MyApp());
}

Future<void> setUpUiAuth() async {
  try {
    var remoteConfig = await setupRemoteConfig();

    FirebaseUIAuth.configureProviders([
      GoogleProvider(
        clientId: remoteConfig.getString('clientIdGoogleSignIn'),
      ),
      FacebookProvider(
        clientId: '430878690263f1b51e40b637f0b2ec56',
        redirectUri:
            'https://productview-a8b21.firebaseapp.com/__/auth/handler',
      ),
    ]);
  } catch (e) {
    log(e.toString());
  }
}

Future<void> setUpCrashlytics() async {
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    'clientIdGoogleSignIn':
        '457763815946-uq4ku3umcaleu985ughdnl7d7vl6gnn1.apps.googleusercontent.com',
  });
  RemoteConfigValue(null, ValueSource.valueStatic);
  return remoteConfig;
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
