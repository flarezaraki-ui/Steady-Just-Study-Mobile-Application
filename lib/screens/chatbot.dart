import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/applied_ai_provider.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  static String routeName = '/chatbot';

  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  var form = GlobalKey<FormState>();
  String? question;

  // Holds the conversation so far. Each entry is one message.
  final List<String> messages = [];

  Future<void> sendQuestion() async {
    bool isValid = form.currentState!.validate();
    if (!isValid) return;

    form.currentState!.save();

    setState(() {
      messages.add('You: $question');
    });
    form.currentState!.reset();

    final appliedAIService = ref.read(appliedAIServiceProvider);
    final answer = await appliedAIService.askQuestion(question!);

    // Add the AI's reply once it arrives.
    setState(() {
      messages.add('AI: $answer');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Brodie, Study Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: form,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Ask about Code or anything study related...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                      onSaved: (value) => question = value,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendQuestion,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
