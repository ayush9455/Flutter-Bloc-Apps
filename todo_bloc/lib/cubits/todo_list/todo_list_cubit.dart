import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_bloc/models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState.initial());

  void addTodo(Todo newTodo) {
    final newTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: newTodos));
  }

  void editTodo(String id, String newDesc) {
    final newTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return Todo(desc: newDesc, id: id, completed: todo.completed);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void toggleTodo(String id) {
    final newTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return Todo(desc: todo.desc, id: id, completed: !todo.completed);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void removeTodo(String id) {
    final newTodos = state.todos.where((todo) => todo.id != id).toList();
    emit(state.copyWith(todos: newTodos));
  }
}
