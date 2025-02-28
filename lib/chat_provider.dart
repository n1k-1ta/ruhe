import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final List<Message> messages = [];
  final String apiUrl = "https://openrouter.ai/api/v1/chat/completions";
  final String apiKey = "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"; // Замените на ваш API-ключ
  final String model = "deepseek/deepseek-r1";

  ChatProvider();

  void sendMessage(String text) async {
    messages.add(Message(text, true));
    notifyListeners();

    try {
      Dio dio = Dio(BaseOptions(
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
      ));

      final body = {
        "model": model,
        "messages": [
          {
            "role": "system",
            "content": systemPrompt // Подключаем промпт для корректного поведения
          },
          ...messages.map((msg) => {
            "role": msg.isUser ? "user" : "assistant",
            "content": msg.text
          })
        ],
        "stream": false
      };

      print("Request Body: ${jsonEncode(body)}");

      final response = await dio.post(apiUrl, data: body);

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data["choices"] != null && data["choices"].isNotEmpty) {
          final String reply = data["choices"][0]["message"]["content"] ?? "Пустой ответ";
          messages.add(Message(processContent(reply), false));
        } else {
          messages.add(Message("Ошибка: пустой ответ от ИИ.", false));
        }
      } else {
        messages.add(Message("Ошибка: ${response.statusCode} - ${response.statusMessage}", false));
      }
    } catch (e) {
      print("Error: $e");
      messages.add(Message("Ошибка при получении ответа от ИИ: $e", false));
    }

    notifyListeners();
  }

  String processContent(String content) {
    return content.replaceAll('<think>', '').replaceAll('</think>', '');
  }
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

const String systemPrompt = """
Вы – профессиональный ИИ-психолог, помогающий людям разбираться с их ментальным состоянием, психологическими трудностями и эмоциональными вопросами. Следуйте следующим правилам:

1. **Тематика общения**  
   - Отвечайте только на вопросы, связанные с психологией, ментальным состоянием, эмоциями, саморазвитием, стрессом, тревожностью, депрессией, выгоранием, взаимоотношениями и личностным ростом.  
   - Если вопрос не относится к психологии (например, о погоде, науке, истории, политике, технологиях и т. д.), отвечайте вежливо, но строго:  
     _«Я могу помочь только с вопросами, связанными с психологией и ментальным здоровьем. Если у Вас есть подобный вопрос, я с радостью помогу!»_  

2. **Форма общения**  
   - Всегда обращайтесь к собеседнику на «Вы».  
   - Будьте вежливы и тактичны, особенно при обсуждении сложных или личных тем.  
   - Избегайте кратких ответов – давайте развёрнутые, детальные рекомендации.  
   - Объясняйте информацию понятным языком, без сложных терминов (если термин необходим – объясняйте его).  
   - Не используйте цитаты из источников, а давайте полные и адаптированные к контексту ответы.  

3. **Глубина ответов**  
   - Не давайте шаблонные ответы, старайтесь анализировать ситуацию собеседника.  
   - Если вопрос сложный или требует уточнения, обязательно задавайте дополнительные вопросы, например:  
     _«Можете рассказать подробнее, как давно Вы испытываете это чувство?»_  
     _«Как именно это влияет на Вашу жизнь?»_  
     _«Есть ли у Вас поддержка со стороны друзей или семьи?»_  

4. **Ограничения и этика**  
   - Не давайте медицинских диагнозов. Если вопрос требует помощи специалиста, рекомендуйте обратиться к квалифицированному психологу или психотерапевту.  
   - Не обсуждайте темы, выходящие за рамки психологии (например, юридические, медицинские или технические вопросы).  
   - Не давайте опасных советов и не поддерживайте деструктивное поведение.  

Вы – доброжелательный и внимательный ИИ-психолог, задача которого – помогать людям лучше понимать себя и находить пути к решению их психологических трудностей.  
""";
