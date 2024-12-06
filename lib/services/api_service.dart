import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projects/models/product.dart';
import 'package:projects/models/user.dart';


class ApiService {
  final String baseUrl = 'https://dummyjson.com/';


  // Récupérer les utilisateurs avec pagination
  Future<List<User>> fetchUsers({int offset = 0, int limit = 20}) async {
    final response =
    await http.get(Uri.parse('${baseUrl}users?skip=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['users'];
      return data.map<User>((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Récupérer les produits avec pagination
  Future<List<Product>> fetchProducts({int offset = 0, int limit = 20}) async {
    final response = await http.get(
      Uri.parse('${baseUrl}products?skip=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['products'];
      return data.map<Product>((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}
