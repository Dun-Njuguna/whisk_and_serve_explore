import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/custom_chip.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/video_popup.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MealDetailsSection extends StatefulWidget {
  final MealDetails meal;

  const MealDetailsSection({super.key, required this.meal});

  @override
  MealDetailsSectionState createState() => MealDetailsSectionState();
}

class MealDetailsSectionState extends State<MealDetailsSection> {
  int selectedTab = 0; // 0 for Ingredients, 1 for Instructions
  YoutubePlayerController? _youtubeController;

  late String pureInstructions;
  late String nutritionFacts;
  late bool hasNutritionFacts;

  @override
  void initState() {
    super.initState();

    // Split the instructions
    final splitContent =
        _splitInstructionsAndNutrition(widget.meal.instructions);
    pureInstructions = splitContent['instructions']!;
    nutritionFacts = splitContent['nutrition']!;
    hasNutritionFacts = nutritionFacts.isNotEmpty;

    // YouTube init logic stays unchanged
    if (widget.meal.youtube != null && widget.meal.youtube!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.meal.youtube!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    }

    if (widget.meal.youtube != null && widget.meal.youtube!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.meal.youtube!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _playVideo() {
    if (_youtubeController != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => VideoPopup(controller: _youtubeController!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Name
          Text(
            widget.meal.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Category & Cuisine + YouTube Video Chip
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              buildChip(context, 'Category: ${widget.meal.category}'),
              buildChip(context, 'Cuisine: ${widget.meal.area}'),
              if (widget.meal.youtube != null &&
                  widget.meal.youtube!.isNotEmpty)
                GestureDetector(
                  onTap: _playVideo,
                  child: buildChip(context, 'Watch Video',
                      icon: Icons.play_circle_fill),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Tab Buttons
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _buildTabButton(context, 'Ingredients', 0),
            const SizedBox(width: 8),
            _buildTabButton(context, 'Instructions', 1),
            if (hasNutritionFacts) ...[
              const SizedBox(width: 8),
              _buildTabButton(context, 'Nutrition Facts', 2),
            ],
          ]),
          const SizedBox(height: 8),

          // Tab Content
// Tab Content
          if (selectedTab == 0)
            _buildIngredients(context, widget.meal.ingredients)
          else if (selectedTab == 1)
            _buildInstructions(pureInstructions)
          else if (selectedTab == 2 && hasNutritionFacts)
            _buildNutritionFacts(context, nutritionFacts)
        ],
      ),
    );
  }

  // Custom Tab Button Widget
  Widget _buildTabButton(BuildContext context, String title, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => selectedTab = index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: TextStyle(
                  color:
                      isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Bottom indicator line
            Container(
              height: 3,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionFacts(BuildContext context, String nutritionFacts) {
    // Clean and split the nutrition facts string
    final rawFacts = nutritionFacts
        .replaceFirst('Nutrition Facts', '')
        .split(',')
        .map((fact) => fact.trim())
        .where((fact) => fact.isNotEmpty)
        .toList();

    // Reverse the order to make it like: 'calories  445'
    final reversedFacts = rawFacts.map((fact) {
      final parts = fact.split(' ');
      if (parts.length > 1) {
        final value = parts.first;
        final name = parts.sublist(1).join(' ');
        return {'label': name, 'value': value};
      }
      return {'label': fact, 'value': ''}; // Return empty value if can't split
    }).toList();

    // Render as list like ingredients with spacing
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, // Aligns with ingredient styling
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reversedFacts.length,
        itemBuilder: (context, index) {
          final fact = reversedFacts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                // Numbering Circle (same as ingredients)
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Fact content aligned like ingredients
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Label (e.g., 'calories')
                      Text(
                        fact['label'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      // Value (e.g., '445')
                      Text(
                        fact['value'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Instructions Section with improved detection of bullet points
  Widget _buildInstructions(String instructions) {
    // Multiple ways to detect instruction boundaries
    final List<String> formatedInstructions =
        _detectInstructionBoundaries(instructions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < formatedInstructions.length; i++)
          InstructionItem(
            index: i + 1,
            instruction: formatedInstructions[i],
          ),
      ],
    );
  }
}

// Extracted instruction item into its own widget for better reusability
class InstructionItem extends StatelessWidget {
  final int index;
  final String instruction;

  const InstructionItem({
    Key? key,
    required this.index,
    required this.instruction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              index.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction.trim(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Ingredients Section with improved design
Widget _buildIngredients(
    BuildContext context, List<Map<String, String>> ingredients) {
  return MediaQuery.removePadding(
    context: context,
    removeTop: true, // This removes the upper padding
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingredient['strIngredient'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (ingredient['strMeasure'] != null)
                      Text(
                        ingredient['strMeasure']!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Map<String, String> _splitInstructionsAndNutrition(String rawInstructions) {
  final nutritionIndex = rawInstructions.indexOf('Nutrition Facts');

  if (nutritionIndex != -1) {
    // Split correctly
    final instructions = rawInstructions.substring(0, nutritionIndex).trim();
    final nutritionFacts = rawInstructions.substring(nutritionIndex).trim();
    return {
      'instructions': instructions,
      'nutrition': nutritionFacts,
    };
  } else {
    // No Nutrition Facts present
    return {
      'instructions': rawInstructions.trim(),
      'nutrition': '',
    };
  }
}

// Multiple strategies to detect instruction boundaries
List<String> _detectInstructionBoundaries(String rawInstructions) {
  // First try: If instructions already have numbers at the beginning (e.g., "1. Do this")
  final numberPattern = RegExp(r'^\s*\d+[\.\)]\s+');

  // Second try: If instructions have bullet points
  final bulletPattern = RegExp(r'^\s*[\•\-\*]\s+');

  // Third try: Split by newlines and look for sentence patterns
  final newlinePattern = RegExp(r'\r\n|\n');

  // Fourth try: Look for sequential sentences ending with periods followed by capital letters
  final sentencePattern = RegExp(r'(?<=[.!?])\s+(?=[A-Z])');

  // Try the most structured approach first (numbered list)
  if (rawInstructions.contains(numberPattern)) {
    return rawInstructions
        .split(newlinePattern)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceFirst(numberPattern, '').trim())
        .toList();
  }

  // Try bullet points
  if (rawInstructions.contains(bulletPattern)) {
    return rawInstructions
        .split(newlinePattern)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceFirst(bulletPattern, '').trim())
        .toList();
  }

  // Try newlines
  final byNewlines = rawInstructions
      .split(newlinePattern)
      .where((line) => line.trim().isNotEmpty)
      .map((line) => line.trim())
      .toList();

  if (byNewlines.length > 1) {
    return byNewlines;
  }

  // Try sentence boundaries
  final bySentences = rawInstructions
      .split(sentencePattern)
      .where((sentence) => sentence.trim().isNotEmpty)
      .map((sentence) => sentence.trim())
      .toList();

  if (bySentences.length > 1) {
    return bySentences;
  }

  // If all else fails, just return the whole text as a single instruction
  return [rawInstructions.trim()];
}

// Helper function to determine if a line is likely the start of a new instruction
bool _isLikelyNewInstruction(String line) {
  // Common patterns indicating a new step
  final patterns = [
    RegExp(r'^\s*Step\s+\d+', caseSensitive: false), // "Step 1", "Step 2", etc.
    RegExp(r'^\s*First', caseSensitive: false), // "First, ..."
    RegExp(r'^\s*Next', caseSensitive: false), // "Next, ..."
    RegExp(r'^\s*Then', caseSensitive: false), // "Then, ..."
    RegExp(r'^\s*Finally', caseSensitive: false), // "Finally, ..."
    RegExp(r'^\s*After that', caseSensitive: false), // "After that, ..."
    RegExp(r'^\s*Once', caseSensitive: false), // "Once ...", "Once you've ..."
  ];

  for (final pattern in patterns) {
    if (pattern.hasMatch(line)) {
      return true;
    }
  }

  return false;
}

// Advanced NLP-like approach to detect instruction boundaries
List<String> _detectInstructionsBySemantics(String rawInstructions) {
  final sentences = rawInstructions.split(RegExp(r'(?<=[.!?])\s+'));
  final instructions = <String>[];
  String currentInstruction = '';

  for (final sentence in sentences) {
    if (currentInstruction.isEmpty) {
      currentInstruction = sentence;
      continue;
    }

    // If the sentence starts with a word that indicates a new action
    if (_isLikelyNewInstruction(sentence)) {
      if (currentInstruction.isNotEmpty) {
        instructions.add(currentInstruction.trim());
      }
      currentInstruction = sentence;
    } else {
      currentInstruction += ' ' + sentence;
    }
  }

  if (currentInstruction.isNotEmpty) {
    instructions.add(currentInstruction.trim());
  }

  return instructions;
}
