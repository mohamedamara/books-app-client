import 'package:flutter/material.dart';

import 'core/navigation/navigation_router.dart';
import 'core/themes/custom_light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Books app',
      themeMode: ThemeMode.light,
      theme: CustomLightTheme.getTheme(context),
      initialRoute: initialRoute,
      onGenerateRoute: NavigationRouter.generateRoute,
    );
  }
}