part of '../app.dart';

class _GuardPanel extends StatelessWidget {
  const _GuardPanel({required this.guard, required this.securityEvents});

  final ReportGuard guard;
  final List<String> securityEvents;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 780;
        final rules = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderLine(
              icon: Icons.shield_outlined,
              title: 'Control antiabuso',
            ),
            const SizedBox(height: 8),
            _RuleTile(
              icon: Icons.timer_outlined,
              title: 'Limite temporal',
              value:
                  '${guard.maxReportsPerWindow} reportes / ${guard.rateWindow.inMinutes} min',
            ),
            _RuleTile(
              icon: Icons.content_copy_outlined,
              title: 'Duplicados',
              value: '${guard.duplicateWindow.inMinutes} min por zona cercana',
            ),
            const _RuleTile(
              icon: Icons.verified_user_outlined,
              title: 'Confianza',
              value: 'Penalizacion por baja reputacion',
            ),
          ],
        );
        final events = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderLine(
              icon: Icons.fact_check_outlined,
              title: 'Pruebas de error',
            ),
            const SizedBox(height: 8),
            for (final event in securityEvents.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: _oruroGreen,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(event)),
                  ],
                ),
              ),
          ],
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [rules, const SizedBox(height: 12), events],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: rules),
            const SizedBox(width: 12),
            Expanded(child: events),
          ],
        );
      },
    );
  }
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon, color: _oruroCrimson, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(value, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
