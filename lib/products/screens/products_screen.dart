import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listin/products/helpers/calculate_total_price.dart';
import 'package:flutter_listin/products/helpers/enum_order.dart';
import 'package:flutter_listin/products/components/product_add_edit_modal.dart';
import 'package:flutter_listin/products/services/product_service.dart';
import '../../listins/models/listin.dart';
import '../model/product.dart';
import '../widgets/product_list_item.dart';

class ProductsScreen extends StatefulWidget {
  final Listin listin;
  const ProductsScreen({super.key, required this.listin});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> listaProdutosPlanejados = [];
  List<Product> listaProdutosPegos = [];

  ProductOrder ordem = ProductOrder.name;
  bool isDecrescente = false;

  bool isPlanejadosExpanded = true;
  bool isPegosExpanded = true;

  bool isGroupedByCategory = false;

  final ProductService _productService = ProductService();

  late StreamSubscription listener;

  @override
  void initState() {
    setupListeners();
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listin.name),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: ProductOrder.name,
                  child: Text("Ordenar por nome"),
                ),
                const PopupMenuItem(
                  value: ProductOrder.amount,
                  child: Text("Ordenar por quantidade"),
                ),
                const PopupMenuItem(
                  value: ProductOrder.price,
                  child: Text("Ordenar por preço"),
                ),
              ];
            },
            onSelected: (value) {
              setState(() {
                if (ordem == value) {
                  isDecrescente = !isDecrescente;
                } else {
                  ordem = value;
                  isDecrescente = false;
                }
              });
              refresh();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddEditModal();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 48, bottom: 32),
                child: Column(
                  children: [
                    Text(
                      "R\$${_calculateTotalPrice().toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 52),
                    ),
                    const Text(
                      "total previsto para essa compra",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(8),
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    isPlanejadosExpanded = !isPlanejadosExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    isExpanded: isPlanejadosExpanded,
                    canTapOnHeader: true,
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.format_list_bulleted),
                          title: Text(
                            "Planejados (${listaProdutosPlanejados.length})",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                              "Produtos planejados para esta compra"),
                        ),
                      );
                    },
                    body: Column(
                      children: List.generate(listaProdutosPlanejados.length,
                          (index) {
                        Product produto = listaProdutosPlanejados[index];
                        return ProductListItem(
                          listinId: widget.listin.id,
                          product: produto,
                          onTap: showAddEditModal,
                          onCheckboxTap: _updateToggledProduct,
                          onTrailButtonTap: _removeProduct,
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                // child: Divider(),
              ),
              ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(8),
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    isPegosExpanded = !isPegosExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    isExpanded: isPegosExpanded,
                    canTapOnHeader: true,
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text(
                            "No carrinho (${listaProdutosPegos.length}) ",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                              "Produtos que já foram postos no carrinho"),
                        ),
                      );
                    },
                    body: Column(
                      children:
                          List.generate(listaProdutosPegos.length, (index) {
                        Product produto = listaProdutosPegos[index];
                        return ProductListItem(
                          listinId: widget.listin.id,
                          product: produto,
                          onTap: showAddEditModal,
                          onCheckboxTap: _updateToggledProduct,
                          onTrailButtonTap: _removeProduct,
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }

  setupListeners() {
    listener = _productService.connectStream(
        onChange: refresh,
        listinId: widget.listin.id,
        ordem: ordem,
        isDecrescente: isDecrescente);
  }

  refresh({QuerySnapshot<Map<String, dynamic>>? snapshot}) async {
    List<Product> listProducts = await _productService.getProducts(
        isDecrescente: isDecrescente,
        listinId: widget.listin.id,
        ordem: ordem,
        snapshot: snapshot);

    if (snapshot != null) {
      verifyChangesToSnackbar(snapshot);
    }

    _filterProducts(listProducts);
  }

  _removeProduct(Product produto) async {
    await _productService.removeProduct(
      produto: produto,
      listinId: widget.listin.id,
    );
  }

  showAddEditModal({Product? product}) {
    showProductAddEditProductModal(
      context: context,
      onRefresh: refresh,
      product: product,
      listinId: widget.listin.id,
    );
  }

  _updateToggledProduct({required Product product, required String listinId}) {
    _productService.upinsertProduct(listinId: listinId, produto: product);
  }

  _filterProducts(List<Product> listaProdutos) {
    List<Product> tempPlanejados = [];
    List<Product> tempPegos = [];

    for (var produto in listaProdutos) {
      if (produto.isPurchased) {
        tempPegos.add(produto);
      } else {
        tempPlanejados.add(produto);
      }
    }

    setState(() {
      listaProdutosPegos = tempPegos;
      listaProdutosPlanejados = tempPlanejados;
    });
  }

  double _calculateTotalPrice() {
    return calculateTotalPriceFromListProduct(listaProdutosPegos);
  }

  verifyChangesToSnackbar(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docChanges.length == 1) {
      for (DocumentChange docChange in snapshot.docChanges) {
        String tipo = "";
        Color cor = Colors.black;
        switch (docChange.type) {
          case DocumentChangeType.added:
            tipo = "Novo Produto";
            cor = Colors.green;
            break;
          case DocumentChangeType.modified:
            tipo = "Produto alterado";
            cor = Colors.orange;
            break;
          case DocumentChangeType.removed:
            tipo = "Produto removido";
            cor = Colors.red;
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cor,
            content: Text(
              "$tipo: ${Product.fromMap(docChange.doc.data() as Map<String, dynamic>).name}",
            ),
          ),
        );
      }
    }
  }
}
