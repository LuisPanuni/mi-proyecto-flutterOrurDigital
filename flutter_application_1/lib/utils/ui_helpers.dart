part of '../app.dart';

IconData _categoryIcon(IncidentCategory category) {
  return switch (category) {
    IncidentCategory.pothole => Icons.warning_amber,
    IncidentCategory.trash => Icons.delete_outline,
    IncidentCategory.lighting => Icons.lightbulb_outline,
    IncidentCategory.roadDamage => Icons.add_road,
    IncidentCategory.sewer => Icons.water_damage_outlined,
    IncidentCategory.signage => Icons.traffic_outlined,
    IncidentCategory.transport => Icons.directions_bus_outlined,
  };
}

Color _priorityColor(int priority) {
  if (priority >= 85) return _oruroCrimson;
  if (priority >= 70) return _oruroGold;
  if (priority >= 45) return _oruroSky;
  return _oruroGreen;
}

extension _IterableSearch<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T value) test) {
    for (final value in this) {
      if (test(value)) {
        return value;
      }
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T value) test) {
    T? match;
    for (final value in this) {
      if (test(value)) {
        match = value;
      }
    }
    return match;
  }
}
