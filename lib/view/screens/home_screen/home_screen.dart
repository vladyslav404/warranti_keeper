import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_it_g/constants/assets.dart';
import 'package:keep_it_g/constants/routes.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';
import 'package:keep_it_g/providers/product_provider.dart';
import 'package:keep_it_g/view/screens/home_screen/widgets/product_list_view.dart';
import 'package:keep_it_g/view/widgets/generic_dialogs.dart';
import 'package:keep_it_g/view/widgets/generic_loading_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  bool isInit = false;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  DateFormat f = DateFormat.yMMMd();
  Future<void> _initAsyncCalls() async {
    isLoading = true;
    var response = await context.read<ProductProvider>().getProducts();
    if (response != null) {
      Dialogs.showDialogIfError(response);
    }
    widget.isInit = true;
    setState(() => isLoading = false);
  }

  Future<void> _onRefresh() async {
    var response = await context.read<ProductProvider>().getProducts();
    if (response != null) {
      Dialogs.showDialogIfError(response);
    }
  }

  _onItemTap(ProductModel productModel, BuildContext context) {
    Navigator.pushNamed(
      context,
      ConstRoutes.createProductScreen,
      arguments: productModel,
    );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isInit) {
      _initAsyncCalls();
    }
  }

  @override
  Widget build(BuildContext context) {
    var pp = context.watch<ProductProvider>();

    return isLoading
        ? const GenericLoadingScreen()
        : DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Items"),
                bottom: const TabBar(
                  tabs: [Tab(text: "Valid"), Tab(text: "Expired")],
                ),
              ),
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: TabBarView(children: [
                  ProductListView(
                    productList: pp.validProducts,
                    onItemTap: _onItemTap,
                  ),
                  ProductListView(
                    productList: pp.expiredProducts,
                    onItemTap: _onItemTap,
                  ),
                ]),
              ),
            ),
          );
  }
}
