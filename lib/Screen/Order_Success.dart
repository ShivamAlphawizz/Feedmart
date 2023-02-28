import 'dart:async';
import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Model/Order_Model.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import '../Helper/Constant.dart';
import '../Helper/String.dart';
import 'package:http/http.dart'as http;

import 'Login.dart';

class OrderSuccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateSuccess();
  }
}

class StateSuccess extends State<OrderSuccess> {
  int offset = 0;
  int total = 0;

  int pos = 0;

  List<OrderModel> searchList = [];
  String? searchText;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool _isNetworkAvail = true;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = ScrollController();
  String _searchText = "", _lastsearch = "";
  bool isLoadingmore = true, isGettingdata = false, isNodata = false;
  String? activeStatus;
  String? Orderids, deliveryDate;

  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    awaitingPayment
  ];


  getOrderDetails()async{
    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjM3NDAzNzksImlhdCI6MTY2Mzc0MDA3OSwiaXNzIjoiZXNob3AifQ.A2CUKAe_-ZIlprYmfEywYH6tz9ue5OX4KPtojuh3rrA',
      'Cookie': 'ci_session=81pgv9lcbncpfq5huctqkrftms2s6ts4; ekart_security_cookie=9090cfaa006e2fbb881150c5303e880d'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://alphawizztest.tk/Feedmart/app/v1/api/get_orders'));
    request.fields.addAll({
      'user_id': '$USER_ID',
      'offset': ' 0',
      'limit': ' 10',
      'search': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalresult = await response.stream.bytesToString();
      final jsonResponse = OrderModel.fromJson(json.decode(finalresult));
      print("final result here  ${jsonResponse.id.toString()}");
    }
    else {
      print(response.reasonPhrase);
    }

    // var response = http.post(Uri.parse('https://alphawizztest.tk/Feedmart/app/v1/api/get_orders'),body:{
    //   "user_id" : "22",
    //   "offset": "0",
    //   "limit": "10",
    //   "search": ""
    // });
    // print("response here ${response}");
    // var result = SectionModel.fromJson(json.decode(response))
  }

  Future<Null> getOrder() async {


      try {
        if (isLoadingmore) {
          if (mounted) {
            setState(() {
              isLoadingmore = false;
              isGettingdata = true;
              if (offset == 0) {
                searchList = [];
              }
            });
          }

          if (CUR_USERID != null) {
            var parameter = {
              USER_ID: CUR_USERID,
              OFFSET: "0",
              LIMIT: perPage.toString(),
              SEARCH: _searchText.trim(),
            };
            if (activeStatus != null) {
              if (activeStatus == awaitingPayment) activeStatus = "awaiting";
              parameter[ACTIVE_STATUS] = activeStatus;
            }
            Response response =
            await post(getOrderApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

            var getdata = json.decode(response.body);
            print(getOrderApi);
            print(parameter.toString());
            print(getdata.toString());
            bool error = getdata["error"];

            setState(() {
              isGettingdata = false;
            });
            if (offset == 0) isNodata = error;

            if (!error) {
              // total = int.parse(getdata["total"]);

              //  if ((offset) < total) {
              var data = getdata["data"];
              print(" check order data here  and ${data}");
              if (data.length != 0) {
                List<OrderModel> items = [];
                List<OrderModel> allitems = [];

                items.addAll((data as List)
                    .map((data) => OrderModel.fromJson(data))
                    .toList());
                print("checking item here ${items[0].id}");
             setState(() {
               Orderids = "${items[0].id}";
               deliveryDate = "${items[0].delDate}";
             });
               // print("checking item here${items[0].id}")
                allitems.addAll(items);

                for (OrderModel item in items) {
                  searchList.where((i) => i.id == item.id).map((obj) {
                    allitems.remove(item);
                    return obj;
                  }).toList();
                }
                searchList.addAll(allitems);

                isLoadingmore = true;
                _isLoading = false;
                offset = offset + perPage;
              } else {
                isLoadingmore = false;
              }

              // orderList = (data as List)
              //     .map((data) => new OrderModel.fromJson(data))
              //     .toList();
              // searchList.addAll(orderList);
              // offset = offset + perPage;
              // }
            } else {
              isLoadingmore = false;
            }

            if (mounted) {
              setState(() {
                _isLoading = false;
                //isLoadingmore = false;
              });
            }
          } else {
            if (mounted) if (mounted) {
              setState(() {
                isLoadingmore = false;
                //msg = goToLogin;
              });
            }

            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            });
          }
        }
      } on TimeoutException catch (_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            isLoadingmore = false;
          });
        }
        // setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getOrderDetails();
    getOrder();
  }
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: getAppBar(getTranslated(context, 'ORDER_PLACED')!, context),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.symmetric(vertical: 40),
              child: SvgPicture.asset(
                imagePath + "bags.svg",
                color: colors.primary,
              ),
              /*  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),*/
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslated(context, 'ORD_PLC')!,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),

            Text(
              getTranslated(context, 'ORD_PLC_SUCC')!,
              style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
            ),
            SizedBox(height: 10,),
           Orderids == null ? SizedBox.shrink() : Text("Order Id : ${Orderids}"),
            // deliveryDate == null ? SizedBox.shrink() : Text("Delivery date : ${deliveryDate}"),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 28.0),
              child: CupertinoButton(
                child: Container(
                    width: deviceWidth! * 0.7,
                    height: 45,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      color: colors.secondary,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [colors.secondary, colors.button],
                          stops: [0, 1]),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(10.0)),
                    ),
                    child:
                    Text(getTranslated(context, 'CONTINUE_SHOPPING')!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.white,
                            fontWeight: FontWeight.normal))
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
