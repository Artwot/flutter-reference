import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  void _onIncrement(WidgetRef ref) {
    ref.read(counterProvider.notifier).increment();
  }

  void _onDecrement(WidgetRef ref) {
    ref.read(counterProvider.notifier).decrement();
  }

  // This method could works fot this simple case, but can be not recommended
  // for the widget Lifecycle.
  void _onReset(WidgetRef ref) {
    ref.invalidate(counterProvider);
  }

  // For this example, we should use this approach.
  void _onResetMethod(WidgetRef ref) {
    ref.read(counterProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constantNum = ref.watch(constantProvider);
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Provider example')),
      body: Center(
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            Text(
              'Constant int value: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '$constantNum',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Counter:', style: Theme.of(context).textTheme.bodyLarge),
            Text('$count', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: .center,
              children: [
                ElevatedButton(
                  onPressed: () => _onIncrement(ref),
                  child: Text('Increment'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _onDecrement(ref),
                  child: Text('Decrement'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _onReset(ref),
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () => _onResetMethod(ref),
                  child: Text('Reset Method'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Simple provider
final constantProvider = Provider<int>((ref) {
  return 42;
});

// Notifier provider
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);

class CounterNotifier extends Notifier<int> {
  static const int _initialValue = 0;

  @override
  int build() => _initialValue;

  void increment() => state++;

  void decrement() => state--;

  void reset() => state = _initialValue;
}
