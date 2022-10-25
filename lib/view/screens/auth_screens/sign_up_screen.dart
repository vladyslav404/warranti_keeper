import 'package:flutter/material.dart';
import 'package:keep_it_g/constants/routes.dart';
import 'package:keep_it_g/localization/keys.dart';
import 'package:keep_it_g/localization/translations.i18n.dart';
import 'package:keep_it_g/providers/auth_provider.dart';
import 'package:keep_it_g/utils/validation.dart';
import 'package:keep_it_g/view/widgets/generic_contained_button.dart';
import 'package:keep_it_g/view/widgets/generic_dialogs.dart';
import 'package:keep_it_g/view/widgets/generic_loading_screen.dart';
import 'package:keep_it_g/view/widgets/generic_text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isObscure = true;
  final bool _autoFocus = true;
  bool isLoading = false;
  final FocusNode _confirmPasswordFocus = FocusNode();

  void _setIsObscure(bool? canSee) => setState(() => _isObscure = !_isObscure);

  void onPasswordTextFieldSubmit(value) => _checkIfTextFieldsEmpty() ? null : _onSignUpPress(context);

  bool _checkIfTextFieldsEmpty() => _email.text.isEmpty || _password.text.isEmpty || _confirmPassword.text.isEmpty;

  Future<void> _onSignUpPress(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var result = await context.read<AuthProvider>().signUp(
            _email.text.trim(),
            _password.text.trim(),
          );
      if (result != null) {
        Dialogs.showDialogIfError(result);
        setState(() => isLoading = false);
        return;
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          ConstRoutes.navigationScreen,
          (route) => false,
        );
      }
    }
  }

  _buildSignUpForm() {
    return Form(
      key: _formKey,
      onChanged: () => setState(() => {}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              TranslationKeys.signUp.i18n,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 50),
            GenericTextField(
              autofocus: _autoFocus,
              controller: _email,
              hintText: TranslationKeys.email.i18n,
              keyboardType: TextInputType.emailAddress,
              label: Text(TranslationKeys.email.i18n),
              textInputAction: TextInputAction.next,
              validator: Validator.onEmailValidation,
            ),
            const SizedBox(height: 32),
            GenericTextField(
              controller: _password,
              hintText: TranslationKeys.password.i18n,
              isObscure: _isObscure,
              label: Text(TranslationKeys.password.i18n),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _confirmPasswordFocus.requestFocus(),
              validator: Validator.onPasswordValidation,
            ),
            const SizedBox(height: 32),
            GenericTextField(
              controller: _confirmPassword,
              focusNode: _confirmPasswordFocus,
              hintText: TranslationKeys.confirmPassword.i18n,
              isObscure: _isObscure,
              label: Text(TranslationKeys.confirmPassword.i18n),
              onFieldSubmitted: onPasswordTextFieldSubmit,
              textInputAction: TextInputAction.next,
              validator: (value) => _password.text != value ? TranslationKeys.warnValidationConfirmPassword : null,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  onChanged: _setIsObscure,
                  value: !_isObscure,
                  activeColor: const Color(0xFF6200EE),
                ),
                Text(TranslationKeys.showPassword.i18n),
              ],
            ),
            const SizedBox(height: 32),
            GenericContainedButton(
              onPressed: _checkIfTextFieldsEmpty() ? null : () => _onSignUpPress(context),
              buttonText: TranslationKeys.createAccount.i18n,
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
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const Spacer(),
                              _buildSignUpForm(),
                              const Spacer(),
                            ],
                          ),
                        ]),
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
    _confirmPassword.dispose();
    super.dispose();
  }
}
