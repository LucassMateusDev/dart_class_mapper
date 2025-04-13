import 'package:dart_class_mapper/dart_class_mapper.dart';
import 'package:dart_class_mapper/src/mapper/mapper_service.dart';
import 'package:test/test.dart';

import '../example/dart_class_mapper_example.dart';

void main() {
  late final User user;
  late final UserGetDto userGetDto;
  setUp(() => MapperService.i.clear());
  setUpAll(() {
    user = User(
      name: 'John Doe',
      email: 'john.doe@example',
      password: 'teste',
    );
    userGetDto = UserGetDto(
      name: 'John Doe',
      email: 'john.doe@example',
    );
  });

  group('Create Map', () {
    test('Deve registrar um mapeamento com sucesso', () async {
      //Arrange
      CreateMap<UserGetDto, User>((user) => UserGetDto(
            name: user.name,
            email: user.email,
          ));

      //Act
      final key = MapperService.i.getMappingKey<User, UserGetDto>();
      final mappings = MapperService.i.mappings;

      //Assert
      expect(mappings.keys, containsOnce(key));
    });

    test('Deve registrar um mapeamento reverso com sucesso', () async {
      //Arrange
      CreateMap<UserGetDto, User>(
        (user) => UserGetDto(
          name: user.name,
          email: user.email,
        ),
        reverse: (dto) => User(
          name: dto.name,
          email: dto.email,
          password: '',
        ),
      );

      //Act
      final key = MapperService.i.getMappingKey<UserGetDto, User>();
      final mappings = MapperService.i.mappings;

      //Assert
      expect(mappings.keys, containsOnce(key));
    });
    test('Deve lançar uma exceção ao tentar registrar um mapeamento duplicado',
        () async {
      //Arrange
      CreateMap<UserGetDto, User>((user) => UserGetDto(
            name: user.name,
            email: user.email,
          ));

      //Act
      act(User value) => () => CreateMap<UserGetDto, User>(
            (value) => UserGetDto(
              name: value.name,
              email: value.email,
            ),
          );

      //Assert
      expect(act(user), throwsA(isA<DartClassMapperException>()));
    });
  });

  group('Get Mapper', () {
    test('Deve recuperar corretamente um mapeamento registrado', () async {
      //Arrange
      CreateMap<UserGetDto, User>((user) => UserGetDto(
            name: user.name,
            email: user.email,
          ));

      //Act
      final userGetDto = GetMapper<UserGetDto, User>().value(user);

      //Assert
      expect(userGetDto.name, equals(user.name));
      expect(userGetDto.email, equals(user.email));
    });
    test('Deve recuperar corretamente um mapeamento reverso registrado',
        () async {
      //Arrange
      CreateMap<UserGetDto, User>(
        (user) => UserGetDto(
          name: user.name,
          email: user.email,
        ),
        reverse: (dto) => User(
          name: dto.name,
          email: dto.email,
          password: '',
        ),
      );

      //Act
      final user = GetMapper<User, UserGetDto>().value(userGetDto);

      //Assert
      expect(user.name, equals(userGetDto.name));
      expect(user.email, equals(userGetDto.email));
    });
    test('Deve lançar exceção ao recuperar um mapeamento inexistente',
        () async {
      //Arrange

      //Act
      act(User value) => () => GetMapper<UserGetDto, User>().value(value);

      //Assert
      expect(act(user), throwsA(isA<DartClassMapperException>()));
    });
  });

  group('Geração de key', () {
    test('Deve gerar corretamente a key do mapeamento', () async {
      //Arrange

      //Act
      final key = MapperService.i.getMappingKey<User, UserGetDto>();

      //Assert
      expect(key, equals('User_UserGetDto'));
    });
  });
}
