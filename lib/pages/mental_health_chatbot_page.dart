import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';

class MentalHealthChatbotPage extends StatefulWidget {
  const MentalHealthChatbotPage({super.key});

  @override
  State<MentalHealthChatbotPage> createState() => _MentalHealthChatbotPageState();
}

class _MentalHealthChatbotPageState extends State<MentalHealthChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hello! I'm your mental health assistant. How can I support you today?");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(CalmTheme.spacingL),
      decoration: BoxDecoration(
        color: CalmTheme.primaryGreen,
        boxShadow: [
          BoxShadow(
            color: CalmTheme.primaryGreen.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.self_improvement,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: CalmTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wellness Assistant',
                    style: CalmTheme.headingMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Container(
      color: CalmTheme.lightGreen.withOpacity(0.1),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(CalmTheme.spacingL),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageBubble(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: CalmTheme.spacingM),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CalmTheme.sage.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.spa,
                  color: CalmTheme.primaryGreen,
                  size: 18,
                ),
              ),
              SizedBox(width: CalmTheme.spacingS),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.all(CalmTheme.spacingM),
                decoration: BoxDecoration(
                  color: isUser 
                    ? CalmTheme.primaryGreen 
                    : CalmTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CalmTheme.sage.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: CalmTheme.bodyLarge.copyWith(
                    color: isUser 
                      ? Colors.white 
                      : CalmTheme.textPrimary,
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              SizedBox(width: CalmTheme.spacingS),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CalmTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.person,
                  color: CalmTheme.primaryGreen,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(CalmTheme.spacingL),
      decoration: BoxDecoration(
        color: CalmTheme.surface,
        border: Border(
          top: BorderSide(
            color: CalmTheme.sage.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CalmTheme.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: CalmTheme.sage.withOpacity(0.3),
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Share what\'s on your mind...',
                  hintStyle: CalmTheme.bodyLarge.copyWith(
                    color: CalmTheme.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: CalmTheme.spacingL,
                    vertical: CalmTheme.spacingM,
                  ),
                ),
                style: CalmTheme.bodyLarge,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          SizedBox(width: CalmTheme.spacingM),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: CalmTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    
    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 1000), () {
      _addBotMessage(_generateBotResponse(text));
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('anxious') || message.contains('anxiety')) {
      return "I understand you're feeling anxious. Try the 4-7-8 breathing technique: Inhale for 4 counts, hold for 7, exhale for 8. Would you like me to guide you through some breathing exercises?";
    } else if (message.contains('sad') || message.contains('depressed')) {
      return "I'm sorry you're feeling this way. Remember that it's okay to feel sad sometimes. Have you tried any mood-lifting activities today, like taking a walk or listening to music?";
    } else if (message.contains('stress') || message.contains('stressed')) {
      return "Stress can be overwhelming. Let's break it down - what's the main thing causing you stress right now? Sometimes talking about it can help reduce its power over us.";
    } else if (message.contains('sleep') || message.contains('tired')) {
      return "Sleep is crucial for mental health. Try creating a bedtime routine: dim lights 1 hour before bed, avoid screens, and practice some gentle stretches or meditation.";
    } else if (message.contains('thank') || message.contains('thanks')) {
      return "You're very welcome! I'm here whenever you need support. Remember, taking care of your mental health is a sign of strength, not weakness.";
    } else {
      return "Thank you for sharing that with me. Can you tell me more about how you're feeling right now? I'm here to listen and support you.";
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
  }) : timestamp = DateTime.now();
}
