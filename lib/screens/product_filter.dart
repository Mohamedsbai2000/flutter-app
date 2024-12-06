import 'package:flutter/material.dart';
import 'package:projects/models/product.dart';
import 'package:projects/screens/product_details.dart';

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: results[index]),
              ),
            );
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
            // Naviguer vers la page de détails du produit
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: suggestions[index]),
              ),
            );
          },
        );
      },
    );
  }
}

