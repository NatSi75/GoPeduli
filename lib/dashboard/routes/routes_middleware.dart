import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class GoPeduliRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated
        ? null
        : const RouteSettings(name: GoPeduliRoutes.login);
  }
}
