import 'package:flutter/material.dart';
import 'package:quiz_app/features/home/data/models/question_model.dart';
import 'package:quiz_app/shared/config/dimens.dart';
import '../../data/datasources/quiz_local_data_source.dart';


class AddQuestionScreen extends StatefulWidget {
  final QuizLocalDataSource dataSource;

  const AddQuestionScreen({super.key, required this.dataSource});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
  List.generate(4, (_) => TextEditingController());
  int _correctAnswer = 0;

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final question = QuestionModel(
        question: _questionController.text,
        options: _optionControllers.map((e) => e.text).toList(),
        correctIndex: _correctAnswer,
      );
      widget.dataSource.addQuestion(question);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Question')),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.standard_16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                style: theme.textTheme.bodyLarge,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: _optionControllers[i],
                    decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                    style: theme.textTheme.bodyLarge,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                  ),
                );
              }),
              const SizedBox(height: Dimens.standard_12),
              DropdownButtonFormField<int>(
                value: _correctAnswer,
                items: List.generate(4, (i) {
                  return DropdownMenuItem(
                    value: i,
                    child: Text('Correct Answer: Option ${i + 1}'),
                  );
                }),
                onChanged: (value) => setState(() {
                  _correctAnswer = value!;
                }),
              ),
              const SizedBox(height: Dimens.standard_20),
              ElevatedButton(
                onPressed: _saveQuestion,
                child: const Text('Save Question'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
