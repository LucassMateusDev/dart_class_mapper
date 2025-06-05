import 'dart:convert';

import 'package:dart_class_mapper/dart_class_mapper.dart';

// 1. CLASSES DE MODELO
class Address {
  String street;
  String city;
  String zipCode;

  Address({required this.street, required this.city, required this.zipCode});

  @override
  String toString() =>
      'Address(street: $street, city: $city, zipCode: $zipCode)';
}

class Tag {
  int id;
  String name;

  Tag({required this.id, required this.name});

  @override
  String toString() => 'Tag(id: $id, name: $name)';
}

class User {
  String name;
  String email;
  String password;
  Address? mainAddress;
  List<Address>? shippingAddresses;
  List<String>? roles;
  List<Tag>? tags;
  bool isActive;
  int age;
  double accountBalance;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.mainAddress,
    this.shippingAddresses,
    this.roles,
    this.tags,
    required this.isActive,
    required this.age,
    required this.accountBalance,
  });

  @override
  String toString() {
    return '''
      User(
        name: $name, 
        email: $email, 
        password: $password,
        isActive: $isActive,
        age: $age,
        accountBalance: $accountBalance,
        mainAddress: $mainAddress,
        shippingAddresses: ${shippingAddresses?.join(', ')},
        roles: ${roles?.join(', ')},
        tags: ${tags?.join(', ')}
      )''';
  }
}

class UserGetDto {
  String name;
  String email;
  Address? mainAddress;
  List<String>? roles;

  UserGetDto({
    required this.name,
    required this.email,
    this.mainAddress,
    this.roles,
  });

  @override
  String toString() {
    return '''
      UserGetDto(
        name: $name, 
        email: $email, 
        mainAddress: $mainAddress,
        roles: ${roles?.join(', ')}
      )''';
  }
}

// 2. CONFIGURAÇÃO DOS MAPEAMENTOS
void setupMappings() {
  Mapper.configure((cfg) {
    // UserGetDto <-> User
    cfg.buildMap<UserGetDto, User>(
      (user) => UserGetDto(
        name: user.name,
        email: user.email,
        mainAddress: user.mainAddress, // Mapeia Address se existir
        roles: user.roles,
      ),
    );

    // Address <-> JSON
    cfg
        .buildJsonMap<Address>(
          (json) => Address(
            street: json.getString('streetAddress', defaultValue: 'N/A'),
            city: json.getString('cityLocation', defaultValue: 'Unknown'),
            zipCode: json.getString('postalCode', defaultValue: '00000-000'),
          ),
        )
        .reverse(
          (address) => {
            'streetAddress': address.street,
            'cityLocation': address.city,
            'postalCode': address.zipCode,
          },
        );

    // Tag <-> JSON
    cfg
        .buildJsonMap<Tag>(
          (json) => Tag(
            id: json.getInt('tagId'),
            name: json.getString('tagName'),
          ),
        )
        .reverse(
          (tag) => {
            'tagId': tag.id,
            'tagName': tag.name,
          },
        );

    // User <-> JSON
    cfg
        .buildJsonMap<User>(
          (json) => User(
            name: json.getString('fullName'),
            email: json.getString('contactEmail'),
            password: json.getString('secretKey'), // Mapeando a senha do JSON
            mainAddress: json.mapToObject<Address>('primaryAddress'),
            shippingAddresses:
                json.mapToListOfObjects<Address>('otherAddresses'),
            roles: json.getListOf<String>('userRoles') ?? [],
            tags: json.mapToListOfObjects<Tag>('userTags') ?? [],
            isActive: json.getBool('activeStatus', defaultValue: true),
            age: json.getInt('userAge', defaultValue: 18),
            accountBalance: json.getDouble('balance', defaultValue: 0.0),
          ),
        )
        .reverse(
          (user) => {
            'fullName': user.name,
            'contactEmail': user.email,
            'activeStatus': user.isActive,
            'userAge': user.age,
            'balance': user.accountBalance,
            'primaryAddress': user.mainAddress?.toJson(),
            'otherAddresses': user.shippingAddresses?.toJsonList(),
            'userRoles': user.roles,
            'userTags': user.tags?.toJsonList(),
          },
        );
  });
}

// 3. EXEMPLOS DE USO
void main() {
  setupMappings();
  // --- Exemplo 1: JSON para Object (Address) ---
  print('\n--- 1. JSON para Object (Address) ---');
  final JSON addressJson = {
    'streetAddress': '123 Main St',
    'cityLocation': 'Metropolis',
    'postalCode': '12345-678'
  };
  final addressObject = addressJson.mapTo<Address>();
  print('Address Mapeado: $addressObject');
  print('Rua: ${addressObject.street}');

  // --- Exemplo 2: Object (Address) para JSON ---
  print('\n--- 2. Object (Address) para JSON ---');
  final addressToConvert =
      Address(street: '456 Oak Ave', city: 'Gotham', zipCode: '98765-432');
  final convertedAddressJson = addressToConvert.toJson();
  print('Address para JSON: ${jsonEncode(convertedAddressJson)}');

  // --- Exemplo 3 & 4: JSON <-> Object ---
  print('\n--- 3 & 4. JSON <-> Object (User) ---');
  final JSON userJsonData = {
    'appUser': {
      'fullName': 'Jane Doe',
      'contactEmail': 'jane.doe@example.com',
      'secretKey': 'supersecretpassword',
      'activeStatus': true,
      'userAge': 30,
      'balance': 123.45,
      'primaryAddress': {
        'streetAddress': '789 Pine Ln',
        'cityLocation': 'Star City',
        'postalCode': '11223-344'
      },
      'otherAddresses': [
        {
          'streetAddress': '101 River Rd',
          'cityLocation': 'Central City',
          'postalCode': '55667-788'
        },
        {
          'streetAddress': '202 Mountain Dr',
          'cityLocation': 'Fawcett City',
          'postalCode': '99001-122'
        }
      ],
      'userRoles': ['admin', 'editor', 'viewer'],
      'userTags': [
        {'tagId': 1, 'tagName': 'developer'},
        {'tagId': 2, 'tagName': 'dart-lover'}
      ]
    }
  };

  // JSON -> User
  final userObject = userJsonData.mapTo<User>(key: 'appUser');
  print('User Mapeado do JSON: \n$userObject');
  print('Endereço Principal do User: ${userObject.mainAddress?.city}');
  print(
      'Primeiro Endereço de Envio: ${userObject.shippingAddresses?.first.street}');
  print('Primeiro Papel: ${userObject.roles?.first}');
  print('Primeira Tag: ${userObject.tags?.first.name}');
  print('Idade: ${userObject.age}');
  print('Saldo: ${userObject.accountBalance}');

  // User -> JSON
  final userToConvert = User(
      name: 'Clark Kent',
      email: 'clark@dailyplanet.com',
      password: 'kryptoniteIsBad',
      isActive: true,
      age: 35,
      accountBalance: 1000.00,
      mainAddress:
          Address(street: 'Farm Road', city: 'Smallville', zipCode: '00001'),
      shippingAddresses: [
        Address(street: 'Fortress of Solitude', city: 'Arctic', zipCode: 'N/A')
      ],
      roles: [
        'reporter',
        'hero'
      ],
      tags: [
        Tag(id: 10, name: 'super'),
        Tag(id: 11, name: 'strong')
      ]);
  final convertedUserJson = userToConvert.toJson();
  print('\nUser para JSON: ${jsonEncode(convertedUserJson)}');

  // Lista de JSON <-> Lista de Object
  print('\n--- 5 & 6. Lista de JSON <-> Lista de Object (List<Address>) ---');
  final List<JSON> addressListJson = [
    {
      'streetAddress': '1 King St',
      'cityLocation': 'Capital City',
      'postalCode': '00001'
    },
    {
      'streetAddress': '2 Queen Ave',
      'cityLocation': 'Royal Town',
      'postalCode': '00002'
    },
  ];

  // List<JSON> -> List<Address>
  final List<Address> addressObjectList =
      addressListJson.mapToList<Address>().toList();
  print('Lista de Address Mapeada:');
  addressObjectList.forEach(print);

  // List<Address> -> List<JSON>
  final List<Address> addressesToConvertList = [
    Address(street: 'A St', city: 'ACity', zipCode: 'A1'),
    Address(street: 'B St', city: 'BCity', zipCode: 'B2'),
  ];
  final List<JSON> convertedAddressListJson =
      addressesToConvertList.toJsonList();
  print(
      '\nLista de Address para JSON: ${jsonEncode(convertedAddressListJson)}');

  print('\n--- 7. Tratamento de Nulos e Ausentes ---');
  final JSON partialAddressJson = {'streetAddress': 'Only Street'};
  final partialAddress = partialAddressJson.mapTo<Address>();
  print('Partial Address: $partialAddress');

  final JSON userWithMissingDataJson = {
    'appUser': {
      'fullName': 'Missing Info User',
      'contactEmail': 'missing@example.com',
    }
  };
  final partialUser = userWithMissingDataJson.mapTo<User>(key: 'appUser');
  print('Partial User: \n$partialUser');
  print('Main Address: ${partialUser.mainAddress}');
  print('Roles: ${partialUser.roles}');
  print('Tags: ${partialUser.tags}');
  print('isActive: ${partialUser.isActive}');
  print('Age: ${partialUser.age}');

  print('\n--- 8. DTO <-> Entity ---');
  final userForDto = User(
      name: 'Diana Prince',
      email: 'diana@them.com',
      password: 'lasso',
      isActive: true,
      age: 1000,
      accountBalance: 500.0,
      mainAddress: Address(
          street: 'Paradise Island', city: 'Themyscira', zipCode: 'N/A'),
      roles: ['ambassador', 'warrior']);
  final userDto = userForDto.mapTo<UserGetDto>();
  print('UserGetDto: $userDto');
}
