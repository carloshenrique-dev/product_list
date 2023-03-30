import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_list/core/services/routing.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ProductList',
                  style: GoogleFonts.nunito(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthStateListener<OAuthController>(
                  listener: (oldState, newState, controller) {
                    if (newState is SignedIn) {
                      context.pushReplacementNamed(AppRoutes.home.name);
                    }
                    return null;
                  },
                  child: OAuthProviderButton(
                    provider: GoogleProvider(clientId: 'clientId'),
                  ),
                ),
                OAuthProviderButton(
                  provider: FacebookProvider(clientId: 'clientId'),
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
    );
  }
}
