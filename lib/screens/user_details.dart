import 'package:flutter/material.dart';
import 'package:projects/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user; // Passer l'objet utilisateur

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatar),
            ),
            SizedBox(height: 16),
            Text(
              "Name: ${user.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Email: ${user.email}"),
            SizedBox(height: 8),
            Text("Phone: ${user.phone}"),
            SizedBox(height: 8),
            Text("Address: ${user.address}"),
          ],
        ),
      ),
    );
  }
}
