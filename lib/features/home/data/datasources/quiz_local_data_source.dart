import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:quiz_app/features/home/data/models/question_model.dart';

abstract class IQuizLocalDataSource {
  Future<void> init();
  Future<List<QuestionModel>> getQuestions();
}

class QuizLocalDataSource implements IQuizLocalDataSource {
  final Box<QuestionModel> box;

  QuizLocalDataSource(this.box);

  @override
  Future<void> init() async {
    if (box.isEmpty) {
      final jsonString = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = jsonDecode(jsonString);
      final questions = data.map((e) => QuestionModel.fromJson(e)).toList();
      await box.addAll(questions);
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions() async {
    return box.values.toList();
  }

  Future<void> addQuestion(QuestionModel question) async {
    await box.add(question);
  }
}
