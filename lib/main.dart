import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/auth/blocs/auth_bloc.dart';
import 'core/auth/blocs/auth_event.dart';
import 'core/theme/theme.dart';
import 'core/widgets/splash_page.dart';
import 'init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final authBloc = getIt<AuthBloc>();
            authBloc.add(AppStarted());
            return authBloc;
          },
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blog App',
          theme: AppTheme.darkThemeMode,
          home: const SplashScreen()),
    );
  }
}
