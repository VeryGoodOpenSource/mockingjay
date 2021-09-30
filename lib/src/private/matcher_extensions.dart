import 'package:matcher/matcher.dart';

/// Extensions on [Matcher] for convenience.
extension MatcherExtensions on Matcher {
  /// Returns the description of this matcher as a string.
  String describeAsString() {
    Description description = StringDescription();
    description = describe(description);
    return description.toString();
  }

  /// Returns the mismatch description of this matcher as a string.
  // ignore: avoid_positional_boolean_parameters
  String describeMismatchAsString(dynamic item, Map matchState, bool verbose) {
    Description description = StringDescription();
    description = describeMismatch(
      item,
      description,
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
