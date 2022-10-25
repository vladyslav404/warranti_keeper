import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_it_g/constants/api.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';
import 'package:keep_it_g/models/api_models/product_image_model.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  static CollectionReference productsCollection = FirebaseFirestore.instance.collection(ConstApi.collectionProducts);
  static var productsStorageReference = FirebaseStorage.instance.ref().child(ConstApi.referenceProductImages);

  static Future<List<ProductModel>> getProducts() async {
    List<ProductModel> productsList = [];
    var response =
        await productsCollection.where(ConstApi.fieldUserId, isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for (var element in response.docs) {
      productsList.add(ProductModel.fromJson(element.data() as Map<String, dynamic>));
    }
    return productsList;
  }

  static Future<ProductModel> addProduct(ProductModel productModel) async {
    await productsCollection.add(productModel.toJson());
    return productModel;
  }

  static Future<ProductImageModel> deleteProductImage(ProductImageModel imageInfo) async {
    var imageReference = productsStorageReference.child(imageInfo.imageId);
    await imageReference.delete();
    return imageInfo;
  }

  static Future<ProductModel> deleteProduct(ProductModel productModel) async {
    await deleteProductImage(productModel.productImage);
    var response = await productsCollection.where(ConstApi.uid, isEqualTo: productModel.uid).get();
    String docId = response.docs.first.id;
    await productsCollection.doc(docId).delete();
    return productModel;
  }

  static Future<Map<String, dynamic>> updateProduct(String productUid,
      {String? productName, DateTime? expiryDate, ProductImageModel? imageInfo}) async {
    var response = await productsCollection.where(ConstApi.uid, isEqualTo: productUid).get();
    String docId = response.docs[0].id;
    Map<String, dynamic> allFields = {
      ConstApi.productName: productName,
      ConstApi.expiryDate: expiryDate,
    };
    if (imageInfo != null) {
      allFields.addAll({
        ConstApi.productImage: {
          ConstApi.imageId: imageInfo.imageId,
          ConstApi.imageUrl: imageInfo.imageUrl,
        },
      });
    }
    allFields.removeWhere((key, value) => value == null);
    await productsCollection.doc(docId).update(allFields);
    return allFields;
  }

  static Future<ProductImageModel> addProductImage(File image) async {
    String imageType = image.path.split(".").last;
    var imageReference = productsStorageReference.child("${const Uuid().v4()}.$imageType");
    var result = await imageReference.putFile(image);
    String url = await result.ref.getDownloadURL();
    String imageName = result.ref.name;
    return ProductImageModel(imageId: imageName, imageUrl: url);
  }

  static Future<ProductImageModel> updateProductImage(File newImage, ProductImageModel currentImageData) async {
    var imageReference = productsStorageReference.child(currentImageData.imageId);
    var result = await imageReference.putFile(newImage);
    String url = await result.ref.getDownloadURL();
    return ProductImageModel(imageId: result.ref.name, imageUrl: url);
  }
}
