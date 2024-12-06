import 'package:flutter/material.dart';
import 'package:projects/models/user.dart';
import 'package:projects/screens/user_details.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<User> users;

  CustomSearchDelegate(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Réinitialiser la recherche
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Ferme la recherche
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<User> results = users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(results[index].avatar),
          ),
          title: Text(results[index].name),
          subtitle: Text(results[index].email),
          onTap: () {
            // Naviguer vers la page de détails de l'utilisateur
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<User> suggestions = users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(suggestions[index].avatar),
          ),
          title: Text(suggestions[index].name),
          subtitle: Text(suggestions[index].email),
          onTap: () {
            // Naviguer vers la page de détails de l'utilisateur
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: suggestions[index]),
              ),
            );
          },
        );
      },
    );
  }
}
