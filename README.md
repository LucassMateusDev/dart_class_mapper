# Dart Class Mapper

Um package simples para mapeamento de classes em Dart, permitindo converter instâncias de um tipo para outro de maneira flexível e reutilizável.

## 🎯  **Recursos**
- **⚡ Simples e fácil de usar**
- **🔁 Evita repetições desnecessárias no código**
- **🔄 Permite a reutilização de mapeamentos**
- **🛠️  API intuitiva com CreateMap e GetMapper**


## 📦 **Instalação**

Adicione o **Dart Class Mapper** ao seu projeto pelo pubspec.yaml: 
```sh
dependencies:
  dart_class_mapper:: ^1.0.0
```

## 🚀 Como usar
### 🏗️ Criando as classes
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

### 🔗 Criando o mapeamento

Use CreateMap para registrar mapeamentos entre classes.
```dart
CreateMap<UserGetDto, User>((user) => UserGetDto(
        name: user.name,
        email: user.email,
      ));
```

### 🔍 Recuperando o mapeamento
Use GetMapper para recuperar mapeamentos.
```dart
final userGetDto = GetMapper<UserGetDto, User>().value(user);
```

## Exemplo de Uso

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
