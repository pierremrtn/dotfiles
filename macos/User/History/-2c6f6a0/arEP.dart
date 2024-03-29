import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router_prototype/go_router_prototype.dart';
import 'package:tech_by_tech/auth/auth.dart';

import 'widgets/widgets.dart';
import 'dashboard/dashboard.dart';
import 'profile/profile.dart';

RouteBase candidateRouteTree(BuildContext context) => ShellRoute(
      // path: '/candidate',
      // Temporary workaround for go router prototype
      path: '/',
      defaultRoute: 'ui-kit',
      redirect: (_) => authGuard(context),
      builder: (context, child) => CandidatePageShell(
        body: child,
      ),
      routes: [
        NestedStackRoute(
          path: 'ui-kit',
          builder: (context) => const UiKitPage(),
        ),
        NestedStackRoute(
          path: 'dashboard',
          builder: (context) => const CandidateDashboard(),
        ),
        ShellRoute(
          path: 'profile',
          defaultRoute: 'personal-information/user',
          builder: (context, child) => CandidateProfilePageShell(
            body: child,
          ),
          routes: [
            ShellRoute(
                path: 'personal-information',
                builder: (context, child) => const CandidateProfilePageShell(
                      body: CandidateUserDetails(),
                    ),
                routes: [
                  StackedRoute(
                      path: 'user',
                      builder: (context) => CandidateUserDetails())
                ]),
            // StackedRoute(
            //   path: 'professional-information',
            //   builder: (context) => const CandidatePersonalInformation(),
            // ),
          ],
        ),
      ],
    );
