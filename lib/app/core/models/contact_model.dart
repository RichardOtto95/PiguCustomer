import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  DocumentReference uid;
  String user_id;
  String user_number;
  String contact_name;

  ContactModel({this.uid, this.contact_name, this.user_id, this.user_number});

  factory ContactModel.fromDocument(DocumentSnapshot doc) {
    //print'category : ${doc.data}');
    return ContactModel(
      uid: doc.reference,
      contact_name: doc['contact_name'],
      user_id: doc['contact_name'],
      user_number: doc['contact_name'],
    );
  }

  Map<String, dynamic> toJson(ContactModel doc) => {
        'uid': doc.uid,
        'contact_name': doc.contact_name,
        'user_id': doc.user_id,
        'user_number': doc.user_number
      };
}
