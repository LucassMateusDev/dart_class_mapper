import 'package:dart_class_mapper/src/mapper/mapper_builder.dart';
import 'package:dart_class_mapper/src/mapper/mapper_utils.dart';

class MapperConfiguration {
  MapperBuilder<T, R> buildMap<T, R>(T Function(R value) function) =>
      MapperBuilder<T, R>(function);

  MapperBuilder<T, JSON> buildJsonMap<T>(T Function(JSON json) function) =>
      MapperBuilder<T, JSON>(function);
}
