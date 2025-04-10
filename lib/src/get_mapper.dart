import 'package:dart_class_mapper/src/mapper/mapper_service.dart';

/// Recupera um mapeamento registrado no [MapperService] e aplica a conversão entre dois tipos [T] e [R].
///
/// Essa classe facilita a obtenção de um mapeamento previamente registrado, transformando um objeto do tipo [R]
/// em um objeto do tipo [T].
///
/// Para que a conversão funcione, é necessário que um mapeamento tenha sido registrado previamente com [CreateMap].
///
/// Exemplo de uso:
/// ```dart
/// Primeiro, criamos um mapeamento entre User e UserDto.
/// CreateMap<UserDto, User>((user) => UserDto(name: user.name, email: user.email));
///
/// Depois, podemos recuperar a conversão usando GetMapper.
/// final userDto = GetMapper<UserDto, User>().value(user);
/// ```
class GetMapper<T, R> {
  /// Converte um objeto do tipo [R] para o tipo [T] usando o [MapperService].
  ///
  /// Se não houver um mapeamento registrado entre [R] e [T], lança uma [DartClassMapperException].
  ///
  /// Exemplo:
  /// ```dart
  /// final userDto = GetMapper<UserDto, User>().value(user);
  /// ```
  T value(R value) => MapperService.i.get<T, R>(value);

  List<T> list(List<R> values) => values.map((e) => value(e)).toList();

  Set<T> set(Set<R> values) => values.map((e) => value(e)).toSet();

  Map<String, T> map(Map<String, R> values) =>
      values.map((key, value) => MapEntry(key, this.value(value)));
}
