import 'package:flutter/material.dart';
import 'package:keep_it_g/constants/routes.dart';
import 'package:keep_it_g/localization/keys.dart';
import 'package:keep_it_g/localization/translations.i18n.dart';
import 'package:keep_it_g/providers/auth_provider.dart';
import 'package:keep_it_g/utils/validation.dart';
import 'package:keep_it_g/view/widgets/generic_contained_button.dart';
import 'package:keep_it_g/view/widgets/generic_dialogs.dart';
import 'package:keep_it_g/view/widgets/generic_loading_screen.dart';
import 'package:keep_it_g/view/widgets/generic_text_divider.dart';
import 'package:keep_it_g/view/widgets/generic_text_field.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isObscure = true;
  bool _autoFocus = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool _checkIfTextFieldsEmpty() => _email.text.isEmpty || _password.text.isEmpty;

  void _setIsObscure() => setState(() => _isObscure = !_isObscure);

  void _onPasswordTextFieldSubmit(value) => _checkIfTextFieldsEmpty() ? null : onSignInPress(context);

  Future<void> onSignInPress(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _autoFocus = false;
      setState(() => isLoading = true);
      var result = await context.read<AuthProvider>().signIn(_email.text.trim(), _password.text.trim());
      print(result);
      if (result != null) {
        Dialogs.showDialogIfError(result);
        setState(() => isLoading = false);
        return;
      }
      if (mounted) Navigator.pushNamed(context, ConstRoutes.navigationScreen);
    }
  }

  _buildSignInForm() {
    return Form(
      key: _formKey,
      onChanged: () => setState(() {}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TranslationKeys.signIn.i18n,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 50),
            GenericTextField(
              controller: _email,
              label: Text(TranslationKeys.email.i18n),
              hintText: TranslationKeys.email.i18n,
              keyboardType: TextInputType.emailAddress,
              autofocus: _autoFocus,
              textInputAction: TextInputAction.next,
              validator: Validator.onEmailValidation,
            ),
            const SizedBox(height: 32),
            GenericTextField(
              controller: _password,
              label: Text(TranslationKeys.password.i18n),
              hintText: TranslationKeys.password.i18n,
              isObscure: _isObscure,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: _isObscure ? Colors.grey : Theme.of(context).primaryColor,
                ),
                onPressed: _setIsObscure,
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: _onPasswordTextFieldSubmit,
              validator: Validator.onPasswordValidation,
            ),
            const SizedBox(height: 15),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: GestureDetector(
            //     onTap: () {
            //     },
            //     child: Text(
            //       TranslationKeys.forgotPassword.i18n,
            //       style: const TextStyle(fontSize: 12),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 32),
            GenericContainedButton(
              onPressed: _checkIfTextFieldsEmpty() ? null : () => onSignInPress(context),
              buttonText: TranslationKeys.submit.i18n,
            ),
            const SizedBox(height: 32),
            GenericTextDivider(text: TranslationKeys.orConnectYourAccount.i18n),
            // const SizedBox(height: 32),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     GenericContainedButton(onPressed: () {}, buttonText: AppConst.google),
            //     GenericContainedButton(onPressed: () {}, buttonText: AppConst.facebook),
            //     GenericContainedButton(onPressed: () {}, buttonText: AppConst.apple),
            //   ],
            // ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, ConstRoutes.signUpScreen),
              child: Text(
                TranslationKeys.doNotYouHaveAnAccount.i18n,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? const GenericLoadingScreen()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            const Spacer(),
                            _buildSignInForm(),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
