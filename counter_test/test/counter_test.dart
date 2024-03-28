import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:counter_test/main.dart';

void main() {
  group("Counter Class", () {
    test('Counter value should start at 0', () {
      final counter = Counter();
      expect(counter.value, 0);
    });

    test('Counter value should increment', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    test('Counter value should decrement', () {
      final counter = Counter();
      counter.decrement();
      expect(counter.value, -1);
    });

    test('Counter value should be added by more than one', () {
      final counter = Counter();
      counter.add(5);
      expect(counter.value, 5);
    });

    test('Counter value should be subtracted by more than one', () {
      final counter = Counter();
      counter.add(-5);
      expect(counter.value, -5);
    });

    test('Counter value should be reset', () {
      final counter = Counter();
      counter.add(2);
      expect(counter.value, 2);
      counter.reset();
      expect(counter.value, 0);
    });
  });
}
