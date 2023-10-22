// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:todo_bloc/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:todo_bloc/cubits/todo_list/todo_list_cubit.dart';
import 'package:todo_bloc/cubits/todo_search/todo_search_cubit.dart';
import 'package:todo_bloc/models/todo_model.dart';

part 'filtered_todo_state.dart';

class FilteredTodoCubit extends Cubit<FilteredTodoState> {
  late final StreamSubscription todofilterStreamSubscription;
  late final StreamSubscription todoSearchStreamSubscription;
  late final StreamSubscription todoListStreamSubscription;
  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;
  FilteredTodoCubit({
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
  }) : super(FilteredTodoState(filteredTodos: todoListCubit.state.todos)) {
    todoListStreamSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      setFilterTodos();
    });
    todoSearchStreamSubscription =
        todoSearchCubit.stream.listen((TodoSearchState todoSearchState) {
      setFilterTodos();
    });
    todofilterStreamSubscription =
        todoFilterCubit.stream.listen((TodoFilterState todoFilterState) {
      setFilterTodos();
    });
  }
  void setFilterTodos() {
    List<Todo> filteredTodos;
    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        filteredTodos = todoListCubit.state.todos
            .where((element) => !element.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListCubit.state.todos
            .where((element) => element.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListCubit.state.todos;
    }

    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((element) => element.desc
              .toLowerCase()
              .contains(todoSearchCubit.state.searchTerm.toLowerCase()))
          .toList();
    }
    emit(state.copyWith(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoListStreamSubscription.cancel();
    todoSearchStreamSubscription.cancel();
    todofilterStreamSubscription.cancel();
    return super.close();
  }
}
