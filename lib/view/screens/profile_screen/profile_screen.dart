import 'package:flutter/material.dart';
import 'package:keep_it_g/constants/routes.dart';
import 'package:keep_it_g/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/generic_dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> onLogoutPress(BuildContext context) async {
    var authProvider = context.read<AuthProvider>();
    bool response = await Dialogs.showAreYouSureDialog("Are you sure you want to logout?");
    if (response) {
      await authProvider.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        ConstRoutes.signInScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => onLogoutPress(context),
        child: const Text("Logout"),
      ),
    );
  }
}
