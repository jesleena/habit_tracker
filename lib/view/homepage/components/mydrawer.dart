import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class MyDrawers extends StatelessWidget {
  const MyDrawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Center(
        child: Switch(
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) =>
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
        ),
      ),
    );
  }
}
