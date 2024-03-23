import 'package:autojet_sparepart/models/barang_model.dart';

class DetailTransModel {
  final int? id;
  final int? transId;
  final int? barangId;
  final int? qty;
  final int? subtotal;
  final int? discount;
  final int? grandTotal;
  final String? notes;
  final BarangModel? barang;
  final String? createdAt;
  final String? updatedAt;

  DetailTransModel(
      {this.id,
      this.transId,
      this.barangId,
      this.qty,
      this.subtotal,
      this.discount,
      this.grandTotal,
      this.notes,
      this.barang,
      this.createdAt,
      this.updatedAt});

  factory DetailTransModel.fromJson(Map<String, dynamic> json) {
    return DetailTransModel(
      id: json['id'] as int?,
      transId: json['trans_id'] as int?,
      barangId: json['barang_id'] as int?,
      qty: json['qty'] as int?,
      subtotal: json['subtotal'] as int?,
      discount: json['discount'] as int?,
      grandTotal: json['grand_total'] as int?,
      notes: json['notes'] as String?,
      barang: json['barang'] as BarangModel?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
