import 'package:dart_class_mapper/dart_class_mapper.dart';

class User {
  String name;
  String email;
  String password;

  User({required this.name, required this.email, required this.password});
}

class UserGetDto {
  String name;
  String email;

  UserGetDto({required this.name, required this.email});
}

void main() {
  //* Primeiro, criamos um mapeamento entre User e UserDto.
  CreateMap<UserGetDto, User>(
    (user) => UserGetDto(
      name: user.name,
      email: user.email,
    ),
    reverse: (userGetDto) {
      return User(
        name: userGetDto.name,
        email: userGetDto.email,
        password: '', // Adicione um valor padrão ou trate conforme necessário
      );
    },
  );

  //* Exemplo de uso
  final user = User(
    name: 'John Doe',
    email: 'john.doe@example',
    password: 'teste',
  );

  final userGetDto = GetMapper<UserGetDto, User>().value(user);
  print(userGetDto.name); // John Doe
  print(userGetDto.email); // john.doe@example

  final userReverse = GetMapper<User, UserGetDto>().value(userGetDto);
  print(userReverse.name); // John Doe
  print(userReverse.email); // john.doe@example
  print(userReverse.password); // ''

  //* Exemplo de uso com listas
  final users = [
    User(
      name: 'John Doe',
      email: 'john.doe@example',
      password: 'teste',
    ),
    User(
      name: 'Jane Doe',
      email: 'jane.doe@example',
      password: 'teste',
    ),
  ];
  final usersGetDto = GetMapper<UserGetDto, User>().list(users);
  for (var user in usersGetDto) {
    print(user.name);
    print(user.email);
  }

  //* Exemplo de uso com sets
  final usersSet = {
    User(
      name: 'John Doe',
      email: 'john.doe@example',
      password: 'teste',
    ),
    User(
      name: 'Jane Doe',
      email: 'jane.doe@example',
      password: 'teste',
    ),
  };
  final usersGetDtoSet = GetMapper<UserGetDto, User>().set(usersSet);
  for (var user in usersGetDtoSet) {
    print(user.name);
    print(user.email);
  }

  //* Exemplo de uso com maps
  final usersMap = {
    'john': User(
      name: 'John Doe',
      email: 'john.doe@example',
      password: 'teste',
    ),
    'jane': User(
      name: 'Jane Doe',
      email: 'jane.doe@example',
      password: 'teste',
    ),
  };
  final usersGetDtoMap = GetMapper<UserGetDto, User>().map(usersMap);
  for (var user in usersGetDtoMap.entries) {
    print(user.key);
    print(user.value.name);
    print(user.value.email);
  }
}
