// import 'package:pigu/app/modules/table_opening/widgets/person_photo.dart';
// import 'package:pigu/app/modules/table_opening/widgets/phone_chat_button.dart';
// import 'package:pigu/shared/color_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:pigu/app/modules/table_opening/widgets/person_container.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AlphabetPersonContainer extends StatelessWidget {
//   final bool selected;
//   final String nameList;
//   final String mobile_region_code;
//   final String mobile_phone_number;
//   final String username;
//   final String avatar;
//   final List list;
//   final Function onTapp;
//   final Function onTapp2;
//   const AlphabetPersonContainer({
//     Key key,
//     this.onTapp,
//     this.onTapp2,
//     this.list,
//     this.mobile_region_code,
//     this.mobile_phone_number,
//     this.username,
//     this.avatar,
//     this.selected,
//     this.nameList,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     double wXD(double size) {
//       double finalSize = MediaQuery.of(context).size.width * size / 375;
//       return finalSize;
//     }

//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           // child: Text(nameList),
//           child: Text(
//             'A',
//             style: TextStyle(
//               fontFamily: 'Roboto',
//               fontSize: wXD(45),
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           color: Colors.blue,
//           height: size.height * .08,
//           width: size.width,
//         ),
//         Container(
//           child: ListView.builder(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               return PersonContainer(
//                 avatar: avatar,
//                 name: username,
//                 tel: mobile_phone_number,
//                 code: mobile_region_code,
//                 onTap: onTapp2,
//                 selected: selected,
//                 // selected: arrayInvites.contains(snapshot2.data),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
