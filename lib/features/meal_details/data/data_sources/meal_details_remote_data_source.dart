import 'package:whisk_and_serve_core/api/network_client.dart';
import 'package:whisk_and_serve_core/api/network_exception.dart';
import 'package:whisk_and_serve_core/coms/generic_message.dart';
import 'package:whisk_and_serve_core/coms/message_type.dart';
import 'package:whisk_and_serve_explore/features/meal_details/data/models/meal_details_model.dart';

class MealDetailsRemoteDataSource {
  final NetworkClient client;

  MealDetailsRemoteDataSource({required this.client});

  Future<MealDetailsModel> getMealDetails({required String mealId}) async {
    try {
      final response = await client.getRequest('/lookup.php?i=$mealId');
      final data = response.data;
      if (data['meals'] != null) {
        return MealDetailsModel.fromJson(response.data['meals'][0]);
      } else {
        throw GenericMessage(
            message: 'Meal details not found', type: MessageType.info);
      }
    } on NetworkException catch (_) {
      rethrow;
    } on GenericMessage catch (_) {
      rethrow;
    }
  }
}
