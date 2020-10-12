class ProfileResponseOb {
  bool success;
  ProfileOb result;

  ProfileResponseOb({this.success, this.result});

  ProfileResponseOb.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? new ProfileOb.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class ProfileOb {
  int id;
  String name;
  String image;
  String email;
  String createdAt;
  String updatedAt;

  ProfileOb(
      {this.id,
        this.name,
        this.image,
        this.email,
        this.createdAt,
        this.updatedAt});

  ProfileOb.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
