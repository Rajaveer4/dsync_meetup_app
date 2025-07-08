import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsync_meetup_app/core/config/firebase_initializer.dart';
import 'presentation/routes/app_router.dart';
import 'logic/auth/auth_cubit.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Firebase apps at start of main: ${Firebase.apps.map((app) => app.name).toList()}');
  

    // ✅ Initialize Firebase using the central helper
    await FirebaseInitializer.instance.init();

    final sharedPreferences = await SharedPreferences.getInstance();
    final authService = AuthService();
    final authCubit = AuthCubit(authService, sharedPreferences);

    runApp(MyApp(authCubit: authCubit));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;

  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => authCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter(authCubit).router,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
