String enumToString(Object? enumValue) {
  final stringValue = enumValue.toString().split('.').last;
  return stringValue[0].toUpperCase() +
      stringValue.substring(1).replaceAllMapped(
          RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}');
}