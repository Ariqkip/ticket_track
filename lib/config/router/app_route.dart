import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ticket_track/config/router/route_constant.dart';
import 'package:ticket_track/features/events/presentation/screens/event_details_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/events/domain/entities/events.dart';
import '../../features/events/presentation/screens/events_list_screen.dart';
import '../../features/ticket_scanner/presentation/screens/screen_scannner.dart';

Page<dynamic> _buildPageWithCustomTransition(Widget child) {
  final Event event;
  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // from right to left
      const end = Offset.zero;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    child: child,
  );
}

GoRoute defaultTransitionRoute({
  required String path,
  required String name,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) =>
        _buildPageWithCustomTransition(builder(context, state)),
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final Event event;
  return GoRouter(
    initialLocation: RouteConstant.sign_up,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: RouteConstant.sign_up,
        name: RouteConstant.sign_up,
        pageBuilder: (context, state) =>
            _buildPageWithCustomTransition(const SignUpScreen()),
      ),
      GoRoute(
        path: RouteConstant.login,
        name: RouteConstant.login,
        pageBuilder: (context, state) =>
            _buildPageWithCustomTransition(const LoginScreen()),
      ),
      GoRoute(
        path: RouteConstant.events,
        name: RouteConstant.events,
        pageBuilder: (context, state) =>
            _buildPageWithCustomTransition(const EventsListScreen()),
      ),
      GoRoute(
        path: RouteConstant.event_scanner,
        name: RouteConstant.event_scanner,
        pageBuilder: (context, state) {
          final event = state.extra as Event;
          return _buildPageWithCustomTransition(ScannerScreen(event: event));
        },
      ),
      GoRoute(
        path: RouteConstant.event_details,
        name: RouteConstant.event_details,
        pageBuilder: (context, state) {
          final event = state.extra as Event;
          return _buildPageWithCustomTransition(
            EventDetailsScreen(event: event),
          );
        },
      ),
    ],
  );
});
