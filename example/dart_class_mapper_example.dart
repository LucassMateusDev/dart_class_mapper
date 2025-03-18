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
  CreateMap<UserGetDto, User>((user) => UserGetDto(
        name: user.name,
        email: user.email,
      ));

  final user = User(
    name: 'John Doe',
    email: 'john.doe@example',
    password: 'teste',
  );

  final userGetDto = GetMapper<UserGetDto, User>().value(user);

  print(userGetDto.name); // John Doe
  print(userGetDto.email); // john.doe@example
}
