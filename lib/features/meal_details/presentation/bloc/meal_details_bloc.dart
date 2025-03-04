import 'package:flutter/foundation.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/meal_details/domain/usecases/get_meal_details_by_id.dart';

part 'meal_details_event.dart';
part 'meal_details_state.dart';

class MealDetailsBloc extends BaseBloc<MealDetailsEvent, MealDetailsState> {
  GetMealDetailsById getMealDetailsById;

  MealDetailsBloc({required this.getMealDetailsById})
      : super(MealDetailsInitial()) {
    onWithStateEmitter<FetchMealDetailsById>(
      _getMealsDetailsById,
    );
  }

  Future<void> _getMealsDetailsById(
    FetchMealDetailsById event,
    StateEmitter<MealDetailsState> emitter,
  ) async {
    await emitter.emit(MealDetailsLoading());
    try {
      final meal = await getMealDetailsById.call(mealId: event.mealId);
      await emitter.emit(MealDetailsLoaded(meal: meal));
    } catch (e) {
      await emitter.emit(MealDetailsError(message: e.toString()));
    }
  }
}
