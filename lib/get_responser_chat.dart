import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getChatGptResponse({required String question}) async {
  const apiURL = 'https://api.openai.com/v1/chat/completions';
  // أدخل مفتاح الواجهة البرمجية الخاص بك هنا.
  const apiKey =
      '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';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
    'Accept-Language': 'ar',
  };

  final requestBody = json.encode({
    "model": "gpt-3.5-turbo",
    'messages': [
      {"role": "system", "content": "You are a poet who creates poems that evoke emotions."},
      {"role": "user", "content": question}
    ],


  });

  final response = await http.post(
    Uri.parse(apiURL),
    headers: headers,
    body: requestBody,
  );
  const Utf8Codec().decode(response.bodyBytes);
  if (response.statusCode == 200) {
    final responseData =
        json.decode(const Utf8Codec().decode(response.bodyBytes));
    final output = responseData['choices'][0]['message']['content'].toString();
    return output;
  } else {
    return 'فشل في الاتصال بواجهة برمجة تطبيقات CHAT-GPT.\nتأكد من إدخال مفتاح الواجهة البرمجية الخاص بك';
  }
}
