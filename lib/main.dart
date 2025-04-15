import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_objectbox/data/objectbox/objectbox.dart';
import 'package:flutter_todo_objectbox/presentation/screens/todo_list_screen.dart';
import 'package:flutter_todo_objectbox/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Simple Todo List',
      theme: AppTheme.light,
      home: const TodoListScreen(),
    );
  }
}