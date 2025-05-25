import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/login/widgets/password_field_widget.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_bloc.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_state.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ganti Password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          PasswordFieldWidget(
            controller: _currentPasswordController,
            labelText: 'Password Saat Ini',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            cursorColor: AppColors.primary,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              label: Text(
                'Password Baru',
                style: TextStyle(fontSize: AppTextSize.bodySmall),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Harap masukkan password baru';
              }
              if (value.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              label: Text(
                'Konfirmasi Password',
                style: TextStyle(fontSize: AppTextSize.bodySmall),
              ),

              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'Password tidak sama';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12),
                  backgroundColor: AppColors.primary,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: AppColors.onPrimary,
                  overlayColor: Colors.transparent,
                ),
                onPressed:
                    state is ProfileUpdating
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileBloc>().add(
                              ChangePassword(
                                currentPassword:
                                    _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                              ),
                            );
                          }
                        },
                child:
                    state is ProfileUpdating
                        ? const CircularProgressIndicator()
                        : const Text(
                          'Simpan Password',
                          style: TextStyle(color: Colors.white),
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
