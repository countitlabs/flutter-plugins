part of health;

/// Custom Exception for the plugin. Used when a Health Data Type is requested,
/// but not available on the current platform.
class HealthException implements Exception {
  /// Data Type that was requested.
  dynamic dataType;

  /// Cause of the exception.
  String cause;

  HealthException(this.dataType, this.cause);

  String toString() =>
      "Error requesting health data type '$dataType' - cause: $cause";
}

/// A list of supported platforms.
enum PlatformType { IOS, ANDROID }

/// Error codes for iOS HealthKit [PlatformException]s thrown by this plugin.
///
/// These mirror `HealthKitErrorCodes` in the Swift layer — both sides of the
/// plugin own this contract together. Consumers should always reference these
/// constants instead of comparing against raw strings.
///
/// Example:
/// ```dart
/// } catch (e) {
///   if (e is PlatformException && e.code == HealthKitErrorCode.databaseInaccessible) {
///     // device is locked, handle gracefully
///   }
/// }
/// ```
class HealthKitErrorCode {
  HealthKitErrorCode._();

  /// The device is locked and HealthKit protected data is inaccessible.
  /// Expected during background fetch — do not report to crash tooling.
  static const databaseInaccessible = 'HEALTHKIT_DATABASE_INACCESSIBLE';

  /// A generic HealthKit error with no specific mapping.
  static const error = 'HEALTHKIT_ERROR';

  /// The native error object was nil — origin unknown.
  static const unknown = 'HEALTHKIT_UNKNOWN_ERROR';
}
