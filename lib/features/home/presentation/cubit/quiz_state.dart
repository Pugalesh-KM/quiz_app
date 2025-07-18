part of 'quiz_cubit.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;

  const QuizLoaded(this.questions, this.currentIndex, this.score);

  @override
  List<Object> get props => [questions, currentIndex, score];
}