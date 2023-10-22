part of 'filtered_todo_cubit.dart';

class FilteredTodoState {
  final List<Todo> filteredTodos;
  FilteredTodoState({
    required this.filteredTodos,
  });

  factory FilteredTodoState.initial() {
    return FilteredTodoState(filteredTodos: []);
  }

  @override
  bool operator ==(covariant FilteredTodoState other) {
    if (identical(this, other)) return true;

    return listEquals(other.filteredTodos, filteredTodos);
  }

  @override
  int get hashCode => filteredTodos.hashCode;

  FilteredTodoState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodoState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }

  @override
  String toString() => 'FilteredTodoState(filteredTodos: $filteredTodos)';
}
