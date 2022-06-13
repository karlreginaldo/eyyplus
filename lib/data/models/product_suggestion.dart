import 'package:hive/hive.dart';

import 'package:eyyplus/domain/entity/product_suggestion.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
part 'product_suggestion.g.dart';

@HiveType(typeId: 2)
class ProductSuggestionModel extends ProductSuggestionEntity {
  @HiveField(0)
  final String suggestion;
  final String receiptno;
  ProductSuggestionModel({
    required this.suggestion,
    required this.receiptno,
  }) : super(
          suggestion: suggestion,
          receiptno: receiptno,
        );

  factory ProductSuggestionModel.fromEntity(ProductSuggestionEntity product) {
    return ProductSuggestionModel(
      suggestion: product.suggestion,
      receiptno: product.receiptno,
    );
  }
}
