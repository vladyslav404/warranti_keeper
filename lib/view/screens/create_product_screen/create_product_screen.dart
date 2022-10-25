import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_it_g/constants/assets.dart';
import 'package:keep_it_g/localization/keys.dart';
import 'package:keep_it_g/localization/translations.i18n.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';
import 'package:keep_it_g/providers/product_provider.dart';
import 'package:keep_it_g/utils/validation.dart';
import 'package:keep_it_g/view/widgets/generic_contained_button.dart';
import 'package:keep_it_g/view/widgets/generic_dialogs.dart';
import 'package:keep_it_g/view/widgets/generic_loading_screen.dart';
import 'package:keep_it_g/view/widgets/generic_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/generic_modals.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key, this.productModel}) : super(key: key);

  final ProductModel? productModel;
  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  bool isLoading = false;
  bool _autoFocus = true;
  XFile? _selectedImage;

  final _formKey = GlobalKey<FormState>();
  final _f = DateFormat.yMMMd();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController(
    text: DateFormat.yMMMd().format(DateTime.now()).toString(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) _setProduct();
  }

  Future<void> _setProduct() async {
    isLoading = true;
    _productName.text = widget.productModel!.productName;
    _expiryDate.text = _f.format(widget.productModel!.expiryDate).toString();
    XFile image = await _getFileFromUrl(widget.productModel!.productImage.imageUrl);
    _selectedImage = image;
    setState(() => isLoading = false);
  }

  Future<XFile> _getFileFromUrl(String imageUrl) async {
    var httpClient = HttpClient();
    imageCache.clear();
    try {
      var request = await httpClient.getUrl(Uri.parse(imageUrl));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      File file = File('${dir.path}/tempImage');
      await file.writeAsBytes(bytes);
      return XFile(file.path);
    } catch (error) {
      return XFile('');
    }
  }

  Future<void> _openModalForImageSource(BuildContext context) async {
    XFile? tempImage = await Modals.openModalForImageSource(context, imageQuality: 50, maxHeight: 200, minWidth: 200);
    if (tempImage != null) {
      setState(() => _selectedImage = tempImage);
    }
  }

  Future<void> _openDatePicker(BuildContext context) async {
    _autoFocus = false;
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate.text.isEmpty || DateTime.now().isAfter(_f.parse(_expiryDate.text))
          ? DateTime.now()
          : _f.parse(_expiryDate.text),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() => _expiryDate.text = DateFormat.yMMMd().format(selectedDate).toString());
    }
  }

  Future<void> _onSavePress(BuildContext context) async {
    if (_selectedImage == null) {
      Dialogs.showSnackBar("Please pick image");
      return;
    }
    if (_formKey.currentState!.validate()) {
      _autoFocus = false;
      setState(() => isLoading = true);
      if (mounted) {
        String? result;
        if (widget.productModel != null) {
          result = await context.read<ProductProvider>().updateProduct(
                widget.productModel!.uid,
                productName: _productName.text == widget.productModel!.productName ? null : _productName.text,
                expiryDate: _expiryDate.text == _f.format(widget.productModel!.expiryDate).toString()
                    ? null
                    : _f.parse(_expiryDate.text),
                selectedImage: _selectedImage!.name.contains("tempImage") ? null : _selectedImage,
                currentImage: widget.productModel!.productImage,
              );
        } else {
          result = await context.read<ProductProvider>().addProduct(
                _productName.text,
                _f.parse(_expiryDate.text),
                _selectedImage!,
              );
        }

        if (result != null) {
          Dialogs.showDialogIfError(result);
          setState(() => isLoading = false);
          return;
        }
      }
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _onDeletePress(BuildContext context) async {
    bool response = await Dialogs.showAreYouSureDialog(
      "Are you sure you want to delete product?",
    );
    if (response && mounted) {
      setState(() => isLoading = true);
      var response = await context.read<ProductProvider>().removeProduct(widget.productModel!);
      if (response != null) {
        setState(() => isLoading = false);
        Dialogs.showDialogIfError(response);
      } else {
        if (mounted) Navigator.pop(context);
      }
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.productModel != null)
              TextButton(
                onPressed: () => _onDeletePress(context),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            else
              Container(),
            TextButton(
              onPressed: () => _onSavePress(context),
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GenericTextField(
            label: const Text("Product name"),
            controller: _productName,
            hintText: "Enter product name",
            keyboardType: TextInputType.text,
            autofocus: _autoFocus,
            validator: Validator.onNotEmptyValidation,
            onEditingComplete: () => _openDatePicker(context),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => _openDatePicker(context),
            child: GenericTextField(
              label: const Text("Expiry date"),
              controller: _expiryDate,
              hintText: TranslationKeys.productName.i18n,
              isEnabled: false,
              textInputAction: TextInputAction.next,
              validator: Validator.onNotEmptyValidation,
            ),
          ),
          GenericContainedButton(
            onPressed: () => _openModalForImageSource(context),
            buttonText: "Select picture",
          ),
          if (_selectedImage != null)
            Expanded(
              child: Image.file(
                File(_selectedImage!.path),
              ),
            )
          else
            Expanded(child: Image.asset(ConstAssets.imgPlaceholder)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const GenericLoadingScreen()
        : GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: _buildAppBar(),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildForm(),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _expiryDate.dispose();
    _productName.dispose();
    super.dispose();
  }
}
