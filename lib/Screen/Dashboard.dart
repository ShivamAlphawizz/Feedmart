// import 'dart:async';
// import 'dart:convert';
//
// import 'package:eshop_multivendor/Helper/Color.dart';
// import 'package:eshop_multivendor/Helper/Constant.dart';
// import 'package:eshop_multivendor/Helper/PushNotificationService.dart';
// import 'package:eshop_multivendor/Helper/Session.dart';
// import 'package:eshop_multivendor/Helper/String.dart';
// import 'package:eshop_multivendor/Model/Section_Model.dart';
// import 'package:eshop_multivendor/Provider/UserProvider.dart';
// import 'package:eshop_multivendor/Screen/Favorite.dart';
// import 'package:eshop_multivendor/Screen/Login.dart';
// import 'package:eshop_multivendor/Screen/MyProfile.dart';
// import 'package:eshop_multivendor/Screen/Product_Detail.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'All_Category.dart';
// import 'Cart.dart';
// import 'HomePage.dart';
// import 'NotificationLIst.dart';
// import 'Sale.dart';
// import 'Search.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<Dashboard> with TickerProviderStateMixin {
//   int _selBottom = 0;
//   late TabController _tabController;
//   bool _isNetworkAvail = true;
//
//   @override
//   void initState() {
//     SystemChrome.setEnabledSystemUIOverlays(
//         [SystemUiOverlay.top, SystemUiOverlay.bottom]);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     super.initState();
//     initDynamicLinks();
//     _tabController = TabController(
//       length: 5,
//       vsync: this
//     );
//
//     // final pushNotificationService = PushNotificationService(
//     //     context: context, tabController: _tabController);
//     // pushNotificationService.initialise();
//
//     _tabController.addListener(
//       () {
//         Future.delayed(Duration(seconds: 0)).then(
//           (value) {
//             if (_tabController.index == 2) {
//               if (CUR_USERID == null) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Login(),
//                   ),
//                 );
//                 _tabController.animateTo(0);
//               }
//             }
//           },
//         );
//
//         setState(
//           () {
//             _selBottom = _tabController.index;
//           },
//         );
//       },
//     );
//   }
//
//   void initDynamicLinks() async {
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//       final Uri? deepLink = dynamicLink?.link;
//
//       if (deepLink != null) {
//         if (deepLink.queryParameters.length > 0) {
//           int index = int.parse(deepLink.queryParameters['index']!);
//
//           int secPos = int.parse(deepLink.queryParameters['secPos']!);
//
//           String? id = deepLink.queryParameters['id'];
//
//           String? list = deepLink.queryParameters['list'];
//
//           getProduct(id!, index, secPos, list == "true" ? true : false);
//         }
//       }
//     }, onError: (OnLinkErrorException e) async {
//       print(e.message);
//     });
//
//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     final Uri? deepLink = data?.link;
//     if (deepLink != null) {
//       if (deepLink.queryParameters.length > 0) {
//         int index = int.parse(deepLink.queryParameters['index']!);
//
//         int secPos = int.parse(deepLink.queryParameters['secPos']!);
//
//         String? id = deepLink.queryParameters['id'];
//
//         // String list = deepLink.queryParameters['list'];
//
//         getProduct(id!, index, secPos, true);
//       }
//     }
//   }
//
//   Future<void> getProduct(String id, int index, int secPos, bool list) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       try {
//         var parameter = {
//           ID: id,
//         };
//
//         // if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID;
//         Response response =
//             await post(getProductApi, headers: headers, body: parameter)
//                 .timeout(Duration(seconds: timeOut));
//
//         var getdata = json.decode(response.body);
//         bool error = getdata["error"];
//         String msg = getdata["message"];
//         if (!error) {
//           var data = getdata["data"];
//
//           List<Product> items = [];
//
//           items =
//               (data as List).map((data) => new Product.fromJson(data)).toList();
//
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ProductDetail(
//                     index: list ? int.parse(id) : index,
//                     model: list
//                         ? items[0]
//                         : sectionList[secPos].productList![index],
//                     secPos: secPos,
//                     list: list,
//                   )));
//         } else {
//           if (msg != "Products Not Found !") setSnackbar(msg, context);
//         }
//       } on TimeoutException catch (_) {
//         setSnackbar(getTranslated(context, 'somethingMSg')!, context);
//       }
//     } else {
//       {
//         if (mounted)
//           setState(() {
//             _isNetworkAvail = false;
//           });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_tabController.index != 0) {
//           _tabController.animateTo(0);
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.lightWhite,
//         appBar: _getAppBar(),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             HomePage(),
//             AllCategory(),
//              Sale(),
//             Cart(
//               fromBottom: true,
//             ),
//             MyProfile(),
//           ],
//         ),
//         //fragments[_selBottom],
//         bottomNavigationBar: _getBottomBar(),
//       ),
//     );
//   }
//
//   AppBar _getAppBar() {
//     String? title;
//     if (_selBottom == 1)
//       title = getTranslated(context, 'CATEGORY');
//     else if (_selBottom == 2)
//       title = getTranslated(context, 'OFFER');
//     else if (_selBottom == 3)
//       title = getTranslated(context, 'MYBAG');
//     else if (_selBottom == 4) title = getTranslated(context, 'PROFILE');
//
//     return
//     AppBar(
//           //  automaticallyImplyLeading: false,
//       //  leading: _selBottom == 0
//       //      ? Image.asset(
//       //    'assets/images/titleicon.png',
//       //
//       //    //height: 40,
//       //
//       //      width: 200,
//       //    height: 40,
//       //    //s
//       //    // width: 45,
//       //  )
//       // : SizedBox(width: 0,),
//         centerTitle: false,
//       title: _selBottom == 0
//           ? Stack(
//             children: [
//               Image.asset(
//         'assets/images/titleicon.png',
//
//         //height: 40,
//
//        // width: 200,
//         height: 40,
//         //s
//         // width: 45,
//       ),
//       ]
//           )
//           : Text(
//               title!,
//               style: TextStyle(
//                   color: Theme.of(context).colorScheme.lightBlack, fontWeight: FontWeight.normal),
//             ),
//
//       // leading: _selBottom == 2
//       //     ? InkWell(
//       //         child: Center(
//       //             child: SvgPicture.asset(
//       //           imagePath + "search.svg",
//       //           height: 20,
//       //           color: colors.primary,
//       //         )),
//       //         onTap: () {
//       //           Navigator.push(
//       //               context,
//       //               MaterialPageRoute(
//       //                 builder: (context) => Search(),
//       //               ));
//       //         },
//       //       )
//       //     : null,
//       // iconTheme: new IconThemeData(color: colors.primary),
//       // centerTitle:_curSelected == 0? false:true,
//       actions: <Widget>[
//         _selBottom == 0
//             ? Container()
//             : IconButton(
//                 icon: SvgPicture.asset(
//                   imagePath + "search.svg",
//                   height: 20,
//                   color: Theme.of(context).colorScheme.lightBlack,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Search(),
//                       ));
//                 }),
//         IconButton(
//           icon: SvgPicture.asset(
//             imagePath + "desel_notification.svg",
//             color: Theme.of(context).colorScheme.lightBlack,
//           ),
//           onPressed: () {
//             CUR_USERID != null
//                 ? Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NotificationList(),
//                     ))
//                 : Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Login(),
//                     ));
//           },
//         ),
//         IconButton(
//           padding: EdgeInsets.all(0),
//           icon: SvgPicture.asset(
//             imagePath + "desel_fav.svg",
//             color: Theme.of(context).colorScheme.lightBlack,
//           ),
//           onPressed: () {
//             CUR_USERID != null
//                 ? Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Favorite(),
//                     ))
//                 : Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Login(),
//                     ));
//           },
//         ),
//       ],
//       backgroundColor: Theme.of(context).colorScheme.white,
//     );
//   }
//
//   Widget _getBottomBar() {
//     return Material(
//         color: Theme.of(context).colorScheme.white,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.white,
//             boxShadow: [
//               BoxShadow(
//                   color: Theme.of(context).colorScheme.black26, blurRadius: 10)
//             ],
//           ),
//           child: TabBar(
//             onTap: (_) {
//               if (_tabController.index == 2) {
//                 if (CUR_USERID == null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Login(),
//                     ),
//                   );
//                   _tabController.animateTo(0);
//                 }
//               }
//             },
//             controller: _tabController,
//             tabs: [
//               Tab(
//                 icon: _selBottom == 0
//                     ? SvgPicture.asset(
//                         imagePath + "sel_home.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       )
//                     : SvgPicture.asset(
//                         imagePath + "desel_home.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       ),
//                 text:
//                     _selBottom == 0 ? getTranslated(context, 'HOME_LBL') : null,
//               ),
//               Tab(
//                 icon: _selBottom == 1
//                     ? SvgPicture.asset(
//                         imagePath + "category01.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       )
//                     : SvgPicture.asset(
//                         imagePath + "category.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       ),
//                 text:
//                     _selBottom == 1 ? getTranslated(context, 'category') : null,
//               ),
//               Tab(
//                 icon: _selBottom == 2
//                     ? SvgPicture.asset(
//                         imagePath + "sale02.svg",
//                         color: colors.primary,
//                       )
//                     : SvgPicture.asset(
//                         imagePath + "sale.svg",
//                         color: colors.primary,
//                       ),
//                 text: _selBottom == 2 ? getTranslated(context, 'SALE') : null,
//               ),
//               Tab(
//                 icon: Selector<UserProvider, String>(
//                   builder: (context, data, child) {
//                     return Stack(
//                       children: [
//                         Center(
//                           child: _selBottom == 2
//                               ? SvgPicture.asset(
//                                   imagePath + "cart01.svg",
//                                   color: Theme.of(context).colorScheme.lightBlack,
//                                 )
//                               : SvgPicture.asset(
//                                   imagePath + "cart.svg",
//                                   color: Theme.of(context).colorScheme.lightBlack,
//                                 ),
//                         ),
//                         (data != null && data.isNotEmpty && data != "0")
//                             ? new Positioned.directional(
//                                 bottom: _selBottom == 3 ? 6 : 20,
//                                 textDirection: Directionality.of(context),
//                                 end: 0,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Theme.of(context).colorScheme.lightBlack,),
//                                   child: new Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(3),
//                                       child: new Text(
//                                         data,
//                                         style: TextStyle(
//                                             fontSize: 7,
//                                             fontWeight: FontWeight.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     );
//                   },
//                   selector: (_, homeProvider) => homeProvider.curCartCount,
//                 ),
//                 text: _selBottom == 2 ? getTranslated(context, 'CART') : null,
//               ),
//               Tab(
//                 icon: _selBottom == 3
//                     ? SvgPicture.asset(
//                         imagePath + "profile01.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       )
//                     : SvgPicture.asset(
//                         imagePath + "profile.svg",
//                         color: Theme.of(context).colorScheme.lightBlack,
//                       ),
//                 text:
//                     _selBottom == 3 ? getTranslated(context, 'ACCOUNT') : null,
//               ),
//             ],
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(color: colors.primary, width: 5.0),
//               insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
//             ),
//             labelColor: Theme.of(context).colorScheme.lightBlack,
//             labelStyle: TextStyle(fontSize: 8 , fontWeight: FontWeight.w600),
//           ),
//         ));
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/PushNotificationService.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Favorite.dart';
import 'package:eshop_multivendor/Screen/Login.dart';
import 'package:eshop_multivendor/Screen/MyProfile.dart';
import 'package:eshop_multivendor/Screen/Product_Detail.dart';
import 'package:eshop_multivendor/Screen/videoplay.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../Provider/SettingProvider.dart';
import 'All_Category.dart';
import 'Cart.dart';
import 'HomePage.dart';
import 'NotificationLIst.dart';
import 'Sale.dart';
import 'Search.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> with TickerProviderStateMixin {
  int _selBottom = 0;
  late TabController _tabController;
  bool _isNetworkAvail = true;


  final homebaxKey = GlobalKey();
  final cateeKey = GlobalKey();
  final videokey = GlobalKey();
  final cartKey = GlobalKey();
  final profile = GlobalKey();

  List <TargetFocus> targetList = [];

  // void startTutorialMode(){
  //   TutorialCoachMark(
  //     alignSkip: Alignment.topRight,
  //       targets: targetList)..show(context: context);
  // }

  void startTutorialMode(){
    TutorialCoachMark(
        alignSkip: Alignment.topRight,
        targets: targetList)..show(context: context);
  }

  Future<void> checkFirstTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(this.context, listen: false);
    //bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    print("checking first time value ${_seen}");
    if(_seen == true){
      //startTutorialMode();
    }
    else{
      await prefs.setBool('seen', true);
      startTutorialMode();
    }
  }


  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, checkFirstTime);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();

    Future.delayed(Duration(seconds: 2),(){
      return startTime();
    });
    targetList.addAll([
      TargetFocus(keyTarget: homebaxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.top,child: Column(
          children: [
            Text("Tap For Home Screen",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget: cateeKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.top,child: Column(
          children: [
            Text("Tap for categories screen",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:videokey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.top ,child: Column(
          children: [
            Text("Tap for video screen",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:cartKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.top ,child: Column(
          children: [
            Text("Tap for cart screen",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:profile,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.top ,child: Column(
          children: [
            Text("Tap for profile screen",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
    ]);
    initDynamicLinks();
    _tabController = TabController(
      length: 5,
      vsync: this,
    );

    final pushNotificationService = PushNotificationService(
        context: context, tabController: _tabController);
    pushNotificationService.initialise();

    _tabController.addListener(
          () {
        Future.delayed(Duration(seconds: 0)).then(
              (value) {
            if (_tabController.index == 3) {
              if (CUR_USERID == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                _tabController.animateTo(0);
              }
            }
          },
        );

        setState(
              () {
            _selBottom = _tabController.index;
          },
        );
      },
    );
  }

  void initDynamicLinks() async {
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //       final Uri? deepLink = dynamicLink?.link;
    //
    //       if (deepLink != null) {
    //         if (deepLink.queryParameters.length > 0) {
    //           int index = int.parse(deepLink.queryParameters['index']!);
    //
    //           int secPos = int.parse(deepLink.queryParameters['secPos']!);
    //
    //           String? id = deepLink.queryParameters['id'];
    //
    //           String? list = deepLink.queryParameters['list'];
    //
    //           getProduct(id!, index, secPos, list == "true" ? true : false);
    //         }
    //       }
    //     }, onError: (OnLinkErrorException e) async {
    //   print(e.message);
    // });

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      if (deepLink.queryParameters.length > 0) {
        int index = int.parse(deepLink.queryParameters['index']!);

        int secPos = int.parse(deepLink.queryParameters['secPos']!);

        String? id = deepLink.queryParameters['id'];

        // String list = deepLink.queryParameters['list'];

        getProduct(id!, index, secPos, true);
      }
    }
  }
  List<dynamic> _handlePages = [
    HomePage(),
    AllCategory(),
    VideoPlay(),
    // VideoPlay()
    // VideoPlayersList(),
    Cart(
      fromBottom: true,
    ),
    MyProfile(),
  ];


  Future<void> getProduct(String id, int index, int secPos, bool list) async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stateid = prefs.getString('stateId');
    if (_isNetworkAvail) {
      try {
        var parameter = {
          ID: id,
          "state_id": "${stateid}"
        };
        print("api here ${getProductApi} and ${parameter}");

        // if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID;
        Response response =
        await post(getProductApi, headers: headers, body: parameter)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<Product> items = [];

          items =
              (data as List).map((data) => new Product.fromJson(data)).toList();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetail(
                index: list ? int.parse(id) : index,
                model: list
                    ? items[0]
                    : sectionList[secPos].productList![index],
                secPos: secPos,
                list: list,
              )));
        } else {
          if (msg != "Products Not Found !") setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: colors.primary
                    ),
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: colors.primary
                    ),
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        // if (_tabController.index != 0) {
        //   _tabController.animateTo(0);
        //   return false;
        // }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            body: _handlePages[currentIndex],
            bottomNavigationBar: _getBottomNavigator(),
             // appBar: _getAppBar(),

        ),
      ),
    );
  }
  int currentIndex = 0;
  bool isLoading = false;
  AppBar _getAppBar() {
    String? title;
    if (_selBottom == 1)
      title = getTranslated(context, 'CATEGORY');
    else if (_selBottom == 2)
      title = getTranslated(context, 'OFFER');
    else if (_selBottom == 3)
      title = getTranslated(context, 'MYBAG');
    else if (_selBottom == 4) title = getTranslated(context, 'PROFILE');

    return AppBar(
      centerTitle: _selBottom == 2  ? true : false,
      leadingWidth: _selBottom == 0  ? 100 : 0,
      leading: _selBottom == 0  ? Container(
        width: 100,
        height: 60,
        child: Image.asset(
          'assets/images/titleicon.png',
          fit: BoxFit.cover,

          //height: 40,

          //   width: 200,
          // height: 50,
          //s
          // width: 45,
        ),
      )
      : SizedBox.shrink(),
      title:
      // _selBottom == 0
      //     ? Image.asset(
      //   'assets/images/titleicon.png',
      //
      //   //height: 40,
      //
      //   //   width: 200,
      //   height: 40,
      //   //s
      //   // width: 45,
      // )
      //     :
      Text(
          _selBottom == 0 ?
              "":
        title.toString(),
        style: TextStyle(
             color:Theme.of(context).colorScheme.darkMode, fontWeight: FontWeight.normal),
      ),

      // leading: _selBottom == 0
      //     ? InkWell(
      //   child: Center(
      //       child: SvgPicture.asset(
      //         imagePath + "search.svg",
      //         height: 20,
      //         color: colors.primary,
      //       )),
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Search(),
      //         ));
      //   },
      //
      // )
      //     : null,
      // iconTheme: new IconThemeData(color: colors.primary),
      // centerTitle:_curSelected == 0? false:true,
      actions: <Widget>[
        _selBottom == 2 || _selBottom == 3
            ? Container()
            : IconButton(
            icon: SvgPicture.asset(
              imagePath + "search.svg",
              height: 20,
                color:Theme.of(context).colorScheme.darkMode
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(),
                  ));
            }),
        _selBottom == 2
            ? Container() :  IconButton(
          icon: SvgPicture.asset(
            imagePath + "desel_notification.svg",
              color:Theme.of(context).colorScheme.darkMode
          ),
          onPressed: () {
            CUR_USERID != null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationList(),
                ))
                : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ));
          },
        ),
        _selBottom == 2
            ? Container() :  IconButton(
          padding: EdgeInsets.all(0),
          icon: SvgPicture.asset(
            imagePath + "desel_fav.svg",
              color:Theme.of(context).colorScheme.darkMode
          ),
          onPressed: () {
            CUR_USERID != null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favorite(),
                ))
                : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ));
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.white,
    );
  }
  Widget _getBottomNavigator() {
    return Material(
      color: colors.primary,
      //elevation: 2,
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 50,
        backgroundColor: Color(0xfff4f4f4),
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
             key: homebaxKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bottom1.png',
                  height: 25.0,
                  color: _selBottom == 0 ? colors.secondary : colors.secondary,
                ),
                // Text("Home",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold, fontSize: 10,
                //     color: currentIndex == 0 ? Colors.black : Colors.grey,
                //   ),
                // )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              key: cateeKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.category,
                //   color: currentIndex == 1 ?  backgroundblack : appColorGrey,),
                Image.asset(
                  'assets/images/botom2.png',
                  height: 25.0,
                  color: _selBottom == 1 ?  colors.secondary : colors.secondary,
                ),
                // Text("Category" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10,
                //   color: currentIndex == 1 ? Colors.black : Colors.grey,
                // ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              key: videokey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bottom3.png',
                  height: 25.0,
                  color: _selBottom == 2 ?   colors.secondary : colors.secondary,
                ),
                // Text("Bookings" , style: TextStyle(
                //   fontWeight: FontWeight.bold,
                //   fontSize: 10,
                //   color: currentIndex == 2 ? Colors.black : Colors.grey,
                // ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              key: cartKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bottom4.png',
                  height: 25.0,
                  color: currentIndex == 3 ?  colors.secondary : colors.secondary,
                ),
                // Text("Profile" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10,
                //   color: currentIndex == 3 ? Colors.black : Colors.grey,
                // ),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              key: profile,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 25,
                  color: currentIndex == 4 ? colors.secondary : colors.secondary,
                ),
                // Text("ACCOUNT" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10,
                //   color: currentIndex == 4 ? Colors.black : Colors.grey,
                // ),)
              ],
            ),
          ),
        ],
        onTap: (index) {
          print("current index here ${index}");
          setState(() {
            currentIndex = index;
            _selBottom = currentIndex;
            print("sel bottom ${_selBottom}");
            //_pageController.jumpToPage(index);
          });
          // if (currentIndex == 3 ) {
          // if (CUR_USERID == null) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Login(),
          //     ),
          //   );
          //   // _pageController.jumpToPage(2);
          // }
          // }
        },
      ),
    );
  }

  // _getBottomNavigator() {
  //   return Material(
  //     color: colors.primary,
  //     //elevation: 2,
  //     child: CurvedNavigationBar(
  //       index: currentIndex,
  //       height: 50,
  //       backgroundColor: Color(0xfff4f4f4),
  //       items: <Widget>[
  //
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: Column(
  //             key: homebaxKey,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 'assets/images/bottom1.png',
  //                 height: 25.0,
  //                 color: currentIndex == 0 ? colors.secondary : colors.secondary,
  //               ),
  //               // Text("Home",
  //               //   style: TextStyle(
  //               //     fontWeight: FontWeight.bold, fontSize: 10,
  //               //     color: currentIndex == 0 ? Colors.black : Colors.grey,
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: Column(
  //             key: cateeKey,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // Icon(
  //               //   Icons.category,
  //               //   color: currentIndex == 1 ?  backgroundblack : appColorGrey,),
  //               Image.asset(
  //                 'assets/images/botom2.png',
  //                 height: 25.0,
  //                 color: currentIndex == 1 ?  colors.secondary : colors.secondary,
  //               ),
  //               // Text("Category" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10,
  //               //   color: currentIndex == 1 ? Colors.black : Colors.grey,
  //               // ),)
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: Column(
  //             key: videokey,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 'assets/images/bottom3.png',
  //                 height: 25.0,
  //                 color: currentIndex == 2 ?   colors.secondary : colors.secondary,
  //               ),
  //               // Text("Bookings" , style: TextStyle(
  //               //   fontWeight: FontWeight.bold,
  //               //   fontSize: 10,
  //               //   color: currentIndex == 2 ? Colors.black : Colors.grey,
  //               // ),)
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: Column(
  //             key: cartKey,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 'assets/images/bottom4.png',
  //                 height: 25.0,
  //                 color: currentIndex == 3 ?  colors.secondary : colors.secondary,
  //               ),
  //               // Text("Profile" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10,
  //               //   color: currentIndex == 3 ? Colors.black : Colors.grey,
  //               // ),)
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: Column(
  //             key: profile,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                   'assets/images/bottom5.png',
  //                   height: 25.0,
  //                   color: currentIndex == 4 ?  colors.secondary : colors.secondary
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //       onTap: (index) {
  //         print("current index here ${index}");
  //         setState(() {
  //           currentIndex = index;
  //           _selBottom = currentIndex;
  //           print("sel bottom ${_selBottom}");
  //           //_pageController.jumpToPage(index);
  //         });
  //         // if (currentIndex == 3 ) {
  //         // if (CUR_USERID == null) {
  //         //   Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //       builder: (context) => Login(),
  //         //     ),
  //         //   );
  //         //   // _pageController.jumpToPage(2);
  //         // }
  //         // }
  //       },
  //     ),
  //   );
  // }




  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

