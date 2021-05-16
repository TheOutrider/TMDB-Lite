import 'package:intl/intl.dart';

class AppHelper {
  static String dateFormatter(String date) {
    if (date.isEmpty) return "NA";
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }
}
