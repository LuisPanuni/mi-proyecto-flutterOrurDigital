import '../urban_intelligence.dart';

const List<CityLocation> oruroReferenceLocations = [
  // ============================================================
  // PARQUE DE LA UNIÓN NACIONAL
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Parque de la Unión Nacional',
    x: 0.19,
    y: 0.31,
    latitude: -17.9650,
    longitude: -67.1200,
    highCirculation: true,
  ),

  // ============================================================
  // AV. VILLARROEL
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Av. Villarroel',
    x: 0.48,
    y: 0.08,
    latitude: -17.9570,
    longitude: -67.1120,
    nearTransport: true,
    highCirculation: true,
  ),

  // ============================================================
  // AROMA
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Calle Aroma',
    x: 0.54,
    y: 0.23,
    latitude: -17.9610,
    longitude: -67.1110,
    highCirculation: true,
  ),

  // ============================================================
  // AV. 6 DE OCTUBRE
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Av. 6 de Octubre',
    x: 0.28,
    y: 0.45,
    latitude: -17.9670,
    longitude: -67.1180,
    nearTransport: true,
    highCirculation: true,
  ),

  // ============================================================
  // AV. PAGADOR
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Av. Pagador',
    x: 0.51,
    y: 0.39,
    latitude: -17.9660,
    longitude: -67.1120,
    nearTransport: true,
    highCirculation: true,
  ),

  // ============================================================
  // VELASCO GALVARRO
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Velasco Galvarro',
    x: 0.70,
    y: 0.38,
    latitude: -17.9650,
    longitude: -67.1050,
    nearTransport: true,
    highCirculation: true,
  ),

  // ============================================================
  // JOSÉ IGNACIO LEÓN
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'José Ignacio León',
    x: 0.48,
    y: 0.76,
    latitude: -17.9740,
    longitude: -67.1120,
    nearSchool: true,
  ),

  // ============================================================
  // GRAN HOTEL BOLIVIA
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Gran Hotel Bolivia',
    x: 0.68,
    y: 0.48,
    latitude: -17.9680,
    longitude: -67.1060,
    highCirculation: true,
  ),

  // ============================================================
  // CALLE POTOSÍ
  // ============================================================
  CityLocation(
    zone: 'Norte',
    label: 'Calle Potosí',
    x: 0.34,
    y: 0.47,
    latitude: -17.9680,
    longitude: -67.1150,
    highCirculation: true,
  ),
];

// ============================================================================
// BUSCAR EL LUGAR DE REFERENCIA MÁS CERCANO
// ============================================================================

CityLocation nearestOruroLocation(double x, double y) {
  // Evita que el punto salga fuera del mapa
  final safeX = x.clamp(0.03, 0.97).toDouble();
  final safeY = y.clamp(0.03, 0.97).toDouble();

  // Punto temporal utilizado para calcular distancias
  final selectedPoint = CityLocation(zone: '', label: '', x: safeX, y: safeY);

  // Comenzamos con la primera ubicación
  var nearest = oruroReferenceLocations.first;

  var minimumDistance = nearest.distanceTo(selectedPoint);

  // Buscamos la ubicación más cercana
  for (final location in oruroReferenceLocations.skip(1)) {
    final candidateDistance = location.distanceTo(selectedPoint);

    if (candidateDistance < minimumDistance) {
      nearest = location;
      minimumDistance = candidateDistance;
    }
  }

  // Devolvemos la ubicación real pero con
  // las coordenadas exactas donde el usuario tocó.
  return nearest.copyWith(
    label: 'Punto marcado cerca de ${nearest.label}',
    x: safeX,
    y: safeY,
  );
}
