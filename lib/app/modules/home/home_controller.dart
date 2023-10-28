import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/app/core/repositories/categories_repository_interface.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_controller.g.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final authController = Modular.get<AuthController>();

  _HomeControllerBase() {
    // Geolocator.getCurrentPosition(
    //         desiredAccuracy: .bestForNavigation)
    //     .then((value) {
    //   authController.position = value;
    //   print('entriu');
    //   authController.setPosition(value);

    //   print('authController.position ; ${authController.position}');
    // });
    // Geolocator.checkPermission();
    //print'contrutor');

    // askPermissions();
    FirebaseAuth.instance.currentUser().then((value) {
      print('valuevaluevaluevaluevaluevaluevalue ;${value.uid}');
      Firestore.instance
          .collection('users')
          .document(value.uid)
          .get()
          .then((valueuser) {
        valueuser.reference
            .collection('contacts')
            .getDocuments()
            .then((valueContact) {
          if (valueContact.documents.isEmpty == true) {
            askPermissions();
          }
        });
      });
      getUserDB(value);
      getuserDB(value);
    });

    // determinePosition();
  }

  getPostion() async {
    GeoPoint posi = (await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best)) as GeoPoint;
    print('posiposiposi:${posi}');
    return posi;
  }

  @observable
  num estimation = 0;
  @observable
  num estimation2 = 0;
  @observable
  int value = 0;
  @observable
  SellerModel sellerModel;
  @observable
  String categoryID = null;
  @observable
  String routerMenu = null;
  @observable
  bool promoteHoster = false;
  @observable
  String myGroupSelected;
  @observable
  String groupChat;
  // @observable
  // String groupCode = '';
  @observable
  FirebaseUser user;
  @observable
  bool spin;
  @observable
  DocumentSnapshot userDB;
  @observable
  DocumentSnapshot userDs;
  @observable
  bool restaurantFav = false;
  @observable
  List<Contact> _contacts;
  @observable
  List<String> strList = [];
  @observable
  bool userHaveContacts = false;
  @observable
  String note = '';
  @observable
  String groupRepeatOrder;
  @observable
  bool contactsync = false;
  @observable
  bool shoow = true;
  @observable
  bool shooow = true;
  @observable
  String statusMyGroup;
  @observable
  bool queueRoute = false;
  @observable
  num _tables = 0;
  @observable
  num _usedTables = 0;
  @observable
  bool awaitingCheckout = false;
  @observable
  bool showOpenButton = true;
  @observable
  bool showToastSync = false;
  // @action
  // setPermission(LocationPermission perr) => permission = perr;
  @action
  setShowSpnSync(bool _showToastSync) => showToastSync = _showToastSync;
  @action
  setSpn(bool spn) => spin = spn;
  @action
  setAwaitingCheckout(bool _awaitingCheck) => awaitingCheckout = _awaitingCheck;
  @action
  setQRoute(bool rt) => queueRoute = rt;
  @action
  setShooow(bool _shooow) => shooow = _shooow;
  @action
  setMyGroupStauts(_myGroupStatus) => statusMyGroup = _myGroupStatus;
  @action
  setShowOpenTableButton(bool hehe) => showOpenButton = hehe;
  @action
  void increment() {
    value++;
  }

  // @action
  // Future<Position> getPosition() async {
  //   print('permission 1: ${permission}');

  //   if (permission != LocationPermission.denied && permission != null) {
  //     print('tudo');

  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation);

  //     authController.setPosition(position);

  //     return position;
  //   } else {
  //     print('nada');
  //     return null;
  //   }
  // }

  getTables(SellerModel seller) async {
    print('seller.id: ${seller.id}');
    QuerySnapshot _tab = await Firestore.instance
        .collection('tables')
        .where('seller_id', isEqualTo: seller.id)
        .getDocuments();

    QuerySnapshot _usdTab = await Firestore.instance
        .collection('tables')
        .where('seller_id', isEqualTo: seller.id)
        .where('status', isEqualTo: 'used')
        .getDocuments();

    _tables = await _tab.documents.length;
    if (_tables < 1 || _tables == null) {
      _tables = 2;
    }
    _usedTables = await _usdTab.documents.length;
    // if (_usedTables < 1 || _usedTables == null) {
    //   _usedTables = 1;
    // }
  }

  @action
  getTableOpening({SellerModel seller}) async {
    if (_tables == _usedTables) {
      if (seller.hasVirtualQueue) {
        await queueRequest(
            usedTables: _usedTables, tables: _tables, seller: seller);
      } else {
        Fluttertoast.showToast(
            msg: "Estabelecimento lotado! Tente novamente mais tarde.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorTheme.primaryColor,
            textColor: Colors.white,
            fontSize: 16);
        // setState(() {
        setSpn(false);
        // });
      }
    } else if (userHaveContacts) {
      Fluttertoast.showToast(
          msg: "Aguardando sincronização",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorTheme.primaryColor,
          textColor: Colors.white,
          fontSize: 16);
      setSpn(false);
    } else {
      setSpn(false);
      setShowSpnSync(false);

      Modular.to.pushNamed('/table-opening', arguments: seller);
    }
  }

  @action
  void updatingStatus(var dss) {
    int contagem = 0;
    int members = 0;
    Firestore.instance
        .collection('orders')
        .document(dss['order_id'])
        .collection('members')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        // //print'entrou primeiro ForEachh ${value.documents.length}');
        members++;
        // //print'members  $members');
        if (element.data['role'] == 'accepted_invite') {
          // //print'entrou no ifffff ${element.data['status']}');
          contagem++;
          // //print'contagem de caras aceitoss $contagem');
        }
      });
    });
    if (contagem == members) {
      Firestore.instance
          .collection('orders')
          .document(dss['order_id'])
          .get()
          .then((value) {
        value.reference.updateData({'status': 'order_requested'});
      });
    }
  }

  @action
  setShow(bool eeee) => shoow = eeee;
  @action
  setCategoryID(String ee) => categoryID = ee;
  @action
  setRouterMenu(String eee) => routerMenu = eee;
  @action
  setrestfav(bool add) => restaurantFav = add;
  @action
  setSeller(SellerModel see) => sellerModel = see;
  @action
  setPromotehost(bool _promote) => promoteHoster = _promote;
  // @action
  // setGroupCode(String _group) => groupCode = _group;
  @action
  setNote(String newNote) => note = newNote;
  @action
  setGroupRepeatOrder(String _group) => groupRepeatOrder = _group;
  @action
  getUserAuth() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @action
  getuserDB(value) {
    Firestore.instance
        .collection('users')
        .document(value.uid)
        .get()
        .then((value) => userDs = value);
  }

  @action
  getUserDB(value) async {
    userDB =
        await Firestore.instance.collection('users').document(value.uid).get();
    return userDB;
  }

  @action
  setmMyGroupSelected(String _my) => myGroupSelected = _my;

  @action
  setGroupChat(String _label) => groupChat = _label;

  @action
  getCategory() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("categories")
        .where('label')
        .getDocuments();
    var list = querySnapshot.documents;
    list.forEach((element) {
      element.data;
      // //print'CATEGORIAS: ${element.data}');
    });
  }

  @action
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  @action
  Future<void> askPermissions() async {
    print('syncsyncsyncsyncsyncsyncsyncsyncsync');
    showToastSync = true;
    List list = [];
    user = await FirebaseAuth.instance.currentUser();
    userDs =
        await Firestore.instance.collection('users').document(user.uid).get();
    contactsync = userDs.data['contactlist_sync'];

    if (contactsync == false) {
      PermissionStatus permissionStatus = await _getPermission();
      print('permissionStatus: ${permissionStatus}');

      //print('status da permissao: $permissionStatus');
      if (permissionStatus == PermissionStatus.granted) {
        print('ACEITO');

        final Iterable<Contact> contacts =
            (await ContactsService.getContacts(withThumbnails: false));
        List<Contact> result = await contacts.map((data) => data).toList();
        _contacts = result;
        print('result: ${result}');

        // varrendo todos os contatos do user logado
        result.forEach((contato) async {
          //LOGICA
          if (contato.phones.isNotEmpty) {
            print('contato: ${contato.phones}');

            String auxName = contato.phones.first.value.replaceAll("-", "");
            String finalName = auxName.replaceAll(new RegExp(r"\s+"), "");
            String var1 = finalName.replaceAll(")", "");
            String var2 = var1.replaceAll("(", "");

            finalName = var2;

            switch (finalName.length) {
              case 8:
                finalName = '+55' +
                    '${user.phoneNumber.substring(3, 5)}' +
                    '9' +
                    '$finalName';

                break;
              case 9:
                finalName = '+55' +
                    '${user.phoneNumber.substring(3, 5)}' +
                    '$finalName';
                break;
              case 11:
                finalName = '+55' + '$finalName';
                break;
              case 13:
                finalName = finalName.substring(0, 5) +
                    '9' +
                    finalName.substring(5, 13);
                break;
              case 14:
                break;
              default:
            }
            // print('finalName: ${finalName}');
            if (!list.contains(finalName)) {
              list.add(finalName);

              // varrendo no banco de dados cada user que tenha este número em questão
              QuerySnapshot _userDB = await Firestore.instance
                  .collection('users')
                  .where('mobile_full_number', isEqualTo: finalName)
                  .getDocuments();

              // Verifica se trouxe algum contato
              if (_userDB.documents.isNotEmpty) {
                _userDB.documents.forEach((usersDb) async {
                  // if(_userDB.documents.first.data['mobile_full_number'])
                  var user = await FirebaseAuth.instance.currentUser();
                  QuerySnapshot _membs = await Firestore.instance
                      .collection('users')
                      .document(user.uid)
                      .collection('contacts')
                      .where('id', isEqualTo: usersDb.documentID)
                      .getDocuments();

                  //Contatos do usuário que tem o app
                  if (_membs.documents.isEmpty) {
                    print(
                        'usersDb.data[mobile_full_number]: ${usersDb.data['mobile_full_number']}');
                    print('user.phoneNumber: ${user.phoneNumber}');

                    //aqui valida user em outro celular
                    if (usersDb.data['mobile_full_number'] !=
                        user.phoneNumber) {
                      await Firestore.instance
                          .collection('users')
                          .document(user.uid)
                          .collection('contacts')
                          .add({'id': usersDb.documentID});

                      userDs.reference.updateData({'contactlist_sync': true});
                    }
                  } else {
                    DocumentSnapshot _membr = await Firestore.instance
                        .collection('users')
                        .document(_membs.documents.first.data['id'])
                        .get();
                    if (_membr.data['mobile_full_number'] ==
                        usersDb.data['mobile_full_number']) {
                      userDs.reference.updateData({'contactlist_sync': true});
                    } else {
                      DocumentSnapshot _userPPP = await Firestore.instance
                          .collection('users')
                          .document(user.uid)
                          .get();
                      if (_userPPP.data['mobile_full_number'] !=
                          _membr.data['mobile_full_number']) {
                        //aqui validar user em outro celular
                        await Firestore.instance
                            .collection('users')
                            .document(user.uid)
                            .collection('contacts')
                            .add({'id': usersDb.documentID});
                        userDs.reference.updateData({'contactlist_sync': true});
                      }
                      userDs.reference.updateData({'contactlist_sync': true});
                    }
                    userDs.reference.updateData({'contactlist_sync': true});
                  }
                });
                userDs.reference.updateData({'contactlist_sync': true});
              } else {
                userDs.reference.updateData({'contactlist_sync': true});
              }
            }
          }
        });
        print('userDB: ${userDs}');
        userDs.reference.updateData({'contactlist_sync': true});
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<Position> determinePosition() async {
    print('permissãooooooooooooooo');

    bool serviceEnabled;
    LocationPermission permission;
    Position position;

    permission = await Geolocator.requestPermission();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    if (permission == LocationPermission.denied) {
      // permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      authController.setPosition(position);
      Modular.to.pushNamed('/');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @action
  queueRequest({usedTables, int tables, SellerModel seller}) async {
    double timeSum = 0;
    num med = 1;
    num length;

    QuerySnapshot queue = await Firestore.instance
        .collection('sellers')
        .document(seller.id)
        .collection('queue')
        .getDocuments();

    if (queue.documents.isEmpty) {
      Firestore.instance
          .collection('sellers')
          .document(seller.id)
          .collection('queue')
          .add({
        'seller_id': seller.id,
        'table_estimation': 30,
        'estimated_forecast': 20
      }).then((value) {
        value.updateData({'id': value.documentID});
      });
      sellerModel = seller;
      Modular.to.pushNamed('/virtual-queue', arguments: seller);
    }

    QuerySnapshot paidGroups = await Firestore.instance
        .collection('groups')
        .where('seller_id', isEqualTo: seller.id)
        .where('status', isEqualTo: 'paid')
        .orderBy('created_at', descending: true)
        .limit(20)
        .getDocuments();

    QuerySnapshot openGroups = await Firestore.instance
        .collection('groups')
        .where('seller_id', isEqualTo: seller.id)
        .where('status', isEqualTo: 'open')
        .orderBy('created_at', descending: true)
        .limit(20)
        .getDocuments();

    QuerySnapshot queueDocs = await queue.documents.first.reference
        .collection('queued')
        .getDocuments();

    if (tables == null || tables < 1) {
      tables = paidGroups.documents.length;
      if (paidGroups.documents.isNotEmpty) {
        tables = paidGroups.documents.length;
      }
      if (openGroups.documents.isNotEmpty) {
        tables = openGroups.documents.length;
      }
    }

    if (queueDocs.documents.isNotEmpty) {
      length = queueDocs.documents.length;
    } else {
      length = 1;
    }

    if (paidGroups.documents.isNotEmpty) {
      timeSum = 0;

      for (var i = 0; i < paidGroups.documents.length; i++) {
        timeSum += paidGroups.documents[i].data['duration'];
      }

      med = await timeSum / tables;
      if (med.isNaN || med < 5) {
        med = 20;
      }
      await queue.documents.first.reference
          .updateData({'table_estimation': med});
    }

    if (queueDocs.documents.isNotEmpty) {
      num tableEst = await queue.documents.first.data['table_estimation'];
      if (tableEst < 1 || tableEst == null) {
        tableEst = 30;
      }

      timeSum = 0;
      num queueTotal = tableEst * length;
      med = await queueTotal / tables;
      if (med.isNaN || med < 5) {
        med = 20;
      }

      estimation = (length * med) / tables;

      if (estimation < 10) {
        estimation = 20;
      }

      await queue.documents.first.reference
          .updateData({'estimated_forecast': estimation});
    } else {
      await queue.documents.first.reference
          .updateData({'estimated_forecast': 20});
    }
    sellerModel = seller;
    Modular.to.pushNamed('/virtual-queue', arguments: seller);
  }
}
