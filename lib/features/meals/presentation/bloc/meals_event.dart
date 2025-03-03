part of 'meals_bloc.dart';

@immutable
sealed class MealsEvent {}

class FetcMealsByMainIngrident extends MealsEvent {
  final String ingredient;

  FetcMealsByMainIngrident({
    required this.ingredient,
  });
}
