library my_prj.globals;

import 'package:intl/intl.dart';

String toRupiah(int angka) {
  var rupiah = NumberFormat.currency(locale: 'id', name: 'Rp', symbol: 'Rp ');

  return rupiah.format(angka);
}
