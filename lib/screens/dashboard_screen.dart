import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.go('/users'); // Utilisation de GoRouter pour la navigation
              },
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Users"),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                context.go('/products'); // Utilisation de GoRouter pour la navigation
              },
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text("Products"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
