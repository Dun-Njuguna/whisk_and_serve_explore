class MealModel {
  final String mealId;
  final String strMeal;
  final String strMealThumb;

  MealModel(
      {required this.mealId,
      required this.strMeal,
      required this.strMealThumb});

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      mealId: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}
