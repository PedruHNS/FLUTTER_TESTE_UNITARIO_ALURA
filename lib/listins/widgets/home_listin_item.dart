import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/constants/listin_colors.dart';
import 'package:flutter_listin/listins/models/listin.dart';
import 'package:flutter_listin/products/screens/products_screen.dart';
import '../../_core/helpers/time_passed.dart';

class HomeListinItem extends StatelessWidget {
  final Listin listin;
  final Function showOptionModal;
  const HomeListinItem({
    super.key,
    required this.listin,
    required this.showOptionModal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.list),
          title: Text(
            listin.name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          subtitle: Text(getTextualTimePassed(listin.dateUpdate)),
          trailing: InkWell(
            child: const Icon(Icons.more_vert),
            onTap: () {
              showOptionModal(listin);
            },
          ),
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductsScreen(listin: listin),
              ),
            );
          },
        ),
        const Divider(
          color: ListinColors.graydark,
        ),
      ],
    );
  }
}
