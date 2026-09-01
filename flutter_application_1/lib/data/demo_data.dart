part of '../app.dart';

const List<DemoUser> _demoUsers = [
  DemoUser(
    id: 'cit-001',
    name: 'Vecina Centro',
    email: 'ciudadano@oruro.bo',
    role: UserRole.citizen,
    trustScore: 0.82,
  ),
  DemoUser(
    id: 'adm-001',
    name: 'Unidad Urbana',
    email: 'admin@oruro.bo',
    role: UserRole.admin,
    trustScore: 0.98,
  ),
];

const Map<String, String> _demoPasswords = {
  'ciudadano@oruro.bo': 'ciudadano123',
  'admin@oruro.bo': 'admin123',
};

List<IncidentReport> _seedReports(DateTime now) {
  IncidentReport report({
    required String id,
    required String title,
    required IncidentCategory category,
    required CityLocation location,
    required String description,
    required int urgency,
    required int daysAgo,
    required String reporterId,
    required double trust,
    bool hasPhoto = true,
    bool flagged = false,
    ReportStatus status = ReportStatus.grouped,
  }) {
    return IncidentReport(
      id: id,
      title: title,
      category: category,
      location: location,
      description: description,
      urgency: urgency,
      createdAt: now.subtract(Duration(days: daysAgo)),
      reporterId: reporterId,
      reporterTrust: trust,
      hasPhoto: hasPhoto,
      imageNote: hasPhoto ? 'Evidencia fotografica registrada' : '',
      flagged: flagged,
      status: status,
    );
  }

  return [
    report(
      id: 'R-1001',
      title: 'Bache profundo en la avenida',
      category: IncidentCategory.pothole,
      location: oruroReferenceLocations[1],
      description:
          'Agujero grande con riesgo para motociclistas y automoviles.',
      urgency: 5,
      daysAgo: 12,
      reporterId: 'cit-001',
      trust: 0.82,
    ),
    report(
      id: 'R-1002',
      title: 'Bache cerca de parada',
      category: IncidentCategory.pothole,
      location: oruroReferenceLocations[1].copyWith(x: 0.43, y: 0.26),
      description: 'El bache obliga a los autos a invadir el otro carril.',
      urgency: 5,
      daysAgo: 10,
      reporterId: 'cit-002',
      trust: 0.76,
    ),
    report(
      id: 'R-1003',
      title: 'Hueco en calzada',
      category: IncidentCategory.pothole,
      location: oruroReferenceLocations[1].copyWith(x: 0.38, y: 0.22),
      description: 'Varios vecinos reportaron golpes en llantas.',
      urgency: 4,
      daysAgo: 8,
      reporterId: 'cit-003',
      trust: 0.88,
    ),
    report(
      id: 'R-1004',
      title: 'Luminaria apagada',
      category: IncidentCategory.lighting,
      location: oruroReferenceLocations[2],
      description: 'La calle queda oscura en horario nocturno.',
      urgency: 4,
      daysAgo: 5,
      reporterId: 'cit-004',
      trust: 0.74,
    ),
    report(
      id: 'R-1005',
      title: 'Basura acumulada',
      category: IncidentCategory.trash,
      location: oruroReferenceLocations[4],
      description: 'Bolsas de residuos bloquean la acera y generan mal olor.',
      urgency: 3,
      daysAgo: 4,
      reporterId: 'cit-005',
      trust: 0.79,
    ),
    report(
      id: 'R-1006',
      title: 'Alcantarilla sin tapa',
      category: IncidentCategory.sewer,
      location: oruroReferenceLocations[5],
      description: 'Hay una abertura peligrosa cerca de la terminal.',
      urgency: 5,
      daysAgo: 2,
      reporterId: 'cit-006',
      trust: 0.91,
    ),
    report(
      id: 'R-1007',
      title: 'Senal caida',
      category: IncidentCategory.signage,
      location: oruroReferenceLocations[0],
      description: 'La senal de transito no es visible desde la avenida.',
      urgency: 3,
      daysAgo: 1,
      reporterId: 'cit-007',
      trust: 0.71,
      hasPhoto: false,
      flagged: true,
    ),
  ];
}
