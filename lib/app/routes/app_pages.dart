import 'package:get/get.dart';
import 'package:qualnote/app/modules/overview/views/widgets/project_not_found.dart';

import '../modules/audio_recording/bindings/audio_recording_binding.dart';
import '../modules/audio_recording/views/audio_recording_view.dart';
import '../modules/authentication/login/bindings/login_binding.dart';
import '../modules/authentication/login/views/login_view.dart';
import '../modules/authentication/login/views/widgets/welcome_animation.dart';
import '../modules/authentication/register/bindings/register_binding.dart';
import '../modules/authentication/register/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/map/views/map_view.dart';
import '../modules/overview/bindings/overview_binding.dart';
import '../modules/overview/views/overview_view.dart';
import '../modules/reflection/bindings/reflection_binding.dart';
import '../modules/reflection/views/reflection_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeAnimation(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => const MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_RECORDING,
      page: () => AudioRecordingView(),
      binding: AudioRecordingBinding(),
    ),
    GetPage(
      name: _Paths.OVERVIEW,
      page: () => const OverviewView(),
      binding: OverviewBinding(),
    ),
    GetPage(
      name: _Paths.REFLECTION,
      page: () => const ReflectionView(),
      binding: ReflectionBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_NOT_FOUND,
      page: () => const ProjectNotFound(),
    ),
  ];
}
