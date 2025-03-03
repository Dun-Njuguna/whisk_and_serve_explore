import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/entities/explore/meal.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/meals/domain/usecases/get_meals_by_main_ingrident.dart';

part 'meals_event.dart';
part 'meals_state.dart';

class MealsBloc extends BaseBloc<MealsEvent, MealsState> {
  GetMealsByMainIngrident getMealsByMainIngrident;

  MealsBloc({
    required this.getMealsByMainIngrident,
  }) : super(
          MealsInitial(),
        ) {
    onWithStateEmitter<FetcMealsByMainIngrident>(
      _getMealsByMainIngrident,
    );
  }

  Future<void> _getMealsByMainIngrident(
    FetcMealsByMainIngrident event,
    StateEmitter<MealsState> emitter,
  ) async {
    await emitter.emit(MealsLoading());
    try {
      final meals = await getMealsByMainIngrident.call(
        ingredient: event.ingredient,
      );
      await emitter.emit(MealsLoaded(meals: meals));
    } catch (e) {
      await emitter.emit(MealsError(message: e.toString()));
    }
  }
}
