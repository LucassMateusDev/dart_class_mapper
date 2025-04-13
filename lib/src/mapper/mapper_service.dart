import 'package:dart_class_mapper/src/exceptions/dart_class_mapper_exception.dart';

class MapperService {
  static MapperService? _instance = MapperService._();

  static MapperService get i {
    _instance ??= MapperService._();
    return _instance!;
  }

  MapperService._();

  final Map<String, Function> _mappings = {};
  Map<String, Function> get mappings => _mappings;

  T get<T, R>(R value) {
    final key = getMappingKey<R, T>();

    final mapping = _mappings[key] as T Function(R)?;

    if (mapping == null) {
      throw DartClassMapperException('No mapping registered for $R to $T');
    }

    return mapping(value);
  }

  void register<T, R>(R Function(T) function) {
    final key = getMappingKey<T, R>();

    if (_mappings.containsKey(key)) {
      throw DartClassMapperException('Mapping already registered for $T to $R');
    }

    _mappings[key] = function;
  }

  // ignore: unnecessary_brace_in_string_interps
  String getMappingKey<T, R>() => '${T}_${R}';

  void clear() {
    _mappings.clear();
  }
}
