import 'package:pigu/app/core/models/category_model.dart';

abstract class CategoryRepositoryInterface {
  Stream<List<CategoryModel>> getCategory();
}
