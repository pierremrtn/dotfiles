import 'package:app_client/user/user.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neat/neat.dart';

import 'package:common/common.dart';
import '/passengers/passengers.dart';

class PassengersPage extends StatelessWidget {
  static const String route = "/passengers";
  static Widget builder(_) => const PassengersPage();

  const PassengersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PassengersBloc(
        userRepository: context.read(),
      ),
      child: Page(
        appBar: titledAppBar(
          context,
          title: context.l10n.passengers_page_title,
        ),
        body: const _PassengersPageBody(),
      ),
    );
  }
}

class _PassengersPageBody extends StatelessWidget {
  const _PassengersPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfos = context.select((UserBloc bloc) => bloc.user.infos);
    final passengers =
        context.select((UserBloc bloc) => bloc.user.favoritePassengers);
    final selectedPassengerID =
        context.select((UserBloc bloc) => bloc.user.defaultPassenger?.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Passenger(
          Passenger(
              id: -1,
              email: userInfos.email,
              firstName: userInfos.firstName,
              lastName: userInfos.lastName,
              mobile: userInfos.mobileA),
          selected: selectedPassengerID == null,
          onPressed: () => context
              .read<PassengersBloc>()
              .add(const PassengersEvent.passengerSelected(null)),
        ),
        ...passengers
            .map(
              (passenger) => _Passenger(
                passenger,
                selected: passenger.id == selectedPassengerID,
                onPressed: () => context
                    .read<PassengersBloc>()
                    .add(PassengersEvent.passengerSelected(passenger.id)),
              ),
            )
            .toList(),
        const Space4.h(),
        Button.menu(
          context.l10n.add_passanger_button,
          () => NewPassengerPage.open(context),
          icon: Icons.add,
          color: context.colorScheme.tertiary,
        ),
      ],
    );
  }
}

const double _iconSize = Dimensions.icon2;

class _Passenger extends StatelessWidget {
  const _Passenger(
    this.passenger, {
    this.selected = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final Passenger passenger;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const Padding4.vertical(),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              size: _iconSize,
            ),
            const Space4.w(),
            Expanded(
              child: context.subtitle2(
                "${passenger.firstName.toCapitalized} ${passenger.lastName.toCapitalized}",
              ),
            ),
            Radio<bool>(
              groupValue: true,
              value: selected,
              onChanged: (_) => onPressed?.call(),
              activeColor: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedIcon extends StatelessWidget {
  const _SelectedIcon(
    this.selected, {
    Key? key,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Radio<bool>(
      groupValue: true,
      value: selected,
      onChanged: (_) {},
    );
    return selected
        ? Icon(
            Icons.radio_button_checked_sharp,
            size: _iconSize,
            color: context.colorScheme.primary,
          )
        : Icon(
            Icons.radio_button_off,
            size: _iconSize,
            color: context.colorScheme.secondary,
          );
  }
}