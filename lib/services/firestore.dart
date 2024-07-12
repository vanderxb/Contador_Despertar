import "package:cloud_firestore/cloud_firestore.dart";

class FirestoreService {
  //GET HOME
  final CollectionReference counters =
      FirebaseFirestore.instance.collection("counters");

  //GET HISTÓRICO
  final CollectionReference historyCounters =
      FirebaseFirestore.instance.collection("history");

  //CREATE HISTÓRICO COUNTER
  Future<void> copyCounterToHistory(String docID) {
    // Executar a operação de obter e definir diretamente
    return counters.doc(docID).get().then((counterDoc) {
      historyCounters.add({
        'title': counterDoc['title'],
        'timestamp': counterDoc['timestamp'],
        'quantity': counterDoc['quantity']
      });
      counters.doc(docID).delete();
    }).catchError((error) {
      print('Erro ao copiar documento para a coleção history: $error');
    });
  }

  //CREATE
  Future<void> addCounter(String counterTitle) {
    return counters.add({
      'title': counterTitle.trim(),
      'timestamp': Timestamp.now(),
      'quantity': 0
    });
  }

  //READ
  Stream<QuerySnapshot> getCountersStream() {
    final countersStream =
        counters.orderBy('timestamp', descending: true).snapshots();
    return countersStream;
  }

  // GET HISTÓRICO COM FILTRO POR DATA
  Stream<QuerySnapshot> getHistoryCountersStream({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = historyCounters.orderBy('timestamp', descending: true);

    // Aplicar filtro se startDate for fornecido
    if ((startDate != null && endDate != null)) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate).where(
          'timestamp',
          isLessThanOrEqualTo: endDate.add(const Duration(days: 1)));
    }

    return query.snapshots();
  }

  //UPDATE TITLE
  Future<void> updateCounterTitle(String docID, String newTitle) {
    return counters
        .doc(docID)
        .update({'title': newTitle.trim(), 'timestamp': Timestamp.now()});
  }

  //UPDATE QUANTITY EDIT
  Future<void> updateQuantityEdit(String docID, String quantity) {
    int? quantityNumber = int.tryParse(quantity);
    return counters.doc(docID).update({'quantity': quantityNumber});
  }

  //UPDATE QUANTITY++
  Future<void> updateQuantityPlus(String docID, num quantity) {
    quantity++;
    return counters.doc(docID).update({'quantity': quantity});
  }

  //UPDATE QUANTITY--
  Future<void> updateQuantityMinus(String docID, num quantity) {
    if (quantity > 0) {
      quantity--;
    }
    return counters.doc(docID).update({'quantity': quantity});
  }

  //DELETE COUNTER
  Future<void> deleteCounter(String docID) {
    return counters.doc(docID).delete();
  }

  //DELETE ALL DOCUMENTS IN A COLLECTION
  Future<void> deleteAllDocuments() async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('history');

    // Get all documents in the collection
    final QuerySnapshot snapshot = await collection.get();

    // Delete each document
    for (DocumentSnapshot document in snapshot.docs) {
      await document.reference.delete();
    }
  }
}
