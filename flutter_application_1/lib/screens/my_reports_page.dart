part of '../app.dart';

class _MyReportsPage extends StatelessWidget {
  const _MyReportsPage({required this.reports, required this.problems});

  final List<IncidentReport> reports;
  final List<UrbanProblem> problems;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: ListView(
        children: [
          const _HeaderLine(icon: Icons.assignment, title: 'Mis reportes'),
          const SizedBox(height: 12),
          if (reports.isEmpty)
            const _EmptyState(
              icon: Icons.assignment_outlined,
              title: 'Sin reportes registrados',
              message: 'Tus reportes apareceran aqui.',
            )
          else
            for (final report in reports)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReportTile(
                  report: report,
                  problem: problems.firstWhereOrNull(
                    (problem) =>
                        problem.reports.any((item) => item.id == report.id),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
