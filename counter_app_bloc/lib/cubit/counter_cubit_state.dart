// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'counter_cubit_cubit.dart';

class CounterCubitState {
  final int counter;

  CounterCubitState({
    required this.counter,
  });

  factory CounterCubitState.initial() {
    return CounterCubitState(counter: 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'counter': counter,
    };
  }

  factory CounterCubitState.fromMap(Map<String, dynamic> map) {
    return CounterCubitState(
      counter: map['counter'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CounterCubitState.fromJson(String source) =>
      CounterCubitState.fromMap(json.decode(source) as Map<String, dynamic>);

  CounterCubitState copyWith({
    int? counter,
  }) {
    return CounterCubitState(
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() => 'CounterCubitState(counter: $counter)';

  @override
  bool operator ==(covariant CounterCubitState other) {
    if (identical(this, other)) return true;

    return other.counter == counter;
  }

  @override
  int get hashCode => counter.hashCode;
}
