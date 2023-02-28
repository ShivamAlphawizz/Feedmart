import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_pay_x/upi_pay.dart';

class UpiPayment{
  String amount;
  String upi;
   String advance;
  BuildContext context;
  ValueChanged onResult;
  List<ApplicationMeta>? _apps;
  UpiPayment(this.amount,this.upi, this.context, this.onResult,this.advance);

  void initPayment()async{
    _apps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all);

    showModalBottomSheet(
          isDismissible: true,
        context: context, builder: (BuildContext context){
        return Container(
         // color: Colors.red,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("jhgsufgff")
              appsGrid(_apps!),
            ],
          ),
        );
    });
  }
  
  GridView appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return 
      GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
          key: ObjectKey(it.upiApplication),
          // color: Colors.grey[200],
          child: InkWell(
            onTap: Platform.isAndroid ? () async => await onTap(it) : null,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  it.iconImage(48),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    alignment: Alignment.center,
                    child: Text(
                      it.upiApplication.getAppName(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
  Future<void> onTap(ApplicationMeta app) async {
    print("this is advance amount ${advance.toString()}");
    print("this is upi ${upi.toString()}");

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");
    print("last check here ${advance} and ${app.upiApplication} and ${upi}");
    UpiTransactionResponse response = await UpiPay.initiateTransaction(
      amount: "${advance}",
      app: app.upiApplication,
      receiverName: 'Feedmart payment',
      receiverUpiAddress: "${upi}",
      // receiverUpiAddress: "Q64733865@ybl",
      // receiverUpiAddress: "${Upi}",
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
      // merchantCode: '7372',
    );
    onResult(response);
    print("this is response here now" + response.status.toString());
    print(response.txnId);
    print(response.txnRef);
    print(response.approvalRefNo);
  }
}