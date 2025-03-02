import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/menu_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          Container(
            width: double.infinity, 
            color: const Color(0xFFD5D0E6),
            padding: const EdgeInsets.symmetric(vertical: 10), 
            child: const Center(child: MenuWidget()), 
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD5D0E6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: chatProvider.messages.isEmpty
                  ? const Center(
                      child: Text(
                        "Чем я могу вам помочь?",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
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
                                  ? const Color(0xFF0D0D0D)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color: message.isUser
                                    ? const Color(0xFFD5D0E6)
                                    : const Color(0xFF0D0D0D),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Container(
            color: const Color(0xFF0D0D0D),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5D0E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Color(0xFF0D0D0D)),
                      decoration: const InputDecoration(
                        hintText: "Введите вопрос...",
                        hintStyle: TextStyle(color: Color(0xFF0D0D0D)),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
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
