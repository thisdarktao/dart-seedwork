import 'dart:async';

/// A base event from which all events passing through the [EventBus]
/// must extend.
abstract class Event {
  /// A timestamp of when this [Event] was raised
  final DateTime raisedAt;

  Event(this.raisedAt);
}

/// An event aggregator that follows the standard pub/sub pattern
/// to inform subscribers when events occur.
///
/// This facilitates loose coupling between collaborators that
/// require communication without specifying callbacks or unnecessary
/// message chains etc.
class EventBus {
  bool _isSynchronous;
  StreamController _events;

  /// Whether this [EventBus] is running synchronously.
  bool get isSynchronous => _isSynchronous;

  /// Whether this [EventBus] has been disposed.
  bool get isDisposed => _events.isClosed;

  /// A bus for broadcasting events.
  ///
  /// If [sync] is true events may be fired directly, otherwise they will be
  /// fired at a later microtask.
  EventBus({bool sync: false}) {
    _events = StreamController.broadcast(sync: sync);
    _isSynchronous = sync;
  }

  /// Adds a subscription to this [EventBus].
  ///
  /// Returns a [StreamSubscription] which handles events where the broadcasted
  /// event matches [T].
  StreamSubscription<T> listen<T extends Event>(Function(T) fn) {
    return _events.stream.where((e) => e.runtimeType == T).cast<T>().listen(fn);
  }

  /// Adds a dynamic subscription to this [EventBus].
  ///
  /// Returns a [StreamSubscription] which handles events where any event is
  /// broadcasted.
  StreamSubscription all(Function fn) {
    return _events.stream.listen(fn);
  }

  /// Fires the specified [event] to subscribers.
  void publish<T extends Event>(T event) {
    _events.add(event);
  }

  /// Dispose of this [EventBus] and trigger the done event on all listeners.
  void dispose() {
    _events.close();
  }
}
