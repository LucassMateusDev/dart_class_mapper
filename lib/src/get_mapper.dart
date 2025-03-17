import 'package:dart_class_mapper/src/mapper_service.dart';

class GetMapper<T, R> {
  T value(R value) => MapperService.i.get<T, R>(value);
}
