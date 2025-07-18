import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/features/home/data/datasources/quiz_local_data_source.dart';
import 'package:quiz_app/features/home/data/models/question_model.dart';
import 'package:quiz_app/shared/config/dimens.dart';
import 'package:quiz_app/shared/cubit/theme_cubit.dart';
import 'package:quiz_app/shared/theme/text_styles.dart';
import '../cubit/quiz_cubit.dart';
import 'add_question_screen.dart';
import 'added_question_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<QuizCubit>().loadQuiz();
  }

  Future<void> _navigateToAddQuestion() async {
    final box = Hive.box<QuestionModel>('quizBox');
    final dataSource = QuizLocalDataSource(box);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddQuestionScreen(dataSource: dataSource),
      ),
    );
    context.read<QuizCubit>().loadQuiz();
  }

  Future<void> _navigateToViewQuestions() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddedQuestionsScreen()),
    );
    context.read<QuizCubit>().loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Time!', style: AppTextStyles.openSansBold20),
        centerTitle: true,
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                  context.read<ThemeCubit>().setTheme(newMode);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.standard_16),
        child: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state is QuizInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuizLoaded && state.currentIndex < state.questions.length) {
              final question = state.questions[state.currentIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${state.currentIndex + 1}/${state.questions.length}',
                        style: AppTextStyles.openSansBold16,
                      ),
                      ElevatedButton(
                        onPressed: _navigateToAddQuestion,
                        child: const Text('Add New Question'),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.standard_16),
                  Container(
                    padding: const EdgeInsets.all(Dimens.standard_20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimens.standard_16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      style: AppTextStyles.openSansBold20,
                    ),
                  ),
                  const SizedBox(height: Dimens.standard_24),
                  ...question.options.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimens.standard_6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all( Dimens.standard_16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( Dimens.standard_12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () =>
                            context.read<QuizCubit>().answerQuestion(entry.key),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            entry.value,
                            style: AppTextStyles.openSansBold16.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Score: ${state.score}',
                      style: AppTextStyles.openSansBold16,
                    ),
                  ),
                ],
              );
            } else if (state is QuizLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height:  Dimens.standard_20),
                    const Text(
                      '🎉 Quiz Finished! 🎉',
                      style: AppTextStyles.openSansBold24,
                    ),
                    const SizedBox(height:  Dimens.standard_10),
                    Text(
                      'Your Score: ${state.score}/${state.questions.length}',
                      style: AppTextStyles.openSansBold20,
                    ),
                    const SizedBox(height:  Dimens.standard_30),
                    ElevatedButton(
                      onPressed: () => context.read<QuizCubit>().loadQuiz(),
                      child: Column(
                        children: [
                          const Text(
                            'Restart Quiz',
                            style: AppTextStyles.openSansBold16,
                          ),

                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _navigateToViewQuestions,
                      child: const Text('View All Answer of Question'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
