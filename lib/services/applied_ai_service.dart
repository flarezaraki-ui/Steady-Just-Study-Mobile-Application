import 'dart:convert';
import 'package:http/http.dart' as http;

class AppliedAIService {
  static const groqKey =
      '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';
  static const groqModel = 'llama-3.1-8b-instant';
  static const groqUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> askGroq(String prompt) async {
    final response = await http.post(
      Uri.parse(groqUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $groqKey',
      },
      body: jsonEncode({
        'model': groqModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Groq API error ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body);
    return json['choices'][0]['message']['content'];
  }

  Future<String> askQuestion(String question) async {
    //prompt given to the AI to be dedicated to IT students and help them if stressed
    final prompt =
        ''' 
  You are a IT Study assistant inside a study app. 
  Answer the student's question about code and if their code has any errors. 
  If the user has any stress compliants, start with I hear you.
  Keep your answer short, simple and easy to understand (2 to 4 sentences) unless stated otherwise by the user. 
  Do not use any markdown formatting. 
  Student QUESTION: 
  $question 
  ''';
    return askGroq(prompt);
  }
}
