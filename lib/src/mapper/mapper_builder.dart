import 'package:dart_class_mapper/src/mapper/mapper_service.dart';

class MapperBuilder<T, R> {
  T Function(R value) function;

  MapperBuilder(this.function) {
    MapperService.i.register<R, T>(function);
  }

  MapperBuilder<T, R> reverse(R Function(T value) function) {
    MapperService.i.register<T, R>(function);
    return this;
  }
}
