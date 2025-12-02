import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/config/app_config.dart';
import 'package:ppt_generator/core/constants/app_routes.dart';
import 'package:ppt_generator/core/theme/app_theme.dart';
import 'package:ppt_generator/core/theme/bloc/theme_bloc.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_bloc.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();

  await Supabase.initialize(
    url: AppConfig.getString('SUPABASE_URL') ?? '',
    anonKey: AppConfig.getString('SUPABASE_ANON_KEY') ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<PptGeneratorBloc>(create: (context) => PptGeneratorBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<HistoryBloc>(create: (context) => HistoryBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'PPT Generator',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
