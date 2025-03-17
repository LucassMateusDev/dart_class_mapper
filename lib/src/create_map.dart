import 'package:dart_class_mapper/src/mapper_service.dart';

class CreateMap<T, R> {
  T Function(R) function;

  CreateMap(this.function) {
    MapperService.i.register<R, T>(function);
  }
}
