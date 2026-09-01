import 'package:flutter_application_1/data/oruro_zone.dart';
import 'package:flutter_application_1/urban_intelligence.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime(2026, 8, 26, 12);

  IncidentReport report({
    required String id,
    required String reporterId,
    required IncidentCategory category,
    required CityLocation location,
    required int urgency,
    int minutesAgo = 20,
    int daysAgo = 0,
    double trust = 0.82,
    bool hasPhoto = true,
    bool flagged = false,
    String description = 'Descripción suficiente para validar el reporte.',
  }) {
    return IncidentReport(
      id: id,
      title: 'Reporte urbano $id',
      category: category,
      location: location,
      description: description,
      urgency: urgency,
      createdAt: now.subtract(Duration(days: daysAgo, minutes: minutesAgo)),
      reporterId: reporterId,
      reporterTrust: trust,
      hasPhoto: hasPhoto,
      imageNote: hasPhoto ? 'Foto clara del problema' : '',
      flagged: flagged,
    );
  }

  test('groups nearby reports by category and location', () {
    final engine = UrbanIntelligenceEngine();
    final reports = [
      report(
        id: '1',
        reporterId: 'cit-1',
        category: IncidentCategory.pothole,
        location: oruroReferenceLocations[1],
        urgency: 5,
      ),
      report(
        id: '2',
        reporterId: 'cit-2',
        category: IncidentCategory.pothole,
        location: oruroReferenceLocations[1].copyWith(x: 0.43, y: 0.26),
        urgency: 4,
      ),
      report(
        id: '3',
        reporterId: 'cit-3',
        category: IncidentCategory.trash,
        location: oruroReferenceLocations[1],
        urgency: 3,
      ),
    ];

    final problems = engine.buildProblems(reports, now: now);

    expect(problems, hasLength(2));
    expect(
      problems
          .firstWhere((problem) => problem.category == IncidentCategory.pothole)
          .reportsCount,
      2,
    );
  });

  test(
    'priority becomes critical with many trusted reports near risk points',
    () {
      final engine = UrbanIntelligenceEngine();
      final reports = [
        report(
          id: '1',
          reporterId: 'cit-1',
          category: IncidentCategory.pothole,
          location: oruroReferenceLocations.first,
          urgency: 5,
          daysAgo: 12,
        ),
        report(
          id: '2',
          reporterId: 'cit-2',
          category: IncidentCategory.pothole,
          location: oruroReferenceLocations.first.copyWith(x: 0.54, y: 0.39),
          urgency: 5,
          daysAgo: 10,
        ),
        report(
          id: '3',
          reporterId: 'cit-3',
          category: IncidentCategory.pothole,
          location: oruroReferenceLocations.first.copyWith(x: 0.50, y: 0.40),
          urgency: 4,
          daysAgo: 8,
        ),
      ];

      final problem = engine.buildProblems(reports, now: now).first;

      expect(problem.priority, greaterThanOrEqualTo(90));
      expect(problem.priorityLabel, 'Crítica');
    },
  );

  test('guard blocks a duplicate report from the same user', () {
    final guard = ReportGuard();
    final existing = [
      report(
        id: '1',
        reporterId: 'cit-1',
        category: IncidentCategory.sewer,
        location: oruroReferenceLocations[5],
        urgency: 5,
        minutesAgo: 15,
      ),
    ];
    final candidate = report(
      id: '2',
      reporterId: 'cit-1',
      category: IncidentCategory.sewer,
      location: oruroReferenceLocations[5].copyWith(x: 0.63, y: 0.58),
      urgency: 5,
      minutesAgo: 0,
    );

    final result = guard.validate(existing, candidate, now: now);

    expect(result.allowed, isFalse);
    expect(result.errors.join(' '), contains('similar'));
  });

  test('guard blocks saturation from one user in a short window', () {
    final guard = ReportGuard();
    final existing = [
      for (var index = 0; index < 4; index++)
        report(
          id: 'recent-$index',
          reporterId: 'cit-1',
          category: IncidentCategory.values[index],
          location: oruroReferenceLocations[index],
          urgency: 3,
          minutesAgo: index + 1,
          description:
              'Reporte distinto número $index con información suficiente.',
        ),
    ];
    final candidate = report(
      id: 'fifth',
      reporterId: 'cit-1',
      category: IncidentCategory.transport,
      location: oruroReferenceLocations.last,
      urgency: 4,
      minutesAgo: 0,
      description: 'Nuevo reporte distinto con información suficiente.',
    );

    final result = guard.validate(existing, candidate, now: now);

    expect(result.allowed, isFalse);
    expect(result.errors.join(' '), contains('límite temporal'));
  });

  test(
    'single suspicious reporter has lower priority than several trusted users',
    () {
      final engine = UrbanIntelligenceEngine();
      final suspicious = [
        for (var index = 0; index < 4; index++)
          report(
            id: 'spam-$index',
            reporterId: 'cit-spam',
            category: IncidentCategory.pothole,
            location: oruroReferenceLocations.first.copyWith(
              x: 0.52 + (index * 0.01),
              y: 0.38 + (index * 0.01),
            ),
            urgency: 5,
            trust: 0.35,
            hasPhoto: false,
            flagged: true,
            daysAgo: 1,
          ),
      ];
      final trusted = [
        for (var index = 0; index < 4; index++)
          report(
            id: 'trusted-$index',
            reporterId: 'cit-$index',
            category: IncidentCategory.pothole,
            location: oruroReferenceLocations.first.copyWith(
              x: 0.52 + (index * 0.01),
              y: 0.38 + (index * 0.01),
            ),
            urgency: 5,
            trust: 0.85,
            hasPhoto: true,
            daysAgo: 1,
          ),
      ];

      final suspiciousPriority = engine
          .buildProblems(suspicious, now: now)
          .first
          .priority;
      final trustedPriority = engine
          .buildProblems(trusted, now: now)
          .first
          .priority;

      expect(trustedPriority, greaterThan(suspiciousPriority));
    },
  );
}
