class ProductImageModel {
  String imageId;
  String imageUrl;

  ProductImageModel({required this.imageId, required this.imageUrl});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) => ProductImageModel(
        imageUrl: json["imageUrl"],
        imageId: json["imageId"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "imageId": imageId,
      };

  @override
  String toString() {
    return 'ProductImageModel{imageId: $imageId, imageUrl: $imageUrl}';
  }
}
