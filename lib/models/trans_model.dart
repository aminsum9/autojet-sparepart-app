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
      this.updatedAt});

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
      createdAt: json['created_at'] as String?,
      updatedAt: json['created_at'] as String?,
    );
  }
}
