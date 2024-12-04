// import 'dart:math';

// import 'package:card_stack_widget/card_stack_widget.dart';
// import 'package:card_stack_widget/model/card_orientation.dart';
// import 'package:card_stack_widget/widget/card_stack_widget.dart';
// import 'package:flutter/material.dart';

// CardStackWidget _buildCardStackWidget(BuildContext context) {
//   final mockList = _buildMockList(context, size: 4);

//   return CardStackWidget(
//     opacityChangeOnDrag: true,
//     swipeOrientation: CardOrientation.both,
//     cardDismissOrientation: CardOrientation.both,
//     positionFactor: 3,
//     scaleFactor: 1.5,
//     alignment: Alignment.center,
//     reverseOrder: true,
//     animateCardScale:  Duration(milliseconds: 150),
//     dismissedCardDuration: true,
//     cardList: mockList,
//   );
// }

// /// Create a mock list of `CardModel` to use inside `CardStackWidget`
// _buildMockList(BuildContext context, {int size = 0}) {
//   final double containerWidth = MediaQuery
//       .of(context)
//       .size
//       .width - 16;

//   var list = <CardModel>[];
//   for (int i = 0; i < size; i++) {
//     var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
//         .withOpacity(1.0);

//     list.add(
//       CardModel(
//         backgroundColor: color,
//         radius: 8,
//         shadowColor: Colors.black.withOpacity(0.2),
//         child: SizedBox(
//           height: 310,
//           width: containerWidth,
//           child: Container(), // Whatever you want
//         ),
//       ),
//     );
//   }

//   return list;
// }