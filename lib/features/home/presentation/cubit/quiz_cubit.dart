import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/features/home/data/models/question_model.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final Box<QuestionModel> quizBox;

  QuizCubit(this.quizBox) : super(QuizInitial());

  void loadQuiz() {
    final questions = quizBox.values.toList();
    emit(QuizLoaded(questions, 0, 0));
  }

  void answerQuestion(int selectedIndex) {
    if (state is QuizLoaded) {
      final current = state as QuizLoaded;
      final isCorrect = current.questions[current.currentIndex].correctIndex == selectedIndex;
      final nextIndex = current.currentIndex + 1;
      final updatedScore = isCorrect ? current.score + 1 : current.score;

      if (nextIndex < current.questions.length) {
        emit(QuizLoaded(current.questions, nextIndex, updatedScore));
      } else {
        emit(QuizLoaded(current.questions, nextIndex, updatedScore));
      }
    }
  }
}