# Riverpod Provider

## Declarando un Provider

La estructura más simple para declarar un provider es: `final providerName = ProviderType<type>((ref) {...})

```dart
final constantProvider = Provider<int>((ref) {  
  return 42;  
});
```

## Trade-offs & notas del ejemplo Provider
### invalidate vs reset
- Qué me costó: decidir si debo cambiar el estado o reconstruir el provider.
- Regla: `reset()` cambia `state` dentro del notifier y conserva la instancia. `ref.invalidate(provider)` descarta el notifier y lo vuelve a construir llamando a `build()`.
#### Good ✅
```dart
// For this example, we should use this approach.  
void _onResetMethod(WidgetRef ref) {  
  ref.read(counterProvider.notifier).reset();  
}

// Provider method
void reset() => state = _initialValue;
```
#### Bad ❌
```dart
// This method could works fot this simple case, but can be not recommended  
// for the widget Lifecycle.  
void _onReset(WidgetRef ref) {  
  ref.invalidate(counterProvider);  
}
```

### los dos tipos de `NotifierProvider<A, B>`
- Qué me costó: entender para qué sirven los dos argumentos de tipo.
- Regla: `A` es la clase del notifier (lo que devuelve `ref.read(p.notifier)`), y `B` es el tipo del estado (lo que devuelve `ref.watch(p)`). Sin tipos, el estado queda como `dynamic`.

### los widgets de Consumer
Tenemos diferentes maneras de consumir un Provider desde la capa de la UI, estas son:jk
- `ConsumerWidget`: un widget sin estado que recibe `ref` en `build`.
- `Consumer`: un widget que expone `ref` solo en su subárbol. Sirve para reconstruir una parte pequeña de la pantalla sin convertir todo el widget en consumer.
- `ConsumerStatefulWidget`: para cuando necesitas `ref` junto con un `State`, por ejemplo en `initState` o `dispose`.