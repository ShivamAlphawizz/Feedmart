/// error : false
/// message : "Data fetched successfully"
/// data : [{"id":"1","title":"Corn seed","description":"How to use corn seed","video":"uploads/media/2022/WhatsApp_Video_2022-09-16_at_3_49_19_PM_(1).mp4\t"},{"id":"2","title":"Animal Feeds supliment\t","description":"use of Animal Feeds supliment","video":"uploads/media/2022/WhatsApp_Video_2022-09-16_at_3_49_19_PM_(1).mp4\t"},{"id":"3","title":"Cow Dung manure\t","description":"Cow Dung manure\t","video":"uploads/media/2022/WhatsApp_Video_2022-09-16_at_3_49_19_PM_(1).mp4\t"}]

class GetVideoModel {
  GetVideoModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetVideoModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Data>? _data;
GetVideoModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => GetVideoModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// title : "Corn seed"
/// description : "How to use corn seed"
/// video : "uploads/media/2022/WhatsApp_Video_2022-09-16_at_3_49_19_PM_(1).mp4\t"

class Data {
  Data({
      String? id, 
      String? title, 
      String? description, 
      String? video,}){
    _id = id;
    _title = title;
    _description = description;
    _video = video;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _video = json['video'];
  }
  String? _id;
  String? _title;
  String? _description;
  String? _video;
Data copyWith({  String? id,
  String? title,
  String? description,
  String? video,
}) => Data(  id: id ?? _id,
  title: title ?? _title,
  description: description ?? _description,
  video: video ?? _video,
);
  String? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get video => _video;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['video'] = _video;
    return map;
  }

}