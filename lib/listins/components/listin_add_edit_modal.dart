import "package:flutter/material.dart";
import "package:flutter_listin/listins/models/listin.dart";
import "package:flutter_listin/listins/services/listin_service.dart";
import "package:uuid/uuid.dart";

Future<dynamic> showAddEditListinModal({
  required BuildContext context,
  required Function onRefresh,
  Listin? model,
}) async {
  // Labels à serem mostradas no Modal
  String labelTitle = "Adicionar lista de compras";
  String labelConfirmationButton = "Salvar";
  String labelSkipButton = "Cancelar";

  // Controlador do campo que receberá o nome do Listin
  TextEditingController nameController = TextEditingController();
  TextEditingController obsController = TextEditingController();

  // Caso esteja editando
  DateTime dateCreate = DateTime.now();
  DateTime dateUpdate = DateTime.now();

  if (model != null) {
    labelTitle = "Editando ${model.name}";
    nameController.text = model.name;
    obsController.text = model.obs;
    dateCreate = model.dateCreate;
    dateUpdate = model.dateUpdate;
  }

  // Função do Flutter que mostra o modal na tela
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Define que as bordas verticais serão arredondadas
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(32.0),
          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(
                labelTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.shopping_basket),
                  label: Text("Nome da lista"),
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
                      // Criar um objeto Listin com as infos
                      Listin listin = Listin(
                        // Em criação, esse valor será autogerado pelo banco.
                        id: const Uuid().v4(),
                        name: nameController.text,
                        obs: obsController.text,
                        dateCreate: dateCreate,
                        dateUpdate: dateUpdate,
                      );

                      if (model != null) {
                        listin.id = model.id;
                      }

                      ListinService().upinsertListin(listin: listin);

                      // Atualizar a lista
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
        ),
      );
    },
  );
}
