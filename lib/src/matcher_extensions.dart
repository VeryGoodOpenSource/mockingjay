import 'package:matcher/matcher.dart';

/// Extensions on [Matcher] for convenience.
extension MatcherExtensions on Matcher {
  /// Returns the description of this matcher as a string.
  String describeAsString() {
    return describe(StringDescription()).toString();
  }

  /// Returns the mismatch description of this matcher as a string.
  // ignore: avoid_positional_boolean_parameters
  String describeMismatchAsString(
    dynamic item,
    Map<dynamic, dynamic> matchState, {
    required bool verbose,
  }) {
    final description = describeMismatch(
      item,
      StringDescription(),
      matchState,
      verbose,
    );

    if (description.toString().isEmpty) {
      return 'is $item instead of ${describeAsString()}';
    } else {
      return description.toString();
    }
  }
}
