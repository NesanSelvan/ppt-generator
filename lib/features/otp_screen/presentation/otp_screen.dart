import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ppt_generator/core/constants/app_routes.dart';
import 'package:ppt_generator/features/otp_screen/presentation/bloc/otp_bloc.dart';
import 'package:ppt_generator/features/otp_screen/presentation/bloc/otp_event.dart';
import 'package:ppt_generator/features/otp_screen/presentation/bloc/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc(),
      child: Scaffold(
        body: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home_screen,
                (route) => false,
              );
            } else if (state is OtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter the OTP sent to ${widget.email}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    _buildOtpField(),
                    const SizedBox(height: 24),
                    _buildVerifyButton(state, context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtpField() {
    return TextFormField(
      controller: _otpController,
      focusNode: _otpFocusNode,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'OTP',
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: 'Enter OTP',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        prefixIcon: const Icon(Icons.lock_clock, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      onTapOutside: (value) {
        _otpFocusNode.unfocus();
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the OTP';
        }
        if (value.length < 6) {
          return 'OTP must be at least 6 digits';
        }
        return null;
      },
    );
  }

  Widget _buildVerifyButton(OtpState state, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<OtpBloc>().add(
            OtpSubmitted(
              email: widget.email,
              token: _otpController.text.trim(),
            ),
          );
        }
      },
      child: state is OtpLoading
          ? LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 30,
            )
          : const Text('Verify'),
    );
  }
}
