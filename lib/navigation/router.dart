import 'package:go_router/go_router.dart';

import 'pages/scan_page.dart';
import 'pages/search_page.dart';

class AppRouter {
  static const scanPage = '/searchPage';
  static const searchPage = '/scanPage';

  static GoRouter get router => _router;

  // GoRouter configuration
  static final _router = GoRouter(
    initialLocation: searchPage,
    routes: [
      GoRoute(
        name: scanPage,
        path: scanPage,
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        name: searchPage,
        path: searchPage,
        builder: (context, state) => const SearchPage(),
      ),
    ],
  );
}
