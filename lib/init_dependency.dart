import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/auth/auth_service.dart';
import 'core/auth/blocs/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<AuthService>(AuthService());

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthService>()));
}
