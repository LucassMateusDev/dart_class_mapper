## [1.2.0]

### Added
- **Mapper:** A `Mapper` class has been added with static methods to simplify the configuration and usage of mappings:

    - `static void configure(void Function(MapperConfiguration cfg) configure)` : Central entry point to register all mappings.

    - `static T map<T, R>(R value)` : Performs the mapping of an object from type R to type T using the registered mappings.

- **Enhanced JSON Mapping:**
    - Introduced `buildJsonMap` in `MapperConfiguration` to define direct mappings between Dart objects and JSON (`Map<String, dynamic>`).
    - Added support for `.reverse()` on `buildJsonMap` for bidirectional JSON to Object and Object to JSON conversions.
    - Implemented `JsonParsingHelpers` (extension on `JSON` type alias for `Map<String, dynamic>`) with utility methods for safe and convenient data extraction from JSON:
        - `getString(key, defaultValue?)`
        - `getInt(key, defaultValue?)`
        - `getDouble(key, defaultValue?)`
        - `getBool(key, defaultValue?)`
        - `getObject(key)`
        - `getListOf<T>(key)`
        - `mapToObject<Model>(key)` (for nested JSON objects)
        - `mapToListOfObjects<Model>(key)` (for lists of JSON objects)
    - Added `toJson()` extension method on `Object` for easy serialization of mapped objects to JSON.
    - Added `mapTo<T>({String key = ''})` extension method on `JSON` for deserialization, supporting extraction from a nested JSON key.
    - Added `toJsonList()` extension on `Iterable<Object>` for serializing lists of objects to lists of JSON.
    - Added `mapToObjectsList<T>()` extension on `List<JSON>` for deserializing lists of JSON to lists of objects.

## [1.1.1]
* Adjust formatting

## [1.1.0]
* Added reverse function on CreateMap
* Readme migrated to English
* Description migrated to English

## [1.0.2]
* Description adjustment 

## [1.0.1]
* Description adjustment 

## [1.0.0]

* Initial version.
