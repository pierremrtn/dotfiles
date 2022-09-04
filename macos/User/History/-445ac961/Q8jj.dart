part of '../observation_card.dart';

class _Symptoms extends StatelessWidget {
  const _Symptoms(this.data);

  final ObservationCardSymptomsData data;

  @override
  Widget build(BuildContext context) {
    return TitledSection(
      title: context.l10n.medical_history_title,
      subtitle: context.l10n.medical_history_subtitle,
      child: Wrap(
        spacing: Dimensions.spaceSmallest,
        children: data.items.map((item) => ColoredChip.orange(item)).toList(),
      ),
    );
  }
}