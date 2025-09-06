import '../error/failures.dart' as core_failures;

/// Result type using Dart 3.0+ sealed classes to replace dartz Either
///
/// This provides a clean, functional programming approach to error handling
/// using native Dart features instead of external dependencies.

/// Base class for Result types
sealed class Result<T> {}

/// Success result containing a value
final class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

/// Failure result containing an error
final class ResultFailure<T> extends Result<T> {
  final core_failures.Failure error;
  ResultFailure(this.error);
}

/// Extension methods for Result type to provide convenient operations
extension ResultExtensions<T> on Result<T> {
  /// Returns true if this result represents a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this result represents a failure
  bool get isFailure => this is ResultFailure<T>;

  /// Folds the result into a single value using provided functions
  /// Similar to Either.fold() from dartz
  R fold<R>(R Function(core_failures.Failure failure) onFailure, R Function(T success) onSuccess) {
    return switch (this) {
      Success<T>(value: final value) => onSuccess(value),
      ResultFailure<T>(error: final error) => onFailure(error),
    };
  }

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T value) mapper) {
    return switch (this) {
      Success<T>(value: final value) => Success(mapper(value)),
      ResultFailure<T>(error: final error) => ResultFailure(error),
    };
  }

  /// Flat maps the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) {
    return switch (this) {
      Success<T>(value: final value) => mapper(value),
      ResultFailure<T>(error: final error) => ResultFailure(error),
    };
  }
}

/// Helper functions to create Result instances
Result<T> success<T>(T value) => Success(value);
Result<T> failure<T>(core_failures.Failure error) => ResultFailure(error);
