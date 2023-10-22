import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/cubits/cubits.dart';
import 'package:todo_bloc/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoFilterCubit(),
        ),
        BlocProvider(
          create: (context) => TodoSearchCubit(),
        ),
        BlocProvider(
          create: (context) => TodoListCubit(),
        ),
        BlocProvider(
          create: (context) => ActiveTodoCubit(
              todoListCubit: BlocProvider.of<TodoListCubit>(context)),
        ),
        BlocProvider(
          create: (context) => FilteredTodoCubit(
              todoFilterCubit: BlocProvider.of<TodoFilterCubit>(context),
              todoListCubit: BlocProvider.of<TodoListCubit>(context),
              todoSearchCubit: BlocProvider.of<TodoSearchCubit>(context)),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo Bloc',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const ToDoPage()),
    );
  }
}
