import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product_list/core/services/routing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GoogleSignIn googleSignIn;

  @override
  void initState() {
    googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    super.initState();
  }

  Future<void> _handleSignIn(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      // usuário já autenticado, redireciona para a página inicial
      context.pushReplacementNamed(AppRoutes.home.name);
      return;
    }

    try {
      await googleSignIn.signIn().whenComplete(
          () => context.pushReplacementNamed(AppRoutes.home.name));
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SignInButtonBuilder(
                      elevation: 0,
                      key: const ValueKey("Google"),
                      text: 'Sign in with Google',
                      textColor: Colors.grey,
                      image: Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: const Image(
                            image: AssetImage(
                              'assets/logos/google_light.png',
                              package: 'flutter_signin_button',
                            ),
                            height: 36.0,
                          ),
                        ),
                      ),
                      backgroundColor: const Color(0xFFFFFFFF),
                      onPressed: () => _handleSignIn(context),
                      innerPadding: const EdgeInsets.all(0),
                      fontSize: 18,
                      height: 45.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthStateListener<OAuthController>(
                    listener: (oldState, newState, controller) {
                      if (newState is SignedIn) {
                        context.pushReplacementNamed(AppRoutes.home.name);
                      }
                      return null;
                    },
                    child: OAuthProviderButton(
                      provider: FacebookProvider(clientId: 'clientId'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Sign in with e-mail and password',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot your password? Click here'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> signIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      return true;
    }
    return false;
  }
}
