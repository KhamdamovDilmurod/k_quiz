import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/pages/auth/registr_screen.dart';
import 'package:k_quiz/presentations/pages/auth/widgets/auth_chrome.dart';
import 'package:k_quiz/services/firebase_auth_service.dart';

import 'auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isGoogleLoading = false;

  Future<void> _continueWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final profile = await getIt<FirebaseAuthService>().pickGoogleProfile();
      if (!mounted || profile == null) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RegisterScreen(
            initialEmail: profile.email,
            initialDisplayName: profile.displayName,
            initialPhotoUrl: profile.photoUrl,
            isGoogleFlow: true,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(context, e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showSnackBar(context, state.message, isError: true);
          }

          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/books', (route) => false);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading || _isGoogleLoading;

          return AuthDecoratedBackground(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 1040 : 520,
                      ),
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: _LoginInfoPanel(compact: false),
                                  ),
                                ),
                                Expanded(
                                  child: _LoginFormPanel(
                                    formKey: _formKey,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    obscurePassword: _obscurePassword,
                                    isLoading: isLoading,
                                    isGoogleLoading: _isGoogleLoading,
                                    onTogglePassword: () {
                                      setState(() => _obscurePassword = !_obscurePassword);
                                    },
                                    onSubmit: _submit,
                                    onGoogle: _continueWithGoogle,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const _CompactBrandHeader(
                                  title: 'Korean Quiz',
                                ),
                                const SizedBox(height: 14),
                                _LoginFormPanel(
                                  formKey: _formKey,
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                  obscurePassword: _obscurePassword,
                                  isLoading: isLoading,
                                  isGoogleLoading: _isGoogleLoading,
                                  onTogglePassword: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                  onSubmit: _submit,
                                  onGoogle: _continueWithGoogle,
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignInRequested(
              _emailController.text.trim(),
              _passwordController.text,
            ),
          );
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    final extra = context.appColors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? extra.danger : extra.success,
      ),
    );
  }
}

class _LoginInfoPanel extends StatelessWidget {
  final bool compact;

  const _LoginInfoPanel({required this.compact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: compact ? 0.10 : 0.12),
        borderRadius: BorderRadius.circular(compact ? 24 : 32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            const AuthBrandHeader(
              title: 'Korean Quiz',
              logoSize: 96,
            ),
          ],
        ],
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final bool isGoogleLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onGoogle;

  const _LoginFormPanel({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.isGoogleLoading,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onGoogle,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final theme = Theme.of(context);

    return AuthSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hisobingizga kiring',
              style: theme.textTheme.titleLarge?.copyWith(
                color: extra.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Darslaringizni davom ettirish uchun kirish qiling.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: extra.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
              style: TextStyle(color: extra.textPrimary),
              decoration: authInputDecoration(
                context,
                label: 'Email',
                icon: Icons.alternate_email_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email kiriting';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              enabled: !isLoading,
              style: TextStyle(color: extra.textPrimary),
              decoration: authInputDecoration(
                context,
                label: 'Parol',
                icon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: extra.textSecondary,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Parol kiriting';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [extra.gradientStart, extra.gradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Kirish',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : onGoogle,
                icon: isGoogleLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: extra.textPrimary,
                        ),
                      )
                    : Icon(
                        Icons.g_mobiledata_rounded,
                        size: 30,
                        color: extra.textPrimary,
                      ),
                label: Text(
                  'Google bilan davom etish',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: extra.textPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: extra.cardBorder),
                  backgroundColor: extra.mutedSurface.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Akkountingiz yo\'qmi? ',
                    style: TextStyle(color: extra.textSecondary),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'Ro\'yxatdan o\'tish',
                      style: TextStyle(
                        color: extra.gradientStart,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class _CompactBrandHeader extends StatelessWidget {
  final String title;

  const _CompactBrandHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ), const SizedBox(height: 2),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
