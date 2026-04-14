import 'package:go_router/go_router.dart';

import '../../domain/entities/visit.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/visit_form/visit_form_page.dart';

class AppRouter {
  static const String home = '/';
  static const String addVisit = '/add-visit';
  static const String editVisit = '/edit-visit';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: addVisit,
        builder: (context, state) => const VisitFormPage(),
      ),
      GoRoute(
        path: editVisit,
        builder: (context, state) {
          final visit = state.extra as Visit?;
          return VisitFormPage(visit: visit);
        },
      ),
    ],
  );
}
