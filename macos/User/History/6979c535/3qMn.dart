import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:neat/neat.dart';
import 'package:translations/translations.dart';

import 'guide_editing_controller.dart';

class DateEditingController extends GuideEditingController {
  DateEditingController({
    DateTime? date,
    required String guide,
    required this.format,
  }) : super(
          guide: guide,
          text: date != null ? format.format(date) : null,
        );

  DateEditingController.yM({DateTime? date})
      : format = DateFormat('MM/y'),
        super(
          guide: 'MM/AAAA',
          text: date != null ? DateFormat.yM().format(date) : null,
        );

  final DateFormat format;

  set date(DateTime? date) {
    if (date == null) {
      text = '';
    } else {
      text = format.format(date);
    }
  }

  DateTime? get date {
    try {
      return format.parse(text);
    } catch (e) {
      return null;
    }
  }

  String? validator({
    required String onEmptyField,
    required String onInvalidFormat,
  }) {
    try {
      final parsedDate = format.parseStrict(text);
      final startDate = _controller.startDate.date;
      if (startDate != null) {
        if (parsedDate.isAfter(startDate) == false) {
          return context.l10n.form_error_date_is_not_after(startDate);
        }
      }
      return null;
    } catch (e) {
      return 'invalide date format';
    }
  }
}

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.initialDate,
    this.controller,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.label,
    this.enabled,
  });

  final DateTime? initialDate;
  final DateEditingController? controller;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? label;
  final bool? enabled;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final DateEditingController _controller = widget.controller ??
      DateEditingController.yM(
        date: widget.initialDate,
      );

  @override
  Widget build(BuildContext context) {
    return TbtTextField(
      controller: _controller,
      enabled: widget.enabled,
      onChanged: (text) {
        widget.onChanged?.call(_controller.date);
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]|/')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final newText = newValue.text.characters;
          final oldText = oldValue.text.characters;
          TextEditingValue result = newValue;

          if (newText.length == 2) {
            if (oldText.length < newText.length) {
              result = newValue.copyWith(
                text: '$newText/',
                selection: TextSelection(
                  baseOffset: newText.length + 1,
                  extentOffset: newText.length + 1,
                ),
              );
            } else if (oldText.length > newText.length) {
              result = newValue.copyWith(
                text: newText.first,
                selection: const TextSelection(
                  baseOffset: 1,
                  extentOffset: 1,
                ),
              );
            }
          }
          return result;
        })
      ],
      decoration: InputDecoration(
        labelText: widget.label ?? context.l10n.date_label,
        suffixIcon: IconButton(
          hoverColor: context.tbtColors.secondaryContainer.withOpacity(.47),
          color: context.tbtColors.text,
          icon: const Icon(
            Icons.date_range,
          ),
          onPressed: widget.enabled == true
              ? () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _controller.date ??
                        widget.initialDate ??
                        DateTime.now(),
                    firstDate: widget.firstDate ?? DateTime(1900),
                    lastDate: widget.lastDate ?? DateTime(2200),
                    builder: (context, child) => Theme(
                        data: context.theme.copyWith(
                          inputDecorationTheme:
                              context.theme.inputDecorationTheme.copyWith(
                            labelStyle: TextStyle(
                              color: context.tbtColors.text,
                            ),
                          ),
                        ),
                        child: child ?? const SizedBox.shrink()),
                  );
                  if (date != null && date != _controller.date) {
                    _controller.date = date;
                    widget.onChanged?.call(date);
                  }
                }
              : null,
        ),
      ),
    );
  }
}