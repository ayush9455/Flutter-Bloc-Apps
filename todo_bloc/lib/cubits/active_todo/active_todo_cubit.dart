// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:todo_bloc/cubits/todo_list/todo_list_cubit.dart';

part 'active_todo_state.dart';

class ActiveTodoCubit extends Cubit<ActiveTodoState> {
  late final StreamSubscription todoListSubscription;
  final TodoListCubit todoListCubit;
  ActiveTodoCubit({
    required this.todoListCubit,
  }) : super(ActiveTodoState(
            activeTodoCount: todoListCubit.state.todos.length)) {
    todoListSubscription = todoListCubit.stream.listen((todoListState) {
      final int currentActiveTodoCount = todoListState.todos
          .where((element) => !element.completed)
          .toList()
          .length;
      emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
    });
  }
  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
