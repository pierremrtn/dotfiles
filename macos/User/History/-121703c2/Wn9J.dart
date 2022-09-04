import 'package:bonemeal/bonemeal.dart';
import 'package:model_generators/model_generators.dart';

final _fieldsBase = {
  jsonField('title', refer('String'), name: 'degree'),
  jsonField('school', refer('String'), name: 'schoolName'),
  jsonField('location', refer('String')),
  jsonField('startDate', refer('DateTime'), name: 'startingDate'),
  jsonField('endDate', refer('DateTime?')),
  jsonField('description', refer('String?')),
};

class Education extends Seed {
  @override
  MetaObject grow(BuildContext context) {
    return JsonSerializable(
      'Education',
      {
        jsonField('id', refer('String'), name: 'educationId'),
        ..._fieldsBase,
      },
      methods: [
        method(
          'displayPeriod',
          refer('String', 'package:translations/translations.dart'),
          requiredParameters: {
            funcParam('context',
                refer('BuildContext', 'package:flutter/material.dart')),
          },
          body: const Code('''
if (endDate == null) {
  return context.l10n.period_ongoing(startDate);
}
return context.l10n
    .period_ended(startDate, endDate!);
'''),
        ),
      ],
    );
  }
}

class NewEducation extends Seed {
  @override
  MetaObject grow(BuildContext context) {
    return JsonSerializable(
      'NewEducation',
      _fieldsBase,
    );
  }
}

class EducationUpdate extends Seed {
  @override
  MetaObject grow(BuildContext context) {
    return JsonSerializable('EducationUpdate', {
      jsonField('id', refer('String')),
      ...Fields(_fieldsBase).toNullable(),
    });
  }
}