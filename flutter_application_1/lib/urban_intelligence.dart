import 'dart:math' as math;

enum UserRole { citizen, admin }

extension UserRoleText on UserRole {
  String get label {
    return switch (this) {
      UserRole.citizen => 'Ciudadano',
      UserRole.admin => 'Administrador',
    };
  }
}

class DemoUser {
  const DemoUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.trustScore,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final double trustScore;
}

enum IncidentCategory {
  pothole,
  trash,
  lighting,
  roadDamage,
  sewer,
  signage,
  transport,
}

extension IncidentCategoryText on IncidentCategory {
  String get label {
    return switch (this) {
      IncidentCategory.pothole => 'Bache',
      IncidentCategory.trash => 'Basura',
      IncidentCategory.lighting => 'Luminaria',
      IncidentCategory.roadDamage => 'Calle dañada',
      IncidentCategory.sewer => 'Alcantarillado',
      IncidentCategory.signage => 'Señalización',
      IncidentCategory.transport => 'Transporte',
    };
  }
}

enum ReportStatus { pending, grouped, inReview, resolved }

extension ReportStatusText on ReportStatus {
  String get label {
    return switch (this) {
      ReportStatus.pending => 'Pendiente',
      ReportStatus.grouped => 'Agrupado',
      ReportStatus.inReview => 'En revisión',
      ReportStatus.resolved => 'Resuelto',
    };
  }
}

class CityLocation {
  const CityLocation({
    required this.zone,
    required this.label,
    required this.x,
    required this.y,
    this.latitude,
    this.longitude,
    this.nearSchool = false,
    this.nearTransport = false,
    this.highCirculation = false,
  });

  final String zone;
  final String label;
  final double x;
  final double y;
  final double? latitude;
  final double? longitude;
  final bool nearSchool;
  final bool nearTransport;
  final bool highCirculation;

  double distanceTo(CityLocation other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt((dx * dx) + (dy * dy));
  }

  CityLocation copyWith({
    String? zone,
    String? label,
    double? x,
    double? y,
    double? latitude,
    double? longitude,
    bool? nearSchool,
    bool? nearTransport,
    bool? highCirculation,
  }) {
    return CityLocation(
      zone: zone ?? this.zone,
      label: label ?? this.label,
      x: x ?? this.x,
      y: y ?? this.y,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nearSchool: nearSchool ?? this.nearSchool,
      nearTransport: nearTransport ?? this.nearTransport,
      highCirculation: highCirculation ?? this.highCirculation,
    );
  }
}

class IncidentReport {
  const IncidentReport({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.urgency,
    required this.createdAt,
    required this.reporterId,
    required this.reporterTrust,
    this.hasPhoto = false,
    this.imageNote = '',
    this.status = ReportStatus.pending,
    this.flagged = false,
  });

  final String id;
  final String title;
  final IncidentCategory category;
  final CityLocation location;
  final String description;
  final int urgency;
  final DateTime createdAt;
  final String reporterId;
  final double reporterTrust;
  final bool hasPhoto;
  final String imageNote;
  final ReportStatus status;
  final bool flagged;

  int ageDays(DateTime now) =>
      now.difference(createdAt).inDays.clamp(0, 9999).toInt();

  IncidentReport copyWith({
    String? id,
    String? title,
    IncidentCategory? category,
    CityLocation? location,
    String? description,
    int? urgency,
    DateTime? createdAt,
    String? reporterId,
    double? reporterTrust,
    bool? hasPhoto,
    String? imageNote,
    ReportStatus? status,
    bool? flagged,
  }) {
    return IncidentReport(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      urgency: urgency ?? this.urgency,
      createdAt: createdAt ?? this.createdAt,
      reporterId: reporterId ?? this.reporterId,
      reporterTrust: reporterTrust ?? this.reporterTrust,
      hasPhoto: hasPhoto ?? this.hasPhoto,
      imageNote: imageNote ?? this.imageNote,
      status: status ?? this.status,
      flagged: flagged ?? this.flagged,
    );
  }
}

class UrbanProblem {
  const UrbanProblem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.reports,
    required this.reportsCount,
    required this.uniqueReporters,
    required this.firstReported,
    required this.lastReported,
    required this.averageUrgency,
    required this.priority,
    required this.contextTags,
    required this.flaggedCount,
    required this.status,
  });

  final String id;
  final String title;
  final IncidentCategory category;
  final CityLocation location;
  final List<IncidentReport> reports;
  final int reportsCount;
  final int uniqueReporters;
  final DateTime firstReported;
  final DateTime lastReported;
  final double averageUrgency;
  final int priority;
  final List<String> contextTags;
  final int flaggedCount;
  final ReportStatus status;

  int ageDays(DateTime now) =>
      now.difference(firstReported).inDays.clamp(0, 9999).toInt();

  double get priorityFraction => priority / 100;

  String get priorityLabel {
    if (priority >= 85) return 'Crítica';
    if (priority >= 70) return 'Alta';
    if (priority >= 45) return 'Media';
    return 'Baja';
  }
}

class AbuseValidationResult {
  const AbuseValidationResult({
    required this.allowed,
    this.errors = const [],
    this.warnings = const [],
  });

  final bool allowed;
  final List<String> errors;
  final List<String> warnings;
}

class ReportGuard {
  const ReportGuard({
    this.duplicateRadius = 0.065,
    this.duplicateWindow = const Duration(minutes: 45),
    this.maxReportsPerWindow = 4,
    this.rateWindow = const Duration(minutes: 10),
  });

  final double duplicateRadius;
  final Duration duplicateWindow;
  final int maxReportsPerWindow;
  final Duration rateWindow;

  AbuseValidationResult validate(
    List<IncidentReport> existingReports,
    IncidentReport candidate, {
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final errors = <String>[];
    final warnings = <String>[];

    if (candidate.title.trim().length < 6) {
      errors.add('El título debe ser más específico.');
    }

    if (candidate.description.trim().length < 12) {
      errors.add('La descripción debe explicar mejor la incidencia.');
    }

    final recentReports = existingReports.where((report) {
      return report.reporterId == candidate.reporterId &&
          effectiveNow.difference(report.createdAt) <= rateWindow;
    }).length;

    if (recentReports >= maxReportsPerWindow) {
      errors.add(
        'Se alcanzó el límite temporal de reportes para este usuario.',
      );
    }

    final duplicateExists = existingReports.any((report) {
      final sameReporter = report.reporterId == candidate.reporterId;
      final sameCategory = report.category == candidate.category;
      final nearLocation =
          report.location.distanceTo(candidate.location) <= duplicateRadius;
      final recent =
          (candidate.createdAt.difference(report.createdAt)).abs() <=
          duplicateWindow;
      return sameReporter && sameCategory && nearLocation && recent;
    });

    if (duplicateExists) {
      errors.add(
        'Ya existe un reporte similar del mismo usuario en esta zona.',
      );
    }

    final repeatedText = existingReports.where((report) {
      final sameReporter = report.reporterId == candidate.reporterId;
      final sameText =
          _normalize(report.description) == _normalize(candidate.description);
      final sameDay =
          effectiveNow.difference(report.createdAt) <=
          const Duration(hours: 24);
      return sameReporter && sameText && sameDay;
    }).length;

    if (repeatedText >= 2) {
      errors.add(
        'El sistema detectó reportes repetidos con el mismo contenido.',
      );
    }

    if (candidate.urgency >= 5 && !candidate.hasPhoto) {
      warnings.add(
        'Prioridad crítica sin foto: el reporte quedará marcado para revisión.',
      );
    }

    if (candidate.reporterTrust < 0.55) {
      warnings.add(
        'Usuario con baja confianza: el reporte tendrá menor peso en prioridad.',
      );
    }

    return AbuseValidationResult(
      allowed: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  String _normalize(String value) {
    return value.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}

class UrbanIntelligenceEngine {
  const UrbanIntelligenceEngine({this.groupingRadius = 0.1});

  final double groupingRadius;

  List<UrbanProblem> buildProblems(
    List<IncidentReport> reports, {
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final activeReports =
        reports
            .where((report) => report.status != ReportStatus.resolved)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final groups = <List<IncidentReport>>[];

    for (final report in activeReports) {
      final groupIndex = groups.indexWhere(
        (group) => _canJoinGroup(group, report),
      );
      if (groupIndex == -1) {
        groups.add([report]);
      } else {
        groups[groupIndex].add(report);
      }
    }

    final problems = <UrbanProblem>[
      for (var index = 0; index < groups.length; index++)
        _buildProblem(groups[index], 284 + index, effectiveNow),
    ]..sort((a, b) => b.priority.compareTo(a.priority));

    return problems;
  }

  IntelligenceStats buildStats(List<IncidentReport> reports, {DateTime? now}) {
    final problems = buildProblems(reports, now: now);
    final resolvedReports = reports
        .where((report) => report.status == ReportStatus.resolved)
        .length;
    final flaggedReports = reports.where((report) => report.flagged).length;
    final criticalProblems = problems
        .where((problem) => problem.priority >= 85)
        .length;
    final averagePriority = problems.isEmpty
        ? 0
        : problems.map((problem) => problem.priority).reduce((a, b) => a + b) /
              problems.length;

    return IntelligenceStats(
      totalReports: reports.length,
      activeProblems: problems.length,
      criticalProblems: criticalProblems,
      flaggedReports: flaggedReports,
      resolvedReports: resolvedReports,
      averagePriority: averagePriority.round(),
    );
  }

  bool _canJoinGroup(List<IncidentReport> group, IncidentReport report) {
    if (group.first.category != report.category) {
      return false;
    }

    final centroid = _centroid(group);
    final distance = centroid.distanceTo(report.location);
    if (distance <= groupingRadius) {
      return true;
    }

    final sameZone = group.any(
      (item) => item.location.zone == report.location.zone,
    );
    return sameZone && distance <= groupingRadius * 1.35;
  }

  UrbanProblem _buildProblem(
    List<IncidentReport> group,
    int sequence,
    DateTime now,
  ) {
    final sortedByDate = [...group]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final reporters = group.map((report) => report.reporterId).toSet();
    final averageUrgency =
        group.map((report) => report.urgency).reduce((a, b) => a + b) /
        group.length;
    final location = _centroid(group).copyWith(
      zone: _mostFrequent(group.map((report) => report.location.zone)),
      label: _mostFrequent(group.map((report) => report.location.label)),
      nearSchool: group.any((report) => report.location.nearSchool),
      nearTransport: group.any((report) => report.location.nearTransport),
      highCirculation: group.any((report) => report.location.highCirculation),
    );
    final flaggedCount = group.where((report) => report.flagged).length;

    return UrbanProblem(
      id: '#$sequence',
      title: _problemTitle(group),
      category: group.first.category,
      location: location,
      reports: List.unmodifiable(group),
      reportsCount: group.length,
      uniqueReporters: reporters.length,
      firstReported: sortedByDate.first.createdAt,
      lastReported: sortedByDate.last.createdAt,
      averageUrgency: averageUrgency,
      priority: calculatePriority(group, now: now),
      contextTags: _contextTags(location),
      flaggedCount: flaggedCount,
      status: _dominantStatus(group),
    );
  }

  CityLocation _centroid(List<IncidentReport> group) {
    final x =
        group.map((report) => report.location.x).reduce((a, b) => a + b) /
        group.length;
    final y =
        group.map((report) => report.location.y).reduce((a, b) => a + b) /
        group.length;
    return group.first.location.copyWith(x: x, y: y);
  }

  int calculatePriority(List<IncidentReport> group, {DateTime? now}) {
    final effectiveNow = now ?? DateTime.now();
    final reportsCount = group.length;
    final uniqueReporters = group
        .map((report) => report.reporterId)
        .toSet()
        .length;
    final averageUrgency =
        group.map((report) => report.urgency).reduce((a, b) => a + b) /
        reportsCount;
    final oldest = group
        .map((report) => report.createdAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final ageDays = effectiveNow.difference(oldest).inDays.clamp(0, 60);
    final nearSchool = group.any((report) => report.location.nearSchool);
    final nearTransport = group.any((report) => report.location.nearTransport);
    final highCirculation = group.any(
      (report) => report.location.highCirculation,
    );
    final photoCount = group.where((report) => report.hasPhoto).length;
    final flaggedCount = group.where((report) => report.flagged).length;
    final trustAverage =
        group.map((report) => report.reporterTrust).reduce((a, b) => a + b) /
        reportsCount;

    final reportScore = math.min(
      35,
      (reportsCount * 4.5) + (uniqueReporters * 3.0),
    );
    final urgencyScore = (averageUrgency / 5) * 22;
    final ageScore = math.min(18, ageDays * 2.2);
    final contextScore =
        (nearSchool ? 12 : 0) +
        (nearTransport ? 8 : 0) +
        (highCirculation ? 8 : 0);
    final evidenceScore = (photoCount / reportsCount) * 7;
    final trustPenalty = trustAverage < 0.55
        ? 10
        : (trustAverage < 0.7 ? 5 : 0);
    final flaggedPenalty = flaggedCount * 5;
    final singleReporterPenalty = reportsCount >= 3 && uniqueReporters == 1
        ? 16
        : 0;

    final rawScore =
        reportScore +
        urgencyScore +
        ageScore +
        contextScore +
        evidenceScore -
        trustPenalty -
        flaggedPenalty -
        singleReporterPenalty;

    return rawScore.round().clamp(0, 100).toInt();
  }

  List<String> _contextTags(CityLocation location) {
    return [
      if (location.nearSchool) 'Escuela cercana',
      if (location.nearTransport) 'Parada/terminal cercana',
      if (location.highCirculation) 'Alta circulación',
      if (!location.nearSchool &&
          !location.nearTransport &&
          !location.highCirculation)
        'Zona residencial',
    ];
  }

  String _problemTitle(List<IncidentReport> group) {
    final category = group.first.category.label;
    final zone = _mostFrequent(group.map((report) => report.location.zone));
    return '$category en zona $zone';
  }

  String _mostFrequent(Iterable<String> values) {
    final counts = <String, int>{};
    for (final value in values) {
      counts[value] = (counts[value] ?? 0) + 1;
    }

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  ReportStatus _dominantStatus(List<IncidentReport> group) {
    if (group.any((report) => report.status == ReportStatus.inReview)) {
      return ReportStatus.inReview;
    }
    if (group.any((report) => report.status == ReportStatus.grouped)) {
      return ReportStatus.grouped;
    }
    return ReportStatus.pending;
  }
}

class IntelligenceStats {
  const IntelligenceStats({
    required this.totalReports,
    required this.activeProblems,
    required this.criticalProblems,
    required this.flaggedReports,
    required this.resolvedReports,
    required this.averagePriority,
  });

  final int totalReports;
  final int activeProblems;
  final int criticalProblems;
  final int flaggedReports;
  final int resolvedReports;
  final int averagePriority;
}
