class DartClassMapperException {
  final String message;

  DartClassMapperException(this.message);

  @override
  String toString() {
    return message;
  }
}
