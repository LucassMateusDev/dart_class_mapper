import 'package:dart_class_mapper/dart_class_mapper.dart';
import 'package:dart_class_mapper/src/mapper/mapper_service.dart';
import 'package:test/test.dart';

import '../example/dart_class_mapper_json_example.dart';

void main() {
  setUpAll(() {
    MapperService.i.clear();
    setupMappings();
  });

  group('JSON Mapping', () {
    test('JSON to Simple Object (Address)', () {
      // Arrange
      final JSON json = {
        'streetAddress': '10 Downing St',
        'cityLocation': 'London',
        'postalCode': 'SW1A 2AA'
      };

      // Act
      final address = json.mapTo<Address>();

      // Assert
      expect(address.street, equals('10 Downing St'));
      expect(address.city, equals('London'));
      expect(address.zipCode, equals('SW1A 2AA'));
    });

    test('Simple Object (Address) to JSON', () {
      // Arrange
      final address = Address(
        street: '221B Baker St',
        city: 'London',
        zipCode: 'NW1 6XE',
      );

      // Act
      final json = address.toJson();

      // Assert
      expect(json['streetAddress'], equals('221B Baker St'));
      expect(json['cityLocation'], equals('London'));
      expect(json['postalCode'], equals('NW1 6XE'));
    });

    test('JSON to Complex Object (User)', () {
      // Arrange
      final JSON json = {
        'appUser': {
          'fullName': 'Peter Parker',
          'contactEmail': 'pete@dailybugle.com',
          'secretKey': ' radioactiveSpider',
          'activeStatus': true,
          'userAge': 25,
          'balance': 50.25,
          'primaryAddress': {
            'streetAddress': 'Aunt May Parker House',
            'cityLocation': 'Queens',
            'postalCode': '11367'
          },
          'otherAddresses': [
            {
              'streetAddress': 'Stark Tower',
              'cityLocation': 'New York',
              'postalCode': '10001'
            }
          ],
          'userRoles': ['photographer', 'hero'],
          'userTags': [
            {'tagId': 3, 'tagName': 'friendly'},
            {'tagId': 4, 'tagName': 'neighborhood'}
          ]
        }
      };

      // Act
      final user = json.mapTo<User>(key: 'appUser');

      // Assert
      expect(user.name, equals('Peter Parker'));
      expect(user.email, equals('pete@dailybugle.com'));
      expect(user.password, equals(' radioactiveSpider'));
      expect(user.isActive, isTrue);
      expect(user.age, equals(25));
      expect(user.accountBalance, equals(50.25));
      expect(user.mainAddress?.street, equals('Aunt May Parker House'));
      expect(user.mainAddress?.city, equals('Queens'));
      expect(user.shippingAddresses?.length, equals(1));
      expect(user.shippingAddresses?.first.street, equals('Stark Tower'));
      expect(user.roles, containsAll(['photographer', 'hero']));
      expect(user.tags?.length, equals(2));
      expect(user.tags?.first.name, equals('friendly'));
    });

    test('Complex Object (User) to JSON', () {
      // Arrange
      final user = User(
        name: 'Tony Stark',
        email: 'tony@stark.com',
        password: 'ironman',
        isActive: true,
        age: 45,
        accountBalance: 1000000000.0,
        mainAddress: Address(
          street: 'Stark Tower',
          city: 'New York',
          zipCode: '10001',
        ),
        shippingAddresses: [
          Address(
            street: 'Malibu Point',
            city: 'Malibu',
            zipCode: '90265',
          )
        ],
        roles: ['genius', 'billionaire', 'playboy', 'philanthropist'],
        tags: [
          Tag(id: 5, name: 'ironman'),
          Tag(id: 6, name: 'avenger'),
        ],
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['fullName'], equals('Tony Stark'));
      expect(json.containsKey('secretKey'), isFalse);
      expect(json['activeStatus'], isTrue);
      expect(json['userAge'], equals(45));
      expect(json['primaryAddress']['streetAddress'], equals('Stark Tower'));
      expect(json['otherAddresses'].first['cityLocation'], equals('Malibu'));
      expect(json['userRoles'], contains('genius'));
      expect(json['userTags'].first['tagName'], equals('ironman'));
    });

    test('List of JSON to List of Objects (List<Address>)', () {
      // Arrange
      final List<JSON> jsonList = [
        {
          'streetAddress': '1 Wayne Manor',
          'cityLocation': 'Gotham',
          'postalCode': 'G1 2WA'
        },
        {
          'streetAddress': 'Batcave',
          'cityLocation': 'Under Wayne Manor',
          'postalCode': 'SECRET'
        }
      ];

      // Act
      final addresses = jsonList.mapToList<Address>();

      // Assert
      expect(addresses.length, equals(2));
      expect(addresses.first.street, equals('1 Wayne Manor'));
      expect(addresses.last.city, equals('Under Wayne Manor'));
    });

    test('List of Objects (List<Address>) to List of JSON', () {
      // Arrange
      final addresses = [
        Address(street: 'Daily Planet', city: 'Metropolis', zipCode: 'M1 1AA'),
        Address(street: 'Fortress of Solitude', city: 'Arctic', zipCode: 'NONE')
      ];

      // Act
      final jsonList = addresses.toJsonList();

      // Assert
      expect(jsonList.length, equals(2));
      expect(jsonList.first['streetAddress'], equals('Daily Planet'));
      expect(jsonList.last['cityLocation'], equals('Arctic'));
    });

    test('JSON with missing optional fields', () {
      // Arrange
      final JSON json = {
        'userNode': {
          'fullName': 'Wade Wilson',
          'contactEmail': 'deadpool@xforce.com',
        }
      };

      // Act
      final user = json.mapTo<User>(key: 'userNode');

      // Assert
      expect(user.name, equals('Wade Wilson'));
      expect(user.password, isEmpty);
      expect(user.isActive, isTrue);
      expect(user.age, equals(18));
      expect(user.accountBalance, equals(0.0));
      expect(user.mainAddress, isNull);
      expect(user.shippingAddresses, isNull);
      expect(user.roles, isEmpty);
      expect(user.tags, isEmpty);
    });

    test('Nested object mapping not registered', () {
      // Arrange
      MapperService.i.clear();
      Mapper.configure((cfg) {
        cfg.buildJsonMap<User>((json) => User(
              name: json.getString('fullName'),
              email: json.getString('contactEmail'),
              password: json.getString('secretKey'),
              mainAddress: json.mapToObject<Address>('primaryAddress'),
              isActive: json.getBool('activeStatus', defaultValue: true),
              age: json.getInt('userAge', defaultValue: 18),
              accountBalance: json.getDouble('balance', defaultValue: 0.0),
            ));
      });

      final JSON json = {
        'fullName': 'Test User Missing AddressMap',
        'contactEmail': 'test@example.com',
        'secretKey': 'password',
        'primaryAddress': {
          'streetAddress': '123 St',
          'cityLocation': 'City',
          'postalCode': '123'
        }
      };

      // Act
      final user = json.mapTo<User>();

      // Assert
      expect(user.name, equals('Test User Missing AddressMap'));
      expect(user.mainAddress, isNull);

      MapperService.i.clear();
      setupMappings();
    });

    test('Invalid data type for field uses default', () {
      // Arrange
      final JSON json = {
        'fullName': 'Type Error User',
        'contactEmail': 'type@error.com',
        'secretKey': 'password',
        'userAge': 'not-an-int'
      };

      // Act
      final user = json.mapTo<User>();

      // Assert
      expect(user.name, equals('Type Error User'));
      expect(user.age, equals(18));
    });
  });
}
