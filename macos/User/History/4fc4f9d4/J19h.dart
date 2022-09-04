import 'package:bonemeal/bonemeal.dart';
import 'package:model_generators/model_generators.dart';

extension TranslationExtension on String {
  Expression get tr =>
      refer('context.l10n.$this', 'package:translations/translations.dart');
}

jsonDateField(String fieldName, {String? name}) => jsonField(
      fieldName,
      refer('DateTime'),
      required: true,
      fromJson: refer(
        'dateFromJson',
        'package:models/models.dart',
      ),
      toJson: refer(
        'dateToJson',
        'package:models/models.dart',
      ),
    );

jsonNullableDateField(String fieldName, {String? name}) => jsonField(
      fieldName,
      refer('DateTime?'),
      required: true,
      fromJson: refer(
        'nullableDateFromJson',
        'package:models/models.dart',
      ),
      toJson: refer(
        'nullableDateToJson',
        'package:models/models.dart',
      ),
    );

jsonFakeNullableDateField(String fieldName, {String? name}) => jsonField(
      fieldName,
      refer('DateTime?'),
      fromJson: refer(
        'fakeNullableDateFromJson',
        'package:models/models.dart',
      ),
      toJson: refer(
        'fakeNullableDateToJson',
        'package:models/models.dart',
      ),
    );