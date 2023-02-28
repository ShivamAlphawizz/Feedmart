import 'dart:convert';
/// error : false
/// message : "get successfully!"
/// date : [{"id":"1","name":"Madhya Predesh"},{"id":"2","name":"Uttar Predesh"},{"id":"3","name":"Maharashtra"},{"id":"4","name":"Andhra Pradesh"}]

GetStateModel getStateModelFromJson(String str) => GetStateModel.fromJson(json.decode(str));
String getStateModelToJson(GetStateModel data) => json.encode(data.toJson());
class GetStateModel {
  GetStateModel({
      bool? error, 
      String? message, 
      List<StateData>? date,}){
    _error = error;
    _message = message;
    _date = date;
}

  GetStateModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['date'] != null) {
      _date = [];
      json['date'].forEach((v) {
        _date?.add(StateData.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<StateData>? _date;
GetStateModel copyWith({  bool? error,
  String? message,
  List<StateData>? date,
}) => GetStateModel(  error: error ?? _error,
  message: message ?? _message,
  date: date ?? _date,
);
  bool? get error => _error;
  String? get message => _message;
  List<StateData>? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_date != null) {
      map['date'] = _date?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// name : "Madhya Predesh"

StateData dateFromJson(String str) => StateData.fromJson(json.decode(str));
String dateToJson(StateData data) => json.encode(data.toJson());
class StateData {
  StateData({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  StateData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
StateData copyWith({  String? id,
  String? name,
}) => StateData(  id: id ?? _id,
  name: name ?? _name,
);
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}