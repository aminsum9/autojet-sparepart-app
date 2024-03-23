class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? address;
  final String? phone;
  final String? isVerify;
  final String? createdAt;
  final String? updatedAt;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.image,
      this.address,
      this.phone,
      this.isVerify,
      this.createdAt,
      this.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      isVerify: json['is_verify'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
