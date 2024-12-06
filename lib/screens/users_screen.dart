import 'package:flutter/material.dart';
import 'package:projects/models/user.dart';
import 'package:projects/screens/user_details.dart';
import 'package:projects/screens/users_filter.dart';
import 'package:projects/services/api_service.dart';
import 'package:go_router/go_router.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];  // Liste filtrée des utilisateurs
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0; // Point de départ pour l'API
  final int limit = 20; // Nombre d'utilisateurs à charger à chaque fois
  final ScrollController _scrollController = ScrollController(); // Contrôleur pour écouter le défilement
  final TextEditingController _searchController = TextEditingController(); // Contrôleur pour le champ de recherche

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Charger les 20 premiers utilisateurs
    _scrollController.addListener(_onScroll); // Attacher le listener de défilement
    _searchController.addListener(_onSearchChanged); // Ajouter un listener pour le champ de recherche
  }

  // Charger les utilisateurs (pagination)
  _loadUsers() async {
    setState(() {
      if (offset == 0) {
        isLoading = true; // Chargement initial
      } else {
        isLoadingMore = true; // Chargement supplémentaire
      }
    });
    try {
      final fetchedUsers =
      await ApiService().fetchUsers(offset: offset, limit: limit);
      setState(() {
        users.addAll(fetchedUsers); // Ajouter les nouveaux utilisateurs
        filteredUsers = users; // Mettre à jour la liste filtrée
        offset += limit; // Augmenter l'offset pour la prochaine page
      });
    } catch (e) {
      print('Error loading users: $e');
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  // Vérifier si l'utilisateur atteint la fin de la liste
  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadUsers(); // Charger plus d'utilisateurs
    }
  }

  // Filtrer la liste des utilisateurs selon le texte recherché
  _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(query); // Filtrer par nom
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Nettoyer le contrôleur pour éviter les fuites de mémoire
    _searchController.dispose(); // Nettoyer le contrôleur du champ de recherche
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Retour au Dashboard
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(users),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attacher le contrôleur
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(filteredUsers[index].avatar),
                  ),
                  title: Text(filteredUsers[index].name),
                  subtitle: Text(filteredUsers[index].email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(user: filteredUsers[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (isLoadingMore) // Afficher un indicateur pour le chargement supplémentaire
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

