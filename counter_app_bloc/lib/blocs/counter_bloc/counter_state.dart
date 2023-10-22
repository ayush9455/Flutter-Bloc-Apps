part of 'counter_bloc.dart';

class CounterState {
  final int counter;

  CounterState({
    required this.counter,
  });

  factory CounterState.initial() {
    return CounterState(counter: 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'counter': counter,
    };
  }

  factory CounterState.fromMap(Map<String, dynamic> map) {
    return CounterState(
      counter: map['counter'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CounterState.fromJson(String source) =>
      CounterState.fromMap(json.decode(source) as Map<String, dynamic>);

  CounterState copyWith({
    int? counter,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() => 'CounterCubitState(counter: $counter)';

  @override
  bool operator ==(covariant CounterState other) {
    if (identical(this, other)) return true;

    return other.counter == counter;
  }

  @override
  int get hashCode => counter.hashCode;
}
