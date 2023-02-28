import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Model/GetStateModel.dart';
class ChangeState extends StatefulWidget {
  const ChangeState({Key? key}) : super(key: key);

  @override
  State<ChangeState> createState() => _ChangeStateState();
}

class _ChangeStateState extends State<ChangeState> {
  List<StateData> getStateModel = [];
  bool get wantKeepAlive => true;
  String? selectedState;
  String? state;

  SharedPreferences? prefs;
  getData()async{
    prefs = await SharedPreferences.getInstance();
  }
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(
  //       seconds: 5
  //   ), (){
  //     if(prefs!.getString('stateId') == "" || prefs!.getString("stateId") == null) {
  //
  //     }
  //     else{
  //       String? value = prefs!.getString('stateId');
  //       selectedState = value;
  //     }
  //   });
  //   );
  //
  //   getState();
  // }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500),
        (){
          if(prefs!.getString('stateId') == "" || prefs!.getString("stateId") == null) {
            stateSelectDialog();
          }
          else{
            String? value = prefs!.getString('stateId');
            selectedState = value;
          }
        }
    );
    getState();
    // getStateNew();
    getData();
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

  // getStateNew()async{
  //   var headers = {
  //     'Cookie': 'ci_session=fb3e319fd7002d419a0648f441780c7728476899'
  //   };
  //   var request = http.Request('POST', Uri.parse('$baseUrl/get_states'));
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   print("status code here ${'${baseUrl}get_states'}  ddddd ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     var finalRes = await response.stream.bytesToString();
  //     final jsonResponse = GetStateModel.fromJson(json.decode(finalRes));
  //     setState(() {
  //       getStateModel = jsonResponse.date!;
  //     });
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.whiteTemp,
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios_new,color: colors.secondary,),
        title: Text("Change State",style: TextStyle(color: colors.secondary),),
      ),
      body: Column(
        children: [

          
        ],
      ),
    );
  }
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
                          // callApi();
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

}
