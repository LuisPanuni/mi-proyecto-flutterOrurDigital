part of '../app.dart';

class _ReportPage extends StatelessWidget {
  const _ReportPage({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedLocation,
    required this.selectedUrgency,
    required this.hasPhoto,
    required this.imageNote,
    required this.onCategoryChanged,
    required this.onLocationChanged,
    required this.onUrgencyChanged,
    required this.onHasPhotoChanged,
    required this.onImageNoteChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final IncidentCategory selectedCategory;
  final CityLocation selectedLocation;
  final int selectedUrgency;
  final bool hasPhoto;
  final String imageNote;
  final ValueChanged<IncidentCategory> onCategoryChanged;
  final ValueChanged<CityLocation> onLocationChanged;
  final ValueChanged<int> onUrgencyChanged;
  final ValueChanged<bool> onHasPhotoChanged;
  final ValueChanged<String> onImageNoteChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;
          final form = _ReportForm(
            formKey: formKey,
            titleController: titleController,
            descriptionController: descriptionController,
            selectedCategory: selectedCategory,
            selectedLocation: selectedLocation,
            selectedUrgency: selectedUrgency,
            hasPhoto: hasPhoto,
            imageNote: imageNote,
            onCategoryChanged: onCategoryChanged,
            onLocationChanged: onLocationChanged,
            onUrgencyChanged: onUrgencyChanged,
            onHasPhotoChanged: onHasPhotoChanged,
            onImageNoteChanged: onImageNoteChanged,
            onSubmit: onSubmit,
          );
          final map = _LocationPickerMap(
            selectedLocation: selectedLocation,
            onLocationChanged: onLocationChanged,
          );

          if (!wide) {
            return ListView(children: [form, const SizedBox(height: 16), map]);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: SingleChildScrollView(child: form)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: SingleChildScrollView(child: map)),
            ],
          );
        },
      ),
    );
  }
}

class _ReportForm extends StatelessWidget {
  const _ReportForm({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedLocation,
    required this.selectedUrgency,
    required this.hasPhoto,
    required this.imageNote,
    required this.onCategoryChanged,
    required this.onLocationChanged,
    required this.onUrgencyChanged,
    required this.onHasPhotoChanged,
    required this.onImageNoteChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final IncidentCategory selectedCategory;
  final CityLocation selectedLocation;
  final int selectedUrgency;
  final bool hasPhoto;
  final String imageNote;
  final ValueChanged<IncidentCategory> onCategoryChanged;
  final ValueChanged<CityLocation> onLocationChanged;
  final ValueChanged<int> onUrgencyChanged;
  final ValueChanged<bool> onHasPhotoChanged;
  final ValueChanged<String> onImageNoteChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HeaderLine(
                icon: Icons.add_location_alt,
                title: 'Registrar reporte',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                  prefixIcon: Icon(Icons.short_text),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Escribe un titulo mas especifico.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<IncidentCategory>(
                key: ValueKey(selectedCategory),
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final category in IncidentCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onCategoryChanged(value);
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  prefixIcon: Icon(Icons.notes),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 12) {
                    return 'Describe mejor lo que ocurre.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Ubicacion: ${selectedLocation.label}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final location in oruroReferenceLocations)
                    ChoiceChip(
                      avatar: const Icon(Icons.place_outlined, size: 15),
                      label: Text(location.zone),
                      selected: selectedLocation.zone == location.zone,
                      onSelected: (_) => onLocationChanged(location),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.priority_high, color: _oruroCrimson),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Urgencia: $selectedUrgency/5',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              Slider(
                value: selectedUrgency.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$selectedUrgency',
                onChanged: (value) => onUrgencyChanged(value.round()),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                value: hasPhoto,
                onChanged: onHasPhotoChanged,
                secondary: const Icon(Icons.photo_camera_outlined),
                title: const Text('Evidencia fotografica'),
              ),
              if (hasPhoto) ...[
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  key: ValueKey(imageNote),
                  initialValue: imageNote,
                  decoration: const InputDecoration(
                    labelText: 'Calidad de imagen',
                    prefixIcon: Icon(Icons.image_search),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Foto clara del problema',
                      child: Text('Foto clara del problema'),
                    ),
                    DropdownMenuItem(
                      value: 'Foto nocturna o parcial',
                      child: Text('Foto nocturna o parcial'),
                    ),
                    DropdownMenuItem(
                      value: 'Foto con referencia de calle',
                      child: Text('Foto con referencia de calle'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onImageNoteChanged(value);
                    }
                  },
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.send),
                label: const Text('Guardar reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPickerMap extends StatelessWidget {
  const _LocationPickerMap({
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  final CityLocation selectedLocation;
  final ValueChanged<CityLocation> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderLine(icon: Icons.place, title: 'Zona de Oruro'),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: OruroCityMap(
              problems: const [],
              draftLocation: selectedLocation,
              onLocationSelected: onLocationChanged,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _LocationContext(location: selectedLocation),
      ],
    );
  }
}
