part of '../app.dart';

class OruroCityMap extends StatelessWidget {
  const OruroCityMap({
    super.key,
    required this.problems,
    this.selectedProblem,
    this.draftLocation,
    this.onProblemSelected,
    this.onLocationSelected,
  });

  final List<UrbanProblem> problems;
  final UrbanProblem? selectedProblem;
  final CityLocation? draftLocation;
  final ValueChanged<UrbanProblem>? onProblemSelected;
  final ValueChanged<CityLocation>? onLocationSelected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Relación aproximada de la imagen del mapa
      aspectRatio: 1.14,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: onLocationSelected == null
                ? null
                : (details) {
                    final x = details.localPosition.dx / constraints.maxWidth;
                    final y = details.localPosition.dy / constraints.maxHeight;

                    onLocationSelected!(nearestOruroLocation(x, y));
                  },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // =========================================================
                  // MAPA SATELITAL REAL
                  // =========================================================
                  Positioned.fill(
                    child: Image.asset(
                      'assets/maps/zona_oruro.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // =========================================================
                  // MARCADORES DE LOS PROBLEMAS
                  // =========================================================
                  for (final problem in problems)
                    _ProblemMarker(
                      problem: problem,
                      selected: problem.id == selectedProblem?.id,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      onTap: onProblemSelected == null
                          ? null
                          : () => onProblemSelected!(problem),
                    ),

                  // =========================================================
                  // MARCADOR DEL PUNTO QUE EL USUARIO SELECCIONÓ
                  // =========================================================
                  if (draftLocation != null)
                    _DraftMarker(
                      location: draftLocation!,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// MARCADOR DE PROBLEMA
// ============================================================================

class _ProblemMarker extends StatelessWidget {
  const _ProblemMarker({
    required this.problem,
    required this.selected,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final UrbanProblem problem;
  final bool selected;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(problem.priority);

    final markerSize = selected ? 38.0 : 32.0;

    final left = (problem.location.x * width - markerSize / 2)
        .clamp(6.0, width - markerSize - 6)
        .toDouble();

    final top = (problem.location.y * height - markerSize / 2)
        .clamp(6.0, height - markerSize - 6)
        .toDouble();

    return Positioned(
      left: left,
      top: top,
      child: Tooltip(
        message: '${problem.id} ${problem.title}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(markerSize),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: markerSize,
              height: markerSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: selected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: selected ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _categoryIcon(problem.category),
                color: Colors.white,
                size: selected ? 21 : 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MARCADOR DE UBICACIÓN SELECCIONADA
// ============================================================================

class _DraftMarker extends StatelessWidget {
  const _DraftMarker({
    required this.location,
    required this.width,
    required this.height,
  });

  final CityLocation location;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    const markerSize = 36.0;

    final left = (location.x * width - markerSize / 2)
        .clamp(6.0, width - markerSize - 6)
        .toDouble();

    final top = (location.y * height - markerSize)
        .clamp(6.0, height - markerSize - 6)
        .toDouble();

    return Positioned(
      left: left,
      top: top,
      child: const Icon(
        Icons.location_on,
        size: markerSize,
        color: _oruroCrimson,
      ),
    );
  }
}
