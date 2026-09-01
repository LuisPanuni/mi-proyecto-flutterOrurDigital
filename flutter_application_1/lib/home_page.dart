part of 'app.dart';

class OruroDigitalHomePage extends StatefulWidget {
  const OruroDigitalHomePage({super.key});

  @override
  State<OruroDigitalHomePage> createState() => _OruroDigitalHomePageState();
}

class _OruroDigitalHomePageState extends State<OruroDigitalHomePage> {
  final UrbanIntelligenceEngine _engine = const UrbanIntelligenceEngine();
  final ReportGuard _guard = const ReportGuard();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _reportKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: 'ciudadano@oruro.bo',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'ciudadano123',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late List<IncidentReport> _reports;
  final List<String> _securityEvents = [
    'Regla activa: se agrupan reportes cercanos por categoria.',
    'Regla activa: duplicados del mismo usuario se bloquean por 45 min.',
  ];

  DemoUser? _currentUser;
  int _selectedIndex = 0;
  IncidentCategory _selectedCategory = IncidentCategory.pothole;
  CityLocation _selectedLocation = oruroReferenceLocations.first;
  int _selectedUrgency = 4;
  bool _hasPhoto = true;
  String _imageNote = 'Foto clara del problema';
  String? _selectedProblemId;

  @override
  void initState() {
    super.initState();
    _reports = _seedReports(DateTime.now());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_loginKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    final user = _demoUsers
        .where((candidate) => candidate.email == email)
        .firstOrNull;

    if (user == null || _demoPasswords[email] != password) {
      _showSnack('Credenciales incorrectas.');
      return;
    }

    setState(() {
      _currentUser = user;
      _selectedIndex = 0;
      _selectedProblemId = null;
    });
  }

  void _fillLogin(DemoUser user) {
    setState(() {
      _emailController.text = user.email;
      _passwordController.text = _demoPasswords[user.email] ?? '';
    });
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _selectedIndex = 0;
      _selectedProblemId = null;
    });
  }

  void _submitReport() {
    final user = _currentUser;
    if (user == null || !_reportKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final candidate = IncidentReport(
      id: 'R-${now.millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      location: _selectedLocation,
      description: _descriptionController.text.trim(),
      urgency: _selectedUrgency,
      createdAt: now,
      reporterId: user.id,
      reporterTrust: user.trustScore,
      hasPhoto: _hasPhoto,
      imageNote: _hasPhoto ? _imageNote : '',
    );

    final validation = _guard.validate(_reports, candidate, now: now);
    if (!validation.allowed) {
      setState(() {
        _securityEvents.insert(0, '${user.email}: ${validation.errors.first}');
      });
      _showSnack(validation.errors.first);
      return;
    }

    final flagged = validation.warnings.isNotEmpty;
    setState(() {
      _reports.insert(
        0,
        candidate.copyWith(status: ReportStatus.grouped, flagged: flagged),
      );
      for (final warning in validation.warnings) {
        _securityEvents.insert(0, '${user.email}: $warning');
      }
      _selectedIndex = user.role == UserRole.admin ? 1 : 0;
    });

    _clearReportForm();
    _showSnack(
      flagged
          ? 'Reporte guardado y marcado para revision.'
          : 'Reporte guardado.',
    );
  }

  void _clearReportForm() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedCategory = IncidentCategory.pothole;
    _selectedLocation = oruroReferenceLocations.first;
    _selectedUrgency = 4;
    _hasPhoto = true;
    _imageNote = 'Foto clara del problema';
  }

  void _changeProblemStatus(UrbanProblem problem, ReportStatus status) {
    final reportIds = problem.reports.map((report) => report.id).toSet();
    setState(() {
      _reports = [
        for (final report in _reports)
          if (reportIds.contains(report.id))
            report.copyWith(status: status)
          else
            report,
      ];
      _securityEvents.insert(
        0,
        '${problem.id}: estado actualizado a ${status.label}.',
      );
    });
  }

  void _selectProblem(UrbanProblem problem) {
    setState(() {
      _selectedProblemId = problem.id;
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;
    if (user == null) {
      return _LoginPage(
        formKey: _loginKey,
        emailController: _emailController,
        passwordController: _passwordController,
        onLogin: _login,
        onFillLogin: _fillLogin,
      );
    }

    final isAdmin = user.role == UserRole.admin;
    final destinations = _destinationsFor(user);
    final selectedIndex = _selectedIndex
        .clamp(0, destinations.length - 1)
        .toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oruro Digital'),
        actions: [
          _UserBadge(user: user),
          IconButton(
            tooltip: 'Cerrar sesion',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final content = _pageForIndex(selectedIndex, user);

          if (!wide) {
            return content;
          }

          return Row(
            children: [
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) =>
                    setState(() => _selectedIndex = index),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final destination in destinations)
                    NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: Text(destination.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: content),
            ],
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 920) {
            return const SizedBox.shrink();
          }

          return NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: [
              for (final destination in destinations)
                NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: destination.label,
                ),
            ],
          );
        },
      ),
      floatingActionButton: isAdmin
          ? null
          : FloatingActionButton.extended(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Reportar'),
            ),
    );
  }

  List<_Destination> _destinationsFor(DemoUser user) {
    if (user.role == UserRole.admin) {
      return const [
        _Destination('Mapa', Icons.map_outlined, Icons.map),
        _Destination(
          'Problemas',
          Icons.priority_high_outlined,
          Icons.priority_high,
        ),
        _Destination(
          'Reportar',
          Icons.add_location_alt_outlined,
          Icons.add_location_alt,
        ),
        _Destination(
          'Admin',
          Icons.admin_panel_settings_outlined,
          Icons.admin_panel_settings,
        ),
      ];
    }

    return const [
      _Destination('Mapa', Icons.map_outlined, Icons.map),
      _Destination(
        'Reportar',
        Icons.add_location_alt_outlined,
        Icons.add_location_alt,
      ),
      _Destination('Mis reportes', Icons.assignment_outlined, Icons.assignment),
    ];
  }

  Widget _pageForIndex(int index, DemoUser user) {
    final problems = _engine.buildProblems(_reports);

    if (user.role == UserRole.admin) {
      return switch (index) {
        0 => _MapPage(
          problems: problems,
          selectedProblemId: _selectedProblemId,
          onProblemSelected: _selectProblem,
        ),
        1 => _ProblemsPage(
          problems: problems,
          isAdmin: true,
          onStatusChanged: _changeProblemStatus,
        ),
        2 => _ReportPage(
          formKey: _reportKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          selectedCategory: _selectedCategory,
          selectedLocation: _selectedLocation,
          selectedUrgency: _selectedUrgency,
          hasPhoto: _hasPhoto,
          imageNote: _imageNote,
          onCategoryChanged: (value) =>
              setState(() => _selectedCategory = value),
          onLocationChanged: (value) =>
              setState(() => _selectedLocation = value),
          onUrgencyChanged: (value) => setState(() => _selectedUrgency = value),
          onHasPhotoChanged: (value) => setState(() => _hasPhoto = value),
          onImageNoteChanged: (value) => setState(() => _imageNote = value),
          onSubmit: _submitReport,
        ),
        _ => _AdminPage(
          reports: _reports,
          problems: problems,
          stats: _engine.buildStats(_reports),
          securityEvents: _securityEvents,
          guard: _guard,
          onStatusChanged: _changeProblemStatus,
        ),
      };
    }

    return switch (index) {
      0 => _MapPage(
        problems: problems,
        selectedProblemId: _selectedProblemId,
        onProblemSelected: _selectProblem,
      ),
      1 => _ReportPage(
        formKey: _reportKey,
        titleController: _titleController,
        descriptionController: _descriptionController,
        selectedCategory: _selectedCategory,
        selectedLocation: _selectedLocation,
        selectedUrgency: _selectedUrgency,
        hasPhoto: _hasPhoto,
        imageNote: _imageNote,
        onCategoryChanged: (value) => setState(() => _selectedCategory = value),
        onLocationChanged: (value) => setState(() => _selectedLocation = value),
        onUrgencyChanged: (value) => setState(() => _selectedUrgency = value),
        onHasPhotoChanged: (value) => setState(() => _hasPhoto = value),
        onImageNoteChanged: (value) => setState(() => _imageNote = value),
        onSubmit: _submitReport,
      ),
      _ => _MyReportsPage(
        reports: _reports
            .where((report) => report.reporterId == user.id)
            .toList(),
        problems: problems,
      ),
    };
  }
}
