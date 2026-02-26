import 'package:flutter/widgets.dart';
import 'package:flutter_translate_fix/flutter_translate_fix.dart';

class LocalizedApp extends StatefulWidget {
  final Widget child;

  final LocalizationDelegate delegate;

  LocalizedApp(this.delegate, this.child);

  LocalizedAppState createState() => LocalizedAppState();

  static LocalizedApp of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<LocalizedApp>()!;
}
