# Oruro Digital

Mapa inteligente de incidencias urbanas para una zona de Oruro.

## Funciones demo

- Login por rol: ciudadano y administrador.
- Reportes por categoria: baches, basura, luminarias, calles, alcantarillado, senalizacion y transporte.
- Mapa esquematico de Oruro con puntos de referencia.
- Agrupacion de reportes similares en problemas urbanos.
- Prioridad calculada por cantidad de reportes, usuarios unicos, antiguedad, urgencia, evidencia y contexto.
- Control antiabuso contra duplicados, saturacion y reportes sospechosos.
- Panel administrativo para revisar o resolver problemas.

## Credenciales

- Ciudadano: `ciudadano@oruro.bo` / `ciudadano123`
- Administrador: `admin@oruro.bo` / `admin123`

## Verificacion

```bash
dart analyze
dart run test test/urban_intelligence_test.dart
```

## Parte C++ opcional

El archivo `cpp/priority_reference.cpp` contiene una version pequena del algoritmo de prioridad en C++. No esta conectado al build de Flutter, por eso no rompe la aplicacion. Sirve como apoyo para explicar el calculo de prioridad con otro lenguaje.

Para correr la app:

```bash
flutter run
```
