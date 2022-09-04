import 'package:common/common.dart';
import 'package:flutter/material.dart';

extension CompleteRecordBottomSheet on BuildContext {
  Future<void> showCompleteRecordBottomSheet({
    VoidCallback? onConsultationRapportPressed,
    VoidCallback? onExamRapportPressed,
    VoidCallback? onFollowUpPressed,
    VoidCallback? onCloseRecordPressed,
  }) {
    void closeAndCall(VoidCallback? callback) {
      Navigator.of(this, rootNavigator: true).pop();
      callback?.call();
    }

    return showZanalysBottomSheet(
      title: l10n.hub_bottom_sheet_title,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => closeAndCall(onConsultationRapportPressed),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(l10n.hub_bottom_sheet_consultation_rapport),
              ),
            ),
            SpaceSmaller.h(),
            // Flexible(
            //   child: LimitedBox(
            //     maxHeight: 30,
            //   ),
            // ),
            OutlinedButton(
              onPressed: () => closeAndCall(onExamRapportPressed),
              child: Text(l10n.hub_bottom_sheet_exam_rapport),
            ),
            HighlightedOutlinedButton(
              onPressed: () => closeAndCall(onFollowUpPressed),
              child: Text(l10n.hub_bottom_sheet_followup),
            ),
            OutlinedButton(
              onPressed: () => closeAndCall(onCloseRecordPressed),
              child: Text(l10n.hub_bottom_sheet_close_record),
            ),
            const SpaceSmall.h(),
          ],
        ),
      ),
    );
  }
}