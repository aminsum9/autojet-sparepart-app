class SupplierModel {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? address;
  final String? phone;
  final String? desc;
  final String? createdAt;
  final String? updatedAt;

  SupplierModel(
      {this.id,
      this.name,
      this.email,
      this.image,
      this.address,
      this.phone,
      this.desc,
      this.createdAt,
      this.updatedAt});

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      desc: json['desc'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
