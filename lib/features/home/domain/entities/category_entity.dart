import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String categoryName;
  final String categoryImage;

  const CategoryEntity({
    this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });
  @override
  List<Object?> get props => [categoryId, categoryName, categoryImage];
}
