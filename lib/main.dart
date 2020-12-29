import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}