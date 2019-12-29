import 'package:dart_seedwork/dart_seedwork.dart';

import 'package:test/test.dart';

class LoginEvent extends Event {
  LoginEvent(DateTime raisedAt) : super(raisedAt);
  LoginEvent.now() : super(DateTime.now());
}

class DumbEvent extends Event {
  DumbEvent(DateTime raisedAt) : super(raisedAt);
  DumbEvent.now() : super(DateTime.now());
}

void main() {
  group('EventBus', () {
    EventBus _sut;
    LoginEvent _stubLoginEvent;

    setUp(() {
      _sut = EventBus(sync: true);
      _stubLoginEvent = LoginEvent.now();
    });

    tearDown(() {
      _sut.dispose();
    });

    test('is asynchronous by default', () {
      var sut = EventBus();
      expect(sut.isSynchronous, equals(false));
    });

    test('can be requested to run synchronously', () {
      expect(_sut.isSynchronous, equals(true));
    });

    test('.listen() returns a subscription', () {
      // given
      var subscription = _sut.listen<LoginEvent>((e) {
        expect(e.runtimeType, equals(LoginEvent));
      });

      // when
      _sut.publish(_stubLoginEvent);

      // then
      expect(subscription, isNot(equals(null)));
    });

    test('.all() returns a subscription', () {
      // given
      var subscription = _sut.all((e) {
        expect(e.runtimeType, equals(DumbEvent));
      });

      // when
      _sut.publish(DumbEvent.now());

      // then
      expect(subscription, isNot(equals(null)));
    });

    test('.dispose() closes the event bus', () {
      // when
      _sut.dispose();

      // then
      expect(_sut.isDisposed, equals(true));
    });
  });
}
