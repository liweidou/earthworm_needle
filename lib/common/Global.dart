import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Global{
  static String API_TOKEN = "Token";
  static String BASE_URL = "http://greenprobe.infitack.net";
  static SharedPreferences preferences;
  static int colorAccent = 0xff27DD8F;

  static String getEndMothFor({mothFormart: String, format: String}) {
    DateTime startData = DateTime.parse(mothFormart);
    var dataFormart = new DateFormat(format);
    var dateTime = new DateTime.fromMillisecondsSinceEpoch(
        startData.millisecondsSinceEpoch);
    var dataNextMonthData = new DateTime(dateTime.year, dateTime.month + 1, 1);
    int nextTimeSamp =
        dataNextMonthData.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var dateTimeeee = new DateTime.fromMillisecondsSinceEpoch(nextTimeSamp);
    String formartResult = dataFormart.format(dateTimeeee);
    return formartResult;
  }

}