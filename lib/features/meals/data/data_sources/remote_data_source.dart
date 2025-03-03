import 'package:whisk_and_serve_core/api/network_client.dart';
import 'package:whisk_and_serve_core/api/network_exception.dart';
import 'package:whisk_and_serve_core/coms/generic_message.dart';
import 'package:whisk_and_serve_core/coms/message_type.dart';
import 'package:whisk_and_serve_explore/features/meals/data/models/meal_model.dart';

class RemoteDataSource {
  final NetworkClient client;

  RemoteDataSource({required this.client});

  Future<List<MealModel>> fetchMealsByMainIngredient(String ingredient) async {
    try {
      final response = await client.getRequest('/filter.php?c=$ingredient');
      final data = response.data;
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      } else {
        throw GenericMessage(
            message: 'Meals not found', type: MessageType.info);
      }
    } on NetworkException catch (_) {
      rethrow;
    } on GenericMessage catch (_) {
      rethrow;
    }
  }
}
