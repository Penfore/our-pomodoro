import '../error/failures.dart' as core_failures;

/// Result type using Dart 3.0+ sealed classes to replace dartz Either
///
/// This provides a comprehensive, functional programming approach to error handling
/// using native Dart features, with API parity to dartz Either.

/// Base class for Result types
sealed class Result<T> {}

/// Success result containing a value
final class Success<T> extends Result<T> {
  final T value;
  Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failure result containing an error
final class ResultFailure<T> extends Result<T> {
  final core_failures.Failure error;
  ResultFailure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'ResultFailure($error)';
}

/// Extension methods for Result type to provide comprehensive operations
extension ResultExtensions<T> on Result<T> {
  /// Returns true if this result represents a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this result represents a failure
  bool get isFailure => this is ResultFailure<T>;

  /// Gets the success value or null
  T? get valueOrNull => switch (this) {
    Success<T>(value: final value) => value,
    ResultFailure<T>() => null,
  };

  /// Gets the failure or null
  core_failures.Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(error: final error) => error,
  };

  /// Folds the result into a single value using provided functions
  /// Similar to Either.fold() from dartz
  R fold<R>(
    R Function(core_failures.Failure failure) onFailure,
    R Function(T success) onSuccess,
  ) {
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

  /// Maps the failure value to a new failure type
  Result<T> mapFailure(
    core_failures.Failure Function(core_failures.Failure failure) mapper,
  ) {
    return switch (this) {
      Success<T>() => this,
      ResultFailure<T>(error: final error) => ResultFailure(mapper(error)),
    };
  }

  /// Flat maps the success value to a new Result (also known as bind/chain)
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) {
    return switch (this) {
      Success<T>(value: final value) => mapper(value),
      ResultFailure<T>(error: final error) => ResultFailure(error),
    };
  }

  /// Alias for flatMap (common in functional programming)
  Result<R> bind<R>(Result<R> Function(T value) mapper) => flatMap(mapper);

  /// Alias for flatMap (common in JavaScript/Promise chains)
  Result<R> chain<R>(Result<R> Function(T value) mapper) => flatMap(mapper);

  /// Returns the success value or the provided default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(value: final value) => value,
      ResultFailure<T>() => defaultValue,
    };
  }

  /// Returns the success value or the result of the provided function
  T orElse(T Function(core_failures.Failure failure) defaultValueFunction) {
    return switch (this) {
      Success<T>(value: final value) => value,
      ResultFailure<T>(error: final error) => defaultValueFunction(error),
    };
  }

  /// Swaps Success and Failure (Success becomes Failure with provided error)
  Result<core_failures.Failure> swap(T Function() successToFailureValue) {
    return switch (this) {
      Success<T>() => ResultFailure(
        const core_failures.UnexpectedFailure('Swapped success'),
      ),
      ResultFailure<T>(error: final error) => Success(error),
    };
  }

  /// Executes a function if this is a Success, returns this Result
  Result<T> onSuccess(void Function(T value) action) {
    if (this case Success<T>(value: final value)) {
      action(value);
    }
    return this;
  }

  /// Executes a function if this is a Failure, returns this Result
  Result<T> onFailure(void Function(core_failures.Failure failure) action) {
    if (this case ResultFailure<T>(error: final error)) {
      action(error);
    }
    return this;
  }

  /// Filters the success value, converting to failure if predicate fails
  Result<T> filter(
    bool Function(T value) predicate,
    core_failures.Failure Function() failureIfFalse,
  ) {
    return switch (this) {
      Success<T>(value: final value) =>
        predicate(value) ? this : ResultFailure(failureIfFalse()),
      ResultFailure<T>() => this,
    };
  }

  /// Converts to Future&lt;Result&lt;T&gt;&gt; for async chaining
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) mapper,
  ) async {
    return switch (this) {
      Success<T>(value: final value) => await mapper(value),
      ResultFailure<T>(error: final error) => ResultFailure(error),
    };
  }
}

/// Helper functions to create Result instances
Result<T> success<T>(T value) => Success(value);
Result<T> failure<T>(core_failures.Failure error) => ResultFailure(error);

/// Async helper functions
Future<Result<T>> successAsync<T>(T value) async => Success(value);
Future<Result<T>> failureAsync<T>(core_failures.Failure error) async =>
    ResultFailure(error);

/// Combines multiple Results into one
Result<List<T>> combineResults<T>(List<Result<T>> results) {
  final values = <T>[];
  for (final result in results) {
    switch (result) {
      case Success<T>(value: final value):
        values.add(value);
      case ResultFailure<T>(error: final error):
        return ResultFailure(error);
    }
  }
  return Success(values);
}

/// Tries to execute a function that might throw, returning Result
Result<T> tryCall<T>(T Function() function) {
  try {
    return Success(function());
  } catch (e) {
    return ResultFailure(core_failures.UnexpectedFailure(e.toString()));
  }
}

/// Async version of tryCall
Future<Result<T>> tryCallAsync<T>(Future<T> Function() function) async {
  try {
    final result = await function();
    return Success(result);
  } catch (e) {
    return ResultFailure(core_failures.UnexpectedFailure(e.toString()));
  }
}
