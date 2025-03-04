part of 'meal_details_bloc.dart';

@immutable
sealed class MealDetailsEvent {}

class FetchMealDetailsById extends MealDetailsEvent {
  final String mealId;

  FetchMealDetailsById({
    required this.mealId,
  });
}
