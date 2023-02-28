// import 'package:eshop_multivendor/Helper/Color.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:upi_pay_x/upi_pay.dart';
//
// import '../Helper/Session.dart';
// import '../Helper/upi_payment.dart';
// import '../Provider/CartProvider.dart';
// import 'Cart.dart';
// import 'Payment.dart';
// class New extends StatefulWidget {
//   const New({Key? key}) : super(key: key);
//
//   @override
//   State<New> createState() => _NewState();
// }
//
// class _NewState extends State<New> {
//   StateSetter? checkoutState;
//   bool _isCartLoad = true, _placeOrder = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           doPayment()
//         ],
//       ),
//     );
//   }
//   doPayment() {
//     print(payMethod);
//     if (payMethod == getTranslated(context, 'PAYPAL_LBL')) {
//       //placeOrder('');
//     }else if (payMethod!.toLowerCase().contains("upi")) {
//       Navigator.pop(context);
//       bankTransfer();
//     }
//
//   }
//   bankTransfer() {
//     showGeneralDialog(
//         barrierColor: Theme.of(context).colorScheme.black.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           return Transform.scale(
//             scale: a1.value,
//             child: Opacity(
//                 opacity: a1.value,
//                 child: AlertDialog(
//                   contentPadding: const EdgeInsets.all(0),
//                   elevation: 2.0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                             padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
//                             child: Text(
//                               getTranslated(context, 'BANKTRAN')!,
//                               style: Theme.of(this.context)
//                                   .textTheme
//                                   .subtitle1!
//                                   .copyWith(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .fontColor),
//                             )),
//                         Divider(
//                             color: Theme.of(context).colorScheme.lightBlack),
//                         Padding(
//                             padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
//                             child: Text(getTranslated(context, 'BANK_INS')!,
//                                 style: Theme.of(context).textTheme.caption)),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20.0, vertical: 10),
//                           child: Text(
//                             getTranslated(context, 'ACC_DETAIL')!,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle2!
//                                 .copyWith(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .fontColor),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                           ),
//                           child: Text(
//                             getTranslated(context, 'ACCNAME')! +
//                                 " : " +
//                                 acName!,
//                             style: Theme.of(context).textTheme.subtitle2,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                           ),
//                           child: Text(
//                             getTranslated(context, 'ACCNO')! + " : " + acNo!,
//                             style: Theme.of(context).textTheme.subtitle2,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                           ),
//                           child: Text(
//                             getTranslated(context, 'BANKNAME')! +
//                                 " : " +
//                                 bankName!,
//                             style: Theme.of(context).textTheme.subtitle2,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                           ),
//                           child: Text(
//                             getTranslated(context, 'BANKCODE')! +
//                                 " : " +
//                                 bankNo!,
//                             style: Theme.of(context).textTheme.subtitle2,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                           ),
//                           child: Text(
//                             getTranslated(context, 'EXTRADETAIL')! +
//                                 " : " +
//                                 exDetails!,
//                             style: Theme.of(context).textTheme.subtitle2,
//                           ),
//                         )
//                       ]),
//                   actions: <Widget>[
//                     new TextButton(
//                         child: Text(getTranslated(context, 'CANCEL')!,
//                             style: TextStyle(
//                                 color: Theme.of(context).colorScheme.lightBlack,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold)),
//                         onPressed: () {
//                           checkoutState!(() {
//                             _placeOrder = true;
//                           });
//                           Navigator.pop(context);
//                         }),
//                     new TextButton(
//                         child: Text(getTranslated(context, 'DONE')!,
//                             style: TextStyle(
//                                 color: Theme.of(context).colorScheme.fontColor,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold)),
//                         onPressed: () {
//                           Navigator.pop(context);
//
//                           context.read<CartProvider>().setProgress(true);
//
//                          // placeOrder('');
//                         })
//                   ],
//                 )),
//           );
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: false,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, animation1, animation2) {
//           return Container();
//         });
//   }
// }
