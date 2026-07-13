import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_health');
  group('WorkoutRouteLocation', () {
    test('parses full json', () {
      final json = {
        'latitude': 1.5,
        'longitude': -2.5,
        'timestamp': 1000,
        'altitude': 10.0,
        'horizontalAccuracy': 5.0,
        'verticalAccuracy': 3.0,
        'speed': 2.0,
        'speedAccuracy': 0.5,
        'course': 90.0,
        'courseAccuracy': 1.0,
      };

      final location = WorkoutRouteLocation.fromJson(json);

      expect(location.latitude, 1.5);
      expect(location.longitude, -2.5);
      expect(location.timestamp, DateTime.fromMillisecondsSinceEpoch(1000));
      expect(location.altitude, 10.0);
      expect(location.horizontalAccuracy, 5.0);
      expect(location.verticalAccuracy, 3.0);
      expect(location.speed, 2.0);
      expect(location.speedAccuracy, 0.5);
      expect(location.course, 90.0);
      expect(location.courseAccuracy, 1.0);
    });

    test('parses json with only required fields', () {
      final location = WorkoutRouteLocation.fromJson({
        'latitude': 1.0,
        'longitude': 2.0,
        'timestamp': 0,
      });

      expect(location.altitude, isNull);
      expect(location.horizontalAccuracy, isNull);
      expect(location.speed, isNull);
    });

    test('round trips through toJson', () {
      final location = WorkoutRouteLocation(
        latitude: 1.0,
        longitude: 2.0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(5000),
        speed: 3.0,
      );

      final roundTripped = WorkoutRouteLocation.fromJson(location.toJson());

      expect(roundTripped, location);
    });
  });

  group('WorkoutRouteHealthValue', () {
    test('parses locations and workoutUuid from json', () {
      final value = WorkoutRouteHealthValue.fromJson({
        'route': [
          {'latitude': 1.0, 'longitude': 2.0, 'timestamp': 0},
          {'latitude': 1.1, 'longitude': 2.1, 'timestamp': 1000},
        ],
        'workout_uuid': 'abc-123',
      });

      expect(value.locations.length, 2);
      expect(value.workoutUuid, 'abc-123');
    });

    test('workoutUuid is null when not present in metadata', () {
      final value = WorkoutRouteHealthValue.fromJson({
        'route': [
          {'latitude': 1.0, 'longitude': 2.0, 'timestamp': 0},
        ],
      });

      expect(value.workoutUuid, isNull);
    });

    test('handles an empty route', () {
      final value = WorkoutRouteHealthValue.fromJson({'route': []});

      expect(value.locations, isEmpty);
    });
  });

  group('HealthDataPoint.fromJson', () {
    test('dispatches WORKOUT_ROUTE to WorkoutRouteHealthValue', () {
      final point = HealthDataPoint.fromJson({
        'value': {
          'route': [
            {'latitude': 1.0, 'longitude': 2.0, 'timestamp': 0},
          ],
          'workout_uuid': 'abc-123',
        },
        'data_type': 'WORKOUT_ROUTE',
        'unit': 'NO_UNIT',
        'date_from': '2024-01-01T00:00:00.000Z',
        'date_to': '2024-01-01T01:00:00.000Z',
        'platform_type': 'ios',
        'device_id': 'device',
        'source_id': 'source',
        'source_name': 'source name',
      });

      expect(point.value, isA<WorkoutRouteHealthValue>());
      expect((point.value as WorkoutRouteHealthValue).workoutUuid, 'abc-123');
    });

    test('parses the uuid of a WORKOUT data point', () {
      final point = HealthDataPoint.fromJson({
        'value': {
          'workoutActivityType': 'RUNNING',
        },
        'data_type': 'WORKOUT',
        'unit': 'NO_UNIT',
        'date_from': '2024-01-01T00:00:00.000Z',
        'date_to': '2024-01-01T01:00:00.000Z',
        'platform_type': 'ios',
        'device_id': 'device',
        'source_id': 'source',
        'source_name': 'source name',
        'uuid': 'workout-uuid-123',
      });

      expect(point.uuid, 'workout-uuid-123');
    });

    test('uuid is null when not present in json', () {
      final point = HealthDataPoint.fromJson({
        'value': {'numericValue': '1'},
        'data_type': 'STEPS',
        'unit': 'COUNT',
        'date_from': '2024-01-01T00:00:00.000Z',
        'date_to': '2024-01-01T01:00:00.000Z',
        'platform_type': 'ios',
        'device_id': 'device',
        'source_id': 'source',
        'source_name': 'source name',
      });

      expect(point.uuid, isNull);
    });
  });

  group('HealthFactory.requestAuthorization', () {
    test('WORKOUT_ROUTE and WORKOUT data types are both iOS-available', () {
      final health = HealthFactory();

      expect(health.isDataTypeAvailable(HealthDataType.WORKOUT_ROUTE), isTrue);
      expect(health.isDataTypeAvailable(HealthDataType.WORKOUT), isTrue);
    });
  });

  group('HealthFactory.getWorkoutRoute', () {
    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('sends the workoutUUID and parses the returned route', () async {
      MethodCall? capturedCall;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        capturedCall = call;
        return {
          'route': [
            {'latitude': 1.0, 'longitude': 2.0, 'timestamp': 0},
          ],
          'workout_uuid': 'workout-uuid-123',
        };
      });

      final route = await HealthFactory().getWorkoutRoute('workout-uuid-123');

      expect(capturedCall?.method, 'getWorkoutRoute');
      expect(capturedCall?.arguments, {'workoutUUID': 'workout-uuid-123'});
      expect(route, isNotNull);
      expect(route!.locations.length, 1);
      expect(route.workoutUuid, 'workout-uuid-123');
    });

    test('returns null when the workout has no route', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => null);

      final route = await HealthFactory().getWorkoutRoute('workout-uuid-123');

      expect(route, isNull);
    });
  });
}
