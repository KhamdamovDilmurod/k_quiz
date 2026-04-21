import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/auth/widgets/auth_chrome.dart';

import 'auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialDisplayName;
  final String? initialPhotoUrl;
  final bool isGoogleFlow;

  const RegisterScreen({
    super.key,
    this.initialEmail,
    this.initialDisplayName,
    this.initialPhotoUrl,
    this.isGoogleFlow = false,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialDisplayName ?? '';
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.isGoogleFlow) {
      context.read<AuthBloc>().add(
        AuthGoogleSignInRequested(displayName: _nameController.text.trim()),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        _emailController.text.trim(),
        _passwordController.text,
        displayName: _nameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: extra.danger,
              ),
            );
          }

          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/books',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return AuthDecoratedBackground(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 1040 : 540,
                        ),
                        child: isWide
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 18),
                                      child: _RegisterInfoPanel(
                                        isGoogleFlow: widget.isGoogleFlow,
                                        photoUrl: widget.initialPhotoUrl,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _RegisterFormPanel(
                                      formKey: _formKey,
                                      nameController: _nameController,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      confirmPasswordController:
                                          _confirmPasswordController,
                                      isLoading: isLoading,
                                      isGoogleFlow: widget.isGoogleFlow,
                                      obscurePassword: _obscurePassword,
                                      obscureConfirmPassword:
                                          _obscureConfirmPassword,
                                      onTogglePassword: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      onToggleConfirmPassword: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                      onSubmit: _onRegisterPressed,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _RegisterTopHeader(
                                    isGoogleFlow: widget.isGoogleFlow,
                                  ),
                                  const SizedBox(height: 14),
                                  _RegisterFormPanel(
                                    formKey: _formKey,
                                    nameController: _nameController,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    confirmPasswordController:
                                        _confirmPasswordController,
                                    isLoading: isLoading,
                                    isGoogleFlow: widget.isGoogleFlow,
                                    obscurePassword: _obscurePassword,
                                    obscureConfirmPassword:
                                        _obscureConfirmPassword,
                                    onTogglePassword: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    onToggleConfirmPassword: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                    onSubmit: _onRegisterPressed,
                                  ),
                                ],
                              ),
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
}

class _RegisterTopHeader extends StatelessWidget {
  final bool isGoogleFlow;

  const _RegisterTopHeader({required this.isGoogleFlow});

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
                isGoogleFlow ? 'Profilni yakunlang' : 'Ro\'yxatdan o\'ting',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isGoogleFlow
                    ? 'Google hisob bilan davom eting'
                    : 'Yangi hisob oching',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegisterInfoPanel extends StatelessWidget {
  final bool isGoogleFlow;
  final String? photoUrl;

  const _RegisterInfoPanel({
    required this.isGoogleFlow,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthBrandHeader(
            title: isGoogleFlow ? 'Profilni yakunlang' : 'Yangi akkaunt',
            logoSize: 94,
          ),
          const SizedBox(height: 18),
          if (photoUrl != null) ...[
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(photoUrl!),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            isGoogleFlow
                ? 'Ismni tekshirib, davom eting.'
                : 'Hisob yarating va mashqlarni boshlang.',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isGoogleFlow
                ? 'Qo\'shimcha parol kiritmasdan profilni tez yakunlaysiz.'
                : 'Barcha darslar, saqlangan so\'zlar va progress akkauntingizga ulanadi.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterFormPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isGoogleFlow;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;

  const _RegisterFormPanel({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.isGoogleFlow,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
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
              isGoogleFlow ? 'Hisob ma\'lumotlari' : 'Ro\'yxatdan o\'tish',
              style: theme.textTheme.titleLarge?.copyWith(
                color: extra.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isGoogleFlow
                  ? 'Profilni tasdiqlab davom eting.'
                  : 'Yangi akkaunt uchun maydonlarni to\'ldiring.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: extra.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: nameController,
              enabled: !isLoading,
              style: TextStyle(color: extra.textPrimary),
              decoration: authInputDecoration(
                context,
                label: 'Ism',
                icon: Icons.person_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ism kiriting';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading && !isGoogleFlow,
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
            if (!isGoogleFlow) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                        if (value == null || value.isEmpty) {
                          return 'Parol kiriting';
                        }
                        if (value.length < 6) {
                          return 'Kamida 6 ta belgi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                enabled: !isLoading,
                style: TextStyle(color: extra.textPrimary),
                decoration: authInputDecoration(
                  context,
                  label: 'Parolni tasdiqlang',
                  icon: Icons.verified_user_outlined,
                  suffixIcon: IconButton(
                    onPressed: onToggleConfirmPassword,
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: extra.textSecondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Parolni tasdiqlang';
                  }
                  if (value != passwordController.text) {
                    return 'Parollar mos kelmadi';
                  }
                  return null;
                },
              ),
            ],
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
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            isGoogleFlow
                                ? 'Google bilan davom etish'
                                : 'Ro\'yxatdan o\'tish',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
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
                    'Akkountingiz bormi? ',
                    style: TextStyle(color: extra.textSecondary),
                  ),
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Kirish',
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
