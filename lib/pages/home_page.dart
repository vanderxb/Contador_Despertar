import "package:cloud_firestore/cloud_firestore.dart";
import "package:contador_despertar/services/google_sheet_api.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../services/firestore.dart";
import 'package:flutter/services.dart';

enum MenuItem { item1, item2, item3 }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //FIRESTORE SERVICE
  final FirestoreService firestoreService = FirestoreService();

  //CONTROLLER DO CAMPO DE TEXTO
  final TextEditingController textController = TextEditingController();

  //CONTROLLER DO NÚMERO DO CONTADOR
  final TextEditingController counterNumberController = TextEditingController();

  //ABRIR CAIXA DE DIÁLOGO PARA NOMEAR CONTADOR
  void openCounterTitleBox() {
    ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

    textController.addListener(() {
      if (textController.text.trim().isEmpty) {
        isButtonDisabled.value = true;
      } else {
        isButtonDisabled.value = false;
      }
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ValueListenableBuilder<bool>(
                  valueListenable: isButtonDisabled,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value
                          ? null
                          : () {
                              // ADICIONAR NOVO CONTADOR
                              firestoreService.addCounter(textController.text);
                              // LIMPAR O CONTROLLER
                              textController.clear();
                              // FECHAR CAIXA DE DIÁLOGO
                              Navigator.pop(context);
                            },
                      child: const Text('Adicionar Contador'),
                    );
                  },
                ),
              ],
            ));
  }

  //ABRIR CAIXA DE DIÁLOGO PARA NOMEAR CONTADOR
  void editCounterTitleBox({String? docID}) {
    ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

    textController.addListener(() {
      if (textController.text.trim().isEmpty) {
        isButtonDisabled.value = true;
      } else {
        isButtonDisabled.value = false;
      }
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ValueListenableBuilder<bool>(
                  valueListenable: isButtonDisabled,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value
                          ? null
                          : () {
                              // ADICIONAR NOVO CONTADOR
                              firestoreService.updateCounterTitle(
                                  docID!, textController.text);
                              // LIMPAR O CONTROLLER
                              textController.clear();
                              // FECHAR CAIXA DE DIÁLOGO
                              Navigator.pop(context);
                            },
                      child: const Text('Atualizar'),
                    );
                  },
                ),
              ],
            ));
  }

  openCounterNumberBox({String? docID}) {
    ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

    counterNumberController.addListener(() {
      if (counterNumberController.text.trim().isEmpty) {
        isButtonDisabled.value = true;
      } else {
        isButtonDisabled.value = false;
      }
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                  controller: counterNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              actions: [
                ValueListenableBuilder<bool>(
                  valueListenable: isButtonDisabled,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value
                          ? null
                          : () {
                              firestoreService.updateQuantityEdit(
                                  docID!, counterNumberController.text);
                              //LIMPAR O CONTROLLER
                              counterNumberController.clear();
                              //FECHAR CAIXA DE DIÁLOGO
                              Navigator.pop(context);
                            },
                      child: const Text('Atualizar Quantidade'),
                    );
                  },
                ),
              ],
            ));
  }

  void confirmDelete(String docID, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('EXCLUIR'),
        content: Text('Deseja excluir $title?'),
        actions: [
          TextButton(
            onPressed: () {
              // Fechar o diálogo sem deletar
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Deletar o item
              firestoreService.deleteCounter(docID);
              // Fechar o diálogo
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void confirmSave(
      String docID, String title, String counterQuantity, String date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("SALVAR"),
        content: Text('Salvar $title no histórico?'),
        actions: [
          TextButton(
            onPressed: () {
              // Fechar o diálogo sem deletar
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              GoogleSheetsApi.insert(title, counterQuantity, date);
              // Deletar o item
              firestoreService.copyCounterToHistory(docID);
              // Fechar o diálogo
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Controle de Entrada"), actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history_page');
              },
              icon: const Icon(Icons.history))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: openCounterTitleBox, child: const Icon(Icons.add)),
        body: Stack(
          children: [
            Positioned(
                bottom: -10,
                left: -30,
                child: Image.asset("/logo_despertar.png",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width)),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getCountersStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List countersList = snapshot.data!.docs;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: ListView.builder(
                          itemCount: countersList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = countersList[index];
                            String docID = document.id;
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String counterTitle = data['title'];
                            num counterQuantity = data['quantity'];
                            Timestamp creationDate = data['timestamp'];
                            DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                            String printDate =
                                dateFormat.format(creationDate.toDate());

                            return ListTile(
                              title: Text(counterTitle),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        confirmDelete(docID, counterTitle);
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: counterQuantity > 0
                                          ? () {
                                              firestoreService
                                                  .updateQuantityMinus(
                                                      docID, counterQuantity);
                                            }
                                          : null,
                                      icon: const Icon(Icons.remove)),
                                  GestureDetector(
                                      onTap: () {
                                        openCounterNumberBox(docID: docID);
                                      },
                                      child: Text(counterQuantity.toString())),
                                  IconButton(
                                      onPressed: () {
                                        firestoreService.updateQuantityPlus(
                                            docID, counterQuantity);
                                      },
                                      icon: const Icon(Icons.add)),
                                  PopupMenuButton(
                                      itemBuilder: (context) => [
                                            const PopupMenuItem(
                                                value: MenuItem.item1,
                                                child: Text("Excluir")),
                                            const PopupMenuItem(
                                                value: MenuItem.item2,
                                                child: Text("Editar Título")),
                                            const PopupMenuItem(
                                                value: MenuItem.item3,
                                                child: Text("Salvar"))
                                          ],
                                      onSelected: (value) {
                                        switch (value) {
                                          case MenuItem.item1:
                                            confirmDelete(docID, counterTitle);
                                            break;
                                          case MenuItem.item2:
                                            editCounterTitleBox(docID: docID);
                                            break;
                                          case MenuItem.item3:
                                            confirmSave(
                                                docID,
                                                counterTitle,
                                                counterQuantity.toString(),
                                                printDate);
                                            break;
                                        }
                                      })
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ));
  }
}
