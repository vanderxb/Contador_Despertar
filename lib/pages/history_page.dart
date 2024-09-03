import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
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

  DateTime? start;
  DateTime? end;
  bool hasData = false;

  void _showDatePicker() async {
    final result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(
          const Duration(days: 356),
        ));

    if (result != null) {
      setState(() {
        start = result.start;
        end = result.end;
      });
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Histórico'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('''Deseja excluir todo o histórico?
Esta ação não poderá ser desfeita
                              '''),
          ],
        ),
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
              firestoreService.deleteAllDocuments();
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
      appBar: AppBar(
        title: const Text("Histórico"),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getHistoryCountersStream(
                startDate: start, endDate: end),
            builder: (context, snapshot) {
              hasData = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
              return IconButton(
                onPressed: hasData ? confirmDelete : null,
                icon: const Icon(Icons.delete_forever),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showDatePicker, child: const Text("Filtrar")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset("/logo_despertar.png",
                  fit: BoxFit.cover, width: MediaQuery.of(context).size.width)),
          Column(
            children: [
              Container(
                color: Colors.grey[300],
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CONTADOR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'QUANTIDADE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'DATA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getHistoryCountersStream(
                      startDate: start, endDate: end),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List historyCountersList = snapshot.data!.docs;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: ListView.builder(
                            itemCount: historyCountersList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  historyCountersList[index];
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
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          counterTitle,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(), // Optional divider for better separation
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          counterQuantity.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(), // Optional divider for better separation
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          printDate,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
