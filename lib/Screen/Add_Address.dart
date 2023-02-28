import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Model/PincodeModel.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../Helper/AppBtn.dart';
import '../Helper/Color.dart';
import '../Helper/String.dart';
import '../Model/GetStateModel.dart';
import '../Model/User.dart';
import 'Cart.dart';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  final bool? update;
  final int? index;

  const AddAddress({Key? key, this.update, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateAddress();
  }
}

String? latitude, longitude, state, country;

class StateAddress extends State<AddAddress> with TickerProviderStateMixin {
  String? name,
      mobile,
      city,
      area,
      address,
      pincode,
      landmark,
      altMob,
      type = "Home",
      isDefault;
  bool checkedDefault = false, isArea = false;
  bool _isProgress = false;
  StateSetter? areaState, cityState;

  String? selectedStates;
  //bool _isLoading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<User> cityList = [];
  List<User> areaList = [];
  List<User> areaSearchList = [];
  List<User> citySearchLIst = [];
  bool cityLoading = true, areaLoading = true;
  TextEditingController? nameC,
      mobileC,
      pincodeC,
      addressC,
      landmarkC,
      cityC,
      stateC,
      countryC,
      altMobC;
  int? selectedType = 1;
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  FocusNode? nameFocus,
      monoFocus,
      almonoFocus,
      addFocus,
      landFocus,
      locationFocus = FocusNode();
  User? selArea;
  int? selAreaPos = -1, selCityPos = -1;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  GetStateModel? getStateModel;

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
        getStateModel = jsonResponse;
      });
      // print("okkk ${getStateModel} and ${getStateModel.date}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();

    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController!,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
    callApi();
    getState();
    _areaController.addListener(() {
      areaSearch(_areaController.text);
    });

    _cityController.addListener(() {
      citySearch(_cityController.text);
    });

    mobileC = new TextEditingController();
    nameC = new TextEditingController();
    altMobC = new TextEditingController();
    pincodeC = new TextEditingController();
    addressC = new TextEditingController();
    stateC = new TextEditingController();
    countryC =  TextEditingController(text: "India");
    landmarkC = new TextEditingController();
    cityC = new TextEditingController();

    if (widget.update!) {
      User item = addressList[widget.index!];

      mobileC!.text = item.mobile!;
      nameC!.text = item.name!;
      altMobC!.text = item.altMob!;
      landmarkC!.text = item.landmark!;
      cityC!.text = item.city!;
      pincodeC!.text = item.pincode!;
      addressC!.text = item.address!;
      stateC!.text = item.state!;
      countryC!.text = item.country!;
      stateC!.text = item.state!;
      latitude = item.latitude;
      longitude = item.longitude;
      selectedStates =  item.state.toString();
      type = item.type;
      city = item.cityId;
      area = item.areaId;

      if (type!.toLowerCase() == HOME.toLowerCase()) {
        selectedType = 1;
      } else if (type!.toLowerCase() == OFFICE.toLowerCase()) {
        selectedType = 2;
      } else {
        selectedType = 3;
      }

      checkedDefault = item.isDefault == "1" ? true : false;
    } else {
      //getCurrentLoc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: getSimpleAppBar(getTranslated(context, "ADDRESS_LBL")!, context),
        body: _isNetworkAvail ? _showContent() : noInternet(context),
      ),
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
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  addBtn() {
    return AppBtn(
      title: widget.update!
          ? getTranslated(context, 'UPDATEADD')
          : getTranslated(context, 'ADDADDRESS'),
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () {
        validateAndSubmit();
      },
    );
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
     //  checkPinCode();
      await checkNetwork();
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;

    form.save();
    if (form.validate()) {
      // if (city == null || city!.isEmpty) {
      //   setSnackbar(getTranslated(context, 'cityWarning')!);
      // } else
      //   if (area == null || area!.isEmpty) {
      //   setSnackbar(getTranslated(context, 'areaWarning')!);
      // } else
      //   if (latitude == null || longitude == null) {
      //   setSnackbar(getTranslated(context, 'locationWarning')!);
      // } else {
         return true;
      // }
    }
    return false;
  }
    String? lat, long;
  checkPinCode()async{
    var headers = {
      'Cookie': 'ci_session=3d38f29c3d3471b980a5a47c7c30aaf9dd943c4f'
    };
    var request = http.MultipartRequest('POST',Uri.parse('https://developmentalphawizz.com/feedmart/app/v1/api/check_pincode'));
    request.fields.addAll({
      'pincode': '${pincodeC!.text}'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("sss ${response.statusCode}");
    if (response.statusCode == 200) {
      print("sss ${response.stream.toString()}");
      var jsonResponse = await response.stream.bytesToString();
      print("sfsfs ${jsonResponse}");
      var finalResult1 = json.decode(jsonResponse);
      if(finalResult1['status'] == false){
        Fluttertoast.showToast(msg: "${finalResult1['message']}");
      }
      final finalResult = PincodeModel.fromJson(json.decode(jsonResponse));
      print("check pincode data ${finalResult.message} and ${finalResult.status}");
      setState(() {
        lat = finalResult.data!.lat.toString();
        long = finalResult.data!.lng.toString();
      });
      print("PPPPPPPPPPPPP${lat} AAAAAAAAAAAAA ${long}");
      if(lat == null || lat == "" || long == null || long ==""){
        return Fluttertoast.showToast(msg: "Invalid Pincode");
      }
      else{
        addNewAddress();
      }
      // addNewAddress();
    }
    else {
      Fluttertoast.showToast(msg: '${response.reasonPhrase}');
      //print(response.reasonPhrase);
    }
  }

  Future<void> checkNetwork() async {

    bool avail = await isNetworkAvailable();
    if (avail) {
      checkPinCode();
      // if(lat == null || lat == "" || long == null || long ==""){
      //   Future.delayed(Duration(seconds: 1),(){
      //     return Fluttertoast.showToast(msg: "Invalid Pincode");
      //   });
      // }
      // else{
      //   addNewAddress();
      // }

    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
        await buttonController!.reverse();
      });
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  setUserName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: nameFocus,
            controller: nameC,
            textCapitalization: TextCapitalization.words,
            validator: (val) => validateUserName(
                val!,
                getTranslated(context, 'USER_REQUIRED'),
                getTranslated(context, 'USER_LENGTH')),
            onSaved: (String? value) {
              name = value;
            },
            onFieldSubmitted: (v) {
              _fieldFocusChange(context, nameFocus!, monoFocus);
            },
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "NAME_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: getTranslated(context, 'NAME_LBL'),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: mobileC,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            focusNode: monoFocus,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            validator: (val) => validateMob(
                val!,
                getTranslated(context, 'MOB_REQUIRED'),
                getTranslated(context, 'VALID_MOB')),
            onSaved: (String? value) {
              mobile = value;
            },
            onFieldSubmitted: (v) {
              _fieldFocusChange(context, monoFocus!, almonoFocus);
            },
            decoration: InputDecoration(
                label: Text(getTranslated(context, "MOBILEHINT_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: getTranslated(context, 'MOBILEHINT_LBL'),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  setAltMobileNo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: altMobC,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            focusNode: almonoFocus,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            // validator: (val) => validateMob(
            //     val!,
            //     getTranslated(context, 'MOB_REQUIRED'),
            //     getTranslated(context, 'VALID_MOB')),
            onSaved: (String? value) {
              altMob = value;
            },
            onFieldSubmitted: (v) {
              _fieldFocusChange(context, almonoFocus!, almonoFocus);
            },
            decoration: InputDecoration(
                label: Text(getTranslated(context, "ALTMOBILEHINT_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: getTranslated(context, 'ALTMOBILEHINT_LBL'),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  areaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            areaState = setStater;
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5.0,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    child: Text(
                      getTranslated(context, 'AREASELECT_LBL')!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle1!
                          .copyWith(
                              color: Theme.of(context).colorScheme.fontColor),
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.fontColor,
                    ),
                    controller: _areaController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                      prefixIcon:
                          Icon(Icons.search, color: colors.primary, size: 17),
                      hintText: getTranslated(context, 'SEARCH_LBL'),
                      hintStyle: TextStyle(
                        color: colors.primary.withOpacity(0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.white),
                      ),
                    ),
                    // onChanged: (query) => updateSearchQuery(query),
                  ),
                  Divider(color: Theme.of(context).colorScheme.lightBlack),
                  areaLoading
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (areaSearchList.length > 0)
                          ? Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: getAreaList()),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: getNoItem(context),
                            )
                ],
              ),
            );
          },
        );
      },
    );
  }

  cityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            cityState = setStater;
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    child: Text(
                      getTranslated(context, 'CITYSELECT_LBL')!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle1!
                          .copyWith(
                              color: Theme.of(context).colorScheme.fontColor),
                    ),
                  ),
                  TextField(
                    controller: _cityController,
                    autofocus: false,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.fontColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                      prefixIcon:
                          Icon(Icons.search, color: colors.primary, size: 17),
                      hintText: getTranslated(context, 'SEARCH_LBL'),
                      hintStyle:
                          TextStyle(color: colors.primary.withOpacity(0.5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.white),
                      ),
                    ),
                    // onChanged: (query) => updateSearchQuery(query),
                  ),
                  Divider(color: Theme.of(context).colorScheme.lightBlack),
                  cityLoading
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (citySearchLIst.length > 0)
                          ? Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: setCities(),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: getNoItem(context),
                            )
                ],
              ),
            );
          },
        );
      },
    );
  }

  getAreaList() {
    return areaSearchList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                if (mounted) {
                  setState(
                    () {
                      //selectedDelBoy = index;
                      selAreaPos = index;
                      Navigator.of(context).pop();

                      selArea = areaSearchList[selAreaPos!];
                      area = selArea!.id;
                      pincodeC!.text = selArea!.pincode!;
                    },
                  );
                }
              },
              child: Container(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    areaSearchList[index].name!,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  // getCityList() {
  //   return citySearchLIst
  //       .asMap()
  //       .map(
  //         (index, element) => MapEntry(
  //           index,
  //           InkWell(
  //             onTap: () {
  //               if (mounted) {
  //                 setState(
  //                   () {
  //                     isArea = false;
  //                     selCityPos = index;
  //                     selAreaPos = null;
  //                     selArea = null;
  //                     pincodeC!.text = "";
  //                     Navigator.of(context).pop();
  //                   },
  //                 );
  //               }
  //               city = citySearchLIst[selCityPos!].id;
  //
  //               getArea(city, true);
  //             },
  //             child: Container(
  //               width: double.maxFinite,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   citySearchLIst[index].name!,
  //                   style: Theme.of(context).textTheme.subtitle2,
  //                 ),State
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //       .values
  //       .toList();
  // }
  //
  // setCities() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).colorScheme.white,
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: Padding(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 10.0,
  //           ),
  //           child: GestureDetector(
  //             child: InputDecorator(
  //                 decoration: InputDecoration(
  //                   fillColor: Theme.of(context).colorScheme.white,
  //                   isDense: true,
  //                   border: InputBorder.none,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text(
  //                             getTranslated(context, 'CITYSELECT_LBL')!,
  //                             style: Theme.of(context).textTheme.caption,
  //                           ),
  //                           Text(
  //                               selCityPos != null && selCityPos != -1
  //                                   ? citySearchLIst[selCityPos!].name!
  //                                   : "",
  //                               style: TextStyle(
  //                                   color: selCityPos != null
  //                                       ? Theme.of(context)
  //                                           .colorScheme
  //                                           .fontColor
  //                                       : Colors.grey)),
  //                         ],
  //                       ),
  //                     ),
  //                     Icon(Icons.keyboard_arrow_right)
  //                   ],
  //                 )),
  //             onTap: () {
  //               cityDialog();
  //             },
  //           )),
  //     ),
  //   );
  // }



  setArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: GestureDetector(
              child: InputDecorator(
                  decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.white,
                      isDense: true,
                      border: InputBorder.none),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTranslated(context, 'AREASELECT_LBL')!,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                                selAreaPos != null && selAreaPos != -1
                                    ? areaSearchList[selAreaPos!].name!
                                    : "",
                                style: TextStyle(
                                    color: selAreaPos != null
                                        ? Theme.of(context)
                                            .colorScheme
                                            .fontColor
                                        : Colors.grey)),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  )),
              onTap: () {
                areaDialog();
              },
            )),
      ),
    );
  }

  setAddress() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: colors.disableColor,
                // color: Theme.of(context).colorScheme.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Theme.of(context).colorScheme.fontColor),
                  focusNode: addFocus,
                  controller: addressC,
                  validator: (val) => validateField(
                      val!, getTranslated(context, 'FIELD_REQUIRED')),
                  onSaved: (String? value) {
                    address = value;
                  },
                  onFieldSubmitted: (v) {
                    _fieldFocusChange(context, addFocus!, locationFocus);
                  },
                  decoration: InputDecoration(
                    label: Text(getTranslated(context, "ADDRESS_LBL")!),
                    fillColor: Theme.of(context).colorScheme.white,
                    isDense: true,
                    hintText: getTranslated(context, 'ADDRESS_LBL'),
                    border: InputBorder.none,
                    // suffixIcon: IconButton(
                    //   icon: Icon(
                    //     Icons.my_location,
                    //     color: colors.primary,
                    //   ),
                    //   focusNode: locationFocus,
                    //   onPressed: () async {
                    //     Position position = await Geolocator.getCurrentPosition(
                    //         desiredAccuracy: LocationAccuracy.high);
                    //
                    //     await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Map(
                    //                   latitude:
                    //                       latitude == null || latitude == ""
                    //                           ? position.latitude
                    //                           : double.parse(latitude!),
                    //                   longitude:
                    //                       longitude == null || longitude == ""
                    //                           ? position.longitude
                    //                           : double.parse(longitude!),
                    //                   from:
                    //                       getTranslated(context, 'ADDADDRESS'),
                    //                 )));
                    //     if (mounted) setState(() {});
                    //     List<Placemark> placemark =
                    //         await placemarkFromCoordinates(
                    //             double.parse(latitude!),
                    //             double.parse(longitude!));
                    //
                    //     var address;
                    //     address = placemark[0].name;
                    //     address = address + "," + placemark[0].subLocality;
                    //     address = address + "," + placemark[0].locality;
                    //
                    //     state = placemark[0].administrativeArea;
                    //     country = placemark[0].country;
                    //     // pincode = placemark[0].postalCode;
                    //     //  address = placemark[0].name;
                    //     if (mounted) {
                    //       setState(() {
                    //         countryC!.text = country!;
                    //         stateC!.text = state!;
                    //         addressC!.text = address;
                    //         //  pincodeC!.text = pincode!;
                    //         // addressC!.text = address!;
                    //       });
                    //     }
                    //   },
                    // ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  setPincode() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: TextFormField(
              maxLength: 6,
              validator: (v){
                if(v!.length<6){
                  return "Enter Valid Pincode";
                }
              },
              //readOnly: true,
              keyboardType: TextInputType.number,
              controller: pincodeC,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Theme.of(context).colorScheme.fontColor),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (String? value) {
                // pincode = value;
              },
              // validator: (val) => validatePincode(val, getTranslated(context, 'PIN_REQUIRED')),
              decoration: InputDecoration(
                counterText: "",
                  label: Text(getTranslated(context, "PINCODEHINT_LBL")!),
                  fillColor: Theme.of(context).colorScheme.white,
                  isDense: true,
                  hintText: getTranslated(context, 'PINCODEHINT_LBL'),
                  border: InputBorder.none),
            )),
      ),
    );
  }

  Future<void> callApi() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      await getCities();
      if (widget.update!) {
        getArea(addressList[widget.index!].cityId, false);
      }
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  Future<void> getCities() async {
    try {
      Response response = await post(getCitiesApi, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        cityList =
            (data as List).map((data) => new User.fromJson(data)).toList();

        citySearchLIst.addAll(cityList);
      } else {
        setSnackbar(msg!);
      }
      cityLoading = false;
      if (cityState != null) cityState!(() {});
      if (mounted) setState(() {});

      if (widget.update!) {
        selCityPos = citySearchLIst
            .indexWhere((f) => f.id == addressList[widget.index!].cityId);

        if (selCityPos == -1) selCityPos = null;
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
    }
  }

  Future<void> getArea(String? city, bool clear) async {
    try {
      var data = {
        ID: city,
      };

      Response response =
          await post(getAreaByCityApi, body: data, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String? msg = getdata["message"];

      if (!error) {
        var data = getdata["data"];
        areaList.clear();
        if (clear) {
          area = null;
          selArea = null;
        }
        areaList =
            (data as List).map((data) => new User.fromJson(data)).toList();

        areaSearchList.addAll(areaList);

        if (widget.update!)
          for (User item in addressList) {
            for (int i = 0; i < areaSearchList.length; i++) {
              if (areaSearchList[i].id == item.areaId) {
                selArea = areaSearchList[i];
                selAreaPos = i;
              }
            }
          }
      } else {
        setSnackbar("msg!");
      }
      areaLoading = false;

      if (mounted) {
        setState(() {
          isArea = true;
        });
        if (areaState != null && mounted) areaState!(() {});
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: colors.primary),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 1.0,
    ));
  }

  setLandmark() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: landFocus,
            controller: landmarkC,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            validator: (val) =>
                validateField(val!, getTranslated(context, 'FIELD_REQUIRED')),
            onSaved: (String? value) {
              landmark = value;
            },
            decoration: InputDecoration(
                label: Text("Landmark"),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: "Landmark",
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  setCities() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: landFocus,
            controller: cityC,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            validator: (val) =>
                validateField(val!, getTranslated(context, 'FIELD_REQUIRED')),
            onSaved: (String? value) {
              landmark = value;
            },
            decoration: InputDecoration(
                label: Text("City/District"),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: "City/District",
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  setStateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: getStateModel == null ? Container(child:Center(child:CircularProgressIndicator(),)) : DropdownButton(
            underline: Container(),
            value: selectedStates,
            icon: const Icon(Icons.keyboard_arrow_down_outlined),
            hint: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width/1.25,
                child: Text("Select state",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w100),)),
            items: getStateModel!.date!.map((items){
              return DropdownMenuItem(
                value: items.name,
                child: Padding(
                  padding:  EdgeInsets.only(left: 10),
                  child: Text(items.name.toString()),
                ),
              );
            }).toList(),
            onChanged: (newValue){
              setState((){
                selectedStates = newValue as String?;
                print("selected address ${selectedStates}");
               // prefs!.setString('stateId', '${selectedState}');
                Navigator.of(context);
               // callApi();
               //  Navigator.of(context);
              });
            }),
      ),
    );
  }

  setCountry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.disableColor,
          // color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: countryC,
            readOnly: true,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
            onSaved: (String? value) {
              country = value;
            },
            validator: (val) =>
                validateField(val!, getTranslated(context, 'FIELD_REQUIRED')),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "COUNTRY_LBL")!),
                fillColor: Theme.of(context).colorScheme.white,
                isDense: true,
                hintText: getTranslated(context, 'COUNTRY_LBL'),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  addDeliveryCharge(String addId)async{
    var headers = {
      'Cookie': 'ci_session=28b4afd1b1444d58aedc2e9270429038a57c62d2'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_delivery_charge'));
    request.fields.addAll({
      'address_id': '${CUR_USERID}',
      'user_id': '${addId}',
      'weight': ''
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("checking delivery Charge message ${jsonResponse['message']}");
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> addNewAddress() async {
    if (mounted) {
      setState(() {
        _isProgress = true;
      });
    }

    try {
      var data = {
        USER_ID: context.read<SettingProvider>().userId,
        NAME: name,
        MOBILE: mobile,
        ALT_MOBNO: altMob,
        LANDMARK: landmark,
        PINCODE: pincodeC!.text,
        CITY_ID: "",
        "city" : cityC!.text,
        AREA_ID: "",
        ADDRESS: address,
        STATE: '${selectedStates}',
        COUNTRY: country,
        TYPE: type,
        ISDEFAULT: checkedDefault.toString() == "true" ? "1" : "0",
        LATITUDE: lat,
        LONGITUDE: long
      };
      print(" parmeters here ${data}");
      print(widget.update.toString());
      if (widget.update!) data[ID] = addressList[widget.index!].id;
      print(widget.update.toString());

      Response response = await post(
              widget.update! ? updateAddressApi : getAddAddressApi,
              body: data,
              headers: headers)


          .timeout(Duration(seconds: timeOut));
         print(getAddAddressApi.toString());
      print("get Api ----------->: $widget.update");


      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        print("Get Address Data---------->: $getdata");
        bool error = getdata["error"];
        String? msg = getdata["message"];
        addDeliveryCharge(getdata['data'][0]['id'].toString());
        await buttonController!.reverse();
         print("add id here ${getdata['data'][0]['id']}");
        if (!error) {
          var data = getdata["data"];
          if (widget.update!){
            if (checkedDefault.toString() == "true" ||
                addressList.length == 1) {
              for (User i in addressList) {
                i.isDefault = "0";
              }
             // print("address id here ${getdata['data']['id']}");
             // addDeliveryCharge(getdata['data']['id']);
              addressList[widget.index!].isDefault = "1";

              if (!ISFLAT_DEL) {
               // if (oriPrice <
                  //  double.parse(addressList[selectedAddress!].freeAmt.toString())) {
                  // delCharge = double.parse(
                  //     addressList[selectedAddress!].deliveryCharge!);
                //} else {
                  delCharge = 0;
               // }
                totalPrice = totalPrice - delCharge;
              }

              User value = new User.fromAddress(data[0]);

              addressList[widget.index!] = value;

              selectedAddress = widget.index;
              selAddress = addressList[widget.index!].id;

              // if (!ISFLAT_DEL) {
              //   if (oriPrice <
              //       double.parse(addressList[selectedAddress!].freeAmt!)) {
              //     delCharge = double.parse(
              //         addressList[selectedAddress!].deliveryCharge!);
              //   } else {
              //     delCharge = 0;
              //   }
              //   totalPrice = totalPrice + delCharge;
              // }
            }
          } else {
            User value = new User.fromAddress(data[0]);
            addressList.add(value);

            if (checkedDefault.toString() == "true" ||
                addressList.length == 1) {
              for (User i in addressList) {
                i.isDefault = "0";
              }

              addressList[widget.index!].isDefault = "1";

              if (!ISFLAT_DEL && addressList.length != 1) {
                if (oriPrice <
                    double.parse(addressList[selectedAddress!].freeAmt!)) {
                  delCharge = double.parse(
                      addressList[selectedAddress!].deliveryCharge!);
                } else {
                  delCharge = 0;
                }

                totalPrice = totalPrice - delCharge;
              }

              selectedAddress = widget.index;
              selAddress = addressList[widget.index!].id;

              if (!ISFLAT_DEL) {
                // if (totalPrice <
                //     double.parse(addressList[selectedAddress!].freeAmt.toString())) {
                //   delCharge = double.parse(
                //       addressList[selectedAddress!].deliveryCharge!);
                // } else {
                //   delCharge = 0;
                // }
                totalPrice = totalPrice + delCharge;
              }
            }
          }

          if (mounted) {
            setState(() {
              _isProgress = false;
            });
          }
          Navigator.of(context).pop();
        } else {
          setSnackbar(msg!);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
    }
  }

  @override
  void dispose() {
    buttonController!.dispose();
    mobileC?.dispose();
    nameC?.dispose();
    stateC?.dispose();
    countryC?.dispose();
    altMobC?.dispose();
    landmarkC?.dispose();
    cityC?.dispose();
    addressC!.dispose();
    pincodeC?.dispose();

    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  typeOfAddress() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                child: Row(
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: selectedType,
                      activeColor: Theme.of(context).colorScheme.fontColor,
                      value: 1,
                      onChanged: (dynamic val) {
                        if (mounted) {
                          setState(() {
                            selectedType = val;
                            type = HOME;
                          });
                        }
                      },
                    ),
                    Expanded(child: Text(getTranslated(context, 'HOME_LBL')!))
                  ],
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectedType = 1;
                      type = HOME;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Row(
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: selectedType,
                      activeColor: Theme.of(context).colorScheme.fontColor,
                      value: 2,
                      onChanged: (dynamic val) {
                        if (mounted) {
                          setState(() {
                            selectedType = val;
                            type = OFFICE;
                          });
                        }
                      },
                    ),
                    Expanded(child: Text(getTranslated(context, 'OFFICE_LBL')!))
                  ],
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectedType = 2;
                      type = OFFICE;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Row(
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: selectedType,
                      activeColor: Theme.of(context).colorScheme.fontColor,
                      value: 3,
                      onChanged: (dynamic val) {
                        if (mounted) {
                          setState(() {
                            selectedType = val;
                            type = OTHER;
                          });
                        }
                      },
                    ),
                    Expanded(child: Text(getTranslated(context, 'OTHER_LBL')!))
                  ],
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectedType = 3;
                      type = OTHER;
                    });
                  }
                },
              ),
            )
          ],
        ));
  }

  defaultAdd() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: SwitchListTile(
          value: checkedDefault,
          activeColor: Theme.of(context).accentColor,
          dense: true,
          onChanged: (newValue) {
            if (mounted) {
              setState(() {
                checkedDefault = newValue;
              });
            }
          },
          title: Text(
            getTranslated(context, 'DEFAULT_ADD')!,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Theme.of(context).colorScheme.lightBlack,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  _showContent() {
    return Stack(
      children: [
        Form(
            key: _formkey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          setUserName(),
                          setMobileNo(),
                          setAltMobileNo(),
                          setAddress(),
                          setLandmark(),
                           setCities(),
                          // setArea(),
                          setPincode(),
                          setStateField(),
                          setCountry(),
                          typeOfAddress(),
                          defaultAdd(),
                          // addBtn(),
                        ],
                      ),
                    ),
                  ),
                ),

                saveButton(getTranslated(context, 'SAVE_LBL')!, () {
                  validateAndSubmit();
                }),
              ],
            )),
        showCircularProgress(_isProgress, colors.primary)
      ],
    );
  }

  Future<void> areaSearch(String searchText) async {
    areaSearchList.clear();
    for (int i = 0; i < areaList.length; i++) {
      User map = areaList[i];

      if (map.name!.toLowerCase().contains(searchText)) {
        areaSearchList.add(map);
      }
    }

    if (mounted) areaState!(() {});
  }

  Future<void> citySearch(String searchText) async {
    citySearchLIst.clear();
    for (int i = 0; i < cityList.length; i++) {
      User map = cityList[i];

      if (map.name!.toLowerCase().contains(searchText)) {
        citySearchLIst.add(map);
      }
    }

    if (mounted) cityState!(() {});
  }

  Future<void> getCurrentLoc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitude!), double.parse(longitude!),
        localeIdentifier: "en");

    state = placemark[0].administrativeArea;
    country = placemark[0].country;
    // pincode = placemark[0].postalCode;
    // address = placemark[0].name;
    if (mounted) {
      setState(() {
        countryC!.text = country!;
        stateC!.text = state!;
        // pincodeC!.text = pincode!;
        // addressC!.text = address!;
      });
    }
  }

  Widget saveButton(String title, VoidCallback? onBtnSelected) {
    return
    //   Row(
    //   children: [
    //     Expanded(
    //       child: Padding(
    //         padding:
    //         const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
    //         child: MaterialButton(
    //           height: 45.0,
    //           textColor: Theme.of(context).colorScheme.white,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10.0)),
    //           onPressed: onBtnSelected,
    //           child: Text(title),
    //           color: colors.secondary,
    //         ),
    //       ),
    //     ),
    //   ],
    // );

      InkWell(
      onTap: (){
        onBtnSelected!();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 18,right: 18),
        child: Container(
            width: double.infinity,
            height: 45,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: colors.secondary,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.secondary, colors.button],
                  stops: [0, 1]),
              borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: Text("Save",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: colors.whiteTemp, fontWeight: FontWeight.bold))),
      ),
    );


  }
}
