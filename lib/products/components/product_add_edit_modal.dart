import "package:flutter/material.dart";
import 'package:flutter_listin/products/services/product_service.dart';
import 'package:uuid/uuid.dart';
import '../model/product.dart';

showProductAddEditProductModal({
  required BuildContext context,
  required Function onRefresh,
  required String listinId,
  Product? product,
}) {
  // Labels à serem mostradas no Modal
  String labelTitle = "Adicionar produto";
  String labelConfirmationButton = "Salvar";
  String labelSkipButton = "Cancelar";

  // Controlador dos campos do produto
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController obsController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  bool isPurchased = false;
  bool isKilograms = false;

  bool isOptionalExpanded = false;

  // Caso esteja editando
  if (product != null) {
    labelTitle = "Editando ${product.name}";
    nameController.text = product.name;
    obsController.text = product.obs;
    categoryController.text = product.category;

    if (product.price != null) {
      priceController.text = product.price.toString();
    }

    if (product.amount != null) {
      amountController.text = product.amount.toString();
    }

    isPurchased = product.isPurchased;
    isKilograms = product.isKilograms;

    isOptionalExpanded = true;
  }

  // Função do Flutter que mostra o modal na tela
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Define que as bordas verticais serão arredondadas
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
    ),
    builder: (context) {
      return SingleChildScrollView(
        reverse: true,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              // Formulário com Título, Campo e Botões
              child: ListView(
                children: [
                  Text(
                    labelTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      label: Text("Nome do produto"),
                      icon: Icon(Icons.shopping_basket),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        (isKilograms) ? "Quantidade em quilos" : "Quantidade",
                      ),
                      icon: const Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      label: Text((isKilograms) ? "Preço em quilos" : "Preço"),
                      icon: const Icon(Icons.attach_money_rounded),
                      prefixText: "R\$ ",
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CheckboxListTile(
                    value: isPurchased,
                    title: const Text(
                      "Já está no carrinho?",
                    ),
                    onChanged: (value) {
                      setState(() {
                        isPurchased = !isPurchased;
                      });
                    },
                  ),
                  ExpansionPanelList(
                    elevation: 0,
                    materialGapSize: 0,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        isOptionalExpanded = !isOptionalExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        isExpanded: isOptionalExpanded,
                        canTapOnHeader: true,
                        backgroundColor: Colors.white,
                        headerBuilder: (context, isExpanded) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Outros campos",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        body: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: categoryController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                label: Text("Categoria"),
                                icon: Icon(Icons.tag),
                              ),
                            ),
                            TextFormField(
                              controller: obsController,
                              minLines: 2,
                              maxLines: null,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.abc),
                                label: Text("Observações"),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CheckboxListTile(
                              value: isKilograms,
                              title: const Text(
                                "Dividir por quilogramas?",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isKilograms = !isKilograms;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(labelSkipButton),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Criar um objeto Produto com as infos
                          Product produto = Product(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            category: categoryController.text,
                            obs: obsController.text,
                            isPurchased: isPurchased,
                            isKilograms: isKilograms,
                          );

                          // Para o caso de edição
                          if (product != null) {
                            produto.id = product.id;
                          }

                          if (amountController.text != "") {
                            produto.amount =
                                double.parse(amountController.text);
                          }

                          if (priceController.text != "") {
                            String price = priceController.text.replaceAll(
                              ",",
                              ".",
                            );
                            produto.price = double.parse(price);
                          }

                          // Salvar
                          ProductService().upinsertProduct(
                            listinId: listinId,
                            produto: produto,
                          );

                          // Atualizar página
                          onRefresh();

                          // Fechar o Modal
                          Navigator.pop(context);
                        },
                        child: Text(labelConfirmationButton),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
