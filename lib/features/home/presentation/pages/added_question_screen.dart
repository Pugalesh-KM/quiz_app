import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/features/home/data/models/question_model.dart';
import 'package:quiz_app/shared/config/dimens.dart';

class AddedQuestionsScreen extends StatelessWidget {
  const AddedQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<QuestionModel> box = Hive.box<QuestionModel>('quizBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Questions'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<QuestionModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No questions added yet.'));
          }

          return ListView.separated(
            itemCount: box.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final question = box.getAt(index);
              if (question == null) return const SizedBox.shrink();

              return ListTile(
                title: Text(
                  question.question,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    question.options.length,
                        (i) => Text(
                      '${i + 1}. ${question.options[i]}${i == question.correctIndex ? ' ✅' : ''}',
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    box.deleteAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Question deleted')),
                    );
                  },
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: Dimens.standard_16, vertical: Dimens.standard_8),
              );
            },
          );
        },
      ),
    );
  }
}
