import 'package:keep_it_g/constants/api.dart';
import 'package:keep_it_g/models/api_models/product_image_model.dart';

class ProductModel {
  ProductModel({
    required this.uid,
    required this.userId,
    required this.expiryDate,
    required this.productImage,
    required this.productName,
  });

  String uid;
  String userId;
  DateTime expiryDate;
  ProductImageModel productImage;
  String productName;

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      uid: map[ConstApi.uid],
      userId: map[ConstApi.userId],
      expiryDate: map[ConstApi.expiryDate].toDate(),
      productImage: ProductImageModel.fromJson(map["productImage"]),
      productName: map[ConstApi.productName],
    );
  }

  Map<String, dynamic> toJson() => {
        ConstApi.uid: uid,
        ConstApi.userId: userId,
        ConstApi.expiryDate: expiryDate,
        "productImage": productImage.toJson(),
        ConstApi.productName: productName,
      };

  @override
  String toString() {
    return 'ProductModel{uid: $uid, userId: $userId, expiryDate: $expiryDate, imageUrl: $productImage, productName: $productName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          userId == other.userId &&
          expiryDate == other.expiryDate &&
          productImage == other.productImage &&
          productName == other.productName;

  @override
  int get hashCode =>
      uid.hashCode ^ userId.hashCode ^ expiryDate.hashCode ^ productImage.hashCode ^ productName.hashCode;
}
