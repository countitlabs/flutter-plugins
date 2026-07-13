part of health;

/// A numerical value from Apple HealthKit or Google Fit
/// such as integer or double.
/// E.g. 1, 2.9, -3
///
/// Parameters:
/// * [numericValue] - a [num] value for the [HealthDataPoint]
class NumericHealthValue extends HealthValue {
  num _numericValue;

  NumericHealthValue(this._numericValue);

  /// A [num] value for the [HealthDataPoint].
  num get numericValue => _numericValue;

  @override
  String toString() {
    return numericValue.toString();
  }

  /// Parses a json object to [NumericHealthValue]
  factory NumericHealthValue.fromJson(json) {
    return NumericHealthValue(num.parse(json['numericValue']));
  }

  Map<String, dynamic> toJson() => {
        'numericValue': numericValue.toString(),
      };

  @override
  bool operator ==(Object o) {
    return o is NumericHealthValue && this._numericValue == o.numericValue;
  }

  @override
  int get hashCode => numericValue.hashCode;
}

/// A [HealthValue] object for audiograms
///
/// Parameters:
/// * [frequencies] - array of frequencies of the test
/// * [leftEarSensitivities] threshold in decibel for the left ear
/// * [rightEarSensitivities] threshold in decibel for the left ear
class AudiogramHealthValue extends HealthValue {
  List<num> _frequencies;
  List<num> _leftEarSensitivities;
  List<num> _rightEarSensitivities;

  AudiogramHealthValue(this._frequencies, this._leftEarSensitivities,
      this._rightEarSensitivities);

  /// Array of frequencies of the test.
  List<num> get frequencies => _frequencies;

  /// Threshold in decibel for the left ear.
  List<num> get leftEarSensitivities => _leftEarSensitivities;

  /// Threshold in decibel for the right ear.
  List<num> get rightEarSensitivities => _rightEarSensitivities;

  @override
  String toString() {
    return """frequencies: ${frequencies.toString()},
    left ear sensitivities: ${leftEarSensitivities.toString()},
    right ear sensitivities: ${rightEarSensitivities.toString()}""";
  }

  factory AudiogramHealthValue.fromJson(json) {
    return AudiogramHealthValue(
        List<num>.from(json['frequencies']),
        List<num>.from(json['leftEarSensitivities']),
        List<num>.from(json['rightEarSensitivities']));
  }

  Map<String, dynamic> toJson() => {
        'frequencies': frequencies.toString(),
        'leftEarSensitivities': leftEarSensitivities.toString(),
        'rightEarSensitivities': rightEarSensitivities.toString(),
      };

  @override
  bool operator ==(Object o) {
    return o is AudiogramHealthValue &&
        listEquals(this._frequencies, o.frequencies) &&
        listEquals(this._leftEarSensitivities, o.leftEarSensitivities) &&
        listEquals(this._rightEarSensitivities, o.rightEarSensitivities);
  }

  @override
  int get hashCode =>
      Object.hash(frequencies, leftEarSensitivities, rightEarSensitivities);
}

/// A [HealthValue] object for workouts
///
/// Parameters:
/// * [workoutActivityType] - the type of workout
/// * [totalEnergyBurned] - the total energy burned during the workout
/// * [totalEnergyBurnedUnit] - the unit of the total energy burned
/// * [totalDistance] - the total distance of the workout
/// * [totalDistanceUnit] - the unit of the total distance
class WorkoutHealthValue extends HealthValue {
  final double? _duration;
  final String? _durationUnit;
  HealthWorkoutActivityType _workoutActivityType;
  int? _totalEnergyBurned;
  HealthDataUnit? _totalEnergyBurnedUnit;
  int? _totalDistance;
  HealthDataUnit? _totalDistanceUnit;
  String? _activityName;

  WorkoutHealthValue(
      this._duration,
      this._durationUnit,
      this._workoutActivityType,
      this._totalEnergyBurned,
      this._totalEnergyBurnedUnit,
      this._totalDistance,
      this._totalDistanceUnit,
      this._activityName);

  /// The duration of the workout in seconds.
  double? get duration => _duration;

  /// The unit of the duration of the workout.
  String? get durationUnit => _durationUnit;

  /// The type of the workout.
  HealthWorkoutActivityType get workoutActivityType => _workoutActivityType;

  /// The total energy burned during the workout.
  /// Might not be available for all workouts.
  int? get totalEnergyBurned => _totalEnergyBurned;


  // The name of the activity, if available.
  String? get activityName => _activityName;

  /// The unit of the total energy burned during the workout.
  /// Might not be available for all workouts.
  HealthDataUnit? get totalEnergyBurnedUnit => _totalEnergyBurnedUnit;

  /// The total distance covered during the workout.
  /// Might not be available for all workouts.
  int? get totalDistance => _totalDistance;

  /// The unit of the total distance covered during the workout.
  /// Might not be available for all workouts.
  HealthDataUnit? get totalDistanceUnit => _totalDistanceUnit;

  factory WorkoutHealthValue.fromJson(json) {
    return WorkoutHealthValue(
        json['duration'] != null ? (json['duration'] as num).toDouble() : null,
        json['durationUnit'] != null ? (json['durationUnit'] as String).toLowerCase() : null,
        HealthWorkoutActivityType.values.firstWhereOrNull(
            (element) => element.name == json['workoutActivityType']) ?? HealthWorkoutActivityType.UNRECOGNIZED,
        json['totalEnergyBurned'] != null
            ? (json['totalEnergyBurned'] as num).toInt()
            : null,
        json['totalEnergyBurnedUnit'] != null
            ? HealthDataUnit.values.firstWhere(
                (element) => element.name == json['totalEnergyBurnedUnit'])
            : null,
        json['totalDistance'] != null
            ? (json['totalDistance'] as num).toInt()
            : null,
        json['totalDistanceUnit'] != null
            ? HealthDataUnit.values.firstWhere(
                (element) => element.name == json['totalDistanceUnit'])
            : null,
        json['activityName'] as String?
            );
  }

  @override
  Map<String, dynamic> toJson() => {
        'duration': duration,
        'durationUnit': durationUnit?.toLowerCase(),
        'workoutActivityType': _workoutActivityType.name,
        'totalEnergyBurned': _totalEnergyBurned,
        'totalEnergyBurnedUnit': _totalEnergyBurnedUnit?.name,
        'totalDistance': _totalDistance,
        'totalDistanceUnit': _totalDistanceUnit?.name,
      };

  @override
  String toString() {
    return """
           duration: ${duration.toString()},
           durationUnit: ${durationUnit.toString().toLowerCase()},
           workoutActivityType: ${workoutActivityType.name},
           totalEnergyBurned: $totalEnergyBurned,
           totalEnergyBurnedUnit: ${totalEnergyBurnedUnit?.name},
           totalDistance: $totalDistance,
           totalDistanceUnit: ${totalDistanceUnit?.name},
           activityName: $activityName
           """;
  }

  @override
  bool operator ==(Object o) {
    return o is WorkoutHealthValue &&
        this.workoutActivityType == o.workoutActivityType &&
        this.totalEnergyBurned == o.totalEnergyBurned &&
        this.totalEnergyBurnedUnit == o.totalEnergyBurnedUnit &&
        this.totalDistance == o.totalDistance &&
        this.totalDistanceUnit == o.totalDistanceUnit &&
        this.activityName == o.activityName;
  }

  @override
  int get hashCode => Object.hash(workoutActivityType, totalEnergyBurned,
      totalEnergyBurnedUnit, totalDistance, totalDistanceUnit, activityName);
}

/// A [HealthValue] object for ECGs
///
/// Parameters:
/// * [voltageValues] - an array of [ElectrocardiogramVoltageValue]s
/// * [averageHeartRate] - the average heart rate during the ECG (in BPM)
/// * [samplingFrequency] - the frequency at which the Apple Watch sampled the voltage.
/// * [classification] - an [ElectrocardiogramClassification]
class ElectrocardiogramHealthValue extends HealthValue {
  /// An array of [ElectrocardiogramVoltageValue]s.
  List<ElectrocardiogramVoltageValue> voltageValues;

  /// The average heart rate during the ECG (in BPM).
  num? averageHeartRate;

  /// The frequency at which the Apple Watch sampled the voltage.
  double? samplingFrequency;

  /// An [ElectrocardiogramClassification].
  ElectrocardiogramClassification classification;

  ElectrocardiogramHealthValue({
    required this.voltageValues,
    required this.averageHeartRate,
    required this.samplingFrequency,
    required this.classification,
  });

  /// Parses [ElectrocardiogramHealthValue] from JSON.
  factory ElectrocardiogramHealthValue.fromJson(json) =>
      ElectrocardiogramHealthValue(
        voltageValues: (json['voltageValues'] as List)
            .map((e) => ElectrocardiogramVoltageValue.fromJson(e))
            .toList(),
        averageHeartRate: json['averageHeartRate'],
        samplingFrequency: json['samplingFrequency'],
        classification: ElectrocardiogramClassification.values
            .firstWhere((c) => c.value == json['classification']),
      );

  Map<String, dynamic> toJson() => {
        'voltageValues':
            voltageValues.map((e) => e.toJson()).toList(growable: false),
        'averageHeartRate': averageHeartRate,
        'samplingFrequency': samplingFrequency,
        'classification': classification.value,
      };

  @override
  bool operator ==(Object o) =>
      o is ElectrocardiogramHealthValue &&
      voltageValues == o.voltageValues &&
      averageHeartRate == o.averageHeartRate &&
      samplingFrequency == o.samplingFrequency &&
      classification == o.classification;

  @override
  int get hashCode => Object.hash(
      voltageValues, averageHeartRate, samplingFrequency, classification);

  @override
  String toString() =>
      '${voltageValues.length} values, $averageHeartRate BPM, $samplingFrequency HZ, $classification';
}

/// Single voltage value belonging to a [ElectrocardiogramHealthValue]
class ElectrocardiogramVoltageValue extends HealthValue {
  /// Voltage of the ECG.
  num voltage;

  /// Time since the start of the ECG.
  num timeSinceSampleStart;

  ElectrocardiogramVoltageValue(this.voltage, this.timeSinceSampleStart);

  factory ElectrocardiogramVoltageValue.fromJson(json) =>
      ElectrocardiogramVoltageValue(
          json['voltage'], json['timeSinceSampleStart']);

  Map<String, dynamic> toJson() => {
        'voltage': voltage,
        'timeSinceSampleStart': timeSinceSampleStart,
      };

  @override
  bool operator ==(Object o) =>
      o is ElectrocardiogramVoltageValue &&
      voltage == o.voltage &&
      timeSinceSampleStart == o.timeSinceSampleStart;

  @override
  int get hashCode => Object.hash(voltage, timeSinceSampleStart);

  @override
  String toString() => voltage.toString();
}

/// A [HealthValue] object for nutrition
/// Parameters:
/// * [protein] - the amount of protein in grams
/// * [calories] - the amount of calories in kcal
/// * [fat] - the amount of fat in grams
/// * [name] - the name of the food
/// * [carbs] - the amount of carbs in grams
/// * [mealType] - the type of meal
class NutritionHealthValue extends HealthValue {
  double? _protein;
  double? _calories;
  double? _fat;
  String? _name;
  double? _carbs;
  String _mealType;

  NutritionHealthValue(this._protein, this._calories, this._fat, this._name,
      this._carbs, this._mealType);

  /// The amount of protein in grams.
  double? get protein => _protein;

  /// The amount of calories in kcal.
  double? get calories => _calories;

  /// The amount of fat in grams.
  double? get fat => _fat;

  /// The name of the food.
  String? get name => _name;

  /// The amount of carbs in grams.
  double? get carbs => _carbs;

  /// The type of meal.
  String get mealType => _mealType;

  factory NutritionHealthValue.fromJson(json) {
    return NutritionHealthValue(
      json['protein'] != null ? (json['protein'] as num).toDouble() : null,
      json['calories'] != null ? (json['calories'] as num).toDouble() : null,
      json['fat'] != null ? (json['fat'] as num).toDouble() : null,
      json['name'] != null ? (json['name'] as String) : null,
      json['carbs'] != null ? (json['carbs'] as num).toDouble() : null,
      json['mealType'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'protein': _protein,
        'calories': _calories,
        'fat': _fat,
        'name': _name,
        'carbs': _carbs,
        'mealType': _mealType,
      };

  @override
  String toString() {
    return """protein: ${protein.toString()},
    calories: ${calories.toString()},
    fat: ${fat.toString()},
    name: ${name.toString()},
    carbs: ${carbs.toString()},
    mealType: $mealType""";
  }

  @override
  bool operator ==(Object o) {
    return o is NutritionHealthValue &&
        o.protein == this.protein &&
        o.calories == this.calories &&
        o.fat == this.fat &&
        o.name == this.name &&
        o.carbs == this.carbs &&
        o.mealType == this.mealType;
  }

  @override
  int get hashCode => Object.hash(protein, calories, fat, name, carbs);
}

/// A single GPS point of a [WorkoutRouteHealthValue].
///
/// Parameters:
/// * [latitude] - the latitude of the point
/// * [longitude] - the longitude of the point
/// * [timestamp] - when the point was recorded
/// * [altitude] - the altitude at the point, if available
/// * [horizontalAccuracy] - the horizontal accuracy of the point, if available
/// * [verticalAccuracy] - the vertical accuracy of the point, if available
/// * [speed] - the speed at the point, if available
/// * [speedAccuracy] - the speed accuracy of the point, if available
/// * [course] - the course (heading) at the point, if available
/// * [courseAccuracy] - the course accuracy of the point, if available
class WorkoutRouteLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? altitude;
  final double? horizontalAccuracy;
  final double? verticalAccuracy;
  final double? speed;
  final double? speedAccuracy;
  final double? course;
  final double? courseAccuracy;

  WorkoutRouteLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.altitude,
    this.horizontalAccuracy,
    this.verticalAccuracy,
    this.speed,
    this.speedAccuracy,
    this.course,
    this.courseAccuracy,
  });

  factory WorkoutRouteLocation.fromJson(json) => WorkoutRouteLocation(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        altitude: (json['altitude'] as num?)?.toDouble(),
        horizontalAccuracy: (json['horizontalAccuracy'] as num?)?.toDouble(),
        verticalAccuracy: (json['verticalAccuracy'] as num?)?.toDouble(),
        speed: (json['speed'] as num?)?.toDouble(),
        speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble(),
        course: (json['course'] as num?)?.toDouble(),
        courseAccuracy: (json['courseAccuracy'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'altitude': altitude,
        'horizontalAccuracy': horizontalAccuracy,
        'verticalAccuracy': verticalAccuracy,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
        'course': course,
        'courseAccuracy': courseAccuracy,
      };

  @override
  bool operator ==(Object o) =>
      o is WorkoutRouteLocation &&
      latitude == o.latitude &&
      longitude == o.longitude &&
      timestamp == o.timestamp &&
      altitude == o.altitude &&
      horizontalAccuracy == o.horizontalAccuracy &&
      verticalAccuracy == o.verticalAccuracy &&
      speed == o.speed &&
      speedAccuracy == o.speedAccuracy &&
      course == o.course &&
      courseAccuracy == o.courseAccuracy;

  @override
  int get hashCode => Object.hash(
      latitude,
      longitude,
      timestamp,
      altitude,
      horizontalAccuracy,
      verticalAccuracy,
      speed,
      speedAccuracy,
      course,
      courseAccuracy);

  @override
  String toString() => 'lat: $latitude, lng: $longitude, timestamp: $timestamp';
}

/// A [HealthValue] object for a GPS route recorded during a workout.
///
/// Parameters:
/// * [locations] - ordered list of [WorkoutRouteLocation] samples.
/// * [workoutUuid] - the id of the workout this route belongs to, if known.
///   Only populated when the route metadata carries a `workout_uuid` entry
///   (e.g. when written by this plugin); routes recorded by other sources
///   (Apple Watch, third-party apps) do not carry this association.
class WorkoutRouteHealthValue extends HealthValue {
  List<WorkoutRouteLocation> locations;
  String? workoutUuid;

  WorkoutRouteHealthValue({required this.locations, this.workoutUuid});

  factory WorkoutRouteHealthValue.fromJson(json) {
    final rawRoute = json['route'] as List? ?? [];
    return WorkoutRouteHealthValue(
      locations: rawRoute.map((e) => WorkoutRouteLocation.fromJson(e)).toList(),
      workoutUuid: json['workout_uuid'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'route': locations.map((e) => e.toJson()).toList(),
        'workoutUuid': workoutUuid,
      };

  @override
  String toString() =>
      '$runtimeType - locations: ${locations.length} samples, workoutUuid: $workoutUuid';

  @override
  bool operator ==(Object o) =>
      o is WorkoutRouteHealthValue &&
      listEquals(locations, o.locations) &&
      workoutUuid == o.workoutUuid;

  @override
  int get hashCode => Object.hash(Object.hashAll(locations), workoutUuid);
}

/// An abstract class for health values.
abstract class HealthValue {
  Map<String, dynamic> toJson();
}
