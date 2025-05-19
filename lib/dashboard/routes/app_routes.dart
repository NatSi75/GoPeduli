import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:gopeduli/dashboard/routes/routes_middleware.dart';

import 'package:gopeduli/dashboard/screens/dashboard_screen.dart';
import 'package:gopeduli/dashboard/screens/login_screen.dart';

import 'package:gopeduli/dashboard/screens/articles/articles_screen.dart';
import 'package:gopeduli/dashboard/screens/articles/create_article_screen.dart';
import 'package:gopeduli/dashboard/screens/articles/edit_article_screen.dart';

import 'package:gopeduli/dashboard/screens/medicines/medicines_screen.dart';
import 'package:gopeduli/dashboard/screens/medicines/create_medicine_screen.dart';
import 'package:gopeduli/dashboard/screens/medicines/edit_medicine_screen.dart';

class GoPeduliAppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: GoPeduliRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: GoPeduliRoutes.logout,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: GoPeduliRoutes.dashboard,
      page: () => const DashboardScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.articles,
      page: () => const ArticlesScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.createArticle,
      page: () => const CreateArticleScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.editArticle,
      page: () => const EditArticleScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.medicines,
      page: () => const MedicinesScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.createMedicine,
      page: () => const CreateMedicineScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
    GetPage(
      name: GoPeduliRoutes.editMedicine,
      page: () => const EditMedicineScreen(),
      middlewares: [
        GoPeduliRouteMiddleware(),
      ],
    ),
  ];
}
