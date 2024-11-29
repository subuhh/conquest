import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final TextTheme textTheme;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100.withOpacity(0.5),
            Colors.blue.shade200.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Title
            Text(
              recipe['title'],
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.blue.shade900,
                letterSpacing: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Recipe Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailChip(
                  icon: Icons.local_fire_department,
                  label: '${recipe['calories']} Cal',
                  color: Colors.orange.shade400,
                ),
                _buildDetailChip(
                  icon: Icons.timer,
                  label: recipe['recipeTime'],
                  color: Colors.green.shade400,
                ),
                _buildDetailChip(
                  icon: Icons.restaurant,
                  label: recipe['course'],
                  color: Colors.purple.shade400,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Recipe Info
            _buildInfoSection(),

            // Ingredients Section
            _buildSectionHeader("Ingredients"),
            const SizedBox(height: 8),
            _buildIngredientsList(),

            // Steps Section
            _buildSectionHeader("Preparation Steps"),
            const SizedBox(height: 8),
            _buildStepsList(),

            // Nutritional Values
            _buildSectionHeader("Nutritional Insights"),
            const SizedBox(height: 8),
            _buildNutritionalValues(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.roboto(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSmallInfoChip('Cuisine', recipe['cuisine']),
        _buildSmallInfoChip('Diet', recipe['diet']),
      ],
    );
  }

  Widget _buildSmallInfoChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      children: recipe['ingredients']?.map<Widget>((ingredient) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.kitchen, color: Colors.blue.shade300, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${ingredient['ingredient']} (${ingredient['quantity']})",
                      style: GoogleFonts.roboto(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildStepsList() {
    final steps = recipe['steps'] ?? [];
    return Column(
      children: steps.asMap().entries.map<Widget>((entry) {
        final index = entry.key + 1; // For 1-based numbering
        final step = entry.value;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$index", // Displaying the step number
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step['instruction'],
                  style: GoogleFonts.roboto(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutritionalValues() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade100.withOpacity(0.5),
            Colors.green.shade200.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: recipe['nutritionValue'] != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe['nutritionValue'].entries.map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key.toString().toUpperCase(),
                        style: GoogleFonts.roboto(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          : Text(
              "No nutritional information available.",
              style: GoogleFonts.roboto(
                color: Colors.green.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
