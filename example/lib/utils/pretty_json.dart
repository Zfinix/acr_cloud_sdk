import 'dart:convert';

jsonPretty(Object obj) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(obj);
  return prettyprint;
}
