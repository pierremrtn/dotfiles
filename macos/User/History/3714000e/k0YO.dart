import 'package:mustache_template/mustache_template.dart';

// const classTemplate = """
// class {{ ClassName }} {
//   const {{ ClassName }}({
//     {{ memberConstructorInitialization }}
//   });

//   {{ memberDeclarations }}
// }
// """;

class ClassGen {
  const ClassGen();

  String? generate(dynamic data) {
    // final t = Template(classTemplate, name: 'class.dart');
    if (data is Map<String, dynamic>) {
      final ctrInits = data.keys.map((key) => "this.${key}").join(",");
      final class = """
class {{ ClassName }} {
  const {{ ClassName }}({
    {{ memberConstructorInitialization }}
  });

  {{ memberDeclarations }}
}
""";

      return 
    }
    return null;
  }
}