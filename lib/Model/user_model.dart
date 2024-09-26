import 'package:myshop/Model/address.dart';
import 'package:myshop/utils/images.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? phNumber;
  String? role;
  String? createdAt;
  String? updatedAt;
  Address? address;
  bool? isActive;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.profileImage  = AppImages.userProfileImage,
      this.phNumber,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.address,
      this.isActive});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profileImage'] ?? AppImages.userProfileImage;
    phNumber = json['phNumber'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    address =
        json['address'] != null ?  Address.fromJson(json['address']) : null;
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profileImage'] = profileImage ?? AppImages.userProfileImage;
    data['phNumber'] = phNumber;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['isActive'] = isActive;
    return data;
  }
}

