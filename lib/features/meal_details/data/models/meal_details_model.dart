class MealDetailsModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final List<Map<String, String>> ingredients;

  MealDetailsModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetailsModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredientsList.add({
          'strIngredient': ingredient,
          'strMeasure': measure ?? '',
        });
      }
    }

    return MealDetailsModel(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      youtube: json['strYoutube'],
      ingredients: ingredientsList,
    );
  }
}
