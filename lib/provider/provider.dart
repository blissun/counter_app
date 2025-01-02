import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart'; // 프로바이더가 생성될 경로

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
