import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/products_screen.dart';

void main() {
  runApp(MyApp()); // No need to add 'const' here
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => DashboardScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => UserListScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => ProductListScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
