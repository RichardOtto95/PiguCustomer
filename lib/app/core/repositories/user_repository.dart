import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/user_model.dart';
import 'package:pigu/app/core/repositories/user_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository implements UserRepositoryInterface {
  final Firestore firestore;

  UserRepository(this.firestore);

  @override
  Stream<List<UserModel>> getUsers() {
    //Retornando future, faz uma busca e pronto, retornando snapshot, toda atualização no banco é retornada em seguida para cá.
    return firestore.collection('users').snapshots().map((query) {
      return query.documents.map((doc) {
        return UserModel.fromDocument(doc);
      }).toList();
    });
  }

  @override
  Future getAdress(String userId) async {
    // //print'daods*********  ${userId}');
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .document(userId)
        .collection('address')
        .getDocuments();
    // //print'querySnapshot*********  ${querySnapshot.documents}');

    querySnapshot.documents.map((document) {
      // //printdocument.data);
      var _address = document.data;
      // //print'address|address$_address');

      return _address;
    });
    //Retornando future, faz uma busca e pronto, retornando snapshot, toda atualização no banco é retornada em seguida para cá
  }

// this.db.collection('contatos').doc(key).collection('imagens')
  Future setAddress(Map<String, dynamic> address, String userId) {
    //Retornando future, faz uma busca e pronto, retornando snapshot, toda atualização no banco é retornada em seguida para cá.
    return firestore
        .collection('users')
        .document(userId)
        .collection('address')
        .add(address)
        .then((value) {});

    // .snapshots().map((query) {
    //   return query.documents.map((doc) {
    //     return UserModel.fromDocument(doc);
    //   }).toList();
    // });
  }

  Future getUser(String userId) {
    //Retornando future, faz uma busca e pronto, retornando snapshot, toda atualização no banco é retornada em seguida para cá.
    return firestore.collection('users').document(userId).get().then((value) {
      return UserModel.fromDocument(value);
    });

    // .snapshots().map((query) {
    //   return query.documents.map((doc) {
    //     return UserModel.fromDocument(doc);
    //   }).toList();
    // });
  }

  Future recoveryPassword(String email) async {
    FirebaseAuth user = FirebaseAuth.instance;
    return user.sendPasswordResetEmail(email: email);
  }

  Future changePassword(String userPassword) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.updatePassword(userPassword).then((_) {
      //print"Succesfull changed password");
    }).catchError((error) {
      //print"Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
    // if (model.uid == null) {
    //   //print'sem uid: ${model.uid}');
    //   return firestore.collection('orders').add(OrderModel().toJson(model));
    // }
  }

  Future updateUserPhoto(String userPhoto, String userId) async {
    //print'ID DO USUARIO REPOSITORY****************$userId');
    //print'URL DA IMAGEM REPOSITORY****************$userPhoto');

    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'avatar': userPhoto});
    // return user.updatePassword(userPassword).then((_) {
    //   //print"Succesfull changed password");
    // }).catchError((error) {
    //   //print"Password can't be changed" + error.toString());
    //   //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    // });
    // if (model.uid == null) {
    //   //print'sem uid: ${model.uid}');
    //   return firestore.collection('orders').add(OrderModel().toJson(model));
    // }
  }

  Future changeEmail(String userEmail) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.updateEmail(userEmail).then((_) {
      //print"Succesfull changed password");
    }).catchError((error) {
      //print"Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
    // if (model.uid == null) {
    //   //print'sem uid: ${model.uid}');
    //   return firestore.collection('orders').add(OrderModel().toJson(model));
    // }
  }

  Future updateUser(UserModel userM) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userC = UserModel().toJson(userM);
    userC.forEach((key, value) {
      // //print'USER value ********* $value');
      // //print'USER key ********* $key');
      if (value != null) {
        return Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({key: value});
      }
    });

    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.

    // if (model.uid == null) {
    //   //print'sem uid: ${model.uid}');
    //   return firestore.collection('orders').add(OrderModel().toJson(model));
    // }
  }

  // Future getUser(OrderModel model) async {
  //   if (model.uid == null) {
  //     //print'sem uid: ${model.uid}');
  //     return firestore.collection('orders').add(OrderModel().toJson(model));
  //   }
  // }
}
