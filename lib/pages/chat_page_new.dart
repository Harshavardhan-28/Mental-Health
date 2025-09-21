import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  // Track which response to use next
  int _currentResponseIndex = 0;

  // Sequential responses that cycle through in order
  final List<String> _sequentialResponses = [
    "I'm sorry to hear that you're not feeling good today. It takes courage to reach out, and I want you to know that I'm here to listen without judgment.\n\nFrom what I've gathered, when people feel this way, it's often a mix of sadness and a lack of motivation. It's a deeply human experience, and you are not alone in feeling this way.\n\nIf you're up for it, I'm here to listen to what's on your mind. Would you feel comfortable sharing a little bit about what's happening?",
    
    "Thank you for sharing that with me. It sounds incredibly heavy and exhausting to feel like you're carrying all that weight while trying to keep up with a world that won't stop moving. It's completely understandable that even small tasks feel monumental when you're navigating such a profound sense of exhaustion and doubt.\n\nThis feeling, that what you're doing doesn't matter, is something many people, especially students, grapple with. You're not alone in this. The key isn't to force yourself to feel motivated, but to gently get curious about what might be missing.",
    
    "Thank you for sharing that beautiful memory with me. It's not a small moment at all - it's really important. What you're describing is a moment of genuine purpose. All the external pressures faded away, and in their place was something simple and powerful: you used your skills to help someone.\n\nThat feeling you described—'calm, useful, and exactly where I should be'—that is the opposite of feeling like what you're doing doesn't matter. It's a profound clue about what gives your life meaning.",
    
    "Thank you for being so honest about what that feels like. The constant 'background noise' of worry and 'shoulds' is incredibly draining. It's like trying to have a quiet, meaningful conversation next to a roaring engine. Of course you're exhausted.\n\nThis perfect storm you're in - the cognitive noise drains your energy, the lack of energy makes fear feel bigger, and the fear keeps you from taking actions that might quiet the noise. It makes complete sense.",
    
    "Of course that's causing a lot of stress. When you're already feeling overwhelmed and your energy is at rock bottom, a calendar full of events feels like a list of obligations rather than opportunities.\n\nI want to give you full permission to put your well-being first. Choosing not to attend an event when you feel this way is not a failure. It's a necessary and wise act of self-preservation.",
    
    "Let's gently challenge that premise. The goal right now is not to figure out how you can do everything. The true goal is to protect your energy and well-being.\n\nFor every event you choose to skip, you are not failing. You are actively making a powerful choice to conserve your energy for what truly matters: your well-being and the few things that might actually help you feel better.",
    
    "I understand you're feeling anxious. Anxiety can be overwhelming, but remember that these feelings are temporary. Let's try to ground ourselves in the present moment.\n\nSometimes when anxiety hits, our minds race ahead to all the things that could go wrong. But right now, in this moment, you are safe. Try focusing on your breath.",
    
    "That sounds really challenging to deal with. It's understandable that you're looking for support and ways to cope with these feelings.\n\nEveryone's experience is different, but you're not alone in feeling this way. What you're sharing takes courage, and I'm here to listen and support you through this.",
    
    "I hear what you're saying, and I want you to know that your feelings are completely valid. Sometimes it helps just to have someone listen without judgment.\n\nWhat you're experiencing is real and important. Is there anything specific that's been weighing most heavily on your mind today?",
    
    "Thank you for continuing to share with me. It's clear you're going through a difficult time, and reaching out for support shows real strength.\n\nSometimes when we're struggling, even small steps can feel overwhelming. What feels like the most manageable thing you could focus on right now?",
    
    "I appreciate you being so open about your experiences. It takes courage to talk about difficult feelings, especially when everything feels heavy.\n\nRemember that healing isn't linear, and it's okay to have days where things feel harder. You're taking an important step by reaching out and talking about what you're going through.",
    
    "What you're describing resonates with so many people's experiences. That feeling of being stuck while life moves around you is exhausting and isolating.\n\nIt's important to remember that your worth isn't determined by your productivity or how well you keep up with others. You have value exactly as you are, even in this difficult moment.",
    
    "I can hear how much you're struggling right now, and I want you to know that it's okay to not be okay. Sometimes our minds and bodies need us to slow down, even when the world doesn't seem to want to stop.\n\nWhat's one small thing that has brought you even a moment of peace or comfort recently?",
    
    "The overwhelm you're feeling makes complete sense given everything you're dealing with. When we're already running on empty, every additional demand feels impossible.\n\nIt might help to remember that you don't have to figure everything out at once. Sometimes the most radical thing we can do is focus on just getting through today.",
    
    "Your honesty about these struggles is really meaningful. It shows self-awareness and courage to name what you're going through, even when it's difficult.\n\nWhat kind of support feels most important to you right now? Sometimes it's just having someone listen, sometimes it's working through specific challenges together."
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: "Hello! I'm here to support you with your mental health and well-being journey. I'm trained to listen without judgment and help you work through whatever you're experiencing.\n\nHow are you feeling today? Is there something particular on your mind that you'd like to talk about?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate agent response delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      final response = _getNextResponse();
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _getNextResponse() {
    // Get the current response
    final response = _sequentialResponses[_currentResponseIndex];
    
    // Move to next response, cycling back to 0 when we reach the end
    _currentResponseIndex = (_currentResponseIndex + 1) % _sequentialResponses.length;
    
    return response;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      appBar: AppBar(
        backgroundColor: CalmTheme.primaryGreen,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: CalmTheme.spacingM),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wellness Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Here to support you',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(CalmTheme.spacingM),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: CalmTheme.spacingM),
      child: Row(
        mainAxisAlignment: message.isUser 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: CalmTheme.primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: CalmTheme.spacingS),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(CalmTheme.spacingM),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? CalmTheme.primaryGreen 
                  : CalmTheme.sage.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CalmTheme.sage.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: CalmTheme.bodyMedium.copyWith(
                  color: message.isUser ? Colors.white : CalmTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: CalmTheme.spacingS),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: CalmTheme.sage.withOpacity(0.3),
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
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: CalmTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 18,
            ),
          ),
          SizedBox(width: CalmTheme.spacingS),
          Container(
            padding: EdgeInsets.all(CalmTheme.spacingM),
            decoration: BoxDecoration(
              color: CalmTheme.sage.withOpacity(0.2),
              borderRadius: BorderRadius.circular(18).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                SizedBox(width: CalmTheme.spacingXS),
                _buildTypingDot(1),
                SizedBox(width: CalmTheme.spacingXS),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: CalmTheme.primaryGreen.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(CalmTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CalmTheme.sage.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: CalmTheme.spacingM),
                decoration: BoxDecoration(
                  color: CalmTheme.sage.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: CalmTheme.sage.withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  style: CalmTheme.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Share what\'s on your mind...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: CalmTheme.spacingS),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
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
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
