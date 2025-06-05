import 'package:dart_class_mapper/src/mapper/mapper_handler.dart';
import 'package:dart_class_mapper/src/mapper/mapper_service.dart';
import 'package:dart_class_mapper/src/mapper/mapper_utils.dart';

/// Extensão para objetos que permite realizar mapeamentos de instância.
///
/// Usada para converter um objeto para outro tipo configurado previamente
/// com [CreateMap] ou [Mapper.configure].
///
/// Exemplo:
/// ```dart
/// final dto = user.mapTo<UserDto>();
/// ```
extension MapperObjectExtension<R extends Object> on R {
  /// Mapeia a instância atual do tipo [R] para uma instância do tipo [T].
  T mapTo<T>() => MapperService.i.get<T, R>(this);

  /// Tenta mapear a instância atual para o tipo [T], retornando `null` em caso de erro.
  T? mapToOrNull<T>() {
    try {
      return MapperService.i.get<T, R>(this);
    } on Exception {
      return null;
    }
  }
}

/// Extensão para objetos do tipo [Iterable] que permite mapear todos os elementos
/// da coleção para outro tipo utilizando os mapeamentos registrados.
///
/// Exemplo:
/// ```dart
/// final dtos = users.mapToList<UserDto>();
/// ```
extension MapperIterableExtension<R extends Object> on Iterable<R> {
  /// Mapeia todos os elementos da coleção atual do tipo [R] para uma lista do tipo [T].
  Iterable<T> mapToList<T>() => map((e) => e.mapTo<T>()).toList();

  /// Tenta mapear todos os elementos da coleção para uma lista do tipo [T].
  /// Retorna `null` em caso de erro.
  Iterable<T>? mapToListOrNull<T>() {
    try {
      return map((e) => e.mapTo<T>()).toList();
    } on Exception {
      return null;
    }
  }

  List<JSON> toJsonList() => map((e) => e.toJson()).toList();
}

/// Extensão para mapas com chave [String] que permite mapear os valores para outro tipo.
///
/// Exemplo:
/// ```dart
/// final mapped = userMap.mapToMap<UserDto>();
/// ```
extension MapperMapExtension<R extends Object> on Map<String, R> {
  /// Mapeia os valores do mapa atual do tipo [R] para um novo mapa com valores do tipo [T].
  Map<String, T> mapToMap<T>() =>
      map((key, value) => MapEntry(key, value.mapTo<T>()));

  /// Tenta mapear os valores do mapa, retornando `null` em caso de erro.
  Map<String, T>? mapToMapOrNull<T>() {
    try {
      return map((key, value) => MapEntry(key, value.mapTo<T>()));
    } on Exception {
      return null;
    }
  }
}

extension MapperJsonExtension on JSON {
  /// Mapeia o JSON atual para um objeto do tipo [T] usando os mapeamentos registrados.
  T mapTo<T extends Object>({String key = ''}) =>
      MapperHandler<T>().handleJsonMap(this, key: key);
}

extension JsonParsingHelpers on JSON {
  /// Obtém um valor do tipo [T], retornando null se a chave não existir ou o tipo não corresponder.
  T? _get<T>(String key) {
    final value = this[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  String getString(String key, {String defaultValue = ''}) {
    return _get<String>(key) ?? defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    final value = this[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = this[key];
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? defaultValue;
    if (value is int) return value.toDouble();
    return defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _get<bool>(key) ?? defaultValue;
  }

  JSON? getObject(String key) {
    return _get<JSON>(key);
  }

  List<T>? getListOf<T>(String key) {
    final value = this[key];
    if (value is List) {
      return value.whereType<T>().toList();
    }
    return null;
  }

  /// Mapeia um objeto JSON aninhado para um tipo [T] usando mapeamentos registrados.
  T? mapToObject<T extends Object>(String key) {
    final nestedJson = getObject(key);
    if (nestedJson != null) {
      try {
        return MapperService.i.get<T, JSON>(nestedJson);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Mapeia uma lista de objetos JSON para List<[T]> usando mapeamentos registrados.
  List<T>? mapToListOfObjects<T extends Object>(String key) {
    final jsonList = _get<List>(key); // Espera List<dynamic>
    if (jsonList != null) {
      return jsonList
          .whereType<JSON>()
          .map((jsonItem) {
            try {
              return MapperService.i.get<T, JSON>(jsonItem);
            } catch (e) {
              return null;
            }
          })
          .whereType<T>()
          .toList();
    }
    return null;
  }
}

extension MappableObjectToJsonExtension<T extends Object> on T {
  /// Converte a instância atual para [JSON].
  /// Requer que um mapeamento de [T] para [JSON] (CreateMap) esteja registrado.
  JSON toJson() {
    return MapperService.i.get<JSON, T>(this);
  }

  /// Tenta converter a instância para JSON, retornando `null` em caso de erro.
  JSON? toJsonOrNull() {
    try {
      return toJson();
    } on Exception {
      return null;
    }
  }
}

extension MapperJsonListExtension on List<JSON> {
  /// Mapeia uma lista de JSONs para uma lista de objetos do tipo [T] usando os mapeamentos registrados.
  List<T> mapToObjectsList<T extends Object>() {
    return map((json) => MapperService.i.get<T, JSON>(json)).toList();
  }
}
