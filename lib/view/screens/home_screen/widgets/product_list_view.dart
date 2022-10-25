import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_it_g/constants/assets.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';

class ProductListView extends StatelessWidget {
  ProductListView({Key? key, required this.productList, required this.onItemTap}) : super(key: key);
  DateFormat f = DateFormat.yMMMd();

  final List<ProductModel> productList;
  final Function(ProductModel productModel, BuildContext context) onItemTap;

  @override
  Widget build(BuildContext context) {
    return productList.isEmpty
        ? const Center(
            child: Text("No items were found"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ListTile(
                      onTap: () => onItemTap(productList[index], context),
                      title: Text(productList[index].productName),
                      subtitle: Text("Expires: ${f.format(productList[index].expiryDate)}"),
                      dense: false,
                      leading: CachedNetworkImage(
                        imageUrl: productList[index].productImage.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset(ConstAssets.imgPlaceholder),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
