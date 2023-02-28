import 'dart:convert';
PincodeModel pincodeModelFromJson(String str) => PincodeModel.fromJson(json.decode(str));
String pincodeModelToJson(PincodeModel data) => json.encode(data.toJson());
class PincodeModel {
  PincodeModel({
      bool? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  PincodeModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;
PincodeModel copyWith({  bool? status,
  String? message,
  Data? data,
}) => PincodeModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      double? lat, 
      double? lng,}){
    _lat = lat;
    _lng = lng;
}

  Data.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }
  double? _lat;
  double? _lng;
Data copyWith({  double? lat,
  double? lng,
}) => Data(  lat: lat ?? _lat,
  lng: lng ?? _lng,
);
  double? get lat => _lat;
  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}