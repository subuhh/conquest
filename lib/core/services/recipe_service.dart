import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/recipe_model.dart';

class FirebaseRecipeService {
  final CollectionReference recipeCollection =
  FirebaseFirestore.instance.collection('recipes');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Upload recipe image to Firebase Storage
  Future<String> uploadRecipeImage(XFile imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = _firebaseStorage.ref().child('recipe_images/$fileName');

    // Use readAsBytes() asynchronously
    final bytes = await imageFile.readAsBytes(); // Get bytes from the XFile

    final uploadTask = storageRef.putData(bytes);
    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  // Add a new recipe to Firestore
  Future<void> addRecipe(RecipeModel recipe) async {
    await recipeCollection.add(recipe.toJson());
  }

  // Fetch all recipes from Firestore
  Future<List<RecipeModel>> getAllRecipes() async {
    final querySnapshot = await recipeCollection.get();
    return querySnapshot.docs
        .map((doc) => RecipeModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
