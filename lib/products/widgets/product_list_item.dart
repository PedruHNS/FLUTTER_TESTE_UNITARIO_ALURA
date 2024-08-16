import 'package:flutter/material.dart';
import '../model/product.dart';

class ProductListItem extends StatefulWidget {
  final String listinId;
  final Product product;
  final Function onTap;
  final Function onCheckboxTap;
  final Function onTrailButtonTap;

  const ProductListItem({
    super.key,
    required this.listinId,
    required this.product,
    required this.onTap,
    required this.onCheckboxTap,
    required this.onTrailButtonTap,
  });

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap(product: widget.product);
      },
      leading: Checkbox(
        value: widget.product.isPurchased,
        onChanged: (value) {
          setState(() {
            widget.product.isPurchased = !widget.product.isPurchased;
          });
          widget.onCheckboxTap(
            product: widget.product,
            listinId: widget.listinId,
          );
        },
      ),
      trailing: IconButton(
        onPressed: (() {
          widget.onTrailButtonTap(widget.product);
        }),
        icon: const Icon(Icons.delete),
      ),
      title: Text(
        (widget.product.amount == null)
            ? widget.product.name
            : "${widget.product.name} (x${widget.product.amount!.toInt()})",
      ),
      subtitle: Text(
        (widget.product.price == null)
            ? "Clique para adicionar preço"
            : "R\$ ${widget.product.price!}",
      ),
    );
  }
}
