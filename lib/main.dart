import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:withu_leave_tracker/config.dart';
import 'package:withu_leave_tracker/locator.dart';
import 'package:withu_leave_tracker/routes.dart';
import 'package:withu_leave_tracker/presentation/core/theme/app_theme.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/application/dashboard/dashboard_bloc.dart';
import 'package:withu_leave_tracker/application/leave_request/leave_request_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC0-Er1dvaauQorO38V6c0ZCug6d2USkuQ',
      authDomain: 'withu-leave-tracker.firebaseapp.com',
      projectId: 'withu-leave-tracker',
      storageBucket: 'withu-leave-tracker.firebasestorage.app',
      messagingSenderId: '995376043765',
      appId: '1:995376043765:web:b60161c51a7d49089e97bc',
      measurementId: 'G-HGPG4PW5TQ',
    ),
  );

  // Configure dependencies
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.authStateChanged()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => getIt<DashboardBloc>(),
        ),
        BlocProvider<LeaveRequestBloc>(
          create: (context) => getIt<LeaveRequestBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1440, 900), // Web design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: Config.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            // Disable browser navigation for web
            onGenerateTitle: (context) => Config.appName,
          );
        },
      ),
    );
  }
}
