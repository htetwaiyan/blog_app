import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';

class ProfileResponsePostOb {
  bool success;
  List<BlogOb> result;

  ProfileResponsePostOb({this.success, this.result});

  ProfileResponsePostOb.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      result = new List<BlogOb>();
      json['result'].forEach((v) {
        result.add(new BlogOb.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


