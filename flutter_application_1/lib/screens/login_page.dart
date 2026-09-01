part of '../app.dart';

class _LoginPage extends StatelessWidget {
  const _LoginPage({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onFillLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final ValueChanged<DemoUser> onFillLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.location_city,
                          size: 38,
                          color: _oruroCrimson,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Oruro Digital',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mapa inteligente de la ciudad',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('emailField'),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Ingresa un correo valido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          key: const ValueKey('passwordField'),
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contrasena',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'La contrasena debe tener al menos 6 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          key: const ValueKey('loginButton'),
                          onPressed: onLogin,
                          icon: const Icon(Icons.login),
                          label: const Text('Ingresar'),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            for (final user in _demoUsers)
                              ActionChip(
                                avatar: Icon(
                                  user.role == UserRole.admin
                                      ? Icons.admin_panel_settings
                                      : Icons.person,
                                ),
                                label: Text(user.role.label),
                                onPressed: () => onFillLogin(user),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
