import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/presentation/bloc/recipe_categories_bloc.dart';
import 'package:whisk_and_serve_explore/presentation/widgets/category_item.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  ExploreState createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  @override
  void initState() {
    super.initState();
    addBlocEvent<RecipeCategoriesBloc>(context, FetchRecipeCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createBlocBuilder<RecipeCategoriesBloc, RecipeCategoriesState>(
        builder: (context, state) {
                      print("object.............. $state");
          if (state is RecipeCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeCategoriesLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                int columns = getColumnCount(screenWidth: constraints.maxWidth);
                return GridView.builder(
                  itemCount: state.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return CategoryItem(category: category);
                  },
                );
              },
            );
          } else if (state is RecipeCategoriesError) {
            SnackbarHandler(context).show(GenericMessage(
              message: state.message,
              type: MessageType.error,
            ));
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Press refresh to load categories"));
        },
      ),
    );
  }
}
