// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// // import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
// import 'package:eshop_multivendor/Helper/AppBtn.dart';
// import 'package:eshop_multivendor/Helper/Color.dart';
// import 'package:eshop_multivendor/Helper/Constant.dart';
// import 'package:eshop_multivendor/Helper/Session.dart';
// import 'package:eshop_multivendor/Helper/SimBtn.dart';
// import 'package:eshop_multivendor/Helper/String.dart';
// import 'package:eshop_multivendor/Helper/widgets.dart';
// import 'package:eshop_multivendor/Model/GetStateModel.dart';
// import 'package:eshop_multivendor/Model/Model.dart';
// import 'package:eshop_multivendor/Model/Section_Model.dart';
// import 'package:eshop_multivendor/Provider/CartProvider.dart';
// import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
// import 'package:eshop_multivendor/Provider/FavoriteProvider.dart';
// import 'package:eshop_multivendor/Provider/HomeProvider.dart';
// import 'package:eshop_multivendor/Provider/SettingProvider.dart';
// import 'package:eshop_multivendor/Provider/UserProvider.dart';
// import 'package:eshop_multivendor/Screen/NotificationLIst.dart';
// import 'package:eshop_multivendor/Screen/Search.dart';
// import 'package:eshop_multivendor/Screen/SellerList.dart';
// import 'package:eshop_multivendor/Screen/Seller_Details.dart';
// import 'package:eshop_multivendor/Screen/SubCategory.dart';
// import 'package:eshop_multivendor/Screen/videoplay.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:package_info/package_info.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:version/version.dart';
// import '../Model/PrimeProductModel.dart';
// import 'All_Category.dart';
// import 'Login.dart';
// import 'ProductList.dart';
// import 'Product_Detail.dart';
// import 'SectionList.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// List<SectionModel> sectionList = [];
// List<Product> catList = [];
// List<Product> popularList = [];
// ApiBaseHelper apiBaseHelper = ApiBaseHelper();
// List<String> tagList = [];
// List<Product> sellerList = [];
// int count = 1;
// List<Model> homeSliderList = [];
// List<Widget> pages = [];
// int currentindex = 0;
//
// class _HomePageState extends State<HomePage>
//     with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {
//   bool _isNetworkAvail = true;
//
//   final _controller = PageController();
//
//   late Animation buttonSqueezeanimation;
//   late AnimationController buttonController;
//    final TextEditingController controllerfield = TextEditingController();
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   List<Model> offerImages = [];
//
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       new GlobalKey<RefreshIndicatorState>();
//
//   //String? curPin;
//
//   @override
//   bool get wantKeepAlive => true;
//   SharedPreferences? prefs;
//
// getData()async{
//   prefs = await SharedPreferences.getInstance();
// }
//
//   List<StateData> getStateModel = [];
//
//
//   @override
//
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 500
//     ),(){
//       getPrimeProduct();
//     });
//     Future.delayed(Duration(
//       seconds: 5
//     ), (){
//       if(prefs!.getString('stateId') == "" || prefs!.getString("stateId") == null) {
//         stateSelectDialog();
//       }
//       else{
//         String? value = prefs!.getString('stateId');
//         selectedState = value;
//       }
//     });
//     callApi();
//     getState();
//     buttonController = new AnimationController(
//         duration: new Duration(milliseconds: 2000), vsync: this);
//     getData();
//     buttonSqueezeanimation = new Tween(
//       begin: deviceWidth! * 0.7,
//       end: 50.0,
//     ).animate(
//       new CurvedAnimation(
//         parent: buttonController,
//         curve: new Interval(
//           0.0,
//           0.150,
//         ),
//       ),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
//     getState();
//   }
//
//   getState()async{
//     var headers = {
//       'Cookie': 'ci_session=d17027e5a9e874c71f0fd74fbefb2dd76e17e1d9'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_states'));
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//
//     print("status code here ${'${baseUrl}get_states'}  ddddd ${response.statusCode}");
//     if (response.statusCode == 200) {
//       var finalRes = await response.stream.bytesToString();
//       final jsonResponse = GetStateModel.fromJson(json.decode(finalRes));
//       setState(() {
//         getStateModel = jsonResponse.date!;
//       });
//       // print("okkk ${getStateModel} and ${getStateModel.date}");
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   String? selectedState;
//   String? state;
//
//   stateSelectDialog(){
//     showDialog(
//         barrierDismissible: false,
//         context: context, builder: (context){
//       return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
//         return WillPopScope(
//           onWillPop: () async => false,
//           child:AlertDialog(
//             contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Select State",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
//                 SizedBox(height: 10,),
//                 getStateModel != null ?  Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(7),
//                       border: Border.all(
//                         color: Colors.grey,
//                       )
//                   ),
//                   child:DropdownButton(
//                       underline: Container(),
//                       value: selectedState,
//                       icon: const Icon(Icons.keyboard_arrow_down_outlined),
//                       hint: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           width: MediaQuery.of(context).size.width/1.6,
//                           child: Text("Select state")),
//                       items: getStateModel.map((items){
//                         return DropdownMenuItem(
//                           value: items.id,
//                           child: Padding(
//                             padding:  EdgeInsets.only(left: 10),
//                             child: Text(items.name.toString()),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (newValue){
//                         setState((){
//                           selectedState = newValue as String?;
//                           prefs!.setString('stateId', '${selectedState}');
//                           Navigator.of(context);
//                           callApi();
//                           Navigator.of(context);
//                         });
//                       }),
//                 )
//                     : CircularProgressIndicator(),
//               ],
//             ),
//             actions: [
//               InkWell(
//                 onTap: (){
//                   if(selectedState == "" || selectedState == null){
//                     Fluttertoast.showToast(msg: "Please select state");
//                   }
//                   else{
//                     Navigator.of(context).pop();
//                   }
//
//                 },
//                 child:Container(
//                   height: 40,
//                   width: 50,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: colors.primary,
//                       borderRadius: BorderRadius.circular(8)
//                   ),
//                   child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),
//                 ),
//               )
//             ],
//           ),
//         );
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //
//       //   backgroundColor: Colors.red,
//       //
//       //   shape: RoundedRectangleBorder(
//       //       borderRadius: BorderRadius.only(
//       //           bottomLeft: Radius.circular(20),
//       //           bottomRight: Radius.circular(20)
//       //       )
//       //   ),
//       //   elevation: 2,
//       //   // title: Text(
//       //   //   "${getTranslated(context, 'feedback')}",
//       //   //   style: TextStyle(
//       //   //     fontSize: 20,
//       //   //     color: appColorWhite,
//       //   //   ),
//       //   // ),
//       //   centerTitle: true,
//       //   leading:  Padding(
//       //     padding: const EdgeInsets.all(12),
//       //     // child: RawMaterialButton(
//       //     //   // shape: CircleBorder(),
//       //     //   padding: const EdgeInsets.all(0),
//       //     //   fillColor: Colors.white,
//       //     //   splashColor: Colors.grey[400],
//       //     //   // child: Icon(
//       //     //   //   Icons.arrow_back,
//       //     //   //   size: 20,
//       //     //   //   // color: appColorBlack,
//       //     //   // ),
//       //     //   onPressed: () {
//       //     //     Navigator.pop(context);
//       //     //   },
//       //     // ),
//       //   ),
//       // ),
//       body: _isNetworkAvail
//           ? RefreshIndicator(
//               color: colors.primary,
//               key: _refreshIndicatorKey,
//               onRefresh: _refresh,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 125,
//                       width: double.infinity,
//                        decoration: BoxDecoration(borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(30),
//                          //
//                   bottomRight: Radius.circular(30),
//               ),
//                          color: colors.secondary,
//                        ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 14),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 18,top: 7,bottom: 5),
//                                 child: Image.asset("assets/images/feedmartlogo.png",height: 50,width: 100,),
//                               ),
//                               SizedBox(width: 82,),
//                               InkWell(
//                                   onTap: () => launch('https://www.youtube.com/'),
//                                   child: Image.asset("assets/images/youtube.png",height: 25,width: 25)),
//                               SizedBox(width: 12,),
//                               InkWell(
//                                   onTap: () =>launch('https://www.facebook.com/'),
//                                   child: Image.asset("assets/images/facebook.png",height: 20,width: 20,)),
//                               SizedBox(width: 12,),
//                               InkWell(
//                                   onTap: ()=>launch('https://www.instagram.com/'),
//                                   child: Image.asset("assets/images/instagram.png",height: 20,width: 20)),
//                               SizedBox(width: 11,),
//                               InkWell(onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationList()));
//                               },
//                                   child: Image.asset("assets/images/notifaction.png",height: 20,width: 20)),
//                             ],
//                           ),
//                           searchBar(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Expanded(
//                     child: ListView(
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       // mainAxisAlignment: MainAxisAlignment.start,
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // InkWell(
//                         //   onTap: (){
//                         //     stateSelectDialog();
//                         //   },
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.all(8.0),
//                         //     child: Container(
//                         //       height: 45,
//                         //       decoration: BoxDecoration(
//                         //         color: colors.whiteTemp,
//                         //         borderRadius: BorderRadius.circular(20.0)
//                         //       ),
//                         //       child: Padding(
//                         //         padding: const EdgeInsets.all(8.0),
//                         //         child: Row(
//                         //           children: [
//                         //             Icon(Icons.location_on_outlined),
//                         //             // SizedBox(width: 10,),
//                         //             Container(
//                         //
//                         //               child:
//                         //               DropdownButton(
//                         //                  // isExpanded: true,
//                         //                   underline: Container(),
//                         //                   value: state,
//                         //
//                         //                   icon: Padding(
//                         //                     padding: const EdgeInsets.only(left: 50),
//                         //                     child: const Icon(Icons.keyboard_arrow_down_outlined),
//                         //                   ),
//                         //                   hint: Container(
//                         //                       padding: EdgeInsets.symmetric(horizontal: 10),
//                         //                       width: MediaQuery.of(context).size.width/1.6,
//                         //                       child: Text("Select state")),
//                         //                   items: getStateModel.map((items){
//                         //                     return DropdownMenuItem(
//                         //                       value: items.id,
//                         //                       child:
//                         //                       Padding(
//                         //                         padding:  EdgeInsets.only(left: 10),
//                         //                         child: Text(items.name.toString()),
//                         //                       ),
//                         //                     );
//                         //                   }).toList(),
//                         //                   onChanged: (newValue){
//                         //                     setState((){
//                         //                       selectedState = newValue as String?;
//                         //                       prefs!.setString('stateId', '${selectedState}');
//                         //                       callApi();
//                         //                       Navigator.of(context);
//                         //                     });
//                         //                   }
//                         //                   ),
//                         //             )
//                         //           ],
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//
//                         //
//                         // FloatingActionButton(onPressed: ())
//                         // InkWell(
//                         //   onTap: (){
//                         //     stateSelectDialog();
//                         //   },
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.all(8.0),
//                         //     child: Container(
//                         //       height: 45,
//                         //       decoration: BoxDecoration(
//                         //           color: colors.whiteTemp,
//                         //           borderRadius: BorderRadius.circular(20.0)
//                         //       ),
//                         //       child: Padding(
//                         //         padding: const EdgeInsets.all(8.0),
//                         //         child: Row(
//                         //           children: [
//                         //             Icon(Icons.location_on_outlined),
//                         //             // SizedBox(width: 10,),
//                         //             Container(
//                         //               // width: 230,
//                         //               child: DropdownButton(
//                         //                 // isExpanded: true,
//                         //                   underline: Container(),
//                         //                   value: selectedState,
//                         //
//                         //                   icon: Padding(
//                         //                     padding: const EdgeInsets.only(left: 45             ),
//                         //                     child: const Icon(Icons.keyboard_arrow_down_outlined),
//                         //                   ),
//                         //                   hint: Container(
//                         //                       padding: EdgeInsets.symmetric(horizontal: 10),
//                         //                       width: MediaQuery.of(context).size.width/1.6,
//                         //                       child: Text("Select state")),
//                         //                   items: getStateModel.map((items){
//                         //                     return DropdownMenuItem(
//                         //                       value: items.id,
//                         //                       child: Padding(
//                         //                         padding:  EdgeInsets.only(left: 10),
//                         //                         child: Text(items.name.toString()),
//                         //                       ),
//                         //                     );
//                         //                   }).toList(),
//                         //                   onChanged: (newValue){
//                         //                     setState((){
//                         //                       selectedState = newValue as String?;
//                         //                       prefs!.setString('stateId', '${selectedState}');
//                         //                       callApi();
//                         //                       Navigator.of(context);
//                         //                     });
//                         //                   }),
//                         //             )
//                         //           ],
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15),
//                           child: Text("Categories",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 18),),
//                         ),
//                         _catList(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: InkWell(
//                                 onTap: (){
//                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCategory()));
//                                 },
//                                 child: Container(width: 75,
//                                     decoration: BoxDecoration(
//                                         color: colors.secondary,
//                                         borderRadius: BorderRadius.circular(20)
//                                     ),
//                                     child: catList.length >=5 ? Center(child: Text("View all",style: TextStyle(color: colors.whiteTemp),)):SizedBox.shrink()),
//                               ),
//                             )
//                           ],
//                         ),
//                         _slider(),
//                         // playviedo(),
//                         _section(),
//                         SizedBox(height: 10,),
//                         // Padding(
//                         //   padding: const EdgeInsets.all(8.0),
//                         //   child: Text("Prime Products",style: TextStyle(color: colors.blackTemp,fontSize:14,fontWeight: FontWeight.bold),),
//                         // ),
//                         // primeProduct(),
//                         SizedBox(height: 10,),
//                         // _seller()
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : noInternet(context),
//       floatingActionButton:
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: Container(
//               height: 45.0,
//               width: 45.0,
//               child: FloatingActionButton(
//                 backgroundColor: Colors.white ,
//                 onPressed: () {
//                   _callNumber();
//                 },
//                 child: Image.asset("assets/images/telephone.png"),
//               ),
//             ),
//           ),
//           SizedBox(height: 10,),
//           Container(
//             height: 50.0,
//             width: 50.0,
//             child: FloatingActionButton(
//               backgroundColor: Colors.white ,
//               onPressed: () {
//                 openwhatsapp();
//               },
//               child: Image.asset("assets/images/whatsapp.png"),
//             ),
//           ),
//         ],
//       ),
//
//       // Column(
//       //   mainAxisAlignment: MainAxisAlignment.end,
//       //   children: [
//       //     Container(
//       //       height: 45.0,
//       //       width: 45.0,
//       //       child: FloatingActionButton(
//       //         backgroundColor: Colors.white ,
//       //         onPressed: () {
//       //           _callNumber();
//       //         },
//       //         child: Image.asset("assets/images/telephone.png"),
//       //       ),
//       //     ),
//       //     SizedBox(height: 10,),
//       //     Container(
//       //       height: 50.0,
//       //       width: 50.0,
//       //       child: FloatingActionButton(
//       //         backgroundColor: Colors.white ,
//       //         onPressed: () {
//       //           openwhatsapp();
//       //         },
//       //         child: Image.asset("assets/images/whatsapp.png"),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//
//     );
//   }
//
//   Future<Null> _refresh() {
//     context.read<HomeProvider>().setCatLoading(true);
//     context.read<HomeProvider>().setSecLoading(true);
//     context.read<HomeProvider>().setSliderLoading(true);
//
//     return callApi();
//   }
//
//   // Widget _slider() {
//   //   double height = deviceWidth! / 2.2;
//   //
//   //   return Selector<HomeProvider, bool>(
//   //     builder: (context, data, child) {
//   //       return data
//   //           ? sliderLoading()
//   //           : Stack(
//   //               children: [
//   //                 Container(
//   //                   height: height,
//   //                   width: double.infinity,
//   //                   // margin: EdgeInsetsDirectional.only(top: 10),
//   //                   child: PageView.builder(
//   //                     itemCount: homeSliderList.length,
//   //                     scrollDirection: Axis.horizontal,
//   //                     controller: _controller,
//   //                     physics: AlwaysScrollableScrollPhysics(),
//   //                     onPageChanged: (index) {
//   //                       context.read<HomeProvider>().setCurSlider(index);
//   //                     },
//   //                     itemBuilder: (BuildContext context, int index) {
//   //                       return pages[index];
//   //                     },
//   //                   ),
//   //                 ),
//   //                 Positioned(
//   //                   bottom: 0,
//   //                   height: 40,
//   //                   left: 0,
//   //                   width: deviceWidth,
//   //                   child: Row(
//   //                     mainAxisSize: MainAxisSize.max,
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: map<Widget>(
//   //                       homeSliderList,
//   //                       (index, url) {
//   //                         return Container(
//   //                             width: 8.0,
//   //                             height: 8.0,
//   //                             margin: EdgeInsets.symmetric(
//   //                                 vertical: 10.0, horizontal: 2.0),
//   //                             decoration: BoxDecoration(
//   //                               shape: BoxShape.circle,
//   //                               color: context.read<HomeProvider>().curSlider ==
//   //                                       index
//   //                                   ? Theme.of(context).colorScheme.fontColor
//   //                                   : Theme.of(context).colorScheme.lightBlack,
//   //                             ));
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             );
//   //     },
//   //     selector: (_, homeProvider) => homeProvider.sliderLoading,
//   //   );
//   // }
//   _callNumber() async{
//     const number = '+18001022386'; //set the number here
//     bool? res = await FlutterPhoneDirectCaller.callNumber(number);
//   }
//
//
//   openwhatsapp() async {
//     var whatsapp = "+916309132555";
//     // var whatsapp = "+919644595859";
//     var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
//         "&text=Hello, I am messaging from Feed Mart App, I am interested in your products, Can we have chat? ";
//     var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
//     if (Platform.isIOS) {
//       // for iOS phone only
//       if (await canLaunch(whatappURL_ios)) {
//         await launch(whatappURL_ios, forceSafariVC: false);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: new Text("Whatsapp does not exist in this device")));
//       }
//     } else {
//       // android , web
//       if (await canLaunch(whatsappURl_android)) {
//         await launch(whatsappURl_android);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: new Text("Whatsapp does not exist in this device")));
//       }
//     }
//   }
//     Widget _slider() {
//     double height = deviceWidth! / 2.0;
//     return Selector<HomeProvider, bool>(
//       builder: (context, data, child) {
//         return data
//             ? sliderLoading()
//             : ClipRRect(
//           borderRadius: BorderRadius.circular(0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Container(
//                   height: height,
//                   width: double.infinity,
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       viewportFraction: 1.0,
//                       initialPage: 0,
//                       enableInfiniteScroll: true,
//                       reverse: false,
//                       autoPlay: true,
//                       autoPlayInterval: Duration(seconds: 3),
//                       autoPlayAnimationDuration:
//                       Duration(milliseconds: 150),
//                       enlargeCenterPage: false,
//                       scrollDirection: Axis.horizontal,
//                       height: height,
//                       onPageChanged: (position, reason) {
//                         setState(() {
//                           currentindex = position;
//                         });
//                         print(reason);
//                         print(CarouselPageChangedReason.controller);
//                       },
//                     ),
//                     items: homeSliderList.map((val) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image.network(
//                               "${val.image}",
//                               fit: BoxFit.fill,
//                             )),
//                       );
//                     }).toList(),
//                   ),
//                   // margin: EdgeInsetsDirectional.only(top: 10),
//                   // child: PageView.builder(
//                   //   itemCount: homeSliderList.length,
//                   //   scrollDirection: Axis.horizontal,
//                   //   controller: _controller,
//                   //   pageSnapping: true,
//                   //   physics: AlwaysScrollableScrollPhysics(),
//                   //   onPageChanged: (index) {
//                   //     context.read<HomeProvider>().setCurSlider(index);
//                   //   },
//                   //   itemBuilder: (BuildContext context, int index) {
//                   //     return pages[index];
//                   //   },
//                   // ),
//                 ),
//               ),
//               Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: homeSliderList.map((e) {
//                     int index = homeSliderList.indexOf(e);
//                     return Container(
//                         width: 30.0,
//                         height: 8.0,
//                         margin: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 2.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           // shape: BoxShape.circle,
//                           color: currentindex == index
//                               ? Theme.of(context).colorScheme.lightBlack
//                               : Theme.of(context).colorScheme.darkgray,
//                         ));
//                   }).toList()),
//             ],
//           ),
//         );
//       },
//       selector: (_, homeProvider) => homeProvider.sliderLoading,
//     );
//   }
//
//   void _animateSlider() {
//     Future.delayed(Duration(seconds: 30)).then(
//       (_) {
//         if (mounted) {
//           int nextPage = _controller.hasClients
//               ? _controller.page!.round() + 1
//               : _controller.initialPage;
//
//           if (nextPage == homeSliderList.length) {
//             nextPage = 0;
//           }
//           if (_controller.hasClients)
//             _controller
//                 .animateToPage(nextPage,
//                     duration: Duration(milliseconds: 200), curve: Curves.linear)
//                 .then((_) => _animateSlider());
//         }
//       },
//     );
//   }
//
//   _singleSection(int index) {
//     Color back;
//     int pos = index % 5;
//     if (pos == 0)
//       back = Theme.of(context).colorScheme.back1;
//     else if (pos == 1)
//       back = Theme.of(context).colorScheme.back2;
//     else if (pos == 2)
//       back = Theme.of(context).colorScheme.back3;
//     else if (pos == 3)
//       back = Theme.of(context).colorScheme.back4;
//     else
//       back = Theme.of(context).colorScheme.back5;
//
//     return sectionList[index].productList!.length > 0
//         ? Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     _getHeading(sectionList[index].title ?? "", index),
//
//                     _getSection(index),
//                   ],
//                 ),
//               ),
//               offerImages.length > index ? _getOfferImage(index) : Container(),
//             ],
//           )
//         : Container();
//   }
//
//   _getHeading(String title, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 20.0),
//           child: Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.centerRight,
//             children: <Widget>[
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: colors.yellow,
//                 ),
//                 padding: EdgeInsetsDirectional.only(
//                     start: 10, bottom: 3, top: 3, end: 10),
//                 child: Text(
//                   title,
//                   style: Theme.of(context)
//                       .textTheme
//                       .subtitle2!
//                       .copyWith(color: colors.blackTemp),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               /*   Positioned(
//                   // clipBehavior: Clip.hardEdge,
//                   // margin: EdgeInsets.symmetric(horizontal: 20),
//
//                   right: -14,
//                   child: SvgPicture.asset("assets/images/eshop.svg"))*/
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(sectionList[index].shortDesc ?? "",
//                     style: Theme.of(context).textTheme.subtitle1!.copyWith(
//                         color: Theme.of(context).colorScheme.fontColor)),
//               ),
//               // TextButton(
//               //   style: TextButton.styleFrom(
//               //       minimumSize: Size.zero, // <
//               //       backgroundColor: (Theme.of(context).colorScheme.white),
//               //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
//               //   child: Text(
//               //     getTranslated(context, 'SHOP_NOW')!,
//               //     style: Theme.of(context).textTheme.caption!.copyWith(
//               //         color: Theme.of(context).colorScheme.fontColor,
//               //         fontWeight: FontWeight.bold),
//               //   ),
//               //   onPressed: () {
//               //     SectionModel model = sectionList[index];
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => SectionList(
//               //           index: index,
//               //           section_model: model,
//               //         ),
//               //       ),
//               //     );
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//   _getOfferImage(index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: InkWell(
//         child: FadeInImage(
//             fit: BoxFit.contain,
//             fadeInDuration: Duration(milliseconds: 150),
//             image: CachedNetworkImageProvider(offerImages[index].image!),
//             width: double.maxFinite,
//             imageErrorBuilder: (context, error, stackTrace) => erroWidget(50),
//             // errorWidget: (context, url, e) => placeHolder(50),
//             placeholder: AssetImage(
//               "assets/images/sliderph.png",
//             )),
//         onTap: () {
//           if (offerImages[index].type == "products") {
//             Product? item = offerImages[index].list;
//
//             Navigator.push(
//               context,
//               PageRouteBuilder(
//                   //transitionDuration: Duration(seconds: 1),
//                   pageBuilder: (_, __, ___) =>
//                       ProductDetail(model: item, secPos: 0, index: 0, list: true
//                           //  title: sectionList[secPos].title,
//                           )),
//             );
//           } else if (offerImages[index].type == "categories") {
//             Product item = offerImages[index].list;
//             if (item.subList == null || item.subList!.length == 0) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductList(
//                     name: item.name,
//                     id: item.id,
//                     tag: false,
//                     fromSeller: false,
//                   ),
//                 ),
//               );
//             } else {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubCategory(
//                     title: item.name!,
//                     subList: item.subList,
//                   ),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
//
//    _getSection(int i) {
//     var orient = MediaQuery.of(context).orientation;
//
//     return sectionList[i].style == DEFAULT
//         ?
//     Padding(
//             padding: const EdgeInsets.all(5.0),
//             child:
//             GridView.count(
//               // mainAxisSpacing: 12,
//               // crossAxisSpacing: 12,
//               padding: EdgeInsetsDirectional.only(top: 5),
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               mainAxisSpacing: 2,
//               crossAxisSpacing: 5,
//               childAspectRatio: 0.750,
//
//               //  childAspectRatio: 1.0,
//               physics: NeverScrollableScrollPhysics(),
//               children:
//                   //  [
//                   //   Container(height: 500, width: 1200, color: Colors.red),
//                   //   Text("hello"),
//                   //   Container(height: 10, width: 50, color: Colors.green),
//                   // ]
//                   List.generate(
//                 sectionList[i].productList!.length < 4
//                     ? sectionList[i].productList!.length
//                     : 4,
//                 (index) {
//                   // return Container(
//                   //   width: 600,
//                   //   height: 50,
//                   //   color: Colors.red,
//                   // );
//
//                   return productItem(i, index, index % 2 == 0 ? true : false);
//                 },
//               ),
//             ),
//           )
//         : sectionList[i].style == STYLE1
//             ? sectionList[i].productList!.length > 0
//                 ? Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Row(
//                       children: [
//                         Flexible(
//                             flex: 3,
//                             fit: FlexFit.loose,
//                             child: Container(
//                                 height: orient == Orientation.portrait
//                                     ? deviceHeight! * 0.4
//                                     : deviceHeight!,
//                                 child: productItem(i, 0, true))),
//                         Flexible(
//                           flex: 2,
//                           fit: FlexFit.loose,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                   height: orient == Orientation.portrait
//                                       ? deviceHeight! * 0.2
//                                       : deviceHeight! * 0.5,
//                                   child: productItem(i, 1, false)),
//                               Container(
//                                   height: orient == Orientation.portrait
//                                       ? deviceHeight! * 0.2
//                                       : deviceHeight! * 0.5,
//                                   child: productItem(i, 2, false)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ))
//                 : Container()
//             : sectionList[i].style == STYLE2
//                 ? Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Row(
//                       children: [
//                         Flexible(
//                           flex: 2,
//                           fit: FlexFit.loose,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                   height: orient == Orientation.portrait
//                                       ? deviceHeight! * 0.2
//                                       : deviceHeight! * 0.5,
//                                   child: productItem(i, 0, true)),
//                               Container(
//                                   height: orient == Orientation.portrait
//                                       ? deviceHeight! * 0.2
//                                       : deviceHeight! * 0.5,
//                                   child: productItem(i, 1, true)),
//                             ],
//                           ),
//                         ),
//                         Flexible(
//                             flex: 3,
//                             fit: FlexFit.loose,
//                             child: Container(
//                                 height: orient == Orientation.portrait
//                                     ? deviceHeight! * 0.4
//                                     : deviceHeight,
//                                 child: productItem(i, 2, false))),
//                       ],
//                     ))
//                 : sectionList[i].style == STYLE3
//                     ? Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Flexible(
//                                 flex: 1,
//                                 fit: FlexFit.loose,
//                                 child: Container(
//                                     height: orient == Orientation.portrait
//                                         ? deviceHeight! * 0.3
//                                         : deviceHeight! * 0.6,
//                                     child: productItem(i, 0, false))),
//                             Container(
//                               height: orient == Orientation.portrait
//                                   ? deviceHeight! * 0.2
//                                   : deviceHeight! * 0.5,
//                               child: Row(
//                                 children: [
//                                   Flexible(
//                                       flex: 1,
//                                       fit: FlexFit.loose,
//                                       child: productItem(i, 1, true)),
//                                   Flexible(
//                                       flex: 1,
//                                       fit: FlexFit.loose,
//                                       child: productItem(i, 2, true)),
//                                   Flexible(
//                                       flex: 1,
//                                       fit: FlexFit.loose,
//                                       child: productItem(i, 3, false)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ))
//                     : sectionList[i].style == STYLE4
//                         ? Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Flexible(
//                                     flex: 1,
//                                     fit: FlexFit.loose,
//                                     child: Container(
//                                         height: orient == Orientation.portrait
//                                             ? deviceHeight! * 0.25
//                                             : deviceHeight! * 0.5,
//                                         child: productItem(i, 0, false))),
//                                 Container(
//                                   height: orient == Orientation.portrait
//                                       ? deviceHeight! * 0.2
//                                       : deviceHeight! * 0.5,
//                                   child: Row(
//                                     children: [
//                                       Flexible(
//                                           flex: 1,
//                                           fit: FlexFit.loose,
//                                           child: productItem(i, 1, true)),
//                                       Flexible(
//                                           flex: 1,
//                                           fit: FlexFit.loose,
//                                           child: productItem(i, 2, false)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))
//                         : Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: GridView.count(
//                                 padding: EdgeInsetsDirectional.only(top: 5),
//                                 crossAxisCount: 2,
//                                 shrinkWrap: true,
//                                 childAspectRatio: 1.2,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 mainAxisSpacing: 10,
//                                 crossAxisSpacing: 0,
//                                 children: List.generate(
//                                   sectionList[i].productList!.length < 6
//                                       ? sectionList[i].productList!.length
//                                       : 6,
//                                   (index) {
//                                     return productItem(i, index,
//                                         index % 2 == 0 ? true : false);
//                                   },
//                                 )
//                             ));
//   }
//
//   Widget productItem(int secPos, int index, bool pad) {
//     if (sectionList[secPos].productList!.length > index) {
//       String? offPer;
//       double price = double.parse(
//           sectionList[secPos].productList![index].prVarientList![0].disPrice!);
//       if (price == 0) {
//         price = double.parse(
//             sectionList[secPos].productList![index].prVarientList![0].price!);
//       } else {
//         double off = double.parse(sectionList[secPos]
//                 .productList![index]
//                 .prVarientList![0]
//                 .price!) -
//             price;
//         offPer = ((off * 100) /
//                 double.parse(sectionList[secPos]
//                     .productList![index]
//                     .prVarientList![0]
//                     .price!))
//             .toStringAsFixed(2);
//       }
//
//       double width = deviceWidth! * 0.5;
//
//       return Card(
//         elevation: 3.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10)
//         ),
//
//         margin: EdgeInsetsDirectional.only(bottom: 2, end: 2,top: 5,),
//         //end: pad ? 5 : 0),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(4),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Expanded(
//                 /*       child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(5),
//                         topRight: Radius.circular(5)),
//                     child: Hero(
//                       tag:
//                       "${sectionList[secPos].productList![index].id}$secPos$index",
//                       child: FadeInImage(
//                         fadeInDuration: Duration(milliseconds: 150),
//                         image: NetworkImage(
//                             sectionList[secPos].productList![index].image!),
//                         height: double.maxFinite,
//                         width: double.maxFinite,
//                         fit: extendImg ? BoxFit.fill : BoxFit.contain,
//                         imageErrorBuilder: (context, error, stackTrace) =>
//                             erroWidget(width),
//
//                         // errorWidget: (context, url, e) => placeHolder(width),
//                         placeholder: placeHolder(width),
//                       ),
//                     )),*/
//                 child: Stack(
//                   // alignment: Alignment.topRight,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                       child: Hero(
//                        // transitionOnUserGestures: true,
//                         tag:
//                             "${sectionList[secPos].productList![index].id}$secPos$index",
//                         child: Container(
//                           height: 170,
//                           child: FadeInImage(
//                             fadeInDuration: Duration(milliseconds: 150),
//                             image: CachedNetworkImageProvider(
//                                 sectionList[secPos].productList![index].image!),
//                             height: double.maxFinite,
//                             width: double.maxFinite,
//                             imageErrorBuilder: (context, error, stackTrace) =>
//                                 erroWidget(double.maxFinite),
//                                 fit: BoxFit.fill,
//                             placeholder: placeHolder(width),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8,top: 4),
//                 child: Text(
//                   sectionList[secPos].productList![index].name!,
//                   style: Theme.of(context).textTheme.caption!.copyWith(
//                       color: Theme.of(context).colorScheme.secondary,fontSize:15,fontWeight: FontWeight.bold),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.only(top: 10,left: 8),
//               //   child: Text("PeckSize: ${sectionList[secPos].productList![index].prVarientList![0].weight}"
//               //       " ${sectionList[secPos].productList![index].prVarientList![0].unittext!}"
//               //     ,style: TextStyle(fontWeight: FontWeight.normal,color: colors.blackTemp),),
//               // ),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child:Row(
//                   children: [
//                     Text("Price: ${CUR_CURRENCY}  ${price} /"),
//                     Container(
//                       width: 50,
//                         child: Text(sectionList[secPos].productList![index].prVarientList![0].weight == "1" ?  "${sectionList[secPos].productList![index].prVarientList![0].unittext.toString()}" :  sectionList[secPos].productList![index].prVarientList![0].weight.toString() + " " + sectionList[secPos].productList![index].prVarientList![0].unittext.toString(),overflow: TextOverflow.ellipsis, ))
//                   ],
//                 ),
//                 // Text(
//                 //   // "Price: ${CUR_CURRENCY! + "" +price.toString()} /${sectionList[secPos].productList![index].prVarientList![0].weight}  ${sectionList[secPos].productList![index].prVarientList![0].unittext!}",
//                 //  //"Price: ${CUR_CURRENCY! + "" +price.toString()} /${sectionList[secPos].productList![index].prVarientList![0].weight}  ${sectionList[secPos].productList![index].prVarientList![0].unittext!}",
//                 //      "Price:" + "${CUR_CURRENCY! +  "" + price.toString()}"  +  "/" +  sectionList[secPos].productList![index].prVarientList![0].weight.toString()  == "1" ? "" : sectionList[secPos].productList![index].prVarientList![0].weight.toString() + sectionList[secPos].productList![index].prVarientList![0].unittext.toString()  ,
//                 //   style: TextStyle(
//                 //     color: Theme.of(context).colorScheme.black,
//                 //     fontWeight: FontWeight.bold,
//                 //     fontSize: 14
//                 //   ),
//                 // ),
//               ),
//               // Positioned.directional(
//               //   textDirection: Directionality.of(context),
//               //   bottom: 5,
//               //   end: 45,
//               //   // child: InkWell(
//               //   //   onTap: () {
//               //   //     if (_isProgress == false)
//               //   //       addToCart(
//               //   //           index,
//               //   //           (int.parse(_controller[index].text) +
//               //   //               int.parse(model.qtyStepSize!))
//               //   //               .toString());
//               //   //   },
//               //   child: Card(
//               //     elevation: 1,
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(50),
//               //     ),
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(8.0),
//               //       child: Icon(
//               //         Icons.shopping_cart_outlined,
//               //         size: 20,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // Padding(
//               //   padding: const EdgeInsetsDirectional.only(
//               //       start: 8.0, bottom: 5, top: 0,),
//               //   child: double.parse(sectionList[secPos]
//               //               .productList![index]
//               //               .prVarientList![0]
//               //               .disPrice!) !=
//               //           0
//               //       ? Row(
//               //           children: <Widget>[
//               //             Text(
//               //               double.parse(sectionList[secPos].productList![index].prVarientList![0].disPrice!) !=
//               //                       0
//               //                   ?  "MRP:" + CUR_CURRENCY! +
//               //                       " " +
//               //                       sectionList[secPos]
//               //                           .productList![index]
//               //                           .prVarientList![0]
//               //                           .price!
//               //                   : "",
//               //               style: Theme.of(context)
//               //                   .textTheme
//               //                   .overline!
//               //                   .copyWith(
//               //                       decoration: TextDecoration.lineThrough,
//               //                       letterSpacing: 0,
//               //                 fontSize: 15,
//               //                 fontWeight: FontWeight.normal,
//               //                 color: colors.blackTemp.withOpacity(0.2)
//               //               ),
//               //             ),
//               //
//               //             // Flexible(
//               //             //   child: Text(" | " + "$offPer%",
//               //             //       maxLines: 1,
//               //             //       overflow: TextOverflow.ellipsis,
//               //             //       style: Theme.of(context)
//               //             //           .textTheme
//               //             //           .overline!
//               //             //           .copyWith(
//               //             //               color: colors.primary,
//               //             //               letterSpacing: 0,
//               //             //         fontSize: 15,
//               //             //         fontWeight: FontWeight.bold
//               //             //       )),
//               //             // ),
//               //           ],
//               //         )
//               //       : Container(
//               //           height: 5,
//               //         ),
//               // )
//             ],
//           ),
//           onTap: () {
//             Product model = sectionList[secPos].productList![index];
//             Navigator.push(
//               context,
//               PageRouteBuilder(
//                 // transitionDuration: Duration(milliseconds: 150),
//                 pageBuilder: (_, __, ___) => ProductDetail(
//                     model: model, secPos: secPos, index: index, list: false
//                     //  title: sectionList[secPos].title,
//                     ),
//               ),
//             );
//           },
//         ),
//       );
//     } else
//       return Container();
//   }
//
//   PrimeProductModel? PrimeModel;
//   getPrimeProduct() async {
//     var headers = {
//       'Cookie': 'ci_session=1cf2fc55e4f5c88fe4595b902af453a1fbdf50ce'
//     };
//     var request = http.Request('POST', Uri.parse('$baseUrl/get_prime_products'));
//     print("prim api here ${baseUrl}/get_prime_products");
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       var Result = await response.stream.bytesToString();
//       final FinalResult = PrimeProductModel.fromJson(jsonDecode(Result));
//       print("New+++++++++++++++++++++++${FinalResult.toString()}");
//       setState(() {
//         PrimeModel = FinalResult;
//       });
//     }
//     else {
//     print(response.reasonPhrase);
//     }
//
//   }
//   // primeProduct(){
//   //   return Padding(
//   //     padding: const EdgeInsets.all(6.0),
//   //     child: Container(
//   //       height: MediaQuery.of(context).size.height/3.1,
//   //       child:PrimeModel == null?Center(child: Text("lodding....")): ListView.builder(
//   //           scrollDirection: Axis.horizontal,
//   //           shrinkWrap: true,
//   //         physics:ScrollPhysics(),
//   //           itemCount: PrimeModel!.data!.length,
//   //         itemBuilder: (context, i) {
//   //           print("here");
//   //           return InkWell(
//   //             // onTap: (){
//   //             //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(
//   //             //      secPos: 0, index: 0, list: true)
//   //             //   )
//   //             //   );
//   //             // },
//   //             child: Card(
//   //               shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.circular(12)
//   //               ),
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Container(
//   //                     decoration: BoxDecoration(
//   //                       borderRadius: BorderRadius.all(Radius.circular(10))
//   //                     ),
//   //                       height: 120,
//   //                       width: 160,
//   //                       child: ClipRRect(
//   //                         borderRadius: BorderRadius.circular(10),
//   //                           child:PrimeModel!.data![i].image == null || PrimeModel!.data![i].image ==""?
//   //                           Image.asset("assets/images/placeholder.png"):
//   //                           Image.network("${PrimeModel!.data![i].image}",fit: BoxFit.fill,))),
//   //                           SizedBox(height: 3,),
//   //                   Padding(
//   //                     padding: const EdgeInsets.all(8.0),
//   //                     child: Column(
//   //                       crossAxisAlignment: CrossAxisAlignment.start,
//   //                       children: [
//   //                         Text("${PrimeModel!.data![i].name}",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold),),
//   //                         SizedBox(height: 5,),
//   //                         Text("Size: ${PrimeModel!.data![i].variants![0].weight} ${PrimeModel!.data![i].variants![0].unitText}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.normal),),
//   //                         SizedBox(height: 3,),
//   //                         Text("Offer Price: $CUR_CURRENCY ${PrimeModel!.data![i].variants![0].specialPrice}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
//   //                         SizedBox(height: 3,),
//   //                         Text("MRP:$CUR_CURRENCY ${PrimeModel!.data![i].variants![0].price}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.normal),)
//   //                       ],
//   //                     ),
//   //                   )
//   //
//   //                 ],
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //
//   //       ),
//   //     ),
//   //   );
//   // }
//   _section() {
//     return Selector<HomeProvider, bool>(
//       builder: (context, data, child) {
//         return data
//             ? Container(
//                 width: double.infinity,
//                 child: Shimmer.fromColors(
//                   baseColor: Theme.of(context).colorScheme.simmerBase,
//                   highlightColor: Theme.of(context).colorScheme.simmerHigh,
//                   child: sectionLoading(),
//                 ),
//               )
//             : ListView.builder(
//                 padding: EdgeInsets.all(0),
//                 itemCount: sectionList.length,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   print("here");
//                   return _singleSection(index);
//                 },
//               );
//       },
//       selector: (_, homeProvider) => homeProvider.secLoading,
//     );
//   }
//    searchBar(){
//     return  Padding(
//       padding: const EdgeInsets.only(left: 10,right: 10),
//       child: InkWell(
//         onTap: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
//         },
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0,right: 8),
//           child: Container(
//             height: 40,
//             decoration: BoxDecoration(
//                 color: colors.whiteTemp,
//                 borderRadius: BorderRadius.circular(8.0)
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Row(
//                 children: [
//                   Icon(Icons.search,color: colors.blackTemp.withOpacity(0.2),),
//                   Text("Search...",style: TextStyle(color: colors.blackTemp.withOpacity(0.2)),)
//                 ],
//               ),
//             )
//
//             // TextField(
//             //    controller: controllerfield,
//             //   autofocus: true,
//             //  // readOnly: true,
//             //   style: TextStyle(
//             //       color: Theme.of(context).colorScheme.fontColor,
//             //       fontWeight: FontWeight.bold),
//             //   decoration: InputDecoration(
//             //     contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//             //     // contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
//             //     hintText: getTranslated(context, 'SEARCH_LBL'),
//             //     //: Icon(Icons.document_scanner_outlined,color: colors.primary,),
//             //     prefixIcon: Icon(Icons.search,color: colors.blackTemp.withOpacity(0.2)),
//             //     hintStyle: TextStyle(color: colors.blackTemp.withOpacity(0.2)
//             //     ),
//             //     enabledBorder: UnderlineInputBorder(
//             //       borderSide:
//             //       BorderSide(color: Theme.of(context).colorScheme.white),
//             //     ),
//             //     focusedBorder: UnderlineInputBorder(
//             //       borderSide:
//             //       BorderSide(color: Theme.of(context).colorScheme.white),
//             //     ),
//             //   ),
//             //   // onChanged: (query) => updateSearchQuery(query),
//             // ),
//           ),
//         ),
//       ),
//     );
//    }
//   _catList() {
//     return Selector<HomeProvider, bool>(
//       builder: (context, data, child) {
//         return data
//             ? Container(
//                 width: double.infinity,
//                 child: Shimmer.fromColors(
//                     baseColor: Theme.of(context).colorScheme.simmerBase,
//                     highlightColor: Theme.of(context).colorScheme.simmerHigh,
//                     child: catLoading()))
//             : Container(
//                 height:catList.length >3 ?250 :120,
//                 padding: const EdgeInsets.only(top: 10, left: 5,right: 5),
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   // scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 0,),
//                   itemCount:catList.length
//                     < 6 ? catList.length : 6,
//                   itemBuilder: (context, index) {
//                     if (index == 1.2)
//                       return Container();
//                     else
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 0),
//                         child: GestureDetector(
//                           onTap: () async {
//                             if (catList[index].subList == null ||
//                                 catList[index].subList!.length == 0) {
//                               await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProductList(
//                                       name: catList[index].name,
//                                       id: catList[index].id,
//                                       tag: false,
//                                       fromSeller: false,
//                                     ),
//                                   ));
//                             } else {
//                               await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => SubCategory(
//                                       title: catList[index].name!,
//                                       subList: catList[index].subList,
//                                     ),
//                                   ));
//                             }
//                           },
//                           child: Stack(
//                             // alignment: Alignment.bottomCenter,
//                               children:[
//                                 Card(
//                                elevation: 3,
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                   child: Container(
//                                     color: colors.white10,
//                                     child: Container(
//                                       height: 140,
//                                       width: double.infinity,
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             height: 85,
//                                             width: 150,
//                                             child: ClipRRect(
//                                                 borderRadius: BorderRadius.circular(25),
//                                                 child: Image.network("${catList[index].image }",fit: BoxFit.fill,)),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 0,
//                                   left: 14,
//                                   child: Container(
//                                     height: 16,
//                                     width: 91,
//                                     decoration: BoxDecoration(
//                                         color: colors.secondary,
//                                         borderRadius: BorderRadius.circular(20)
//                                     ),
//                                     // alignment: Alignment.center,
//                                     padding: EdgeInsets.only(left: 5,right:5),
//                                     child: Container(
//                                       child: Center(
//                                         child: Text(
//                                           catList[index].name!.toUpperCase(),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .caption!
//                                               .copyWith(
//                                               color: colors.lightWhite2,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 9),
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.start,
//                                           maxLines: 1,
//
//                                         ),
//
//                                       ),
//                                     ),
//
//                                   ),
//                                 ),
//
//                               ]
//                           ),
//
//
//                         ),
//
//                       );
//
//                   },
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 1.2,
//                     // crossAxisSpacing: 0.0,
//                     mainAxisExtent: 110,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 0,
//                   ),
//                 ),
//                //Listview
//
//                 // ListView.builder(
//                 //   itemCount: catList.length < 5 ? catList.length : 5,
//                 //   scrollDirection: Axis.horizontal,
//                 //   shrinkWrap: true,
//                 //   physics: AlwaysScrollableScrollPhysics(),
//                 //   itemBuilder: (context, index) {
//                 //     if (index == 0)
//                 //       return Container();
//                 //     else
//                 //       return Padding(
//                 //         padding: const EdgeInsets.symmetric(horizontal: 10),
//                 //         child: GestureDetector(
//                 //           onTap: () async {
//                 //             if (catList[index].subList == null ||
//                 //                 catList[index].subList!.length == 0) {
//                 //               await Navigator.push(
//                 //                   context,
//                 //                   MaterialPageRoute(
//                 //                     builder: (context) => ProductList(
//                 //                       name: catList[index].name,
//                 //                       id: catList[index].id,
//                 //                       tag: false,
//                 //                       fromSeller: false,
//                 //                     ),
//                 //                   ));
//                 //             } else {
//                 //               await Navigator.push(
//                 //                   context,
//                 //                   MaterialPageRoute(
//                 //                     builder: (context) => SubCategory(
//                 //                       title: catList[index].name!,
//                 //                       subList: catList[index].subList,
//                 //                     ),
//                 //                   ));
//                 //             }
//                 //           },
//                 //           child: Stack(
//                 //             // alignment: Alignment.bottomCenter,
//                 //             children:[
//                 //               Card(
//                 //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 //                 child: Container(
//                 //                   child: Container(
//                 //                     width: 130,
//                 //                     child: Column(
//                 //                       children: [
//                 //                         Container(
//                 //                         height: 90,
//                 //                         width: double.infinity,
//                 //                         child: ClipRRect(
//                 //                           borderRadius: BorderRadius.circular(15),
//                 //                             child: Image.network("${catList[index].image }",fit: BoxFit.fill,)),
//                 //                         ),
//                 //                       ],
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //               Positioned(
//                 //                 bottom: 0,
//                 //                 left: 15,
//                 //                 child: Container(
//                 //                   height: 20,
//                 //                   width: 110,
//                 //                   decoration: BoxDecoration(
//                 //                       color: colors.secondary,
//                 //                       borderRadius: BorderRadius.circular(20)
//                 //                   ),
//                 //                   // alignment: Alignment.center,
//                 //                    padding: EdgeInsets.only(left: 10,right: 10),
//                 //                   child: Container(
//                 //                     width: 10,
//                 //                     child: Center(
//                 //                       child: Text(
//                 //                         catList[index].name!.toUpperCase(),
//                 //                         style: Theme.of(context)
//                 //                             .textTheme
//                 //                             .caption!
//                 //                             .copyWith(
//                 //                             color: colors.lightWhite2,
//                 //                             fontWeight: FontWeight.w600,
//                 //                             fontSize: 11),
//                 //                         overflow: TextOverflow.ellipsis,
//                 //                         textAlign: TextAlign.start,
//                 //                         maxLines: 1,
//                 //
//                 //                       ),
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ]
//                 //           ),
//                 //         ),
//                 //       );
//                 //   },
//                 // ),
//               );
//       },
//       selector: (_, homeProvider) => homeProvider.catLoading,
//     );
//   }
//
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//
//     return result;
//   }
//
//   Future<Null> callApi() async {
//     UserProvider user = Provider.of<UserProvider>(context, listen: false);
//     SettingProvider setting =
//     Provider.of<SettingProvider>(context, listen: false);
//     user.setUserId(setting.userId);
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       getSetting();
//       getSlider();
//       getState();
//       getCat();
//       getSeller();
//       getSection();
//       getOfferImages();
//
//     } else {
//       if (mounted)
//         setState(() {
//           _isNetworkAvail = false;
//         });
//     }
//     return null;
//   }
//
//   Future _getFav() async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       if (CUR_USERID != null) {
//         Map parameter = {
//           USER_ID: CUR_USERID,
//         };
//         apiBaseHelper.postAPICall(getFavApi, parameter).then((getdata) {
//           bool error = getdata["error"];
//           String? msg = getdata["message"];
//           if (!error) {
//             var data = getdata["data"];
//
//             List<Product> tempList = (data as List)
//                 .map((data) => new Product.fromJson(data))
//                 .toList();
//
//             context.read<FavoriteProvider>().setFavlist(tempList);
//           } else {
//             if (msg != 'No Favourite(s) Product Are Added')
//               setSnackbar(msg!, context);
//           }
//
//           context.read<FavoriteProvider>().setLoading(false);
//         }, onError: (error) {
//           setSnackbar(error.toString(), context);
//           context.read<FavoriteProvider>().setLoading(false);
//         });
//       } else {
//         context.read<FavoriteProvider>().setLoading(false);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Login()),
//         );
//       }
//     } else {
//       if (mounted)
//         setState(() {
//           _isNetworkAvail = false;
//         });
//     }
//   }
//
//   void getOfferImages() {
//     Map parameter = Map();
//
//     apiBaseHelper.postAPICall(getOfferImageApi, parameter).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       print(getOfferImageApi.toString());
//       print(parameter.toString());
//       if (!error) {
//         var data = getdata["data"];
//         offerImages.clear();
//         offerImages =
//             (data as List).map((data) => new Model.fromSlider(data)).toList();
//       } else {
//         setSnackbar(msg!, context);
//       }
//
//       context.read<HomeProvider>().setOfferLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setOfferLoading(false);
//     });
//   }
//   // playviedo(){
//   //         return InkWell(
//   //           onTap: () {
//   //             Navigator.push(
//   //                 context, MaterialPageRoute(builder: (context) => VideoPlay()));
//   //
//   //           },
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(8.0),
//   //             child: Container(
//   //               height: 45
//   //                 ,
//   //               width: MediaQuery.of(context).size.width,
//   //     decoration: BoxDecoration(
//   //       color: colors.primary,
//   //       borderRadius: BorderRadius.circular(10.0)
//   //     ),
//   //     child: Center(child: Text("FEED MART TV",style: TextStyle(color: colors.secondary),))
//   //   ),
//   //           ),
//   //         );
//   // }
//   void getSection() {
//     String? stateid =  prefs!.getString('stateId');
//     // Map parameter = {PRODUCT_LIMIT: "5", PRODUCT_OFFSET: "6"};
//     Map parameter = {PRODUCT_LIMIT: "5",'state_id':'${stateid}','product_type':'prime_products'
//     };
//     if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID!;
//     String curPin = context.read<UserProvider>().curPincode;
//     if (curPin != '') parameter[ZIPCODE] = curPin;
//
//     apiBaseHelper.postAPICall(getSectionApi, parameter).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       print("section api ${getSectionApi}");
//       print("section para ${parameter}");
//       print("Get Section Data---------: $getdata");
//       sectionList.clear();
//       if (!error) {
//         var data = getdata["data"];
//         print("Get Section Data2: $data");
//         sectionList = (data as List)
//             .map((data) => new SectionModel.fromJson(data))
//             .toList();
//       } else {
//         if (curPin != '') context.read<UserProvider>().setPincode('');
//         setSnackbar(msg!, context);
//         print("Get Section Error Msg: $msg");
//       }
//       context.read<HomeProvider>().setSecLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setSecLoading(false);
//     });
//   }
//   void getSetting() {
//     CUR_USERID = context.read<SettingProvider>().userId;
//     //print("")
//     Map parameter = Map();
//     if (CUR_USERID != null) parameter = {USER_ID: CUR_USERID};
//
//     apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//
//       if (!error) {
//         var data = getdata["data"]["system_settings"][0];
//         cartBtnList = data["cart_btn_on_list"] == "1" ? true : false;
//         refer = data["is_refer_earn_on"] == "1" ? true : false;
//         CUR_CURRENCY = data["currency"];
//         RETURN_DAYS = data['max_product_return_days'];
//         MAX_ITEMS = data["max_items_cart"];
//         MIN_AMT = data['min_amount'];
//         CUR_DEL_CHR = data['delivery_charge'];
//         String? isVerion = data['is_version_system_on'];
//         extendImg = data["expand_product_images"] == "1" ? true : false;
//         String? del = data["area_wise_delivery_charge"];
//         MIN_ALLOW_CART_AMT = data[MIN_CART_AMT];
//
//         if (del == "0")
//           ISFLAT_DEL = true;
//         else
//           ISFLAT_DEL = false;
//
//         if (CUR_USERID != null) {
//           REFER_CODE = getdata['data']['user_data'][0]['referral_code'];
//
//           context
//               .read<UserProvider>()
//               .setPincode(getdata["data"]["user_data"][0][PINCODE]);
//
//           if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
//             generateReferral();
//
//           context.read<UserProvider>().setCartCount(
//               getdata["data"]["user_data"][0]["cart_total_items"].toString());
//           context
//               .read<UserProvider>()
//               .setBalance(getdata["data"]["user_data"][0]["balance"]);
//
//           _getFav();
//           _getCart("0");
//         }
//
//         UserProvider user = Provider.of<UserProvider>(context, listen: false);
//         SettingProvider setting =
//             Provider.of<SettingProvider>(context, listen: false);
//         user.setMobile(setting.mobile);
//         user.setName(setting.userName);
//         user.setEmail(setting.email);
//         user.setProfilePic(setting.profileUrl);
//
//         Map<String, dynamic> tempData = getdata["data"];
//         if (tempData.containsKey(TAG))
//           tagList = List<String>.from(getdata["data"][TAG]);
//
//         if (isVerion == "1") {
//           String? verionAnd = data['current_version'];
//           String? verionIOS = data['current_version_ios'];
//
//           PackageInfo packageInfo = await PackageInfo.fromPlatform();
//
//           String version = packageInfo.version;
//
//           final Version currentVersion = Version.parse(version);
//           final Version latestVersionAnd = Version.parse(verionAnd);
//           final Version latestVersionIos = Version.parse(verionIOS);
//
//           if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
//               (Platform.isIOS && latestVersionIos > currentVersion))
//             updateDailog();
//         }
//       } else {
//         setSnackbar(msg!, context);
//       }
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//     });
//   }
//
//   Future<void> _getCart(String save) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? stateid = prefs.getString('stateId');
//     if (_isNetworkAvail) {
//       try {
//         var parameter = {USER_ID: CUR_USERID, SAVE_LATER: save,'state_id':'${stateid}'};
//
//         Response response =
//             await post(getCartApi, body: parameter, headers: headers)
//                 .timeout(Duration(seconds: timeOut));
//
//         var getdata = json.decode(response.body);
//         bool error = getdata["error"];
//         String? msg = getdata["message"];
//         if (!error) {
//           var data = getdata["data"];
//
//           List<SectionModel> cartList = (data as List)
//               .map((data) => new SectionModel.fromCart(data))
//               .toList();
//           context.read<CartProvider>().setCartlist(cartList);
//         }
//       } on TimeoutException catch (_) {}
//     } else {
//       if (mounted)
//         setState(() {
//           _isNetworkAvail = false;
//         });
//     }
//   }
//   final _chars =
//       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   Random _rnd = Random();
//
//   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//
//   Future<Null> generateReferral() async {
//     String refer = getRandomString(8);
//
//     Map parameter = {
//       REFERCODE: refer,
//     };
//     apiBaseHelper.postAPICall(validateReferalApi, parameter).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       if (!error) {
//         REFER_CODE = refer;
//         Map parameter = {
//           USER_ID: CUR_USERID,
//           REFERCODE: refer,
//         };
//         apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
//       } else {
//         if (count < 5) generateReferral();
//         count++;
//       }
//
//       context.read<HomeProvider>().setSecLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setSecLoading(false);
//     });
//   }
//   updateDailog() async {
//     await dialogAnimate(context,
//         StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(5.0))),
//         title: Text(getTranslated(context, 'UPDATE_APP')!),
//         content: Text(
//           getTranslated(context, 'UPDATE_AVAIL')!,
//           style: Theme.of(this.context)
//               .textTheme
//               .subtitle1!
//               .copyWith(color: Theme.of(context).colorScheme.fontColor),
//         ),
//         actions: <Widget>[
//           new TextButton(
//               child: Text(
//                 getTranslated(context, 'NO')!,
//                 style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
//                     color: Theme.of(context).colorScheme.lightBlack,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               }),
//           new TextButton(
//               child: Text(
//                 getTranslated(context, 'YES')!,
//                 style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
//                     color: Theme.of(context).colorScheme.fontColor,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () async {
//                 Navigator.of(context).pop(false);
//
//                 String _url = '';
//                 if (Platform.isAndroid) {
//                   _url = androidLink + packageName;
//                 } else if (Platform.isIOS) {
//                   _url = iosLink;
//                 }
//
//                 if (await canLaunch(_url)) {
//                   await launch(_url);
//                 } else {
//                   throw 'Could not launch $_url';
//                 }
//               })
//         ],
//       );
//     }));
//   }
//
//   Widget homeShimmer() {
//     return Container(
//       width: double.infinity,
//       child: Shimmer.fromColors(
//         baseColor: Theme.of(context).colorScheme.simmerBase,
//         highlightColor: Theme.of(context).colorScheme.simmerHigh,
//         child: SingleChildScrollView(
//             child: Column(
//           children: [
//             catLoading(),
//             sliderLoading(),
//             sectionLoading(),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget sliderLoading() {
//     double width = deviceWidth!;
//     double height = width / 2;
//     return Shimmer.fromColors(
//         baseColor: Theme.of(context).colorScheme.simmerBase,
//         highlightColor: Theme.of(context).colorScheme.simmerHigh,
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 10),
//           width: double.infinity,
//           height: height,
//           color: Theme.of(context).colorScheme.white,
//         ));
//   }
//
//   Widget _buildImagePageItem(Model slider) {
//     double height = deviceWidth! / 0.5;
//
//     return GestureDetector(
//       child: FadeInImage(
//           fadeInDuration: Duration(milliseconds: 12),
//           image: CachedNetworkImageProvider(slider.image!),
//           height: height,
//           width: double.maxFinite,
//           fit: BoxFit.contain,
//           imageErrorBuilder: (context, error, stackTrace) => Image.asset(
//                 "assets/images/sliderph.png",
//             fit: BoxFit.contain,
//                 height: height,
//                 color: colors.primary,
//               ),
//           placeholderErrorBuilder: (context, error, stackTrace) =>
//               Image.asset(
//                 "assets/images/sliderph.png",
//                 fit: BoxFit.contain,
//                 height: height,
//                 color: colors.primary,
//               ),
//           placeholder: AssetImage(imagePath + "sliderph.png")),
//       onTap: () async {
//         int curSlider = context.read<HomeProvider>().curSlider;
//
//         if (homeSliderList[curSlider].type == "products") {
//           Product? item = homeSliderList[curSlider].list;
//
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => ProductDetail(
//                     model: item, secPos: 0, index: 0, list: true)),
//           );
//         } else if (homeSliderList[curSlider].type == "categories") {
//           Product item = homeSliderList[curSlider].list;
//           if (item.subList == null || item.subList!.length == 0) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductList(
//                     name: item.name,
//                     id: item.id,
//                     tag: false,
//                     fromSeller: false,
//                   ),
//                 ));
//           } else {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubCategory(
//                     title: item.name!,
//                     subList: item.subList,
//                   ),
//                 ));
//           }
//         }
//       },
//     );
//   }
//
//   Widget deliverLoading() {
//     return Shimmer.fromColors(
//         baseColor: Theme.of(context).colorScheme.simmerBase,
//         highlightColor: Theme.of(context).colorScheme.simmerHigh,
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//           width: double.infinity,
//           height: 18.0,
//           color: Theme.of(context).colorScheme.white,
//         ));
//   }
//
//   Widget catLoading() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//                 children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
//                     .map((_) => Container(
//                           margin: EdgeInsets.symmetric(horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.white,
//                             shape: BoxShape.circle,
//                           ),
//                           width: 50.0,
//                           height: 50.0,
//                         ))
//                     .toList()),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//           width: double.infinity,
//           height: 18.0,
//           color: Theme.of(context).colorScheme.white,
//         ),
//       ],
//     );
//   }
//
//   Widget noInternet(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           noIntImage(),
//           noIntText(context),
//           noIntDec(context),
//           AppBtn(
//             title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
//             btnAnim: buttonSqueezeanimation,
//             btnCntrl: buttonController,
//             onBtnSelected: () async {
//               context.read<HomeProvider>().setCatLoading(true);
//               context.read<HomeProvider>().setSecLoading(true);
//               context.read<HomeProvider>().setSliderLoading(true);
//               _playAnimation();
//
//               Future.delayed(Duration(seconds: 2)).then((_) async {
//                 _isNetworkAvail = await isNetworkAvailable();
//                 if (_isNetworkAvail) {
//                   if (mounted)
//                     setState(() {
//                       _isNetworkAvail = true;
//                     });
//                   callApi();
//                 } else {
//                   await buttonController.reverse();
//                   if (mounted) setState(() {});
//                 }
//               });
//             },
//           )
//         ]),
//       ),
//     );
//   }
//
//   // SearchTab(){
//   //   TextField(
//   //     decoration: InputDecoration(
//   //         prefixIcon: const Icon(Icons.search),
//   //         suffixIcon: IconButton(
//   //           icon: const Icon(Icons.clear),
//   //           onPressed: () {
//   //             /* Clear the search field */
//   //           },
//   //         ),
//   //         hintText: 'Search...',
//   //         border: InputBorder.none),
//   //   );
//   // }
//   // New() {
//   //   // String curpin = context.read<UserProvider>().curPincode;
//   //   return GestureDetector(
//   //     child: InkWell(
//   //
//   //       child: TextField(
//   //         decoration: InputDecoration(
//   //             prefixIcon: const Icon(Icons.search),
//   //             border: InputBorder.none),
//   //       ),
//   //     ),
//   //       // child: ListTile(
//   //       //   dense: true,
//   //       //   minLeadingWidth: 10,
//   //       //   leading: Icon(
//   //       //     Icons.search,
//   //       //   ),
//   //       //   title: Selector<UserProvider, String>(
//   //       //     builder: (context, data, child) {
//   //       //       return Text(
//   //       //         data == ''
//   //       //             ? getTranslated(context, 'SELOC')!
//   //       //             : getTranslated(context, 'DELIVERTO')! + data,
//   //       //         style:
//   //       //             TextStyle(color: Theme.of(context).colorScheme.fontColor),
//   //       //       );
//   //       //     },
//   //       //     selector: (_, provider) => provider.curPincode,
//   //       //   ),
//   //       //   trailing: Icon(Icons.keyboard_arrow_right),
//   //       // ),
//   //
//   //     // onTap: Search()
//   //   );
//   // }
//
//   // void _pincodeCheck() {
//   //   showModalBottomSheet<dynamic>(
//   //       context: context,
//   //       isScrollControlled: true,
//   //       shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.only(
//   //               topLeft: Radius.circular(25), topRight: Radius.circular(25))),
//   //       builder: (builder) {
//   //         return StatefulBuilder(
//   //             builder: (BuildContext context, StateSetter setState) {
//   //           return Container(
//   //             constraints: BoxConstraints(
//   //                 maxHeight: MediaQuery.of(context).size.height * 0.9),
//   //             child: ListView(shrinkWrap: true, children: [
//   //               Padding(
//   //                   padding: const EdgeInsets.only(
//   //                       left: 20.0, right: 20, bottom: 40, top: 30),
//   //                   child: Padding(
//   //                     padding: EdgeInsets.only(
//   //                         bottom: MediaQuery.of(context).viewInsets.bottom),
//   //                     child: Form(
//   //                         key: _formkey,
//   //                         child: Column(
//   //                           mainAxisSize: MainAxisSize.min,
//   //                           crossAxisAlignment: CrossAxisAlignment.start,
//   //                           children: [
//   //                             Align(
//   //                               alignment: Alignment.topRight,
//   //                               child: InkWell(
//   //                                 onTap: () {
//   //                                   Navigator.pop(context);
//   //                                 },
//   //                                 child: Icon(Icons.close),
//   //                               ),
//   //                             ),
//   //                             TextFormField(
//   //                               keyboardType: TextInputType.text,
//   //                               textCapitalization: TextCapitalization.words,
//   //                               validator: (val) => validatePincode(val!,
//   //                                   getTranslated(context, 'PIN_REQUIRED')),
//   //                               onSaved: (String? value) {
//   //                                 context
//   //                                     .read<UserProvider>()
//   //                                     .setPincode(value!);
//   //                               },
//   //                               style: Theme.of(context)
//   //                                   .textTheme
//   //                                   .subtitle2!
//   //                                   .copyWith(
//   //                                       color: Theme.of(context)
//   //                                           .colorScheme
//   //                                           .fontColor),
//   //                               decoration: InputDecoration(
//   //                                 isDense: true,
//   //                                 prefixIcon: Icon(Icons.location_on),
//   //                                 hintText:
//   //                                     getTranslated(context, 'PINCODEHINT_LBL'),
//   //                               ),
//   //                             ),
//   //                             Padding(
//   //                               padding: const EdgeInsets.only(top: 8.0),
//   //                               child: Row(
//   //                                 children: [
//   //                                   Container(
//   //                                     margin:
//   //                                         EdgeInsetsDirectional.only(start: 20),
//   //                                     width: deviceWidth! * 0.35,
//   //                                     child: OutlinedButton(
//   //                                       onPressed: () {
//   //                                         context
//   //                                             .read<UserProvider>()
//   //                                             .setPincode('');
//   //
//   //                                         context
//   //                                             .read<HomeProvider>()
//   //                                             .setSecLoading(true);
//   //                                         getSection();
//   //                                         Navigator.pop(context);
//   //                                       },
//   //                                       child: Text(
//   //                                           getTranslated(context, 'All')!),
//   //                                     ),
//   //                                   ),
//   //                                   Spacer(),
//   //                                   SimBtn(
//   //                                       size: 0.35,
//   //                                       title: getTranslated(context, 'APPLY'),
//   //                                       onBtnSelected: () async {
//   //                                         if (validateAndSave()) {
//   //                                           // validatePin(curPin);
//   //                                           context
//   //                                               .read<HomeProvider>()
//   //                                               .setSecLoading(true);
//   //                                           getSection();
//   //
//   //                                           context
//   //                                               .read<HomeProvider>()
//   //                                               .setSellerLoading(true);
//   //                                           sellerList.clear();
//   //                                           getSeller();
//   //                                           Navigator.pop(context);
//   //                                         }
//   //                                       }),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                           ],
//   //                         )),
//   //                   ))
//   //             ]),
//   //           );
//   //           //});
//   //         });
//   //       });
//   // }
//
//   bool validateAndSave() {
//     final form = _formkey.currentState!;
//
//     form.save();
//     if (form.validate()) {
//       return true;
//     }
//     return false;
//   }
//
//   Future<Null> _playAnimation() async {
//     try {
//       await buttonController.forward();
//     } on TickerCanceled {}
//   }
//
//   void getSlider() {
//     Map map = Map();
//
//     apiBaseHelper.postAPICall(getSliderApi, map).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       if (!error) {
//         var data = getdata["data"];
//
//         homeSliderList =
//             (data as List).map((data) => new Model.fromSlider(data)).toList();
//
//         pages = homeSliderList.map((slider) {
//           return _buildImagePageItem(slider);
//         }).toList();
//       } else {
//         setSnackbar(msg!, context);
//       }
//
//       context.read<HomeProvider>().setSliderLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setSliderLoading(false);
//     });
//   }
//
//   void getCat() {
//    String? stateid =  prefs!.getString('stateId');
//     Map parameter = {
//       CAT_FILTER: "false",
//       'state_id':'${stateid}',
//     };
//     print("cat ${getCatApi}");
//     print("checking parameter here ${parameter.toString()}");
//     apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       if (!error) {
//         var data = getdata["data"];
//         catList =
//             (data as List).map((data) => new Product.fromCat(data)).toList();
//
//         if (getdata.containsKey("popular_categories")) {
//           var data = getdata["popular_categories"];
//           popularList =
//               (data as List).map((data) => new Product.fromCat(data)).toList();
//
//           if (popularList.length > 0) {
//             // Product pop =
//                 // new Product.popular("Popular", imagePath + "popular.svg");
//             // catList.insert(0, pop);
//             context.read<CategoryProvider>().setSubList(popularList);
//           }
//         }
//       } else {
//         setSnackbar(msg!, context);
//       }
//
//       context.read<HomeProvider>().setCatLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setCatLoading(false);
//     });
//   }
//
//   sectionLoading() {
//
//     return Column(
//         children: [0, 1, 2, 3, 4]
//             .map((_) => Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Container(
//                               margin: EdgeInsets.only(bottom: 40),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.white,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 5),
//                                 width: double.infinity,
//                                 height: 18.0,
//                                 color: Theme.of(context).colorScheme.white,
//                               ),
//                               GridView.count(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 10),
//                                 crossAxisCount: 2,
//                                 shrinkWrap: true,
//                                 childAspectRatio: 1.0,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 mainAxisSpacing: 5,
//                                 crossAxisSpacing: 5,
//                                 children: List.generate(
//                                   4,
//                                   (index) {
//                                     return Container(
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       color:
//                                           Theme.of(context).colorScheme.white,
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     sliderLoading()
//                     //offerImages.length > index ? _getOfferImage(index) : Container(),
//                   ],
//                 ))
//             .toList());
//   }
//
//   void getSeller() {
//     String pin = context.read<UserProvider>().curPincode;
//     String? stateid =  prefs!.getString('stateId');
//     Map parameter = {};
//     if (pin != '') {
//       parameter = {
//         ZIPCODE: pin,
//         'state_id':'${stateid}'
//       };
//     }
//     apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
//       bool error = getdata["error"];
//       String? msg = getdata["message"];
//       if (!error) {
//         var data = getdata["data"];
//         print("Seller Parameter =========> $parameter");
//         print("Seller Data=====================> : $data ");
//         sellerList = (data as List).map((data) => new Product.fromSeller(data)).toList();
//
//       } else {
//         setSnackbar(msg!, context);
//       }
//       context.read<HomeProvider>().setSellerLoading(false);
//     }, onError: (error) {
//       setSnackbar(error.toString(), context);
//       context.read<HomeProvider>().setSellerLoading(false);
//     });
//   }
//
//   _seller() {
//     return Selector<HomeProvider, bool>(
//       builder: (context, data, child) {
//         return data
//             ? Container(
//                 width: double.infinity,
//                 child: Shimmer.fromColors(
//                     baseColor: Theme.of(context).colorScheme.simmerBase,
//                     highlightColor: Theme.of(context).colorScheme.simmerHigh,
//                     child: catLoading()))
//             : Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   sellerList.isNotEmpty ? Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(getTranslated(context, 'SHOP_BY_SELLER')!,
//                             style: TextStyle(
//                                 color: Theme.of(context).colorScheme.fontColor,
//                                 fontWeight: FontWeight.bold)),
//                         GestureDetector(
//                           child: Text(getTranslated(context, 'VIEW_ALL')!),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => SellerList()));
//                           },
//                         )
//                       ],
//                     ),
//                   ) : Container(),
//                   Container(
//                     height: 100,
//                     padding: const EdgeInsets.only(top: 10, left: 10),
//                     child: ListView.builder(
//                       itemCount: sellerList.length,
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsetsDirectional.only(end: 10),
//                           child: GestureDetector(
//                             onTap: () {
//                               print(sellerList[index].open_close_status);
//                               if(sellerList[index].open_close_status == '1'){
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => SellerProfile(
//                                           sellerStoreName: sellerList[index].store_name ?? "",
//                                           sellerRating: sellerList[index]
//                                               .seller_rating ??
//                                               "",
//                                           sellerImage: sellerList[index]
//                                               .seller_profile ??
//                                               "",
//                                           sellerName:
//                                           sellerList[index].seller_name ??
//                                               "",
//                                           sellerID:
//                                           sellerList[index].seller_id,
//                                           storeDesc: sellerList[index]
//                                               .store_description,
//                                         )));
//                               } else {
//                                 showToast("Currently Store is Off");
//                               }
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsetsDirectional.only(
//                                       bottom: 5.0),
//                                   child: new ClipRRect(
//                                     borderRadius: BorderRadius.circular(25.0),
//                                     child: new FadeInImage(
//                                       fadeInDuration:
//                                           Duration(milliseconds: 150),
//                                       image: CachedNetworkImageProvider(
//                                         sellerList[index].seller_profile!,
//                                       ),
//                                       height: 50.0,
//                                       width: 50.0,
//                                       fit: BoxFit.contain,
//                                       imageErrorBuilder:
//                                           (context, error, stackTrace) =>
//                                               erroWidget(50),
//                                       placeholder: placeHolder(50),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   child: Text(
//                                     sellerList[index].seller_name!,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .caption!
//                                         .copyWith(
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .fontColor,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 10),
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   width: 50,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//       },
//       selector: (_, homeProvider) => homeProvider.sellerLoading,
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/AppBtn.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';

import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/widgets.dart';
import 'package:eshop_multivendor/Model/GetStateModel.dart';
import 'package:eshop_multivendor/Model/Model.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/FavoriteProvider.dart';
import 'package:eshop_multivendor/Provider/HomeProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Cart.dart';
import 'package:eshop_multivendor/Screen/NotificationLIst.dart';
import 'package:eshop_multivendor/Screen/OrderDetail.dart';
import 'package:eshop_multivendor/Screen/Search.dart';
import 'package:eshop_multivendor/Screen/SellerList.dart';
import 'package:eshop_multivendor/Screen/Seller_Details.dart';
import 'package:eshop_multivendor/Screen/SubCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:paytm/paytm.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:upi_pay_x/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import '../Helper/PaymentRadio.dart';
import '../Helper/Stripe_Service.dart';
import '../Helper/upi_payment.dart';
import '../Model/Order_Model.dart';
import '../Model/PrimeProductModel.dart';
import 'All_Category.dart';
import 'Login.dart';
import 'Order_Success.dart';
import 'Payment.dart';
import 'PaypalWebviewActivity.dart';
import 'ProductList.dart';
import 'Product_Detail.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<SectionModel> sectionList = [];
List<Product> catList = [];
List<Product> popularList = [];
ApiBaseHelper apiBaseHelper = ApiBaseHelper();
List<String> tagList = [];
List<Product> sellerList = [];
int count = 1;
List<Model> homeSliderList = [];
List<Widget> pages = [];
int currentindex = 0;
Razorpay? _razorpay;
StateSetter? checkoutState;

String? razorpayId,
    paystackId,
    stripeId,
    stripeSecret,
    upi,
    stripeMode = "test",
    stripeCurCode,
    stripePayId,
    paytmMerId,
    paytmMerKey;
bool payTesting = true;
bool _isCartLoad = true, _placeOrder = true;


class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {

  bool _isNetworkAvail = true;

  final _controller = PageController();


  var dCharge;
  String? overallAmount;
  String? finalAmount;


  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final TextEditingController controllerfield = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Model> offerImages = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  new GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<ScaffoldMessengerState> _checkscaffoldKey =
  new GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();



  //String? curPin;
  List<SectionModel> saveLaterList = [];
  String? msg;
  String? sellerId;
  bool _isLoading = true;
  Razorpay? _razorpay;
  TextEditingController promoC = new TextEditingController();
  TextEditingController noteC = new TextEditingController();
  StateSetter? checkoutState;
  final paystackPlugin = PaystackPlugin();
  bool deliverable = false;
  bool saveLater = false, addCart = false;
  bool isOnOff = false;
  String? totalamount;
  String? upi;
  String? remainingAmount;
  String? advanceAmount;
  String? advancePercentage;
  RadioModel? radioData;
  //List<PaymentItem> _gpaytItems = [];
  //Pay _gpayClient;

  String? finalDeliveryCharge = "0";


  var finalValues;




  final whatsapppBoxKey = GlobalKey();
  final contactBoxKey = GlobalKey();
  final cateBoxKey = GlobalKey();
  final searchBoxKey = GlobalKey();
  final youtubeBoxKey = GlobalKey();
  final facebookBoxKey = GlobalKey();
  final instaBoxKey = GlobalKey();
  final notificationBoxKey = GlobalKey();

  List <TargetFocus> targetList = [];
  List<OrderModel> orderList = [];
  bool bottomcart = true;

  @override
  bool get wantKeepAlive => true;
  SharedPreferences? prefs;
  bool isPaid = true;

  getData()async{
    prefs = await SharedPreferences.getInstance();
  }

  List<OrderModel> items = [];
  OrderModel? getOrderModel;
  Future<OrderModel?>
   getNewOrder() async {
   //  String? stateid =  prefs!.getString('stateId');
   //  var headers = {
   //    'Cookie': 'ci_session=e80168d5de4a2c1ac8d5d68142a64406f0106c4a'
   //  };
   //  var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_orders'));
   //  request.fields.addAll({
   //    'user_id': '${CUR_USERID}',
   //    'offset': ' 0',
   //     // LIMIT: perPage.toString(),
   //    'search': ' ',
   //    'state_id': '${stateid}'
   //  });
   //  print("this is order request ====>>>> ${request.fields.toString()}");
   //  request.headers.addAll(headers);
   //  http.StreamedResponse response = await request.send();
   //  print("this is status code ${response.statusCode}");
   //  if (response.statusCode == 200) {
   //    print("working okok");
   //    final result = await response.stream.bytesToString();
   //    var finalData = OrderModel.fromJson(jsonDecode(result));
   //    print("this is a ===${finalData}");
   //    // var  result = await response.stream.bytesToString();
   //    // //var r1 = json.decode(result);
   //    // // var re = r1[0]['data'];
   //    // var finalData = OrderModel.fromJson(jsonDecode(result));
   //    setState(() {
   //      getOrderModel = finalData;
   //    });
   //    print("this is model data *** ${finalData}");
   //  }
   //  else {
   //    print(response.reasonPhrase);
   // }
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        if (CUR_USERID != null) {
          var parameter = {
            USER_ID: CUR_USERID,
            OFFSET: "0",
            LIMIT: perPage.toString(),
            SEARCH: "",
          };
          print(getOrderApi);
          print(parameter);
          Response response =
          await post(getOrderApi, body: parameter, headers: headers)
              .timeout(Duration(seconds: timeOut));
          print("newwwwwwwwww=======${getOrderApi.toString()}");
          print("${parameter.toString()}");

          var getdata = json.decode(response.body);
          print(getdata);
          bool error = getdata["error"];

          if (!error) {
            // setState((){
            //   bottomcart = false;
            // });
            // total = int.parse(getdata["total"]);

            //  if ((offset) < total) {
            var data = getdata["data"];
            if (data.length != 0) {
              // List<OrderModel> items = [];
              List<OrderModel> allitems = [];

              items.addAll((data as List)
                  .map((data) => OrderModel.fromJson(data))
                  .toList());

              allitems.addAll(items);

              for (OrderModel item in items) {
                orderList.where((i) => i.id == item.id).map((obj) {
                  allitems.remove(item);
                  return obj;
                }).toList();
              }
              if (mounted) {
                setState(() {
                  orderList.addAll(allitems);
                  // setState((){
                  //  bottomcart = false;
                  // });
                });
              }
              print(orderList.length);
            }
          }
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted) {
        setState(() {
          _isNetworkAvail = false;
        });
      }
    }

    return null;
  }
  clearAll() {
    totalPrice = 0;
    oriPrice = 0;

    taxPer = 0;
    delCharge = 0;
    addressList.clear();
    // cartList.clear();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<CartProvider>().setCartlist([]);
      context.read<CartProvider>().setProgress(false);
    });

    promoAmt = 0;
    remWalBal = 0;
    usedBal = 0;
    payMethod = '';
    isPromoValid = false;
    isUseWallet = false;
    isPayLayShow = true;
    selectedMethod = null;
  }


  //
  // getNewOrder()async {
  //   print("working this here");
  //   String? stateid =  prefs!.getString('stateId');
  //   var headers = {
  //     'Cookie': 'ci_session=e885b843d898354fa771565407318527a9e301fe'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_orders'));
  //   request.fields.addAll({
  //     'user_id': '${CUR_USERID}',
  //     'offset': '  0',
  //     'limit': '  10',
  //     'search': '  ',
  //     'state_id': '${stateid}'
  //   });
  //   print("parametesrs here ${request.fields}");
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   print("checking status code heres 1111111 ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     print("second step");
  //     var finalResult = await response.stream.bytesToString();
  //     print("third step");
  //     final jsonResponse = OrderModel.fromJson(json.decode(finalResult));
  //     print("Checking final result ${jsonResponse}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  List<StateData> getStateModel = [];


  Future<void> checkFirstTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen1 = (prefs.getBool('seen1') ?? false);

    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(this.context, listen: false);
    bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    print("checking first time value sdsssdss ${isFirstTime}");
    if(_seen1 == true){
      //startTutorialMode();
    }
    else{
     // await prefs.setBool('seen', true);
      await prefs.setBool('seen1', true);
      startTutorialMode();
    }
  }


  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, checkFirstTime);
  }

  @override
  void initState() {
    super.initState();
    //getSetting();

    Future.delayed(Duration(seconds: 3),(){
      return startTime();
    });
    targetList.addAll([
      TargetFocus(keyTarget: whatsapppBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom,child: Column(
          children: [
            Text("Tap for whatsapp",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget: contactBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom,child: Column(
          children: [
            Text("Tap for contact",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:cateBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for all categories",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:searchBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for search",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:youtubeBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for youtube",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:facebookBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for facebook",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:instaBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for instagram",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
      TargetFocus(keyTarget:notificationBoxKey,contents:[
        TargetContent(
            padding: EdgeInsets.all(20),
            align: ContentAlign.bottom ,child: Column(
          children: [
            Text("Tap for notification",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ) )
      ] ),
    ]);
    Future.delayed(Duration(milliseconds: 500
    ),(){
      getPrimeProduct();
    });
    Future.delayed(Duration(
        seconds: 5
    ), (){
      if(prefs!.getString('stateId') == "" || prefs!.getString("stateId") == null) {
        stateSelectDialog();
      }
      else{
        String? value = prefs!.getString('stateId');
        selectedState = value;
      }
    });
    callApi();
    getState();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    getData();
    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
    getState();

    // getOrder();
  }

  void startTutorialMode(){
    TutorialCoachMark(targets: targetList)..show(context: context);
  }


  getState()async{
    var headers = {
      'Cookie': 'ci_session=d17027e5a9e874c71f0fd74fbefb2dd76e17e1d9'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_states'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print("status code here ${'${baseUrl}get_states'}  ddddd ${response.statusCode}");
    if (response.statusCode == 200) {
      var finalRes = await response.stream.bytesToString();
      final jsonResponse = GetStateModel.fromJson(json.decode(finalRes));
      setState(() {
        getStateModel = jsonResponse.date!;
      });
      // print("okkk ${getStateModel} and ${getStateModel.date}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  String? selectedState;
  String? state;

  stateSelectDialog(){
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context){
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
        return WillPopScope(
          onWillPop: () async => false,
          child:AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select State",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                SizedBox(height: 10,),
                getStateModel != null ?  Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.grey,
                      )
                  ),
                  child:DropdownButton(
                      underline: Container(),
                      value: selectedState,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      hint: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width/1.6,
                          child: Text("Select state")),
                      items: getStateModel.map((items){
                        return DropdownMenuItem(
                          value: items.id,
                          child: Padding(
                            padding:  EdgeInsets.only(left: 10),
                            child: Text(items.name.toString()),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue){
                        setState((){
                          selectedState = newValue as String?;
                          prefs!.setString('stateId', '${selectedState}');
                          Navigator.of(context);
                          callApi();
                          Navigator.of(context);
                        });
                      }),
                )
                    : CircularProgressIndicator(),
              ],
            ),
            actions: [
              InkWell(
                onTap: (){
                  if(selectedState == "" || selectedState == null){
                    Fluttertoast.showToast(msg: "Please select state");
                  }
                  else{
                    Navigator.of(context).pop();
                  }

                },
                child:Container(
                  height: 40,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),
                ),
              )
            ],
          ),
        );
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar: AppBar(
      //
      //   backgroundColor: Colors.red,
      //
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(20),
      //           bottomRight: Radius.circular(20)
      //       )
      //   ),
      //   elevation: 2,
      //   // title: Text(
      //   //   "${getTranslated(context, 'feedback')}",
      //   //   style: TextStyle(
      //   //     fontSize: 20,
      //   //     color: appColorWhite,
      //   //   ),
      //   // ),
      //   centerTitle: true,
      //   leading:  Padding(
      //     padding: const EdgeInsets.all(12),
      //     // child: RawMaterialButton(
      //     //   // shape: CircleBorder(),
      //     //   padding: const EdgeInsets.all(0),
      //     //   fillColor: Colors.white,
      //     //   splashColor: Colors.grey[400],
      //     //   // child: Icon(
      //     //   //   Icons.arrow_back,
      //     //   //   size: 20,
      //     //   //   // color: appColorBlack,
      //     //   // ),
      //     //   onPressed: () {
      //     //     Navigator.pop(context);
      //     //   },
      //     // ),
      //   ),
      // ),
      body: _isNetworkAvail
          ? RefreshIndicator(
        color: colors.primary,
        key: _refreshIndicatorKey,
        onRefresh: _refresh,

        child: Column(
          children: [
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                //
                bottomRight: Radius.circular(30),
              ),
                color: colors.secondary,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset("assets/images/feedmartlogo.png",height: 50,width: 110,),
                        ),
                        SizedBox(width: 90,),
                        InkWell(
                            onTap: () => launch('${youTube}'),
                            child: Image.asset("assets/images/youtube.png",height: 25,width: 25,key: youtubeBoxKey,)),
                        SizedBox(width: 12,),
                        InkWell(
                            onTap: () =>launch('${facebook}'),
                            child: Image.asset("assets/images/facebook.png",height: 20,width: 20,key: facebookBoxKey,)),
                        SizedBox(width: 12,),
                        InkWell(
                            onTap: ()=>launch('${instagram}'),
                            child: Image.asset("assets/images/instagram.png",height: 20,width: 20,key: instaBoxKey,)),
                        SizedBox(width: 11,),
                        InkWell(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationList()),);
                        },
                            child: Image.asset("assets/images/notifaction.png",height: 20,width: 20,key: notificationBoxKey,)),
                      ],
                    ),
                  ),
                  searchBar(),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InkWell(
                  //   onTap: (){
                  //     stateSelectDialog();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       height: 45,
                  //       decoration: BoxDecoration(
                  //         color: colors.whiteTemp,
                  //         borderRadius: BorderRadius.circular(20.0)
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           children: [
                  //             Icon(Icons.location_on_outlined),
                  //             // SizedBox(width: 10,),
                  //             Container(
                  //
                  //               child:
                  //               DropdownButton(
                  //                  // isExpanded: true,
                  //                   underline: Container(),
                  //                   value: state,
                  //
                  //                   icon: Padding(
                  //                     padding: const EdgeInsets.only(left: 50),
                  //                     child: const Icon(Icons.keyboard_arrow_down_outlined),
                  //                   ),
                  //                   hint: Container(
                  //                       padding: EdgeInsets.symmetric(horizontal: 10),
                  //                       width: MediaQuery.of(context).size.width/1.6,
                  //                       child: Text("Select state")),
                  //                   items: getStateModel.map((items){
                  //                     return DropdownMenuItem(
                  //                       value: items.id,
                  //                       child:
                  //                       Padding(
                  //                         padding:  EdgeInsets.only(left: 10),
                  //                         child: Text(items.name.toString()),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                   onChanged: (newValue){
                  //                     setState((){
                  //                       selectedState = newValue as String?;
                  //                       prefs!.setString('stateId', '${selectedState}');
                  //                       callApi();
                  //                       Navigator.of(context);
                  //                     });
                  //                   }
                  //                   ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //
                  // FloatingActionButton(onPressed: ())
                  // InkWell(
                  //   onTap: (){
                  //     stateSelectDialog();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       height: 45,
                  //       decoration: BoxDecoration(
                  //           color: colors.whiteTemp,
                  //           borderRadius: BorderRadius.circular(20.0)
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           children: [
                  //             Icon(Icons.location_on_outlined),
                  //             // SizedBox(width: 10,),
                  //             Container(
                  //               // width: 230,
                  //               child: DropdownButton(
                  //                 // isExpanded: true,
                  //                   underline: Container(),
                  //                   value: selectedState,
                  //
                  //                   icon: Padding(
                  //                     padding: const EdgeInsets.only(left: 45             ),
                  //                     child: const Icon(Icons.keyboard_arrow_down_outlined),
                  //                   ),
                  //                   hint: Container(
                  //                       padding: EdgeInsets.symmetric(horizontal: 10),
                  //                       width: MediaQuery.of(context).size.width/1.6,
                  //                       child: Text("Select state")),
                  //                   items: getStateModel.map((items){
                  //                     return DropdownMenuItem(
                  //                       value: items.id,
                  //                       child: Padding(
                  //                         padding:  EdgeInsets.only(left: 10),
                  //                         child: Text(items.name.toString()),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                   onChanged: (newValue){
                  //                     setState((){
                  //                       selectedState = newValue as String?;
                  //                       prefs!.setString('stateId', '${selectedState}');
                  //                       callApi();
                  //                       Navigator.of(context);
                  //                     });
                  //                   }),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                        onTap: (){
                          //  startTutorialMode();
                        },

                        child: Text(
                          "Categories",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold,fontSize: 18),key: cateBoxKey,)),
                  ),
                  _catList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCategory()));
                          },
                          child: Container(width: 75,
                              decoration: BoxDecoration(
                                  color: colors.secondary,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: catList.length >=5 ? Center(child: Text("View all",style: TextStyle(color: colors.whiteTemp),)):SizedBox.shrink()),
                        ),
                      )
                    ],
                  ),
                  _slider(),
                  // playviedo(),
                  _section(),
                  SizedBox(height: 10,),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text("Prime Products",style: TextStyle(color: colors.blackTemp,fontSize:14,fontWeight: FontWeight.bold),),
                  // ),
                  // primeProduct(),
                  SizedBox(height: 10,),
                  // _seller()
                ],
              ),
            ),
          ],
        ),


      )
          : noInternet(context),
      bottomNavigationBar:
      orderList.length > 0
      // orderList[0].itemList != null
          ?
          isPaid ?
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          items[0].remainingAmount == "0" || items[0].remainingAmount == " " ?SizedBox.shrink():
          productItem1(0, orderList[0].itemList![0]),
          Container(
            color: Colors.white,
            height: 10,
          ),
        ],
      )
              : SizedBox(
            height: 0,
          )
          : SizedBox(
        height: 0,
      ),
      floatingActionButton:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              height: 45.0,
              width: 45.0,
              child: FloatingActionButton(
                key: contactBoxKey,
                backgroundColor: Colors.white ,
                onPressed: () {
                  _callNumber();
                },
                child: Image.asset("assets/images/telephone.png"),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            key: whatsapppBoxKey,
            height: 50.0,
            width: 50.0,
            child: FloatingActionButton(
              backgroundColor: Colors.white ,
              onPressed: () {
                openwhatsapp();
              },
              child: Image.asset("assets/images/whatsapp.png"),
            ),
          ),
        ],
      ),


      // Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Container(
      //       height: 45.0,
      //       width: 45.0,
      //       child: FloatingActionButton(
      //         backgroundColor: Colors.white ,
      //         onPressed: () {
      //           _callNumber();
      //         },
      //         child: Image.asset("assets/images/telephone.png"),
      //       ),
      //     ),
      //     SizedBox(height: 10,),
      //     Container(
      //       height: 50.0,
      //       width: 50.0,
      //       child: FloatingActionButton(
      //         backgroundColor: Colors.white ,
      //         onPressed: () {
      //           openwhatsapp();
      //         },
      //         child: Image.asset("assets/images/whatsapp.png"),
      //       ),
      //     ),
      //   ],
      // ),

    );
  }

  Future<Null> _refresh() {
    context.read<HomeProvider>().setCatLoading(true);
    context.read<HomeProvider>().setSecLoading(true);
    context.read<HomeProvider>().setSliderLoading(true);

    return callApi();
  }

  // Widget _slider() {
  //   double height = deviceWidth! / 2.2;
  //
  //   return Selector<HomeProvider, bool>(
  //     builder: (context, data, child) {
  //       return data
  //           ? sliderLoading()
  //           : Stack(
  //               children: [
  //                 Container(
  //                   height: height,
  //                   width: double.infinity,
  //                   // margin: EdgeInsetsDirectional.only(top: 10),
  //                   child: PageView.builder(
  //                     itemCount: homeSliderList.length,
  //                     scrollDirection: Axis.horizontal,
  //                     controller: _controller,
  //                     physics: AlwaysScrollableScrollPhysics(),
  //                     onPageChanged: (index) {
  //                       context.read<HomeProvider>().setCurSlider(index);
  //                     },
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return pages[index];
  //                     },
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   height: 40,
  //                   left: 0,
  //                   width: deviceWidth,
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: map<Widget>(
  //                       homeSliderList,
  //                       (index, url) {
  //                         return Container(
  //                             width: 8.0,
  //                             height: 8.0,
  //                             margin: EdgeInsets.symmetric(
  //                                 vertical: 10.0, horizontal: 2.0),
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: context.read<HomeProvider>().curSlider ==
  //                                       index
  //                                   ? Theme.of(context).colorScheme.fontColor
  //                                   : Theme.of(context).colorScheme.lightBlack,
  //                             ));
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //     },
  //     selector: (_, homeProvider) => homeProvider.sliderLoading,
  //   );
  // }
  _callNumber() async{
    var number = "${mobileNumber}"; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  openwhatsapp() async {
    var whatsapp = "${whatsNumber}";
    // var whatsapp = "+919644595859";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
        "&text=Hello, I am messaging from Feed Mart App, I am interested in your products, Can we have chat? ";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp does not exist in this device")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp does not exist in this device")));
      }
    }
  }
  Widget _slider() {
    double height = deviceWidth! / 2.0;
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? sliderLoading()
            : ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: height,
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration:
                      Duration(milliseconds: 150),
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      height: height,
                      onPageChanged: (position, reason) {
                        setState(() {
                          currentindex = position;
                        });
                        print(reason);
                        print(CarouselPageChangedReason.controller);
                      },
                    ),
                    items: homeSliderList.map((val) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "${val.image}",
                              fit: BoxFit.fill,
                            )),
                      );
                    }).toList(),
                  ),
                  // margin: EdgeInsetsDirectional.only(top: 10),
                  // child: PageView.builder(
                  //   itemCount: homeSliderList.length,
                  //   scrollDirection: Axis.horizontal,
                  //   controller: _controller,
                  //   pageSnapping: true,
                  //   physics: AlwaysScrollableScrollPhysics(),
                  //   onPageChanged: (index) {
                  //     context.read<HomeProvider>().setCurSlider(index);
                  //   },
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return pages[index];
                  //   },
                  // ),
                ),
              ),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: homeSliderList.map((e) {
                    int index = homeSliderList.indexOf(e);
                    return Container(
                        width: 30.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // shape: BoxShape.circle,
                          color: currentindex == index
                              ? Theme.of(context).colorScheme.lightBlack
                              : Theme.of(context).colorScheme.darkgray,
                        ));
                  }).toList()),
            ],
          ),
        );
      },
      selector: (_, homeProvider) => homeProvider.sliderLoading,
    );
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 30)).then(
          (_) {
        if (mounted) {
          int nextPage = _controller.hasClients
              ? _controller.page!.round() + 1
              : _controller.initialPage;

          if (nextPage == homeSliderList.length) {
            nextPage = 0;
          }
          if (_controller.hasClients)
            _controller
                .animateToPage(nextPage,
                duration: Duration(milliseconds: 200), curve: Curves.linear)
                .then((_) => _animateSlider());
        }
      },
    );
  }
  Widget productItem1(int index, OrderItem orderItem) {

    print("checking final answer here ${items[0].id}");
    if (orderItem != null) {
      String? sDate = orderItem.listDate!.last;
      String? proStatus = orderItem.listStatus!.last;
      String message = "Waiting for the vendor confirmation";
      List l;
      l = message.split(' ');
      print("1=== ${l.length.toString()}");
      if (proStatus == 'received') {
        proStatus = 'YOUR LAST ORDER';
        bottomcart = false;
      }
      if (proStatus == CONFIRMED) {
        message = "Your order getting ready, now sit back and relax";
        l = message.split(' ');
        bottomcart = false;
        print("2=== ${l.length.toString()}");
      } else if (proStatus == ASSIGN) {
        message = "Delivery executive has been assigned for your order";
        l = message.split(' ');
        bottomcart = false;
        print("3=== ${l.length.toString()}");
      } else if (proStatus == ARRIVED) {
        message = "Delivery executive  has reached to pick up your order";
        l = message.split(' ');
        bottomcart = false;
        print("4=== ${l.length.toString()}");
      } else if (proStatus == PICKED) {
        message =
        "On the way to delivery please provide the otp once order received by you";
        l = message.split(' ');
        bottomcart = false;
        print("5=== ${l.length.toString()}");
      } else {
        message = "Waiting for the vendor confirmation";
        l = message.split(' ');
        print("6=== ${l.length.toString()}");
      }
      String name = orderItem.name ?? "";
      name = name +
          " ${orderList[index].itemList!.length > 1 ? " and more items" : ""} ";
      return proStatus != DELIVERD &&
          proStatus != CANCLED &&
          proStatus != RETURNED
          ? InkWell(
        borderRadius: BorderRadius.circular(7),
        child: Container(

          color: colors.secondary,
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Column(children: <Widget>[
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      topLeft: Radius.circular(0.0)),
                  child: commonHWImage(orderItem.image, 60.0, 60.0, "",
                      context, "assets/images/sliderph.png")),
              Expanded(
                  flex: 9,
                  child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 10.0, end: 5.0, bottom: 8.0, top: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "${proStatus.toUpperCase()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text("Order ID:${items[0].id}",style: TextStyle(color: colors.whiteTemp,fontSize: 11),
                            //   // overflow: TextOverflow.ellipsis,
                            // ),
                            // AnimatedTextKit(
                            //   animatedTexts: [
                            //     ColorizeAnimatedText(
                            //       "$proStatus on $sDate \n$message",
                            //       textStyle: colorizeTextStyle,
                            //       colors: colorizeColors,
                            //     ),
                            //   ],
                            //   pause: Duration(milliseconds: 100),
                            //   isRepeatingAnimation: true,
                            //   totalRepeatCount: 100,
                            //   onTap: () {
                            //     print("Tap Event");
                            //   },
                            // ),
                            // Text(
                            //   name,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .subtitle2!
                            //       .copyWith(
                            //     fontSize: 12,
                            //           color: Theme.of(context)
                            //               .colorScheme
                            //               .black,
                            //           fontWeight: FontWeight.normal),
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ]))),
              const Spacer(),
              Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text("BALANCE : $CUR_CURRENCY ${items[0].remainingAmount}",style: TextStyle(color: colors.whiteTemp,fontWeight: FontWeight.bold),)
                    ),
                    InkWell(
                      onTap: ()async{
                        print("hbdfhksdfdfdfhdfkhfgb");
                        //getSetting1();
                        //
                        print("this is aaaa====${items[0].remainingAmount}rrrrrr   ${upi}sdsdsd  ${upi}");
                        UpiPayment upiPayment =  UpiPayment("${items[0].remainingAmount}", "${upi}", context, (value) {
                          print("checking value status here ${value.status}");
                          if(value.status==UpiTransactionStatus.success){
                            Navigator.pop(context);
                            //placeOrder('',upiResponse: value);
                            addMony("transID");
                          } else if(value.status==UpiTransactionStatus.failure){
                            // setState((){
                            //   _placeOrder = true;
                            // });
                            Fluttertoast.showToast(msg: "Payment Failed");
                          }
                          else if(value.status == UpiTransactionStatus.failedToLaunch){
                            // setState((){
                            //   _placeOrder = true;
                            // });
                            Fluttertoast.showToast(msg: "Payment Failed");
                          }
                          else{
                            // setState((){
                            //   _placeOrder = true;
                            // });
                            Fluttertoast.showToast(msg: "Payment Failed");
                          }
                        }, items[0].remainingAmount.toString());


                        upiPayment.initPayment();
                       // doPayment();
                       //  addMony("transID");
                        // _razorpay = Razorpay();
                        // _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                        // _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                        // _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                        razorpayPayment(items[0].remainingAmount.toString(),);

                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => AlertDialog(
                        //     title: Text("Pay Remaining Amount"),
                        //     content: Text(""),
                        //     actions: <Widget>[
                        //       TextButton(
                        //         onPressed: () {
                        //          Navigator.pop(context);
                        //         },
                        //         child: Container(
                        //
                        //           decoration: BoxDecoration(
                        //               color: colors.secondary,
                        //             borderRadius: BorderRadius.circular(10)
                        //           ),
                        //
                        //           child:Center(child: Text("Back")),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            color: colors.primary,
                          borderRadius: BorderRadius.circular(10)
                        ),

                        child: Center(child: Text("Pay Now",style: TextStyle(color: colors.whiteTemp),)),
                      ),
                    )


                  ],
              )

              // Container(
              //   child: Text("Pay Now"),
              // )
            ]),
          ]),
        ),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetail(
                  model: orderList[index],
                  sellerId: orderItem.seller_id,
                  orderId: orderList[index].itemList![0].varientId,
                )),
          );
        },
      )
          : SizedBox(
        height: 0,
      );
    } else {
      return
        //   checkOut.curCartCount != "0" && checkOut.curCartCount != null
        //     ? Container(
        //   margin: const EdgeInsets.only(left: 15.0, right: 15,  bottom: 8),
        //   padding: EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //       color: Colors.white,
        //       //colors.primary,
        //       borderRadius: BorderRadius.circular(10)
        //   ),
        //   height: 70,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       sub == true ?
        //       CircularProgressIndicator(color: colors.primary,)
        //           : InkWell(
        //         onTap: (){
        //           getCartSeller(checkOut.curSellerId);
        //           Future.delayed(Duration(seconds: 2), (){
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => SellerProfile(
        //                       title: checkOut.storeName,
        //                       sellerID: checkOut.curSellerId,
        //                       sellerId: checkOut.curSellerId,
        //                       sellerData: sellerLists[0],
        //                       userLocation: currentAddress.text,
        //                       // catId: widget.catId,
        //                       shop: false,
        //                     )));
        //           });
        //         },
        //         child: Row(
        //           children: [
        //             CircleAvatar(
        //               backgroundImage: NetworkImage(checkOut.sellerProfile),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(left: 8.0),
        //               child: Container(
        //                 width: 150,
        //                 child: Text("${checkOut.storeName}",
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 2,
        //                   style: TextStyle(color: colors.primary,
        //                       fontWeight: FontWeight.w600),),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //
        //
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => Cart(fromBottom: false)));
        //         },
        //         child: Container(
        //           padding: EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //               color: colors.primary,
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Column(
        //             children: [
        //               Text("${checkOut.curCartCount} Item | $CUR_CURRENCY${checkOut.totalAmount}",
        //                 style: TextStyle(color: Colors.white),),
        //               Text(
        //                 "View Cart",
        //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        //     : Container();
        SizedBox();
    }
  }

  _singleSection(int index) {
    Color back;
    int pos = index % 5;
    if (pos == 0)
      back = Theme.of(context).colorScheme.back1;
    else if (pos == 1)
      back = Theme.of(context).colorScheme.back2;
    else if (pos == 2)
      back = Theme.of(context).colorScheme.back3;
    else if (pos == 3)
      back = Theme.of(context).colorScheme.back4;
    else
      back = Theme.of(context).colorScheme.back5;

    return sectionList[index].productList!.length > 0
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _getHeading(sectionList[index].title ?? "", index),

              _getSection(index),
            ],
          ),
        ),
        offerImages.length > index ? _getOfferImage(index) : Container(),
      ],
    )
        : Container();
  }

  _getHeading(String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: colors.yellow,
                ),
                padding: EdgeInsetsDirectional.only(
                    start: 10, bottom: 3, top: 3, end: 10),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: colors.blackTemp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              /*   Positioned(
                  // clipBehavior: Clip.hardEdge,
                  // margin: EdgeInsets.symmetric(horizontal: 20),

                  right: -14,
                  child: SvgPicture.asset("assets/images/eshop.svg"))*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(sectionList[index].shortDesc ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor)),
              ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //       minimumSize: Size.zero, // <
              //       backgroundColor: (Theme.of(context).colorScheme.white),
              //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
              //   child: Text(
              //     getTranslated(context, 'SHOP_NOW')!,
              //     style: Theme.of(context).textTheme.caption!.copyWith(
              //         color: Theme.of(context).colorScheme.fontColor,
              //         fontWeight: FontWeight.bold),
              //   ),
              //   onPressed: () {
              //     SectionModel model = sectionList[index];
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SectionList(
              //           index: index,
              //           section_model: model,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
  _getOfferImage(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: FadeInImage(
            fit: BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 150),
            image: CachedNetworkImageProvider(offerImages[index].image!),
            width: double.maxFinite,
            imageErrorBuilder: (context, error, stackTrace) => erroWidget(50),
            // errorWidget: (context, url, e) => placeHolder(50),
            placeholder: AssetImage(
              "assets/images/sliderph.png",
            )),
        onTap: () {
          if (offerImages[index].type == "products") {
            Product? item = offerImages[index].list;

            Navigator.push(
              context,
              PageRouteBuilder(
                //transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) =>
                      ProductDetail(model: item, secPos: 0, index: 0, list: true
                        //  title: sectionList[secPos].title,
                      )),
            );
          } else if (offerImages[index].type == "categories") {
            Product item = offerImages[index].list;
            if (item.subList == null || item.subList!.length == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var transID = response.paymentId;
    // placeOrder(response.paymentId);
    addMony(transID!);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    const snackBar = SnackBar(
      content: Text('Payment Canal'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   // var getdata = json.decode(response.message!);
   // String errorMsg = getdata["error"]["description"];
   // setSnackbar(errorMsg, setSnackbar("dsfsfsdfdfbfdf", context));

    // if (mounted)
      // checkoutState!(() {
      //   // _placeOrder = true;
      // });
    context.read<CartProvider>().setProgress(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  _getSection(int i) {
    var orient = MediaQuery.of(context).orientation;

    return sectionList[i].style == DEFAULT
        ?
    Padding(
      padding: const EdgeInsets.all(5.0),
      child:
      GridView.count(
        // mainAxisSpacing: 12,
        // crossAxisSpacing: 12,
        padding: EdgeInsetsDirectional.only(top: 5),
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 2,
        crossAxisSpacing: 5,
        childAspectRatio: 0.750,

        //  childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children:
        //  [
        //   Container(height: 500, width: 1200, color: Colors.red),
        //   Text("hello"),
        //   Container(height: 10, width: 50, color: Colors.green),
        // ]
        List.generate(
          sectionList[i].productList!.length < 4
              ? sectionList[i].productList!.length
              : 4,
              (index) {
            // return Container(
            //   width: 600,
            //   height: 50,
            //   color: Colors.red,
            // );

            return productItem(i, index, index % 2 == 0 ? true : false);
          },
        ),
      ),
    )
        : sectionList[i].style == STYLE1
        ? sectionList[i].productList!.length > 0
        ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                    height: orient == Orientation.portrait
                        ? deviceHeight! * 0.4
                        : deviceHeight!,
                    child: productItem(i, 0, true))),
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: orient == Orientation.portrait
                          ? deviceHeight! * 0.2
                          : deviceHeight! * 0.5,
                      child: productItem(i, 1, false)),
                  Container(
                      height: orient == Orientation.portrait
                          ? deviceHeight! * 0.2
                          : deviceHeight! * 0.5,
                      child: productItem(i, 2, false)),
                ],
              ),
            ),
          ],
        ))
        : Container()
        : sectionList[i].style == STYLE2
        ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: orient == Orientation.portrait
                          ? deviceHeight! * 0.2
                          : deviceHeight! * 0.5,
                      child: productItem(i, 0, true)),
                  Container(
                      height: orient == Orientation.portrait
                          ? deviceHeight! * 0.2
                          : deviceHeight! * 0.5,
                      child: productItem(i, 1, true)),
                ],
              ),
            ),
            Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                    height: orient == Orientation.portrait
                        ? deviceHeight! * 0.4
                        : deviceHeight,
                    child: productItem(i, 2, false))),
          ],
        ))
        : sectionList[i].style == STYLE3
        ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                    height: orient == Orientation.portrait
                        ? deviceHeight! * 0.3
                        : deviceHeight! * 0.6,
                    child: productItem(i, 0, false))),
            Container(
              height: orient == Orientation.portrait
                  ? deviceHeight! * 0.2
                  : deviceHeight! * 0.5,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: productItem(i, 1, true)),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: productItem(i, 2, true)),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: productItem(i, 3, false)),
                ],
              ),
            ),
          ],
        ))
        : sectionList[i].style == STYLE4
        ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                    height: orient == Orientation.portrait
                        ? deviceHeight! * 0.25
                        : deviceHeight! * 0.5,
                    child: productItem(i, 0, false))),
            Container(
              height: orient == Orientation.portrait
                  ? deviceHeight! * 0.2
                  : deviceHeight! * 0.5,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: productItem(i, 1, true)),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: productItem(i, 2, false)),
                ],
              ),
            ),
          ],
        ))
        : Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
            padding: EdgeInsetsDirectional.only(top: 5),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.2,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 0,
            children: List.generate(
              sectionList[i].productList!.length < 6
                  ? sectionList[i].productList!.length
                  : 6,
                  (index) {
                return productItem(i, index,
                    index % 2 == 0 ? true : false);
              },
            )
        ));
  }

  razorpayPayment(amt) async {

    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(this.context, listen: false);
    print("Payment Email ${settingsProvider.email}");
    print("Payment Email ${settingsProvider.mobile}");

    String? contact = settingsProvider.mobile;
    // String? email = settingsProvider.email;
    // String? amt;

    // if( == null || dCharge == ""){
    //   amt = ((amount) * 100)
    //       .toStringAsFixed(2);
    // }
    // else {
    //   amt = ((amount) * 100)
    //       .toStringAsFixed(2);
    // }
    double remaining = double.parse(amt)*100;

    if (contact != '') {
      context.read<CartProvider>().setProgress(true);
      var options = {
        KEY: razaoPayIdNew,
        AMOUNT: remaining,
        NAME: settingsProvider.userName,
        'prefill': {CONTACT: contact},
      };
      print("Ootion=================>${options.toString()}");
      try {
        print("hfhdgdghidg");
        _razorpay!.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      // if (email == '')
      //   setSnackbar(getTranslated(context, 'emailWarning')!, _checkscaffoldKey);
      if (contact == '')
        setSnackbar(getTranslated(context, 'phoneWarning')!, setSnackbar("khsfbff", context));
    }
  }

  Widget productItem(int secPos, int index, bool pad) {
    if (sectionList[secPos].productList!.length > index) {
      String? offPer;
      double price = double.parse(
          sectionList[secPos].productList![index].prVarientList![0].disPrice!);
      if (price == 0) {
        price = double.parse(
            sectionList[secPos].productList![index].prVarientList![0].price!);
      } else {
        double off = double.parse(sectionList[secPos]
            .productList![index]
            .prVarientList![0]
            .price!) -
            price;
        offPer = ((off * 100) /
            double.parse(sectionList[secPos]
                .productList![index]
                .prVarientList![0]
                .price!))
            .toStringAsFixed(2);
      }

      double width = deviceWidth! * 0.5;

      return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),

        margin: EdgeInsetsDirectional.only(bottom: 2, end: 2,top: 5,),
        //end: pad ? 5 : 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                /*       child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Hero(
                      tag:
                      "${sectionList[secPos].productList![index].id}$secPos$index",
                      child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 150),
                        image: NetworkImage(
                            sectionList[secPos].productList![index].image!),
                        height: double.maxFinite,
                        width: double.maxFinite,
                        fit: extendImg ? BoxFit.fill : BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            erroWidget(width),

                        // errorWidget: (context, url, e) => placeHolder(width),
                        placeholder: placeHolder(width),
                      ),
                    )),*/
                child: Stack(
                  // alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Hero(
                        // transitionOnUserGestures: true,
                        tag:
                        "${sectionList[secPos].productList![index].id}$secPos$index",
                        child: Container(
                          height: 170,
                          child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 150),
                            image: CachedNetworkImageProvider(
                                sectionList[secPos].productList![index].image!),
                            height: double.maxFinite,
                            width: double.maxFinite,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                erroWidget(double.maxFinite),
                            fit: BoxFit.fill,
                            placeholder: placeHolder(width),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 4),
                child: Text(
                  sectionList[secPos].productList![index].name!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,fontSize:15,fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10,left: 8),
              //   child: Text("PeckSize: ${sectionList[secPos].productList![index].prVarientList![0].weight}"
              //       " ${sectionList[secPos].productList![index].prVarientList![0].unittext!}"
              //     ,style: TextStyle(fontWeight: FontWeight.normal,color: colors.blackTemp),),
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 8),
                child:Row(
                  children: [
                    Text("Price: ${CUR_CURRENCY}  ${price.toStringAsFixed(0)} /",style: TextStyle(color:colors.blackTemp,fontWeight: FontWeight.bold),),
                    Container(
                        width: 50,
                        child: Text(sectionList[secPos].productList![index].prVarientList![0].weight == "1" ?  "${sectionList[secPos].productList![index].prVarientList![0].unittext.toString()}" :  sectionList[secPos].productList![index].prVarientList![0].weight.toString() + " " + sectionList[secPos].productList![index].prVarientList![0].unittext.toString(),overflow: TextOverflow.ellipsis,style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold), ))
                  ],
                ),
                // Text(
                //   // "Price: ${CUR_CURRENCY! + "" +price.toString()} /${sectionList[secPos].productList![index].prVarientList![0].weight}  ${sectionList[secPos].productList![index].prVarientList![0].unittext!}",
                //  //"Price: ${CUR_CURRENCY! + "" +price.toString()} /${sectionList[secPos].productList![index].prVarientList![0].weight}  ${sectionList[secPos].productList![index].prVarientList![0].unittext!}",
                //      "Price:" + "${CUR_CURRENCY! +  "" + price.toString()}"  +  "/" +  sectionList[secPos].productList![index].prVarientList![0].weight.toString()  == "1" ? "" : sectionList[secPos].productList![index].prVarientList![0].weight.toString() + sectionList[secPos].productList![index].prVarientList![0].unittext.toString()  ,
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 14
                //   ),
                // ),
              ),
              // Positioned.directional(
              //   textDirection: Directionality.of(context),
              //   bottom: 5,
              //   end: 45,
              //   // child: InkWell(
              //   //   onTap: () {
              //   //     if (_isProgress == false)
              //   //       addToCart(
              //   //           index,
              //   //           (int.parse(_controller[index].text) +
              //   //               int.parse(model.qtyStepSize!))
              //   //               .toString());
              //   //   },
              //   child: Card(
              //     elevation: 1,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Icon(
              //         Icons.shopping_cart_outlined,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.only(
              //       start: 8.0, bottom: 5, top: 0,),
              //   child: double.parse(sectionList[secPos]
              //               .productList![index]
              //               .prVarientList![0]
              //               .disPrice!) !=
              //           0
              //       ? Row(
              //           children: <Widget>[
              //             Text(
              //               double.parse(sectionList[secPos].productList![index].prVarientList![0].disPrice!) !=
              //                       0
              //                   ?  "MRP:" + CUR_CURRENCY! +
              //                       " " +
              //                       sectionList[secPos]
              //                           .productList![index]
              //                           .prVarientList![0]
              //                           .price!
              //                   : "",
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .overline!
              //                   .copyWith(
              //                       decoration: TextDecoration.lineThrough,
              //                       letterSpacing: 0,
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.normal,
              //                 color: colors.blackTemp.withOpacity(0.2)
              //               ),
              //             ),
              //
              //             // Flexible(
              //             //   child: Text(" | " + "$offPer%",
              //             //       maxLines: 1,
              //             //       overflow: TextOverflow.ellipsis,
              //             //       style: Theme.of(context)
              //             //           .textTheme
              //             //           .overline!
              //             //           .copyWith(
              //             //               color: colors.primary,
              //             //               letterSpacing: 0,
              //             //         fontSize: 15,
              //             //         fontWeight: FontWeight.bold
              //             //       )),
              //             // ),
              //           ],
              //         )
              //       : Container(
              //           height: 5,
              //         ),
              // )
            ],
          ),
          onTap: () {
            Product model = sectionList[secPos].productList![index];
            Navigator.push(
              context,
              PageRouteBuilder(
                // transitionDuration: Duration(milliseconds: 150),
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: model, secPos: secPos, index: index, list: false
                  //  title: sectionList[secPos].title,
                ),
              ),
            );
          },
        ),
      );
    } else
      return Container();
  }

  PrimeProductModel? PrimeModel;
  getPrimeProduct() async {
    var headers = {
      'Cookie': 'ci_session=1cf2fc55e4f5c88fe4595b902af453a1fbdf50ce'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/get_prime_products'));
    print("prim api here ${baseUrl}/get_prime_products");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var Result = await response.stream.bytesToString();
      final FinalResult = PrimeProductModel.fromJson(jsonDecode(Result));
      print("New+++++++++++++++++++++++${FinalResult.toString()}");
      setState(() {
        PrimeModel = FinalResult;
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }
  // primeProduct(){
  //   return Padding(
  //     padding: const EdgeInsets.all(6.0),
  //     child: Container(
  //       height: MediaQuery.of(context).size.height/3.1,
  //       child:PrimeModel == null?Center(child: Text("lodding....")): ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           shrinkWrap: true,
  //         physics:ScrollPhysics(),
  //           itemCount: PrimeModel!.data!.length,
  //         itemBuilder: (context, i) {
  //           print("here");
  //           return InkWell(
  //             // onTap: (){
  //             //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(
  //             //      secPos: 0, index: 0, list: true)
  //             //   )
  //             //   );
  //             // },
  //             child: Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12)
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(10))
  //                     ),
  //                       height: 120,
  //                       width: 160,
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(10),
  //                           child:PrimeModel!.data![i].image == null || PrimeModel!.data![i].image ==""?
  //                           Image.asset("assets/images/placeholder.png"):
  //                           Image.network("${PrimeModel!.data![i].image}",fit: BoxFit.fill,))),
  //                           SizedBox(height: 3,),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text("${PrimeModel!.data![i].name}",style: TextStyle(color: colors.primary,fontWeight: FontWeight.bold),),
  //                         SizedBox(height: 5,),
  //                         Text("Size: ${PrimeModel!.data![i].variants![0].weight} ${PrimeModel!.data![i].variants![0].unitText}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.normal),),
  //                         SizedBox(height: 3,),
  //                         Text("Offer Price: $CUR_CURRENCY ${PrimeModel!.data![i].variants![0].specialPrice}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
  //                         SizedBox(height: 3,),
  //                         Text("MRP:$CUR_CURRENCY ${PrimeModel!.data![i].variants![0].price}",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.normal),)
  //                       ],
  //                     ),
  //                   )
  //
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //
  //       ),
  //     ),
  //   );
  // }
  _section() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
          width: double.infinity,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.simmerBase,
            highlightColor: Theme.of(context).colorScheme.simmerHigh,
            child: sectionLoading(),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: sectionList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            print("here");
            return _singleSection(index);
          },
        );
      },
      selector: (_, homeProvider) => homeProvider.secLoading,
    );
  }
  searchBar(){
    return  Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8),
          child: Container(
            key: searchBoxKey,
              height: 40,
              decoration: BoxDecoration(
                  color: colors.whiteTemp,
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(

                  children: [
                    Icon(Icons.search,color: colors.blackTemp.withOpacity(0.2),),
                    Text("Search...",style: TextStyle(color: colors.blackTemp.withOpacity(0.2)),)
                  ],
                ),
              )
            // TextField(
            //    controller: controllerfield,
            //   autofocus: true,
            //  // readOnly: true,
            //   style: TextStyle(
            //       color: Theme.of(context).colorScheme.fontColor,
            //       fontWeight: FontWeight.bold),
            //   decoration: InputDecoration(
            //     contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            //     // contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            //     hintText: getTranslated(context, 'SEARCH_LBL'),
            //     //: Icon(Icons.document_scanner_outlined,color: colors.primary,),
            //     prefixIcon: Icon(Icons.search,color: colors.blackTemp.withOpacity(0.2)),
            //     hintStyle: TextStyle(color: colors.blackTemp.withOpacity(0.2)
            //     ),
            //     enabledBorder: UnderlineInputBorder(
            //       borderSide:
            //       BorderSide(color: Theme.of(context).colorScheme.white),
            //     ),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide:
            //       BorderSide(color: Theme.of(context).colorScheme.white),
            //     ),
            //   ),
            //   // onChanged: (query) => updateSearchQuery(query),
            // ),
          ),
        ),
      ),
    );
  }
  _catList() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
            : Container(
          height:catList.length >3 ?250 :120,
          padding: const EdgeInsets.only(top: 10, left: 5,right: 5),
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 0,),
            itemCount:catList.length
                < 6 ? catList.length : 6,
            itemBuilder: (context, index) {
              if (index == 1.2)
                return Container();
              else
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (catList[index].subList == null ||
                          catList[index].subList!.length == 0) {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductList(
                                name: catList[index].name,
                                id: catList[index].id,
                                tag: false,
                                fromSeller: false,
                              ),
                            ));
                      } else {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubCategory(
                                title: catList[index].name!,
                                subList: catList[index].subList,
                              ),
                            ));
                      }
                    },
                    child: Stack(
                      // alignment: Alignment.bottomCenter,
                        children:[
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              color: colors.white10,
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 85,
                                      width: 150,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: Image.network("${catList[index].image }",fit: BoxFit.fill,)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 14,
                            child: Container(
                              height: 20,
                              width: 91,
                              decoration: BoxDecoration(
                                  color: colors.secondary,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              // alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 5,right:5),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    catList[index].name!.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                        color: colors.lightWhite2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                );

            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              // crossAxisSpacing: 0.0,
              mainAxisExtent: 110,
              mainAxisSpacing: 10,
              crossAxisSpacing: 0,
            ),
          ),
          //Listview

          // ListView.builder(
          //   itemCount: catList.length < 5 ? catList.length : 5,
          //   scrollDirection: Axis.horizontal,
          //   shrinkWrap: true,
          //   physics: AlwaysScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     if (index == 0)
          //       return Container();
          //     else
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 10),
          //         child: GestureDetector(
          //           onTap: () async {
          //             if (catList[index].subList == null ||
          //                 catList[index].subList!.length == 0) {
          //               await Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => ProductList(
          //                       name: catList[index].name,
          //                       id: catList[index].id,
          //                       tag: false,
          //                       fromSeller: false,
          //                     ),
          //                   ));
          //             } else {
          //               await Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => SubCategory(
          //                       title: catList[index].name!,
          //                       subList: catList[index].subList,
          //                     ),
          //                   ));
          //             }
          //           },
          //           child: Stack(
          //             // alignment: Alignment.bottomCenter,
          //             children:[
          //               Card(
          //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          //                 child: Container(
          //                   child: Container(
          //                     width: 130,
          //                     child: Column(
          //                       children: [
          //                         Container(
          //                         height: 90,
          //                         width: double.infinity,
          //                         child: ClipRRect(
          //                           borderRadius: BorderRadius.circular(15),
          //                             child: Image.network("${catList[index].image }",fit: BoxFit.fill,)),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Positioned(
          //                 bottom: 0,
          //                 left: 15,
          //                 child: Container(
          //                   height: 20,
          //                   width: 110,
          //                   decoration: BoxDecoration(
          //                       color: colors.secondary,
          //                       borderRadius: BorderRadius.circular(20)
          //                   ),
          //                   // alignment: Alignment.center,
          //                    padding: EdgeInsets.only(left: 10,right: 10),
          //                   child: Container(
          //                     width: 10,
          //                     child: Center(
          //                       child: Text(
          //                         catList[index].name!.toUpperCase(),
          //                         style: Theme.of(context)
          //                             .textTheme
          //                             .caption!
          //                             .copyWith(
          //                             color: colors.lightWhite2,
          //                             fontWeight: FontWeight.w600,
          //                             fontSize: 11),
          //                         overflow: TextOverflow.ellipsis,
          //                         textAlign: TextAlign.start,
          //                         maxLines: 1,
          //
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ]
          //           ),
          //         ),
          //       );
          //   },
          // ),
        );
      },
      selector: (_, homeProvider) => homeProvider.catLoading,
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Future<Null> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
    Provider.of<SettingProvider>(context, listen: false);
    user.setUserId(setting.userId);
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getSetting();
      getSetting1();
      getSlider();
      getState();
      getCat();
      getNewOrder();
      getSeller();
      getSection();
      getOfferImages();

    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
    return null;
  }

  Future _getFav() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      if (CUR_USERID != null) {
        Map parameter = {
          USER_ID: CUR_USERID,
        };
        apiBaseHelper.postAPICall(getFavApi, parameter).then((getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            var data = getdata["data"];

            List<Product> tempList = (data as List)
                .map((data) => new Product.fromJson(data))
                .toList();

            context.read<FavoriteProvider>().setFavlist(tempList);
          } else {
            if (msg != 'No Favourite(s) Product Are Added')
              setSnackbar(msg!, context);
          }

          context.read<FavoriteProvider>().setLoading(false);
        }, onError: (error) {
          setSnackbar(error.toString(), context);
          context.read<FavoriteProvider>().setLoading(false);
        });
      } else {
        context.read<FavoriteProvider>().setLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  void getOfferImages() {
    Map parameter = Map();

    apiBaseHelper.postAPICall(getOfferImageApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print(getOfferImageApi.toString());
      print(parameter.toString());
      if (!error) {
        var data = getdata["data"];
        offerImages.clear();
        offerImages =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setOfferLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setOfferLoading(false);
    });
  }
  // playviedo(){
  //         return InkWell(
  //           onTap: () {
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (context) => VideoPlay()));
  //
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //               height: 45
  //                 ,
  //               width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       color: colors.primary,
  //       borderRadius: BorderRadius.circular(10.0)
  //     ),
  //     child: Center(child: Text("FEED MART TV",style: TextStyle(color: colors.secondary),))
  //   ),
  //           ),
  //         );
  // }
  void getSection() {
    String? stateid =  prefs!.getString('stateId');
    // Map parameter = {PRODUCT_LIMIT: "5", PRODUCT_OFFSET: "6"};
    Map parameter = {PRODUCT_LIMIT: "5",'state_id':'${stateid}','product_type':'prime_products'
    };
    if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID!;
    String curPin = context.read<UserProvider>().curPincode;
    if (curPin != '') parameter[ZIPCODE] = curPin;

    apiBaseHelper.postAPICall(getSectionApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("section api ${getSectionApi}");
      print("section para ${parameter}");
      print("Get Section Data---------: $getdata");
      sectionList.clear();
      if (!error) {
        var data = getdata["data"];
        print("Get Section Data2: $data");
        sectionList = (data as List)
            .map((data) => new SectionModel.fromJson(data))
            .toList();
      } else {
        if (curPin != '') context.read<UserProvider>().setPincode('');
        setSnackbar(msg!, context);
        print("Get Section Error Msg: $msg");
      }
      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }
  var whatsNumber;
  var mobileNumber;
  var youTube;
  var facebook;
  var instagram;
  var webSetting;
  var SystemSetting;

  void getSetting() {
    CUR_USERID = context.read<SettingProvider>().userId;
    //print("")
    // TYPE:"payment_method"
    Map parameter = Map();
    if (CUR_USERID != null) parameter = {USER_ID: CUR_USERID,TYPE:'all'};

    apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("${getSettingApi.toString()}");
      print("${parameter.toString()}");

      if (!error) {
        webSetting = getdata['data']['web_settings'][0];
        upi = getdata['data']['system_settings'][0]["admin_upi_id"];
       print("Checking final upi id here ${upi}");
        var data = SystemSetting = getdata["data"]["system_settings"][0];
        // razaoPayIdNew = getdata['data']['payment_method'][0];
        // newid = razaoPayIdNew['razorpay_key_id'];

       // var razaoPayIdNew1 = getdata['data'];
       // print("iiiii");
       //  var fsss = razaoPayIdNew1['payment_method'];
       //  print("nnnnnnnnnnnn");
       //  var ooo = fsss['razorpay_key_id'];
       //  print("ssssssssssssssssssssssssssss ${ooo}");
       //
       //  print("safsfsdfsdf===========${razaoPayIdNew}");

        cartBtnList = data["cart_btn_on_list"] == "1" ? true : false;
        refer = data["is_refer_earn_on"] == "1" ? true : false;
        CUR_CURRENCY = data["currency"];
        RETURN_DAYS = data['max_product_return_days'];
        MAX_ITEMS = data["max_items_cart"];
        MIN_AMT = data['min_amount'];
        CUR_DEL_CHR = data['delivery_charge'];
        String? isVerion = data['is_version_system_on'];
        extendImg = data["expand_product_images"] == "1" ? true : false;
        String? del = data["area_wise_delivery_charge"];

        MIN_ALLOW_CART_AMT = data[MIN_CART_AMT];
        whatsNumber = data["support_whatsapp"];
        mobileNumber = data["support_number"];
        youTube = webSetting['youtube_link'];
        facebook = webSetting['facebook_link'];
        instagram = webSetting['instagram_link'];

        // print("RazaoPay===================>${newid}");
        print("youTube============>${youTube}");
        print("MobileNumber============>${mobileNumber}");



        if (del == "0")
          ISFLAT_DEL = true;
        else
          ISFLAT_DEL = false;

        if (CUR_USERID != null) {
          REFER_CODE = getdata['data']['user_data'][0]['referral_code'];

          context
              .read<UserProvider>()
              .setPincode(getdata["data"]["user_data"][0][PINCODE]);

          if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
            generateReferral();

          context.read<UserProvider>().setCartCount(
              getdata["data"]["user_data"][0]["cart_total_items"].toString());
          context
              .read<UserProvider>()
              .setBalance(getdata["data"]["user_data"][0]["balance"]);

          _getFav();
          _getCart("0");
        }

        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);
        user.setMobile(setting.mobile);
        user.setName(setting.userName);
        user.setEmail(setting.email);
        user.setProfilePic(setting.profileUrl);

        Map<String, dynamic> tempData = getdata["data"];
        if (tempData.containsKey(TAG))
          tagList = List<String>.from(getdata["data"][TAG]);

        if (isVerion == "1") {
          String? verionAnd = data['current_version'];
          String? verionIOS = data['current_version_ios'];

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;

          final Version currentVersion = Version.parse(version);
          final Version latestVersionAnd = Version.parse(verionAnd);
          final Version latestVersionIos = Version.parse(verionIOS);

          if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
              (Platform.isIOS && latestVersionIos > currentVersion))
            updateDailog();
        }
      } else {
        setSnackbar(msg!, context);
      }
    }, onError: (error) {
      setSnackbar(error.toString(), context);
    });
  }

  addMony(String transID) async {
    print("sfsfsfsfsfsfsfsdfsfsf");
    var headers = {
      'Cookie': 'ci_session=ddb7ebd504033be67e3a67bb7819ba9d7d2f9e30'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}add_money'));
    request.fields.addAll({
      'order_id': items[0].id.toString(),
      'amount': items[0].remainingAmount.toString(),
      'message': '',
      'transaction_id': '$transID',
      'payment_mode': 'razorpay',
      'purpose': 'product'
    });
    print("Parameter===============?${request.fields}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("this is response here now ${response.statusCode}");

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg:"Remaining paid successfully!");
     final result =  await response.stream.bytesToString();
     final Result = json.decode(result);
     setState((){
       isPaid = false;
     });
      await getNewOrder();
      _refresh();
    }
    else {
    print(response.reasonPhrase);
    }
  }

  var razaoPayIdNew;
  void getSetting1() {
    CUR_USERID = context.read<SettingProvider>().userId;
    //print("")
    // TYPE:"payment_method"
    Map parameter = Map();
    if (CUR_USERID != null) parameter = {USER_ID: CUR_USERID,TYPE:'payment_method'};

    apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("${getSettingApi.toString()}");
      print("${parameter.toString()}");

      if (!error) {
        razaoPayIdNew = getdata['data']['payment_method']['razorpay_key_id'];
        // var data = getdata["data"]["system_settings"][0];
       // print("RazaoPay===================>${razaoPayIdNew}");

        // var razaoPayIdNew1 = getdata['data'];
        // print("iiiii");
        //  var fsss = razaoPayIdNew1['payment_method'];
        //  print("nnnnnnnnnnnn");
        //  var ooo = fsss['razorpay_key_id'];
        //  print("ssssssssssssssssssssssssssss ${ooo}");
        //
        //  print("safsfsdfsdf===========${razaoPayIdNew}");

        cartBtnList = SystemSetting["cart_btn_on_list"] == "1" ? true : false;
        refer = SystemSetting["is_refer_earn_on"] == "1" ? true : false;
        CUR_CURRENCY = SystemSetting["currency"];
        RETURN_DAYS = SystemSetting['max_product_return_days'];
        MAX_ITEMS = SystemSetting["max_items_cart"];
        MIN_AMT = SystemSetting['min_amount'];
        CUR_DEL_CHR = SystemSetting['delivery_charge'];
        String? isVerion = SystemSetting['is_version_system_on'];
        extendImg = SystemSetting["expand_product_images"] == "1" ? true : false;
        String? del = SystemSetting["area_wise_delivery_charge"];

        MIN_ALLOW_CART_AMT = SystemSetting[MIN_CART_AMT];
        // whatsNumber = data["support_whatsapp"];
        // mobileNumber = data["support_number"];
        // youTube = webSetting['youtube_link'];
        // facebook = webSetting['facebook_link'];
        // instagram = webSetting['instagram_link'];

        print("RazaoPay===================>${razaoPayIdNew}");
        // print("youTube============>${youTube}");
        // print("MobileNumber============>${mobileNumber}");



        if (del == "0")
          ISFLAT_DEL = true;
        else
          ISFLAT_DEL = false;

        if (CUR_USERID != null) {
          REFER_CODE = getdata['data']['user_data'][0]['referral_code'];

          context
              .read<UserProvider>()
              .setPincode(getdata["data"]["user_data"][0][PINCODE]);

          if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
            generateReferral();

          context.read<UserProvider>().setCartCount(
              getdata["data"]["user_data"][0]["cart_total_items"].toString());
          context
              .read<UserProvider>()
              .setBalance(getdata["data"]["user_data"][0]["balance"]);

          _getFav();
          _getCart("0");
        }

        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);
        user.setMobile(setting.mobile);
        user.setName(setting.userName);
        user.setEmail(setting.email);
        user.setProfilePic(setting.profileUrl);

        Map<String, dynamic> tempData = getdata["data"];
        if (tempData.containsKey(TAG))
          tagList = List<String>.from(getdata["data"][TAG]);

        if (isVerion == "1") {
          String? verionAnd = SystemSetting['current_version'];
          String? verionIOS = SystemSetting['current_version_ios'];

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;

          final Version currentVersion = Version.parse(version);
          final Version latestVersionAnd = Version.parse(verionAnd);
          final Version latestVersionIos = Version.parse(verionIOS);

          if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
              (Platform.isIOS && latestVersionIos > currentVersion))
            updateDailog();
        }
      } else {
        setSnackbar(msg!, context);
      }
    }, onError: (error) {
      setSnackbar(error.toString(), context);
    });
  }

  Future<void> _getCart(String save) async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stateid = prefs.getString('stateId');
    if (_isNetworkAvail) {
      try {
        var parameter = {USER_ID: CUR_USERID, SAVE_LATER: save,'state_id':'${stateid}'};

        Response response =
        await post(getCartApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<SectionModel> cartList = (data as List)
              .map((data) => new SectionModel.fromCart(data))
              .toList();
          context.read<CartProvider>().setCartlist(cartList);
        }
      } on TimeoutException catch (_) {}
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Null> generateReferral() async {
    String refer = getRandomString(8);

    Map parameter = {
      REFERCODE: refer,
    };
    apiBaseHelper.postAPICall(validateReferalApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        REFER_CODE = refer;
        Map parameter = {
          USER_ID: CUR_USERID,
          REFERCODE: refer,
        };
        apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
      } else {
        if (count < 5) generateReferral();
        count++;
      }

      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }
  updateDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: Text(getTranslated(context, 'UPDATE_APP')!),
            content: Text(
              getTranslated(context, 'UPDATE_AVAIL')!,
              style: Theme.of(this.context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Theme.of(context).colorScheme.fontColor),
            ),
            actions: <Widget>[
              new TextButton(
                  child: Text(
                    getTranslated(context, 'NO')!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.lightBlack,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              new TextButton(
                  child: Text(
                    getTranslated(context, 'YES')!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(false);

                    String _url = '';
                    if (Platform.isAndroid) {
                      _url = androidLink + packageName;
                    } else if (Platform.isIOS) {
                      _url = iosLink;
                    }

                    if (await canLaunch(_url)) {
                      await launch(_url);
                    } else {
                      throw 'Could not launch $_url';
                    }
                  })
            ],
          );
        }));
  }

  Widget homeShimmer() {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
              children: [
                catLoading(),
                sliderLoading(),
                sectionLoading(),
              ],
            )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = deviceWidth!;
    double height = width / 2;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: height,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget _buildImagePageItem(Model slider) {
    double height = deviceWidth! / 0.5;

    return GestureDetector(
      child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 12),
          image: CachedNetworkImageProvider(slider.image!),
          height: height,
          width: double.maxFinite,
          fit: BoxFit.contain,
          imageErrorBuilder: (context, error, stackTrace) => Image.asset(
            "assets/images/sliderph.png",
            fit: BoxFit.contain,
            height: height,
            color: colors.primary,
          ),
          placeholderErrorBuilder: (context, error, stackTrace) =>
              Image.asset(
                "assets/images/sliderph.png",
                fit: BoxFit.contain,
                height: height,
                color: colors.primary,
              ),
          placeholder: AssetImage(imagePath + "sliderph.png")),
      onTap: () async {
        int curSlider = context.read<HomeProvider>().curSlider;

        if (homeSliderList[curSlider].type == "products") {
          Product? item = homeSliderList[curSlider].list;

          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: item, secPos: 0, index: 0, list: true)),
          );
        } else if (homeSliderList[curSlider].type == "categories") {
          Product item = homeSliderList[curSlider].list;
          if (item.subList == null || item.subList!.length == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ));
          }
        }
      },
    );
  }

  Widget deliverLoading() {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget catLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    .map((_) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.white,
                    shape: BoxShape.circle,
                  ),
                  width: 50.0,
                  height: 50.0,
                ))
                    .toList()),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ),
      ],
    );
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              context.read<HomeProvider>().setCatLoading(true);
              context.read<HomeProvider>().setSecLoading(true);
              context.read<HomeProvider>().setSliderLoading(true);
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  if (mounted)
                    setState(() {
                      _isNetworkAvail = true;
                    });
                  callApi();
                } else {
                  await buttonController.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  // SearchTab(){
  //   TextField(
  //     decoration: InputDecoration(
  //         prefixIcon: const Icon(Icons.search),
  //         suffixIcon: IconButton(
  //           icon: const Icon(Icons.clear),
  //           onPressed: () {
  //             /* Clear the search field */
  //           },
  //         ),
  //         hintText: 'Search...',
  //         border: InputBorder.none),
  //   );
  // }
  // New() {
  //   // String curpin = context.read<UserProvider>().curPincode;
  //   return GestureDetector(
  //     child: InkWell(
  //
  //       child: TextField(
  //         decoration: InputDecoration(
  //             prefixIcon: const Icon(Icons.search),
  //             border: InputBorder.none),
  //       ),
  //     ),
  //       // child: ListTile(
  //       //   dense: true,
  //       //   minLeadingWidth: 10,
  //       //   leading: Icon(
  //       //     Icons.search,
  //       //   ),
  //       //   title: Selector<UserProvider, String>(
  //       //     builder: (context, data, child) {
  //       //       return Text(
  //       //         data == ''
  //       //             ? getTranslated(context, 'SELOC')!
  //       //             : getTranslated(context, 'DELIVERTO')! + data,
  //       //         style:
  //       //             TextStyle(color: Theme.of(context).colorScheme.fontColor),
  //       //       );
  //       //     },
  //       //     selector: (_, provider) => provider.curPincode,
  //       //   ),
  //       //   trailing: Icon(Icons.keyboard_arrow_right),
  //       // ),
  //
  //     // onTap: Search()
  //   );
  // }

  // void _pincodeCheck() {
  //   showModalBottomSheet<dynamic>(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(25), topRight: Radius.circular(25))),
  //       builder: (builder) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //             constraints: BoxConstraints(
  //                 maxHeight: MediaQuery.of(context).size.height * 0.9),
  //             child: ListView(shrinkWrap: true, children: [
  //               Padding(
  //                   padding: const EdgeInsets.only(
  //                       left: 20.0, right: 20, bottom: 40, top: 30),
  //                   child: Padding(
  //                     padding: EdgeInsets.only(
  //                         bottom: MediaQuery.of(context).viewInsets.bottom),
  //                     child: Form(
  //                         key: _formkey,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Align(
  //                               alignment: Alignment.topRight,
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Icon(Icons.close),
  //                               ),
  //                             ),
  //                             TextFormField(
  //                               keyboardType: TextInputType.text,
  //                               textCapitalization: TextCapitalization.words,
  //                               validator: (val) => validatePincode(val!,
  //                                   getTranslated(context, 'PIN_REQUIRED')),
  //                               onSaved: (String? value) {
  //                                 context
  //                                     .read<UserProvider>()
  //                                     .setPincode(value!);
  //                               },
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .subtitle2!
  //                                   .copyWith(
  //                                       color: Theme.of(context)
  //                                           .colorScheme
  //                                           .fontColor),
  //                               decoration: InputDecoration(
  //                                 isDense: true,
  //                                 prefixIcon: Icon(Icons.location_on),
  //                                 hintText:
  //                                     getTranslated(context, 'PINCODEHINT_LBL'),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 8.0),
  //                               child: Row(
  //                                 children: [
  //                                   Container(
  //                                     margin:
  //                                         EdgeInsetsDirectional.only(start: 20),
  //                                     width: deviceWidth! * 0.35,
  //                                     child: OutlinedButton(
  //                                       onPressed: () {
  //                                         context
  //                                             .read<UserProvider>()
  //                                             .setPincode('');
  //
  //                                         context
  //                                             .read<HomeProvider>()
  //                                             .setSecLoading(true);
  //                                         getSection();
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: Text(
  //                                           getTranslated(context, 'All')!),
  //                                     ),
  //                                   ),
  //                                   Spacer(),
  //                                   SimBtn(
  //                                       size: 0.35,
  //                                       title: getTranslated(context, 'APPLY'),
  //                                       onBtnSelected: () async {
  //                                         if (validateAndSave()) {
  //                                           // validatePin(curPin);
  //                                           context
  //                                               .read<HomeProvider>()
  //                                               .setSecLoading(true);
  //                                           getSection();
  //
  //                                           context
  //                                               .read<HomeProvider>()
  //                                               .setSellerLoading(true);
  //                                           sellerList.clear();
  //                                           getSeller();
  //                                           Navigator.pop(context);
  //                                         }
  //                                       }),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         )),
  //                   ))
  //             ]),
  //           );
  //           //});
  //         });
  //       });
  // }

  bool validateAndSave() {
    final form = _formkey.currentState!;

    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void getSlider() {
    Map map = Map();

    apiBaseHelper.postAPICall(getSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        pages = homeSliderList.map((slider) {
          return _buildImagePageItem(slider);
        }).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }

  void getCat() {
    String? stateid =  prefs!.getString('stateId');
    Map parameter = {
      CAT_FILTER: "false",
      'state_id':'${stateid}',
    };
    print("cat ${getCatApi}");
    print("checking parameter here ${parameter.toString()}");
    apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        catList =
            (data as List).map((data) => new Product.fromCat(data)).toList();

        if (getdata.containsKey("popular_categories")) {
          var data = getdata["popular_categories"];
          popularList =
              (data as List).map((data) => new Product.fromCat(data)).toList();

          if (popularList.length > 0) {
            // Product pop =
            // new Product.popular("Popular", imagePath + "popular.svg");
            // catList.insert(0, pop);
            context.read<CategoryProvider>().setSubList(popularList);
          }
        }
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setCatLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setCatLoading(false);
    });
  }

  sectionLoading() {

    return Column(
        children: [0, 1, 2, 3, 4]
            .map((_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: double.infinity,
                        height: 18.0,
                        color: Theme.of(context).colorScheme.white,
                      ),
                      GridView.count(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 1.0,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children: List.generate(
                          4,
                              (index) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color:
                              Theme.of(context).colorScheme.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            sliderLoading()
            //offerImages.length > index ? _getOfferImage(index) : Container(),
          ],
        ))
            .toList());
  }

  void getSeller() {
    String pin = context.read<UserProvider>().curPincode;
    String? stateid =  prefs!.getString('stateId');
    Map parameter = {};
    if (pin != '') {
      parameter = {
        ZIPCODE: pin,
        'state_id':'${stateid}'
      };
    }
    apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        print("Seller Parameter =========> $parameter");
        print("Seller Data=====================> : $data ");
        sellerList = (data as List).map((data) => new Product.fromSeller(data)).toList();

      } else {
        setSnackbar(msg!, context);
      }
      context.read<HomeProvider>().setSellerLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSellerLoading(false);
    });
  }

  _seller() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sellerList.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTranslated(context, 'SHOP_BY_SELLER')!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.fontColor,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    child: Text(getTranslated(context, 'VIEW_ALL')!),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerList()));
                    },
                  )
                ],
              ),
            ) : Container(),
            Container(
              height: 100,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: ListView.builder(
                itemCount: sellerList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: GestureDetector(
                      onTap: () {
                        print(sellerList[index].open_close_status);
                        if(sellerList[index].open_close_status == '1'){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerProfile(
                                    sellerStoreName: sellerList[index].store_name ?? "",
                                    sellerRating: sellerList[index]
                                        .seller_rating ??
                                        "",
                                    sellerImage: sellerList[index]
                                        .seller_profile ??
                                        "",
                                    sellerName:
                                    sellerList[index].seller_name ??
                                        "",
                                    sellerID:
                                    sellerList[index].seller_id,
                                    storeDesc: sellerList[index]
                                        .store_description,
                                  )));
                        } else {
                          showToast("Currently Store is Off");
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                bottom: 5.0),
                            child: new ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: new FadeInImage(
                                fadeInDuration:
                                Duration(milliseconds: 150),
                                image: CachedNetworkImageProvider(
                                  sellerList[index].seller_profile!,
                                ),
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.contain,
                                imageErrorBuilder:
                                    (context, error, stackTrace) =>
                                    erroWidget(50),
                                placeholder: placeHolder(50),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              sellerList[index].seller_name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fontColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      selector: (_, homeProvider) => homeProvider.sellerLoading,
    );
  }
  void paytmPayment() async {
    String? paymentResponse;
    context.read<CartProvider>().setProgress(true);

    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (payTesting
        ? 'https://securegw-stage.paytm.in'
        : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var parameter = {
      AMOUNT: totalPrice.toString(),
      USER_ID: CUR_USERID,
      ORDER_ID: orderId
    };

    try {
      final response = await post(
        getPytmChecsumkApi,
        body: parameter,
        headers: headers,
      );

      var getdata = json.decode(response.body);

      bool error = getdata["error"];

      if (!error) {
        String txnToken = getdata["txn_token"];

        setState(() {
          paymentResponse = txnToken;
        });
        // orderId, mId, txnToken, txnAmount, callback
        print(
            "para are $paytmMerId # $orderId # $txnToken # ${totalPrice.toString()} # $callBackUrl  $payTesting");
        var paytmResponse = Paytm.payWithPaytm(
            callBackUrl: callBackUrl,
            mId: paytmMerId!,
            orderId: orderId,
            txnToken: txnToken,
            txnAmount: totalPrice.toString(),
            staging: payTesting);
        paytmResponse.then((value) {
          print("valie is $value");
          value.forEach((key, value) {
            print("key is $key");
            print("value is $value");
          });
          context.read<CartProvider>().setProgress(false);

          _placeOrder = true;
          setState(() {});
          checkoutState!(() {
            if (value['error']) {
              paymentResponse = value['errorMessage'];

              if (value['response'] != null)
                addTransaction(value['response']['TXNID'], orderId,
                    value['response']['STATUS'] ?? '', paymentResponse, false);
            } else {
              if (value['response'] != null) {
                paymentResponse = value['response']['STATUS'];
                if (paymentResponse == "TXN_SUCCESS")
                  placeOrder(value['response']['TXNID']);
                else
                  addTransaction(
                      value['response']['TXNID'],
                      orderId,
                      value['response']['STATUS'],
                      value['errorMessage'] ?? '',
                      false);
              }
            }

            // setSnackbar(paymentResponse!, _checkscaffoldKey);
          });
        });
      } else {
        checkoutState!(() {
          _placeOrder = true;
        });


        context.read<CartProvider>().setProgress(false);

        // setSnackbar(getdata["message"], _checkscaffoldKey);
      }
    } catch (e) {
      print(e);
    }
  }


  Future<void> placeOrder(String? tranId,{UpiTransactionResponse? upiResponse}) async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stateid = prefs.getString('stateId');
    if (_isNetworkAvail) {
      context.read<CartProvider>().setProgress(true);

      SettingProvider settingsProvider =
      Provider.of<SettingProvider>(this.context, listen: false);

      String? mob = settingsProvider.mobile;

      String? varientId, quantity;

      List<SectionModel> cartList = context.read<CartProvider>().cartList;
      for (SectionModel sec in cartList) {
        varientId = varientId != null
            ? varientId + "," + sec.varientId!
            : sec.varientId;
        quantity = quantity != null ? quantity + "," + sec.qty! : sec.qty;
      }
      String? payVia;
      if (payMethod == getTranslated(context, 'COD_LBL'))
        payVia = "COD";
      else if (payMethod!.toLowerCase().contains("upi"))
        payVia = "UPI";
      else if (payMethod == getTranslated(context, 'PAYPAL_LBL'))
        payVia = "PayPal";
      else if (payMethod == getTranslated(context, 'PAYUMONEY_LBL'))
        payVia = "PayUMoney";
      else if (payMethod == getTranslated(context, 'RAZORPAY_LBL'))
        payVia = "RazorPay";
      else if (payMethod == getTranslated(context, 'STRIPE_LBL'))
        payVia = "Stripe";
      else if (payMethod == getTranslated(context, 'PAYTM_LBL'))
        payVia = "Paytm";
      else if (payMethod == "Wallet")
        payVia = "Wallet";
      else if (payMethod == getTranslated(context, 'BANKTRAN'))
        payVia = "bank_transfer";

      String? fPrice,fprice1;

      if(dCharge == null || dCharge == "") {
        double dPrice = double.parse(finalAmount.toString()) + 0.0;
        fPrice = dPrice.toString();
        double dprice1 = double.parse(totalamount.toString()) + 0.0;
        fprice1 = dprice1.toString();
      }
      else{
        double dPrice = double.parse(finalAmount.toString()) +
            double.parse(dCharge.toString());
        fPrice = dPrice.toString();
        print("this is dPrice${dPrice.toString()}");
        print("this is dPrice ${fPrice.toString()}");
        print("this is dPrice${dCharge.toString()}");
        double dprice1 = double.parse(totalamount.toString()) + double.parse(dCharge.toString());
        fprice1 = dprice1.toString();
        print("this is price${dprice1.toString()}");
        print("this is Fprice ${fprice1.toString()}");

      }



      try {
        var parameter = {
          USER_ID: CUR_USERID,
          MOBILE: mob,
          PRODUCT_VARIENT_ID: varientId,
          QUANTITY: quantity,
          TOTAL: oriPrice.toString(),
          FINAL_TOTAL: payMethod == "Cash On Delivery" ? "${ totalamount.toString()}" : finalAmount.toString(),
          DEL_CHARGE: dCharge.toString(),
          TAX_PER: taxPer.toString(),
          PAYMENT_METHOD: payVia,
          ADD_ID: selAddress,
          ISWALLETBALUSED: isUseWallet! ? "1" : "0",
          WALLET_BAL_USED: usedBal.toString(),
          ORDER_NOTE: noteC.text,
          'state_id':'${stateid}'
        };

        if (isTimeSlot!) {
          parameter[DELIVERY_TIME] = selTime ?? 'Anytime';
          parameter[DELIVERY_DATE] = selDate ?? '';
        }
        if (isPromoValid!) {
          parameter[PROMOCODE] = promocode;
          parameter[PROMO_DIS] = promoAmt.toString();
        }

        if (payMethod == getTranslated(context, 'PAYPAL_LBL')) {
          parameter[ACTIVE_STATUS] = WAITING;
        } else if (payMethod == getTranslated(context, 'STRIPE_LBL')) {
          if (tranId == "succeeded")
            parameter[ACTIVE_STATUS] = PLACED;
          else
            parameter[ACTIVE_STATUS] = WAITING;
        } else if (payMethod == getTranslated(context, 'BANKTRAN')) {
          parameter[ACTIVE_STATUS] = WAITING;
        }
        print(parameter.toString());
        print("PLACE ORDER PARAMETER====" + parameter.toString());

        Response response =
        await post(placeOrderApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));
        print("plllllllllllllllllllllllllll${placeOrderApi.toString()}");
        print(parameter.toString());
        _placeOrder = true;
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            String orderId = getdata["order_id"].toString();
            if (payMethod == getTranslated(context, 'RAZORPAY_LBL')) {
              addTransaction(tranId, orderId, SUCCESS, msg, true);
            }else if (payMethod!.toLowerCase().contains("upi")) {
              if(upiResponse!=null){
                addTransaction(upiResponse.txnId, orderId, SUCCESS, msg, true);
              }
            }
            else if (payMethod == getTranslated(context, 'PAYPAL_LBL')) {
              paypalPayment(orderId);
            } else if (payMethod == getTranslated(context, 'STRIPE_LBL')) {
              addTransaction(stripePayId, orderId,
                  tranId == "succeeded" ? PLACED : WAITING, msg, true);
            } else if (payMethod == getTranslated(context, 'PAYSTACK_LBL')) {
              addTransaction(tranId, orderId, SUCCESS, msg, true);
            } else if (payMethod == getTranslated(context, 'PAYTM_LBL')) {
              addTransaction(tranId, orderId, SUCCESS, msg, true);
            } else {
              context.read<UserProvider>().setCartCount("0");

              clearAll();

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => OrderSuccess()),
                  ModalRoute.withName('/home'));
            }
          } else {
            // setSnackbar(msg!, _checkscaffoldKey);
            context.read<CartProvider>().setProgress(false);
          }
        }
      } on TimeoutException catch (_) {
        if (mounted)
          checkoutState!(() {
            _placeOrder = true;
          });
        context.read<CartProvider>().setProgress(false);
      }
    } else {
      if (mounted)
        checkoutState!(() {
          _isNetworkAvail = false;
        });
    }
  }

  doPayment() {
    print("this is upi ID ${upi.toString()}");
    print("pay method here" + payMethod.toString());
    if (payMethod == getTranslated(context, 'PAYPAL_LBL')) {
      placeOrder('');
    }else if (payMethod!.toLowerCase().contains("upi")) {
      Navigator.pop(context);
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAA${totalamount}");
      UpiPayment upiPayment = new UpiPayment(remainingAmount!,
        upi.toString(),
        context, (value) {
          if(value.status==UpiTransactionStatus.success){
            Navigator.pop(context);
            placeOrder('',upiResponse: value);
          } else if(value.status==UpiTransactionStatus.failure){
            setState((){
              _placeOrder = true;
            });
            Fluttertoast.showToast(msg: "Payment Failed");
          }
          else if(value.status == UpiTransactionStatus.failedToLaunch){
            setState((){
              _placeOrder = true;
            });
            Fluttertoast.showToast(msg: "Payment Failed");
          }
          else{
            setState((){
              _placeOrder = true;
            });
            Fluttertoast.showToast(msg: "Payment Failed");
          }

        },
        remainingAmount.toString(),



      );
      print("final upi payment check ${upiPayment.toString()} and ${upiPayment.advance} and ${upiPayment.amount}");
      upiPayment.initPayment();
      print(upiPayment.toString());
    }
    // else if (payMethod == getTranslated(context, 'RAZORPAY_LBL'))
    //   razorpayPayment();
    else if (payMethod == getTranslated(context, 'PAYSTACK_LBL'))
      paystackPayment(context);
    else if (payMethod == getTranslated(context, 'FLUTTERWAVE_LBL'))
      flutterwavePayment();
    else if (payMethod == getTranslated(context, 'STRIPE_LBL'))
      stripePayment();
    else if (payMethod == getTranslated(context, 'PAYTM_LBL'))
      paytmPayment();
    /*  else if (payMethod ==
                                                        getTranslated(
                                                            context, 'GPAY')) {
                                                      googlePayment(
                                                          "google_pay");
                                                    } else if (payMethod ==
                                                        getTranslated(context,
                                                            'APPLEPAY')) {
                                                      googlePayment(
                                                          "apple_pay");
                                                    }*/

    else if (payMethod == getTranslated(context, 'BANKTRAN'))
      bankTransfer();
    // else
    //  // placeOrder('');
  }
  paystackPayment(BuildContext context) async {
    context.read<CartProvider>().setProgress(true);

    String? email = context.read<SettingProvider>().email;

    Charge charge = Charge()
      ..amount = totalPrice.toInt()
      ..reference = _getReference()
      ..email = email;

    try {
      CheckoutResponse response = await paystackPlugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );
      if (response.status) {
        placeOrder(response.reference);
      } else {
        // setSnackbar(response.message, _checkscaffoldKey);
        if (mounted)
          setState(() {
            _placeOrder = true;
          });
        context.read<CartProvider>().setProgress(false);
      }
    } catch (e) {
      context.read<CartProvider>().setProgress(false);
      rethrow;
    }
  }
  Future<void> flutterwavePayment() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        context.read<CartProvider>().setProgress(true);

        var parameter = {
          AMOUNT: totalPrice.toString(),
          USER_ID: CUR_USERID,
        };
        Response response =
        await post(flutterwaveApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);

          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            var data = getdata["link"];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PaypalWebview(
                      url: data,
                      from: "order",
                    )));
          } else {
            // setSnackbar(msg!, _checkscaffoldKey);
          }

          context.read<CartProvider>().setProgress(false);
        }
      } on TimeoutException catch (_) {
        context.read<CartProvider>().setProgress(false);
        // setSnackbar(getTranslated(context, 'somethingMSg')!, _checkscaffoldKey);
      }
    } else {
      if (mounted)
        checkoutState!(() {
          _isNetworkAvail = false;
        });
    }
  }
  stripePayment() async {
    context.read<CartProvider>().setProgress(true);

    var response = await StripeService.payWithNewCard(
        amount: (totalPrice.toInt() * 100).toString(),
        currency: stripeCurCode,
        from: "order",
        context: context);

    if (response.message == "Transaction successful") {
      placeOrder(response.status);
    } else if (response.status == 'pending' || response.status == "captured") {
      placeOrder(response.status);
    } else {
      if (mounted)
        setState(() {
          _placeOrder = true;
        });

      context.read<CartProvider>().setProgress(false);
    }
    // setSnackbar(response.message!, _checkscaffoldKey);
  }
  void bankTransfer() {
    showGeneralDialog(
        barrierColor: Theme.of(context).colorScheme.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                            child: Text(
                              getTranslated(context, 'BANKTRAN')!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fontColor),
                            )),
                        Divider(
                            color: Theme.of(context).colorScheme.lightBlack),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: Text(getTranslated(context, 'BANK_INS')!,
                                style: Theme.of(context).textTheme.caption)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Text(
                            getTranslated(context, 'ACC_DETAIL')!,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .fontColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            getTranslated(context, 'ACCNAME')! +
                                " : " +
                                acName!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            getTranslated(context, 'ACCNO')! + " : " + acNo!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            getTranslated(context, 'BANKNAME')! +
                                " : " +
                                bankName!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            getTranslated(context, 'BANKCODE')! +
                                " : " +
                                bankNo!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            getTranslated(context, 'EXTRADETAIL')! +
                                " : " +
                                exDetails!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        )
                      ]),
                  actions: <Widget>[
                    new TextButton(
                        child: Text(getTranslated(context, 'CANCEL')!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.lightBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          checkoutState!(() {
                            _placeOrder = true;
                          });
                          Navigator.pop(context);
                        }),
                    new TextButton(
                        child: Text(getTranslated(context, 'DONE')!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(context);

                          context.read<CartProvider>().setProgress(true);

                          placeOrder('');
                        })
                  ],
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  Future<void> addTransaction(String? tranId, String orderID, String? status,
      String? msg, bool redirect) async {
    try {
      print("trans api ${addTransactionApi}");

      var parameter = {
        USER_ID: CUR_USERID,
        ORDER_ID: orderID,
        TYPE: payMethod,
        TXNID: tranId,
        'advance_amount': totalPrice.toString(),
        STATUS: status,
        MSG: msg
      };
      print("para ${parameter}");
      Response response =
      await post(addTransactionApi, body: parameter, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String? msg1 = getdata["message"];
      if (!error) {
        if (redirect) {
          // CUR_CART_COUNT = "0";

          context.read<UserProvider>().setCartCount("0");
          clearAll();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OrderSuccess()),
              ModalRoute.withName('/home'));
        }
      } else {
        // setSnackbar(msg1!, _checkscaffoldKey);
      }
    } on TimeoutException catch (_) {
      // setSnackbar(getTranslated(context, 'somethingMSg')!, _checkscaffoldKey);
    }
  }

  Future<void> paypalPayment(String orderId) async {
    try {
      var parameter = {
        USER_ID: CUR_USERID,
        ORDER_ID: orderId,
        AMOUNT: totalPrice.toString()
      };
      Response response =
      await post(paypalTransactionApi, body: parameter, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        String? data = getdata["data"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PaypalWebview(
                  url: data,
                  from: "order",
                  orderId: orderId,
                )));
      } else {
        // setSnackbar(msg!, _checkscaffoldKey);
      }
      context.read<CartProvider>().setProgress(false);
    } on TimeoutException catch (_) {
      // setSnackbar(getTranslated(context, 'somethingMSg')!, _checkscaffoldKey);
    }
  }
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }



}

