# Dart Class Mapper

A lightweight and simple package for class mapping in Dart, allowing flexible and reusable conversion between instance types.

## 🎯  **Recursos**
- **⚡ Simple and easy to use**
- **🔁 Avoids unnecessary code repetition**
- **🔄 Enables reuse of mappings**
- **🛠️ Intuitive API with CreateMap and GetMapper**


## 📦 **Installation**

Add Dart Class Mapper to your project via pubspec.yaml: 
```sh
dependencies:
  dart_class_mapper: ^1.2.1
```

## 🚀 How to Use
### 🏗️ Creating the Classes
```dart
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
```

### 🔗 Creating the Mapping

Use CreateMap to register mappings between classes.
```dart
CreateMap<UserGetDto, User>((user) => UserGetDto(
        name: user.name,
        email: user.email,
      ));
```

### 🔍 Retrieving the Mapping
Use GetMapper to retrieve mappings.
```dart
final userGetDto = GetMapper<UserGetDto, User>().value(user);
```

## Usage Example

```dart
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
```
## For more usage examples:
- ### [Common example](https://github.com/LucassMateusDev/dart_class_mapper/blob/main/example/dart_class_mapper_example.dart)
- ### [JSON example](https://github.com/LucassMateusDev/dart_class_mapper/blob/main/example/dart_class_mapper_json_example.dart)