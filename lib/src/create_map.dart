import 'package:dart_class_mapper/src/mapper_service.dart';

/// Registra um mapeamento entre dois tipos [T] e [R] no [MapperService].
///
/// Essa classe permite criar uma associação de conversão entre dois tipos genéricos
/// e registrá-la automaticamente no serviço de mapeamento.
///
/// Exemplo de uso:
/// ```dart
/// CreateMap<UserDto, User>((user) => UserDto(name: user.name, email: user.email));
/// ```
///
/// Após a criação do mapeamento, é possível recuperar a conversão pelo [GetMapper].
///
/// ```dart
/// final userDto = GetMapper<UserDto, User>().value(user);
/// ```
class CreateMap<T, R> {
  /// Função responsável por transformar um objeto do tipo [R] em um objeto do tipo [T].
  final T Function(R value) function;

  /// Registra automaticamente o mapeamento entre [T] e [R] ao ser instanciado.
  ///
  /// O mapeamento é armazenado dentro do [MapperService], permitindo que
  /// a conversão seja usada posteriormente com [GetMapper].
  ///
  /// Exemplo:
  /// ```dart
  /// CreateMap<UserDto, User>((user) => UserDto(name: user.name, email: user.email));
  /// ```
  CreateMap(this.function) {
    MapperService.i.register<R, T>(function);
  }
}
