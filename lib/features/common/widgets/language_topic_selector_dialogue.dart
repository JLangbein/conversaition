// ignore_for_file: prefer_final_fields

import 'package:conversaition/features/chat/screens/chat_screen.dart';
import 'package:conversaition/features/common/data/supported_languages.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/language_picker_dropdown_controller.dart';
import 'package:language_picker/languages.dart';

class LanguageTopicSelectorDialogue extends StatefulWidget {
  const LanguageTopicSelectorDialogue({super.key});

  @override
  State<LanguageTopicSelectorDialogue> createState() =>
      _LanguageTopicSelectorDialogueState();
}

class _LanguageTopicSelectorDialogueState
    extends State<LanguageTopicSelectorDialogue> {
  // Language Picker Controller
  LanguagePickerDropdownController _languageController =
      LanguagePickerDropdownController(Languages.english);
  // Topic Input Controller
  final _topicController = TextEditingController();

  // States
  bool languagePicked = false;
  bool topicPicked = false;

  // method to start the chat navigates to chat screen
  // and hands over the selected language and topic
  void _start() {
    if (_languageController.value.name.isNotEmpty &&
        _topicController.text.isNotEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            language: _languageController.value.name,
            topic: _topicController.text,
          ),
        ),
        (_) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _languageController.dispose();
    _topicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start Conversation'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Text('Please select the language and the topic of the conversation!'),
          SizedBox(
            width: 270.0,
            child: LanguagePickerDropdown(
              // the controller functionality doesn't seem to work properly
              // hence the manual asigning of the value in setState
              controller: _languageController,
              languages: supportedLanguages,
              onValuePicked: (l) => setState(() {
                _languageController.value = l;
                languagePicked = true;
              }),
            ),
          ),
          SizedBox(
            width: 286.0,
            child: DropdownMenu(
              controller: _topicController,
              enableSearch: false,
              hintText: "Topic",
              inputDecorationTheme: InputDecorationThemeData(
                border: InputBorder.none,
                suffixIconColor: Theme.of(context).colorScheme.outline,
              ),
              textStyle: Theme.of(context).textTheme.titleMedium,
              width: double.infinity,
              menuStyle: MenuStyle(
                maximumSize: WidgetStatePropertyAll(Size.fromWidth(320.0)),
              ),

              onSelected: (_) => setState(() {
                topicPicked = true;
              }),
              dropdownMenuEntries: [
                DropdownMenuEntry<String>(
                  value: 'Business',
                  label: 'Business',
                  labelWidget: Text(
                    'Business',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuEntry<String>(
                  value: 'Hobbies',
                  label: 'Hobbies',
                  labelWidget: Text(
                    'Hobbies',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuEntry<String>(
                  value: 'Travel',
                  label: 'Travel',
                  labelWidget: Text(
                    'Travel',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuEntry<String>(
                  value: 'Food',
                  label: 'Food',
                  labelWidget: Text(
                    'Food',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuEntry<String>(
                  value: 'Music',
                  label: 'Music',
                  labelWidget: Text(
                    'Music',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuEntry<String>(
                  value: 'Movies',
                  label: 'Movies',
                  labelWidget: Text(
                    'Movies',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // two buttons for cancel and start the conversation
      actions: [
        FilledButton.tonalIcon(
          icon: Icon(Icons.cancel_rounded),
          onPressed: Navigator.of(context).pop,
          label: Text('Cancel'),
        ),
        FilledButton.icon(
          icon: Icon(Icons.check),
          onPressed: (languagePicked && topicPicked) ? _start : null,
          label: Text('Start'),
        ),
      ],
    );
  }
}
