import 'package:whisk_and_serve_core/api/network_client.dart';
import 'package:whisk_and_serve_core/api/network_exception.dart';

import 'package:whisk_and_serve_explore/data/models/category_model.dart';

class RecipeRemoteDataSource {
  final NetworkClient client;

  RecipeRemoteDataSource({required this.client});

  Future<List<CategoryModel>> getRecipeCategories() async {
    try {
    final response = await client.getRequest('/categories.php'); 
    final data = response.data;
    if (data['categories'] != null) {
      return (data['categories'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw NetworkException(message: 'Categories not found');
    }
    } on NetworkException catch (_) {
      rethrow;
    }
  }
}
