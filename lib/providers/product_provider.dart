import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_it_g/firebase_api/product_service.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';
import 'package:keep_it_g/models/api_models/product_image_model.dart';
import 'package:uuid/uuid.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _productsList = [];

  List<ProductModel> get products {
    return _productsList;
  }

  List<ProductModel> get validProducts {
    return _productsList.where((element) => DateTime.now().isBefore(element.expiryDate)).toList();
  }

  List<ProductModel> get expiredProducts {
    return _productsList.where((element) => DateTime.now().isAfter(element.expiryDate)).toList();
  }

  set products(List<ProductModel> list) {
    list.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    _productsList = List.from(list);
  }

  Future<String?> getProducts() async {
    try {
      _productsList = await ProductService.getProducts();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> updateProduct(String productId,
      {String? productName,
      DateTime? expiryDate,
      XFile? selectedImage,
      required ProductImageModel currentImage}) async {
    ProductImageModel? imageInfo;
    try {
      if (selectedImage != null) {
        imageInfo = await ProductService.updateProductImage(File(selectedImage.path), currentImage);
      }
      await ProductService.updateProduct(
        productId,
        expiryDate: expiryDate,
        imageInfo: imageInfo,
        productName: productName,
      );
      int updatedProductIndex = _productsList.indexWhere((element) => element.uid == productId);
      if (productName != null) _productsList[updatedProductIndex].productName = productName;
      if (expiryDate != null) _productsList[updatedProductIndex].expiryDate = expiryDate;
      if (imageInfo != null) _productsList[updatedProductIndex].productImage = imageInfo;
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> addProduct(String productName, DateTime expiryDate, XFile selectedImage) async {
    ProductImageModel? imageUrl;
    try {
      imageUrl = await ProductService.addProductImage(
        File(selectedImage.path),
      );
      var response = await ProductService.addProduct(
        ProductModel(
          uid: const Uuid().v4(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          expiryDate: expiryDate,
          productImage: imageUrl,
          productName: productName,
        ),
      );
      _productsList.add(response);
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String?> removeProduct(ProductModel productModel) async {
    try {
      var response = await ProductService.deleteProduct(productModel);
      int index = _productsList.indexWhere((e) => e.uid == response.uid);
      _productsList.removeAt(index);
      notifyListeners();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
