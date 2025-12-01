import 'package:conversaition/features/common/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // to deactivate the Debug Banner
      debugShowCheckedModeBanner: false,
      title: 'Conversaition',
      // Themes are created with flex_color_scheme
      theme: AppTheme.use(context, Brightness.light),
      darkTheme: AppTheme.use(context, Brightness.dark),
      // mode from settings
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('CONVERSaiTION')),
            body: Center(child: Text('Hello World!')),
          );
        },
      ),
    );
  }
}
