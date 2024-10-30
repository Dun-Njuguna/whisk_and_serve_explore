import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whisk_and_serve_explore/data/models/category_model.dart';

class RecipeRemoteDataSource {
  final String _baseUrl =
      'https://www.themealdb.com/api/json/v1/1/categories.php';

  Future<List<CategoryModel>> getRecipeCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['categories'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
