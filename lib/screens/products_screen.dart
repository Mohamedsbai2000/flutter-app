import 'package:flutter/material.dart';
import 'package:projects/models/product.dart';
import 'package:projects/screens/product_details.dart';
import 'package:projects/services/api_service.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> allProducts = []; // Liste complète des produits pour la recherche
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0; // Départ pour l'API
  final int limit = 20; // Nombre de produits chargés par page
  final ScrollController _scrollController = ScrollController(); // Contrôleur pour écouter le scroll

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Charger les 20 premiers produits
    _scrollController.addListener(_onScroll); // Attacher le listener
  }

  // Charger les produits avec pagination
  _loadProducts() async {
    setState(() {
      if (offset == 0) {
        isLoading = true; // Chargement initial
      } else {
        isLoadingMore = true; // Chargement supplémentaire
      }
    });
    try {
      final fetchedProducts =
      await ApiService().fetchProducts(offset: offset, limit: limit);
      setState(() {
        products.addAll(fetchedProducts); // Ajouter les produits récupérés
        allProducts.addAll(fetchedProducts); // Sauvegarder tous les produits pour la recherche
        offset += limit; // Mettre à jour l'offset pour les prochaines données
      });
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  // Détecter quand on atteint le bas de la liste
  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadProducts(); // Charger plus de produits
    }
  }

  // Fonction de recherche
  void _startSearch() {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(products: allProducts),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Nettoyer pour éviter les fuites mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Retour à la route principale
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _startSearch, // Ouvrir la recherche
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Contrôleur pour scroll infini
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    products[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(products[index].title),
                  subtitle: Text("\$${products[index].price}"),
                  onTap: () {
                    // Naviguer vers la page de détails du produit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: products[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (isLoadingMore) // Indicateur pour chargement supplémentaire
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

// SearchDelegate pour filtrer les produits par nom
class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate({required this.products});

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
    List<Product> results = products
        .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(results[index].imageUrl),
          title: Text(results[index].title),
          subtitle: Text("\$${results[index].price}"),
          onTap: () {
            // Naviguer vers la page de détails du produit
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestions = products
        .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(suggestions[index].imageUrl),
          title: Text(suggestions[index].title),
          subtitle: Text("\$${suggestions[index].price}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: suggestions[index]),
              ),
            );          },
        );
      },
    );
  }
}
