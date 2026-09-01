part of '../app.dart';

class _AdminPage extends StatelessWidget {
  const _AdminPage({
    required this.reports,
    required this.problems,
    required this.stats,
    required this.securityEvents,
    required this.guard,
    required this.onStatusChanged,
  });

  final List<IncidentReport> reports;
  final List<UrbanProblem> problems;
  final IntelligenceStats stats;
  final List<String> securityEvents;
  final ReportGuard guard;
  final void Function(UrbanProblem problem, ReportStatus status)
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: ListView(
        children: [
          const _HeaderLine(
            icon: Icons.admin_panel_settings,
            title: 'Panel administrativo',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final cards = [
                _StatCard(
                  title: 'Reportes',
                  value: '${stats.totalReports}',
                  icon: Icons.summarize_outlined,
                  color: _oruroSky,
                ),
                _StatCard(
                  title: 'Problemas',
                  value: '${stats.activeProblems}',
                  icon: Icons.hub_outlined,
                  color: _oruroGreen,
                ),
                _StatCard(
                  title: 'Criticos',
                  value: '${stats.criticalProblems}',
                  icon: Icons.warning_amber,
                  color: _oruroCrimson,
                ),
                _StatCard(
                  title: 'Revision',
                  value: '${stats.flaggedReports}',
                  icon: Icons.verified_user_outlined,
                  color: _oruroGold,
                ),
              ];

              if (!wide) {
                return Column(
                  children: [
                    for (final card in cards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: card,
                      ),
                  ],
                );
              }

              return Row(
                children: [
                  for (final card in cards)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: card,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          _GuardPanel(guard: guard, securityEvents: securityEvents),
          const SizedBox(height: 14),
          const _HeaderLine(
            icon: Icons.engineering_outlined,
            title: 'Acciones',
          ),
          const SizedBox(height: 12),
          for (final problem in problems.take(4))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ProblemCard(
                problem: problem,
                showAdminActions: true,
                onStatusChanged: onStatusChanged,
              ),
            ),
        ],
      ),
    );
  }
}
