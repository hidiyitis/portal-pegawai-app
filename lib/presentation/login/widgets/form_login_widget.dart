import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_bloc.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_state.dart';
import 'package:portal_pegawai_app/presentation/login/widgets/nip_field_widget.dart';
import 'package:portal_pegawai_app/presentation/login/widgets/password_field_widget.dart';

class FormLoginWidget extends StatefulWidget {
  const FormLoginWidget({super.key});

  @override
  State<FormLoginWidget> createState() => _FormLoginWidgetState();
}

class _FormLoginWidgetState extends State<FormLoginWidget> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final nip = _nipController.text.trim();
    if (nip.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('masukkan NIP')));
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(
        nip: _nipController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          NipFieldWidget(controller: _nipController, labelText: 'NIP'),
          PasswordFieldWidget(
            controller: _passwordController,
            labelText: 'Minimal 8 karakter',
          ),
          BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state is AuthLoading ? null : () => _submitForm(context),
                  child:
                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              );
            },
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is AuthSuccess) {
                Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
              }
            },
          ),
        ],
      ),
    );
  }
}
