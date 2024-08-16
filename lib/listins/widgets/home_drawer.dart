import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listin/authentication/services/auth_service.dart';

import '../../authentication/components/dialog_remove_account.dart';

class HomeDrawer extends StatelessWidget {
  final User user;
  const HomeDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: ((user.photoURL == null)
                  ? const AssetImage("assets/logo_1152.png")
                  : NetworkImage(user.photoURL!)) as ImageProvider,
            ),
            accountName: Text(
              (user.displayName != null) ? user.displayName! : "",
            ),
            accountEmail: Text(user.email!),
          ),
          //TODO: Registrar foto de perfil da pessoa usuária
          // ListTile(
          //   leading: const Icon(Icons.image),
          //   title: const Text("Mudar foto de perfil"),
          //   contentPadding: const EdgeInsets.only(left: 16),
          //   dense: true,
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Remover conta"),
            contentPadding: const EdgeInsets.only(left: 16),
            dense: true,
            onTap: () {
              showRemoveAccountPasswordConfirmationDialog(
                context: context,
                email: user.email!,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
            contentPadding: const EdgeInsets.only(left: 16),
            dense: true,
            onTap: () {
              AuthService().logout();
            },
          ),
        ],
      ),
    );
  }
}
