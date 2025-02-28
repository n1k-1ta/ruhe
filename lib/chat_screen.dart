import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    // Получаем текущие отступы для клавиатуры
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bottomInset = viewInsets.bottom;

    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D), // Темный фон
      body: Column(
        children: [
          // Виджет для сообщений
          Container(
            height: MediaQuery.of(context).size.height * 0.9 - bottomInset,
            decoration: BoxDecoration(
              color: Color(0xFFD5D0E6), // Цвет фона виджета
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: chatProvider.messages.isEmpty
                ? Center(
                    child: Text(
                      "Чем я могу вам помочь?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? Color(0xFF0D0D0D) // Фон сообщений пользователя
                                : Colors.transparent, // Фон входящих сообщений
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[800]!),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser
                                  ? Color(0xFFD5D0E6) // Цвет текста пользователя
                                  : Color(0xFF0D0D0D), // Цвет текста входящих сообщений
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Поле ввода и кнопка отправки
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD5D0E6), // Цвет поля ввода
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Color(0xFF0D0D0D)), // Цвет текста
                      decoration: InputDecoration(
                        hintText: "Введите вопрос...",
                        hintStyle: TextStyle(color: Color(0xFF0D0D0D)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        chatProvider.sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
