# CONVERSaiTION

A Flutter native app to learn new languages through conversation with an ai-tutor.
Powered by OpanAi's ChatGTP-4 model.

## How to Use
This repository doesn't provide an API-key for OpenAi. So you have to provide your own.
To do so, simply
1. Create a file called `const.dart` in the `lib` folder and
2. Add the following code to `const.dart` (of course replacing the dummy text with your own key):

```dart
const String openAiKey = 'YOUR API-KEY GOES HERE';
```

Then simply run the app, selcet a language and topic and off you go!

## Completed Tasks and Roadmap
- [x] Flutter App Basics (Color and Text Scheme, Launcer Icon and Splash Screen)
- [x] Welcome Screen
- [x] Language and Topic Selction
- [x] Chat Screen with Dummy Functionality
- [x] Implement BloC/Cubit for Chat Screen Business Logic
- [x] Add ChatGpt Functionality
- [ ] Improve Tutor Prompt (currently inconsistent behaviour)
- [ ] Add Save and Load Thread Functionality
- [ ] Advanced Features like Vocabulary List and Quizzes
- [ ] Gamification to Drive Engagement[^1]

---
## Acknowledgement 
This app wouldn't be possible without the use of these amazing Flutter Packages:
- **chat_gpt_sdk:**
  A community driven wrapper for the ChatGPT API. Very useful, very badly documented.
  [on pub.dev](https://pub.dev/packages/chat_gpt_sdk)
- **dash_chat_2:**
  All you need to create a chat application. Seriously *it has everything* and is easy to use.
  [on pub.de](https://pub.dev/packages/dash_chat_2)
- **flutter_bloc:**
  Makes your code nice and clean and works like a charm, the number-one provider.
  [on pub.dev](https://pub.dev/packages/flutter_bloc)
- **flex_color_scheme:**
  Gives you full controll over your apps color scheme and helps you understand the inner workings of themes a bit more.
  [on pub.dev](https://pub.dev/packages/flex_color_scheme)



[^1]: I hate that sentence as much as you do.
And also wanted to try out footnotes.