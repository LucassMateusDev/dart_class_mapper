class MapperService {
  static MapperService? _instance = MapperService._();

  static MapperService get i {
    _instance ??= MapperService._();
    return _instance!;
  }

  MapperService._();

  final Map<String, Function> _mappings = {};

  T get<T, R>(R value) {
    final key = getMappingKey<R, T>();

    final mapping = _mappings[key] as T Function(R)?;

    if (mapping == null) {
      throw Exception('No mapping registered for $R to $T');
    }

    return mapping(value);
  }

  void register<T, R>(R Function(T) function) {
    final key = getMappingKey<T, R>();

    if (_mappings.containsKey(key)) {
      throw Exception('Mapping already registered for $T to $R');
    }

    _mappings[key] = function;
  }

  // ignore: unnecessary_brace_in_string_interps
  String getMappingKey<T, R>() => '${T}_${R}';
}
