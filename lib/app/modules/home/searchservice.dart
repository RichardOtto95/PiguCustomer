import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    // //print'searchField : $searchField');
    // //print
    //     'searchField.substring(0, 1).toUpperCase() : ${searchField.substring(0, 1).toUpperCase()}');

    return Firestore.instance
        .collection('sellers')
        .where('search_key',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
