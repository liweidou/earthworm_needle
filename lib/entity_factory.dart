import 'package:earthworm_needle/beans/DaysDataEntity.dart';
import 'package:earthworm_needle/beans/handler_entity.dart';
import 'package:earthworm_needle/beans/NeedleEntity.dart';
import 'package:earthworm_needle/beans/OneDayDataEntity.dart';
import 'package:earthworm_needle/beans/UserEntity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "DaysDataEntity") {
      return DaysDataEntity.fromJson(json) as T;
    } else if (T.toString() == "HandlerEntity") {
      return HandlerEntity.fromJson(json) as T;
    } else if (T.toString() == "NeedleEntity") {
      return NeedleEntity.fromJson(json) as T;
    } else if (T.toString() == "OneDayDataEntity") {
      return OneDayDataEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}