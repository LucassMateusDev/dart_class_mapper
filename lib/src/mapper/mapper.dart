import 'package:dart_class_mapper/src/mapper/mapper_configuration.dart';
import 'package:dart_class_mapper/src/mapper/mapper_service.dart';

/// Classe utilitária para configurar e utilizar o mapeamento entre classes.
///
/// Através do método [configure], é possível registrar os mapeamentos utilizando
/// uma instância de [MapperConfiguration].
///
/// O método [map] permite realizar o mapeamento de um objeto de tipo [R] para [T].
///
/// Exemplo:
/// ```dart
/// Mapper.configure((cfg) {
///   cfg.buildMap<UserDto, User>().create((user) => UserDto(name: user.name, email: user.email));
/// });
///
/// final dto = Mapper.map<UserDto, User>(user);
/// ```
class Mapper {
  /// Registra os mapeamentos utilizando a função de configuração fornecida.
  static void configure(void Function(MapperConfiguration cfg) configure) {
    configure(MapperConfiguration());
  }

  /// Realiza o mapeamento de um objeto do tipo [R] para o tipo [T].
  static T map<T, R>(R value) => MapperService.i.get<T, R>(value);
}
