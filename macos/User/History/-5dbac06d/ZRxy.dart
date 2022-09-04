import 'package:bonemeal/bonemeal.dart';
import 'package:form_generator/form_generator.dart';

class IntFormFieldController extends TextFormFieldController {
  IntFormFieldController({
    this.nullable = true,
  });

  final bool nullable;

  @override
  Reference get valueType => nullable ? refer('int?') : refer('int');

  @override
  Expression accessValue(Expression controller) => nullable
      ? refer('int.tryParse').call([controller.property('text')])
      : refer('int.parse').call([controller.property('text')]);

  @override
  Expression invokeController(Expression initialValue) {
    Expression? initial;
    if (nullable) {
      initial = initialValue
          .nullSafeProperty('toString')
          .call([]).ifNullThen(literal(null));
    } else {
      initial = initialValue
          .nullSafeProperty('toString')
          .call([]).ifNullThen(literal(null));
    }
    controllerType.newInstance([], {
      'text': initial,
    });
  }
}

class IntFormFieldWidget extends TextFormFieldWidget {
  IntFormFieldWidget({
    super.label,
    super.hint,
    super.validator,
    super.decorations = const {},
    super.parameters,
  });

  @override
  Map<String, Expression> defaultNamedParameters(Expression accessController) =>
      {
        ...super.defaultNamedParameters(accessController),
        'keyboardType': refer('TextInputType.number'),
        'inputFormatters': refer(
            '<TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]',
            'package:flutter/services.dart'),
      };
}

class IntFormField extends TextFormField {
  IntFormField(
    super.name, {
    super.label,
    super.hint,
    super.validator,
    super.decorations = const {},
    super.parameters = const {},
    this.nullable = true,
  });

  final bool nullable;

  @override
  IntFormFieldController get controller =>
      IntFormFieldController(nullable: nullable);

  @override
  IntFormFieldWidget get widget => IntFormFieldWidget(
        label: label,
        hint: hint,
        validator: validator,
        decorations: decorations,
        parameters: parameters,
      );
}