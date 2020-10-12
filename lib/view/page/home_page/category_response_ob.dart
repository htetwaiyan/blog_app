class CategoryResponseOb {
  bool success;
  List<CategoryOb> result;

  CategoryResponseOb({this.success, this.result});

  CategoryResponseOb.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      result = new List<CategoryOb>();
      json['result'].forEach((v) {
        result.add(new CategoryOb.fromJson(v));
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

class CategoryOb {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  CategoryOb({this.id, this.name, this.createdAt, this.updatedAt});

  CategoryOb.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
