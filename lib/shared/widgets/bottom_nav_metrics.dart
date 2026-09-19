/// Layout constants for the floating pill bottom navigation used by
/// CitizenShell and CollectorShell.
///
/// The shell uses `Scaffold(bottomNavigationBar: ...)` together with
/// `extendBody: true`, so the navigation bar floats OVER the body content.
/// Every scrollable body MUST reserve this height as bottom padding
/// (plus a little breathing room) so the bar never covers buttons,
/// text fields, or list items.
class BottomNavBarMetrics {
  BottomNavBarMetrics._();

  /// Outer margin below the pill (fromLTRB(16, 0, 16, 12)).
  static const double bottomMargin = 12;

  /// Inner vertical padding (6 top + 6 bottom).
  static const double innerPadding = 12;

  /// Icon (21) + gap (3) + label (~14).
  static const double contentHeight = 38;

  /// Total height of the floating pill, including its bottom margin.
  /// (~62 logical px; add breathing room when padding scroll content.)
  static const double totalHeight =
      bottomMargin + innerPadding + contentHeight;

  /// Recommended bottom padding for scrollable screen content so nothing
  /// hides behind the floating navigation bar.
  static const double contentPadding = totalHeight + 24;
}
