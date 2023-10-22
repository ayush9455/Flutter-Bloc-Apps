part of 'todo_list_cubit.dart';

class TodoListState {
  final List<Todo> todos;

  TodoListState({required this.todos});

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(desc: 'Clean Room'),
      Todo(
        desc: 'Wash Clothes',
      )
    ]);
  }

  @override
  String toString() => 'TodoListState(todos: $todos)';

  @override
  bool operator ==(covariant TodoListState other) {
    if (identical(this, other)) return true;

    return listEquals(other.todos, todos);
  }

  @override
  int get hashCode => todos.hashCode;

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
