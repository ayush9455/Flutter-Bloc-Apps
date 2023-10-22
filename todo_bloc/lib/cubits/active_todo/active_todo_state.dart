part of 'active_todo_cubit.dart';

class ActiveTodoState {
  final int activeTodoCount;
  ActiveTodoState({
    required this.activeTodoCount,
  });

  factory ActiveTodoState.initial() {
    return ActiveTodoState(activeTodoCount: 0);
  }
  @override
  String toString() => 'ActiveTodoState(activeTodoCount: $activeTodoCount)';

  @override
  bool operator ==(covariant ActiveTodoState other) {
    if (identical(this, other)) return true;

    return other.activeTodoCount == activeTodoCount;
  }

  @override
  int get hashCode => activeTodoCount.hashCode;

  ActiveTodoState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }
}
