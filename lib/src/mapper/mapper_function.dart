// abstract class MapperFunction<T, R> {
//   T Function(R) mapping;

//   MapperFunction({required this.mapping});

//   T getValue(R data) => mapping(data);
// }

// class MapperObjectFunction<T, R> extends MapperFunction<T, R> {
//   MapperObjectFunction({required super.mapping});
// }

// class MapperJsonFunction<T, JSON> extends MapperFunction<T, JSON> {
//   MapperJsonFunction({this.jsonKey = '', required super.mapping});

//   final String jsonKey;

//   @override
//   T getValue(JSON data) {
//     var json = data as Map<String, dynamic>;
//     if (jsonKey.isNotEmpty) {
//       json = data[jsonKey];
//     }

//     return super.mapping(json as JSON);
//   }
// }
