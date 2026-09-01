part of '../app.dart';

class _MapPage extends StatelessWidget {
  const _MapPage({
    required this.problems,
    required this.selectedProblemId,
    required this.onProblemSelected,
  });

  final List<UrbanProblem> problems;
  final String? selectedProblemId;
  final ValueChanged<UrbanProblem> onProblemSelected;

  @override
  Widget build(BuildContext context) {
    final selectedProblem =
        problems.firstWhereOrNull(
          (problem) => problem.id == selectedProblemId,
        ) ??
        (problems.isEmpty ? null : problems.first);

    return _PagePadding(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final map = _MapPanel(
            problems: problems,
            selectedProblem: selectedProblem,
            onProblemSelected: onProblemSelected,
          );
          final list = _ProblemRankingList(
            problems: problems,
            selectedProblem: selectedProblem,
            onProblemSelected: onProblemSelected,
          );

          if (!wide) {
            return ListView(children: [map, const SizedBox(height: 16), list]);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: SingleChildScrollView(child: map)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: SingleChildScrollView(child: list)),
            ],
          );
        },
      ),
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({
    required this.problems,
    required this.selectedProblem,
    required this.onProblemSelected,
  });

  final List<UrbanProblem> problems;
  final UrbanProblem? selectedProblem;
  final ValueChanged<UrbanProblem> onProblemSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderLine(
          icon: Icons.map,
          title: 'Mapa inteligente',
          trailing: Text(
            '${problems.length} problemas activos',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: OruroCityMap(
              problems: problems,
              selectedProblem: selectedProblem,
              onProblemSelected: onProblemSelected,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (selectedProblem != null) _ProblemCard(problem: selectedProblem!),
      ],
    );
  }
}

class _ProblemRankingList extends StatelessWidget {
  const _ProblemRankingList({
    required this.problems,
    required this.selectedProblem,
    required this.onProblemSelected,
  });

  final List<UrbanProblem> problems;
  final UrbanProblem? selectedProblem;
  final ValueChanged<UrbanProblem> onProblemSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderLine(icon: Icons.auto_graph, title: 'Prioridades'),
        const SizedBox(height: 8),
        for (final problem in problems)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _CompactProblemTile(
              problem: problem,
              selected: problem.id == selectedProblem?.id,
              onTap: () => onProblemSelected(problem),
            ),
          ),
      ],
    );
  }
}
