class NutritionItem {
  final String fid;
  final String foodName;
  final double energyKcal;
  final double carbG;
  final double proteinG;
  final double fatG;
  final double fibreG;
  final double sfaMg;
  final double cholesterolMg;
  final double ironMg;
  final double vitCMg;
  final double calciumMg;
  final double sodiumMg;
  final double potassiumMg;

  NutritionItem({
    required this.fid,
    required this.foodName,
    required this.energyKcal,
    required this.carbG,
    required this.proteinG,
    required this.fatG,
    required this.fibreG,
    required this.sfaMg,
    required this.cholesterolMg,
    required this.ironMg,
    required this.vitCMg,
    required this.calciumMg,
    required this.sodiumMg,
    required this.potassiumMg,
  });

  // Convert JSON to NutritionItem
  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      fid: json['fid'].toString(),
      foodName: json['food_name'],
      energyKcal: json['energy_kcal']?.toDouble() ?? 0.0,
      carbG: json['carb_g']?.toDouble() ?? 0.0,
      proteinG: json['protein_g']?.toDouble() ?? 0.0,
      fatG: json['fat_g']?.toDouble() ?? 0.0,
      fibreG: json['fibre_g']?.toDouble() ?? 0.0,
      sfaMg: json['sfa_mg']?.toDouble() ?? 0.0,
      cholesterolMg: json['cholesterol_mg']?.toDouble() ?? 0.0,
      ironMg: json['iron_mg']?.toDouble() ?? 0.0,
      vitCMg: json['vitc_mg']?.toDouble() ?? 0.0,
      calciumMg: json['calcium_mg']?.toDouble() ?? 0.0,
      sodiumMg: json['sodium_mg']?.toDouble() ?? 0.0,
      potassiumMg: json['potassium_mg']?.toDouble() ?? 0.0,
    );
  }

  // Convert NutritionItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'fid': fid,
      'food_name': foodName,
      'energy_kcal': energyKcal,
      'carb_g': carbG,
      'protein_g': proteinG,
      'fat_g': fatG,
      'fibre_g': fibreG,
      'sfa_mg': sfaMg,
      'cholesterol_mg': cholesterolMg,
      'iron_mg': ironMg,
      'vitc_mg': vitCMg,
      'calcium_mg': calciumMg,
      'sodium_mg': sodiumMg,
      'potassium_mg': potassiumMg,
    };
  }
}
