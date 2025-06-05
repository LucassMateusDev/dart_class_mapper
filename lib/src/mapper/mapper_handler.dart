import 'package:dart_class_mapper/src/mapper/mapper_service.dart';
import 'package:dart_class_mapper/src/mapper/mapper_utils.dart';

class MapperHandler<T> {
  T handleMap<R>(R data) {
    return MapperService.i.get<T, R>(data);
  }

  T handleJsonMap(JSON json, {String key = ''}) {
    var data = json;
    if (key.isNotEmpty) {
      data = json[key];
    }

    return MapperService.i.get<T, JSON>(data);
  }
}
