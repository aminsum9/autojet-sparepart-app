import 'package:autojet_sparepart/models/supplier_model.dart';

class BarangModel {
  final int? id;
  final String? name;
  final String? alias;
  final String? image;
  final int? qty;
  final int? price;
  final int? discount;
  final String? desc;
  final List<SupplierModel>? suppliers;
  final String? createdAt;
  final String? updatedAt;

  BarangModel(
      {this.id,
      this.name,
      this.alias,
      this.image,
      this.qty,
      this.price,
      this.discount,
      this.createdAt,
      this.desc,
      this.suppliers,
      this.updatedAt});

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      alias: json['alias'] as String?,
      image: json['image'] as String?,
      qty: json['qty'] as int?,
      price: json['price'] as int?,
      discount: json['discount'] as int?,
      desc: json['desc'] as String?,
      suppliers: json['supplier'] as List<SupplierModel>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
