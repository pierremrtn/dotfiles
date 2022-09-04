import 'package:bonemeal/bonemeal.dart';

String declareHook({
  required String baseName,
  List<String>? hooks,
}) {
  if (baseName.startsWith('_')) baseName = baseName.substring(1);
  if (baseName.startsWith(r'$')) baseName = baseName.substring(1);

  String className = baseName.pascalCase;
  if (baseName.endsWith('Transformer') == false) {
    className = '${className}Transformer';
  }

  String utilsParamValue = utils?.isNotEmpty == true
      ? """
Code('''
${utils?.join('\n\n')}
''')
"""
      : 'null';

  return """
class $className extends Transformer{
    $className() : super(
    transformer: Code('''
$transformer
'''),
    utils: $utilsParamValue,
  );
}
""";
}