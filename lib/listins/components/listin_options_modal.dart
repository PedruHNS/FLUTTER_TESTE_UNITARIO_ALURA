import "package:flutter/material.dart";
import "package:flutter_listin/_core/components/listin_dialogs.dart";
import "package:flutter_listin/listins/models/listin.dart";

Future<dynamic> showListinOptionsModal({
  required BuildContext context,
  required Listin listin,
  required Function onDuplicate,
  required Function onRemove,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(32.0),
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView(children: [
          Text(
            listin.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.edit),
            title: const Text("Editar"),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          //TODO: Implementar compartilhamento de Listins
          // const ListTile(
          //   contentPadding: EdgeInsets.zero,
          //   leading: Icon(Icons.share),
          //   title: Text("Compartilhar"),
          // ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.file_copy),
            title: const Text("Duplicar"),
            onTap: () {
              showConfirmationDialog(
                      context: context,
                      title: "Deseja mover todos os itens em 'Planejados'?",
                      description:
                          "Ao optar por mover, todos os produtos que já "
                          "estejam no carrinho serão trazidos de volta para  "
                          "a área de planejados.")
                  .then(
                (value) {
                  onDuplicate(listin, value);
                  Navigator.pop(context);
                },
              );
            },
          ),
          // // TODO: Implementar "modelos" de lista
          // const ListTile(
          //   contentPadding: EdgeInsets.zero,
          //   leading: Icon(Icons.save),
          //   title: Text("Salvar como modelo"),
          // ),
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete),
              title: const Text("Excluir"),
              onTap: () {
                onRemove(listin);
                Navigator.pop(context);
              }),
        ]),
      );
    },
  );
}
