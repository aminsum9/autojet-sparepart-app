import 'package:autojet_sparepart/models/detail_trans_model.dart';
import 'package:autojet_sparepart/models/user_model.dart';

class TransModel {
  final int? id;
  final String? trxId;
  final String? userId;
  final int? subtotal;
  final int? discount;
  final int? grandTotal;
  final String? notes;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<DetailTransModel>? detailTrans;
  final UserModel? createdBy;

  TransModel(
      {this.id,
      this.trxId,
      this.userId,
      this.subtotal,
      this.discount,
      this.grandTotal,
      this.notes,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.detailTrans,
      this.createdBy});

  factory TransModel.fromJson(Map<String, dynamic> json) {
    return TransModel(
      id: json['id'] as int?,
      trxId: json['trx_id'] as String?,
      userId: json['user_id'] as String?,
      subtotal: json['subtotal'] as int?,
      discount: json['discount'] as int?,
      grandTotal: json['grand_total'] as int?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      detailTrans: json['detail_transaksi'] as List<DetailTransModel>?,
      createdBy: json['created_by'] as UserModel?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
