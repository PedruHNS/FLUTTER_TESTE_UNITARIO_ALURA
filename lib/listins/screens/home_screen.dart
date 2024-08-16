import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listin/listins/widgets/home_drawer.dart';
import 'package:flutter_listin/listins/widgets/home_listin_item.dart';
import 'package:flutter_listin/listins/services/listin_service.dart';
import '../models/listin.dart';
import '../components/listin_add_edit_modal.dart';
import '../components/listin_options_modal.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListins = [];

  final ListinService _listinService = ListinService();

  bool _isLoading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text("Minhas listas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : (listListins.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/bag.png"),
                      const SizedBox(height: 32),
                      const Text(
                        "Nenhuma lista ainda.\nVamos criar a primeira?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return refresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: ListView(
                      children: List.generate(
                        listListins.length,
                        (index) {
                          Listin listin = listListins[index];
                          return HomeListinItem(
                            listin: listin,
                            showOptionModal: showOptionModal,
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }

  showAddModal({Listin? listin}) {
    showAddEditListinModal(
      context: context,
      onRefresh: refresh,
      model: listin,
    );
  }

  showOptionModal(Listin listin) {
    showListinOptionsModal(
      context: context,
      listin: listin,
      onRemove: remove,
      onDuplicate: duplicate,
    ).then((value) {
      if (value != null && value) {
        showAddModal(listin: listin);
      }
    });
  }

  refresh() async {
    // Basta alimentar essa variável com Listins que, quando o método for
    // chamado, a tela sera reconstruída com os itens.
    setState(() {
      _isLoading = true;
    });

    List<Listin> listaListins = await _listinService.getListins();
    setState(() {
      _isLoading = false;
      listListins = listaListins;
    });
  }

  void duplicate(Listin model, dynamic moveToPlanned) async {
    setState(() {
      _isLoading = true;
    });

    bool needToMove = false;

    if (moveToPlanned != null && moveToPlanned.runtimeType == bool) {
      needToMove = moveToPlanned;

      await _listinService.duplicateListin(
        listinId: model.id,
        isNeedMoveToPlan: needToMove,
      );
    }

    setState(() {
      _isLoading = false;
    });

    refresh();
  }

  void remove(Listin model) async {
    await _listinService.deleteListin(listinId: model.id);
    refresh();
  }
}
