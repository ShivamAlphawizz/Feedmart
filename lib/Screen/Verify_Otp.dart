import 'dart:async';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/cropped_container.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Set_Password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../Helper/AppBtn.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';
import 'SignUp.dart';

class VerifyOtp extends StatefulWidget {
  final String? mobileNumber, countryCode, title;
final otp;
  VerifyOtp(
      {Key? key,
      required String this.mobileNumber,
      this.countryCode,
      this.title, this.otp})
      : assert(mobileNumber != null),
        super(key: key);

  @override
  _MobileOTPState createState() => _MobileOTPState();
}

class _MobileOTPState extends State<VerifyOtp> with TickerProviderStateMixin {
  final dataKey = GlobalKey();
  String? password;
  String? otp;
  bool isCodeSent = false;
  late String _verificationId;
  String signature = "";
  bool _isClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getSingature();
    // _onVerifyCode();
    Future.delayed(Duration(seconds: 60)).then((_) {
      _isClickable = true;
    });
    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));
  }

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    await SmsAutoFill().listenForCode;
  }

  getUserDetails() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    if (mounted) setState(() {});
  }

  Future<void> checkNetworkOtp() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (_isClickable) {
        // _onVerifyCode();
        otpCheck();
      } else {
        setSnackbar(getTranslated(context, 'OTPWR')!);
      }
    } else {
      if (mounted) setState(() {});

      Future.delayed(Duration(seconds: 60)).then((_) async {
        bool avail = await isNetworkAvailable();
        if (avail) {
          if (_isClickable)
            // _onVerifyCode();
            otpCheck();
          else {
            setSnackbar(getTranslated(context, 'OTPWR')!);
          }
        } else {
          await buttonController!.reverse();
          setSnackbar(getTranslated(context, 'somethingMSg')!);
        }
      });
    }
  }

  Widget verifyBtn() {
    return
    InkWell(
      onTap: (){
        otpCheck();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.secondary
          ),
          child: Center(child: Text("Verify Authentication Code",style: TextStyle(color: colors.whiteTemp,fontSize: 18),)),
        ),
      ),
    );
      // AppBtn(
      //   title: getTranslated(context, 'VERIFY_AND_PROCEED'),
      //   btnAnim: buttonSqueezeanimation,
      //   btnCntrl: buttonController,
      //   onBtnSelected: () async {
      //     // _onFormSubmitted();
      //     otpCheck();
      //   });
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
      elevation: 1.0,
    ));
  }
  otpCheck ()async {
    if (widget.otp.toString() == otp.toString()) {
      SettingProvider settingsProvider =
      Provider.of<SettingProvider>(context, listen: false);

      setSnackbar(getTranslated(context, 'OTPMSG')!);
      settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
      settingsProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);
      if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
        Future.delayed(Duration(seconds: 2)).then((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignUp()));
        });
      } else if (widget.title ==
          getTranslated(context, 'FORGOT_PASS_TITLE')) {
        Future.delayed(Duration(seconds: 2)).then((_) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SetPass(mobileNumber: widget.mobileNumber!)));
        });
      }
    }else{

    }
  }

  void _onVerifyCode() async {
    if (mounted)
      setState(() {
        isCodeSent = true;
      });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          SettingProvider settingsProvider =
              Provider.of<SettingProvider>(context, listen: false);

          setSnackbar(getTranslated(context, 'OTPMSG')!);
          settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
          settingsProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);
          if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            });
          } else if (widget.title ==
              getTranslated(context, 'FORGOT_PASS_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SetPass(mobileNumber: widget.mobileNumber!)));
            });
          }
        } else {
          setSnackbar(getTranslated(context, 'OTPERROR')!);
        }
      }).catchError((error) {
        setSnackbar("OTP is not correct");
        setSnackbar(error.toString());
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setSnackbar("OTP is not correct");

      if (mounted)
        setState(() {
          isCodeSent = false;
        });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _verificationId = verificationId;
        });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _isClickable = true;
          _verificationId = verificationId;
        });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+${widget.countryCode}${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    String code = otp!.trim();

    if (code.length == 6) {
      _playAnimation();
      AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      _firebaseAuth
          .signInWithCredential(_authCredential)
          .then((UserCredential value) async {
        if (value.user != null) {
          SettingProvider settingsProvider =
              Provider.of<SettingProvider>(context, listen: false);

          await buttonController!.reverse();
          setSnackbar(getTranslated(context, 'OTPMSG')!);
          settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
          settingsProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);
          if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            });
          } else if (widget.title ==
              getTranslated(context, 'FORGOT_PASS_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SetPass(mobileNumber: widget.mobileNumber!)));
            });
          }
        } else {
          setSnackbar(getTranslated(context, 'OTPERROR')!);
          await buttonController!.reverse();
        }
      }).catchError((error) async {
        setSnackbar(getTranslated(context, 'WRONGOTP')!);

        await buttonController!.reverse();
      });
    } else {
      setSnackbar(getTranslated(context, 'ENTEROTP')!);
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  getImage() {
    return Expanded(
      flex: 4,
      child: Center(
        child: Image.asset('assets/images/homelogo.png'),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  monoVarifyText() {
    return
      Text(getTranslated(context, 'MOBILE_NUMBER_VARIFICATION')!,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.normal,
              fontSize: 25));
  }

  otpText() {
    return Padding(
        padding: EdgeInsetsDirectional.only(top: 30.0, start: 20.0, end: 20.0),
        child: Center(
          child: Text(getTranslated(context, 'SENT_VERIFY_CODE_TO_NO_LBL')!,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal)),
        ));
  }

  mobText() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: 10.0, start: 20.0, end: 20.0, top: 10.0),
      child: Center(
        child: Text("+${widget.countryCode}-${widget.mobileNumber}",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: colors.primary,
                // Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget otpLayout() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 30.0,
          end: 30.0,
        ),
        child: Center(
            child:
            PinCodeFields(
              length: 4,
              fieldBorderStyle: FieldBorderStyle.square,
              responsive: false,
              fieldHeight: 50.0,
              fieldWidth: 50.0,
              borderWidth: 1.0,
              activeBorderColor: colors.primary,
              activeBackgroundColor: colors.white10,
              borderRadius: BorderRadius.circular(10.0),
              keyboardType: TextInputType.number,
              autoHideKeyboard: false,
              fieldBackgroundColor: colors.white10,
              borderColor:colors.primary,
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
              ), onComplete: (String code) {  otp = code; },
              onChange: (String code){
                otp = code;
              },
            ),
            // PinFieldAutoFill(
            //     decoration: UnderlineDecoration(
            //       textStyle: TextStyle(
            //           fontSize: 20,
            //           color: Theme.of(context).colorScheme.fontColor),
            //       colorBuilder: FixedColorBuilder(colors.primary),
            //     ),
            //     // fieldBorderStyle: FieldBorderStyle.square,
            //     //   responsive: false,
            //     //   fieldHeight: 50.0,
            //     //   fieldWidth: 50.0,
            //     //   borderWidth: 1.0,
            //     //   activeBorderColor: colors.primary,
            //     //   activeBackgroundColor: colors.white10,
            //     //   borderRadius: BorderRadius.circular(10.0),
            //     //   keyboardType: TextInputType.number,
            //     //   autoHideKeyboard: false,
            //     //   fieldBackgroundColor: colors.white10,
            //     //   borderColor:colors.primary,
            //     currentCode: otp,
            //     codeLength: 4,
            //     onCodeChanged: (String? code) {
            //       otp = code;
            //     },
            //     onCodeSubmitted: (String code) {
            //       otp = code;
            //     }
            //     )
        ));
  }
  Widget resendText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTranslated(context, 'DIDNT_GET_THE_CODE')!,
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.normal,fontSize: 15),
          ),
        ],
      ),
    );
  }
  Widget resend(){
    return  InkWell(
        onTap: () async {
          await buttonController!.reverse();
          checkNetworkOtp();
        },
        child: Align(
          alignment: Alignment.center,
          child: Text(
            getTranslated(context, 'RESEND_OTP')!,
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: colors.primary,
                // Theme.of(context).colorScheme.primary,
                // decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,fontSize: 15),
          ),
        ));
  }
  expandedBottomView() {
    return Expanded(
      flex: 6,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    monoVarifyText(),
                    otpText(),
                    mobText(),
                    otpLayout(),
                    resendText(),
                    resend(),
                    SizedBox(height: 10,),
                    verifyBtn(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteTemp,
      appBar: AppBar(
        backgroundColor: colors.whiteTemp,
        elevation: 0,
        centerTitle: true,
        title:  monoVarifyText(),
        leading: Icon(Icons.arrow_back_ios_new,color: colors.secondary,),
      ),
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            otpText(),
            mobText(),
            otpLayout(),
            SizedBox(height: 10,),
            resendText(),
              resend(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            verifyBtn(),
            SizedBox(
              height: 20
            ),
            Text("OTP: ${widget.otp}"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
          ],
        ),
        // Stack(
        //   children: [
        //     Container(
        //       width: double.infinity,
        //       height: double.infinity,
        //       decoration: back(),
        //     ),
        //     Image.asset(
        //       'assets/images/doodle.png',
        //       fit: BoxFit.fill,
        //       width: double.infinity,
        //       height: double.infinity,
        //     ),
        //
        //     getLogo(),
        //   ],
        // )
    );
  }

  // getLoginContainer() {
  //   return ConstrainedBox(
  //     constraints: BoxConstraints(
  //       maxHeight: MediaQuery.of(context).size.height * 2,
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.10,
  //         ),
  //         monoVarifyText(),
  //         otpText(),
  //         mobText(),
  //         otpLayout(),
  //         verifyBtn(),
  //         resendText(),
  //         Text("OTP: ${widget.otp}"),
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.10,
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   //   Positioned.directional(
  //   //   start: MediaQuery.of(context).size.width * 0.025,
  //   //   // end: width * 0.025,
  //   //   // top: width * 0.45,
  //   //   top: MediaQuery.of(context).size.height * 0.2, //original
  //   //   //    bottom: height * 0.1,
  //   //   textDirection: Directionality.of(context),
  //   //   child: ClipPath(
  //   //     clipper: ContainerClipper(),
  //   //     child: Container(
  //   //       alignment: Alignment.center,
  //   //       padding: EdgeInsets.only(
  //   //           bottom: MediaQuery.of(context).viewInsets.bottom * 0.6),
  //   //       height: MediaQuery.of(context).size.height * 0.7,
  //   //       width: MediaQuery.of(context).size.width * 0.95,
  //   //       color: Theme.of(context).colorScheme.white,
  //   //       child: Form(
  //   //         // key: _formkey,
  //   //         child: ScrollConfiguration(
  //   //           behavior: MyBehavior(),
  //   //           child: SingleChildScrollView(
  //   //             child: ConstrainedBox(
  //   //               constraints: BoxConstraints(
  //   //                 maxHeight: MediaQuery.of(context).size.height * 2,
  //   //               ),
  //   //               child: Column(
  //   //                 mainAxisSize: MainAxisSize.min,
  //   //                 children: [
  //   //                   SizedBox(
  //   //                     height: MediaQuery.of(context).size.height * 0.10,
  //   //                   ),
  //   //                   monoVarifyText(),
  //   //                   otpText(),
  //   //                   mobText(),
  //   //                   otpLayout(),
  //   //                   verifyBtn(),
  //   //                   resendText(),
  //   //                   Text("OTP: ${widget.otp}"),
  //   //                   SizedBox(
  //   //                     height: MediaQuery.of(context).size.height * 0.10,
  //   //                   ),
  //   //                 ],
  //   //               ),
  //   //             ),
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     ),
  //   //   ),
  //   // );
  // }

  // Widget getLogo() {
  //   return Positioned(
  //     // textDirection: Directionality.of(context),
  //     left: (MediaQuery.of(context).size.width / 2) - 50,
  //     // right: ((MediaQuery.of(context).size.width /2)-55),
  //
  //     top: (MediaQuery.of(context).size.height * 0.2) - 50,
  //     //  bottom: height * 0.1,
  //     child: SizedBox(
  //       width: 100,
  //       height: 100,
  //       child: Image.asset(
  //         'assets/images/loginlogo.png',
  //       ),
  //     ),
  //   );
  // }
}
