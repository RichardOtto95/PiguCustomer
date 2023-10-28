import 'package:pigu/app/core/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'restaurant_selected_controller.g.dart';

@Injectable()
class RestaurantSelectedController = _RestaurantSelectedControllerBase
    with _$RestaurantSelectedController;

abstract class _RestaurantSelectedControllerBase with Store {
  @observable
  int value = 0;
  @observable
  num estimation = 0;
  @observable
  SellerModel seller;
  @observable
  DateTime queuetime;

  @action
  void increment() {
    value++;
  }

  @action
  setSeller(SellerModel sel) => seller = sel;

  // @action
  // queueRequest(usedTables, tables) async {
  //   double timeSum = 0;
  //   num med = 1;

  //   QuerySnapshot queue = await Firestore.instance
  //       .collection('sellers')
  //       .document(seller.id)
  //       .collection('queue')
  //       .getDocuments();

  //   if (queue.documents.isEmpty) {
  //     Firestore.instance
  //         .collection('sellers')
  //         .document(seller.id)
  //         .collection('queue')
  //         .add({
  //       'seller_id': seller.id,
  //       'table_estimation': 30,
  //       'estimated_forecast': 1
  //     }).then((value) {
  //       value.updateData({'id': value.documentID});
  //     });
  //     Modular.to.pushNamed('/virtual-queue', arguments: seller);
  //   }

  //   QuerySnapshot paidGroups = await Firestore.instance
  //       .collection('groups')
  //       .where('seller_id', isEqualTo: seller.id)
  //       .where('status', isEqualTo: 'paid')
  //       .orderBy('created_at', descending: true)
  //       .getDocuments();

  //   QuerySnapshot openGroups = await Firestore.instance
  //       .collection('groups')
  //       .where('seller_id', isEqualTo: seller.id)
  //       .where('status', isEqualTo: 'open')
  //       .orderBy('created_at', descending: true)
  //       .getDocuments();

  //   QuerySnapshot queueDocs = await queue.documents.first.reference
  //       .collection('queued')
  //       .getDocuments();

  //   num length = queueDocs.documents.length;

  //   if (paidGroups.documents.isNotEmpty) {
  //     print('paidGroupspaidGroupspaidGroups:::::$paidGroups');
  //     timeSum = 0;
  //     if (tables == null || tables < 1) {
  //       tables = openGroups.documents.length;
  //       if (tables < 1 || tables == null) {
  //         tables == 5;
  //       }
  //     }
  //     if (paidGroups.documents.length >= 10) {
  //       print('tablestablestablestablestablestables:::::$tables');
  //       for (var i = 0; i < 10; i++) {
  //         print(
  //             'durationdurationdurationdurationduration:::::${paidGroups.documents[i].data['duration']}');
  //         timeSum += paidGroups.documents[i].data['duration'];
  //       }
  //       med = await timeSum / tables;
  //       if (med.isNaN || med < 1) {
  //         med = 30;
  //       }
  //       await queue.documents.first.reference
  //           .updateData({'table_estimation': med});
  //       print(
  //           'queue.documentsqueue.documentsqueue.documents:::::${queue.documents}');
  //     } else if (paidGroups.documents.length < 10) {
  //       for (var i = 0; i < paidGroups.documents.length; i++) {
  //         timeSum += paidGroups.documents[i].data['duration'];
  //       }
  //       med = await timeSum / tables;
  //       if (med.isNaN || med < 1) {
  //         med = 30;
  //       }
  //       await queue.documents.first.reference
  //           .updateData({'table_estimation': med});
  //     }
  //   } else {
  //     num tableEst = await queue.documents.first.data['table_estimation'];
  //     if (tableEst < 1 || tableEst == null) {
  //       tableEst = 30;
  //     }
  //     timeSum = 0;
  //     for (var i = 0; i < usedTables; i++) {
  //       timeSum += tableEst;
  //     }
  //     med = await timeSum / usedTables;
  //     if (med.isNaN || med < 1) {
  //       med = 30;
  //     }
  //     await queue.documents.first.reference
  //         .updateData({'table_estimation': med});
  //   }

  //   if (queueDocs.documents.isNotEmpty) {
  //     num tableEst = await queue.documents.first.data['table_estimation'];
  //     if (tableEst < 1 || tableEst == null) {
  //       tableEst = 30;
  //     }
  //     timeSum = 0;
  //     num queueTotal = tableEst * length;
  //     med = await queueTotal / tables;
  //     if (med.isNaN || med < 1) {
  //       med = 30;
  //     }
  //     estimation = (length * med) / tables;
  //     await queue.documents.first.reference
  //         .updateData({'estimated_forecast': estimation});
  //   } else {
  //     await queue.documents.first.reference
  //         .updateData({'estimated_forecast': med});
  //   }

  //   print('estimationestimationestimationestimation:::$estimation');
  //   print('medmedmedmedmedmedmed2222222222222222222222222222:::$med');

  //   Modular.to.pushNamed('/virtual-queue', arguments: seller);
  // }
}
