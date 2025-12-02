import 'package:conversaition/features/common/widgets/language_topic_selector_dialogue.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CONVERSaiTION')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2.0,
          children: [
            Text(
              'Welcome to CONVERSaiTION!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Your smart conversational language tutor',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Click + to start a new conversation'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => LanguageTopicSelectorDialogue(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
