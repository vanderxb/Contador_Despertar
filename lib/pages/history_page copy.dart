import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "../services/firestore.dart";

enum MenuItem { item1, item2, item3 }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //FIRESTORE SERVICE
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Histórico")),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getHistoryCountersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List historyCountersList = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: historyCountersList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = historyCountersList[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String counterTitle = data['title'];
                      num counterQuantity = data['quantity'];

                      return ListTile(
                        title: Text(counterTitle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                            IconButton(
                                onPressed: counterQuantity > 0 ? () {} : null,
                                icon: const Icon(Icons.remove)),
                            GestureDetector(
                                onTap: () {},
                                child: Text(counterQuantity.toString())),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.add)),
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
                                      break;
                                    case MenuItem.item2:
                                      break;
                                    case MenuItem.item3:
                                      break;
                                  }
                                })
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
