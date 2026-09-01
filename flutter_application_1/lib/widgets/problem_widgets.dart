part of '../app.dart';

class _ProblemCard extends StatelessWidget {
  const _ProblemCard({
    required this.problem,
    this.showAdminActions = false,
    this.onStatusChanged,
  });

  final UrbanProblem problem;
  final bool showAdminActions;
  final void Function(UrbanProblem problem, ReportStatus status)?
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(problem.priority);
    final now = DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_categoryIcon(problem.category), color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROBLEMA ${problem.id}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        problem.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                _StatusChip(label: problem.priorityLabel, color: color),
              ],
            ),
            const SizedBox(height: 9),
            LinearProgressIndicator(
              value: problem.priorityFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _InfoChip(
                  icon: Icons.place_outlined,
                  label: problem.location.zone,
                ),
                _InfoChip(
                  icon: Icons.group_outlined,
                  label: '${problem.reportsCount} reportes',
                ),
                _InfoChip(
                  icon: Icons.person_search_outlined,
                  label: '${problem.uniqueReporters} usuarios',
                ),
                _InfoChip(
                  icon: Icons.calendar_month_outlined,
                  label: '${problem.ageDays(now)} dias',
                ),
                _InfoChip(icon: Icons.percent, label: '${problem.priority}%'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in problem.contextTags) Chip(label: Text(tag)),
                if (problem.flaggedCount > 0)
                  const Chip(
                    avatar: Icon(Icons.flag_outlined, size: 15),
                    label: Text('Revision antiabuso'),
                  ),
              ],
            ),
            const SizedBox(height: 9),
            _EvidenceLine(problem: problem),
            if (showAdminActions && onStatusChanged != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  OutlinedButton.icon(
                    onPressed: () =>
                        onStatusChanged!(problem, ReportStatus.inReview),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('En revision'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        onStatusChanged!(problem, ReportStatus.resolved),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Resolver'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactProblemTile extends StatelessWidget {
  const _CompactProblemTile({
    required this.problem,
    required this.selected,
    required this.onTap,
  });

  final UrbanProblem problem;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(problem.priority);

    return Card(
      color: selected ? color.withValues(alpha: 0.08) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _categoryIcon(problem.category),
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${problem.id} - ${problem.category.label}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${problem.location.zone} - ${problem.reportsCount} reportes',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Text(
                '${problem.priority}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report, required this.problem});

  final IncidentReport report;
  final UrbanProblem? problem;

  @override
  Widget build(BuildContext context) {
    final problemText = problem == null
        ? 'Sin agrupar'
        : 'Agrupado en ${problem!.id}';
    final color = problem == null
        ? _oruroStone
        : _priorityColor(problem!.priority);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_categoryIcon(report.category), color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${report.category.label} - ${report.location.zone} - ${report.status.label}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _InfoChip(icon: Icons.hub_outlined, label: problemText),
                      if (report.hasPhoto)
                        const _InfoChip(
                          icon: Icons.photo_camera_outlined,
                          label: 'Foto',
                        ),
                      if (report.flagged)
                        const _InfoChip(
                          icon: Icons.flag_outlined,
                          label: 'Revision',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenceLine extends StatelessWidget {
  const _EvidenceLine({required this.problem});

  final UrbanProblem problem;

  @override
  Widget build(BuildContext context) {
    final photoCount = problem.reports
        .where((report) => report.hasPhoto)
        .length;
    final latestPhoto = problem.reports.lastWhereOrNull(
      (report) => report.hasPhoto,
    );

    return Row(
      children: [
        Container(
          width: 46,
          height: 34,
          decoration: BoxDecoration(
            color: _oruroSky.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _oruroSky.withValues(alpha: 0.25)),
          ),
          child: Icon(
            photoCount > 0 ? Icons.photo_camera : Icons.no_photography_outlined,
            color: _oruroSky,
            size: 19,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            photoCount > 0
                ? '$photoCount fotos registradas - ${latestPhoto?.imageNote ?? 'Evidencia disponible'}'
                : 'Sin evidencia fotografica',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
