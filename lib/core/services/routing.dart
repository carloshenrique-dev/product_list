import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:product_list/modules/login/login_page.dart';
import 'package:product_list/modules/product/product_page.dart';

import '../../modules/home/home_page.dart';

enum AppRoutes { login, home, product }

final GoRouter routes = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  restorationScopeId: 'router',
  routes: [
    /*GoRoute(
      path: '/',
      name: AppRoutes.welcome.name,
      builder: (context, state) => const WelcomePage(),
    ),*/
    GoRoute(
      path: '/product',
      name: AppRoutes.product.name,
      builder: (context, state) => ProductPage(
        productDescription: state.queryParams['description']!,
        productName: state.queryParams['productName']!,
      ),
    ),
    GoRoute(
      path: '/home',
      name: AppRoutes.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/',
      name: AppRoutes.login.name,
      builder: (context, state) => const LoginPage(),
    ),
  ],
  redirect: (context, state) {
    // if the user is not logged in, they need to login
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn = state.subloc == '/';
    if (!loggedIn) {
      return '/';
    }

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggingIn) {
      return '/home';
    }

    // no need to redirect at all
    return null;
  },
);
