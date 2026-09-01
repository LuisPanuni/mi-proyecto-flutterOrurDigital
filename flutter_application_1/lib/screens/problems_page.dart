part of '../app.dart';

class _ProblemsPage extends StatelessWidget {
  const _ProblemsPage({
    required this.problems,
    required this.isAdmin,
    this.onStatusChanged,
  });

  final List<UrbanProblem> problems;
  final bool isAdmin;
  final void Function(UrbanProblem problem, ReportStatus status)?
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: ListView(
        children: [
          const _HeaderLine(
            icon: Icons.priority_high,
            title: 'Problemas agrupados',
          ),
          const SizedBox(height: 12),
          for (final problem in problems)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProblemCard(
                problem: problem,
                showAdminActions: isAdmin,
                onStatusChanged: onStatusChanged,
              ),
            ),
        ],
      ),
    );
  }
}
