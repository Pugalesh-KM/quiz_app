import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app/shared/cubit/theme_cubit.dart';
import 'package:quiz_app/shared/theme/app_theme.dart';

import 'features/home/data/datasources/quiz_local_data_source.dart';
import 'features/home/data/models/question_model.dart';
import 'features/home/presentation/cubit/quiz_cubit.dart';
import 'features/home/presentation/pages/quiz_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(QuestionModelAdapter());

  final box = await Hive.openBox<QuestionModel>('quizBox');
  final dataSource = QuizLocalDataSource(box);
  await dataSource.init();

  runApp(MyApp(box));
}

class MyApp extends StatelessWidget {
  final Box<QuestionModel> quizBox;

  const MyApp(this.quizBox, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuizCubit(quizBox)),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const QuizScreen(),
        ),
      ),
    );
  }
}