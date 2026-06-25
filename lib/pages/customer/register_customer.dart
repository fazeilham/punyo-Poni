import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterCustomer extends StatefulWidget {
  const RegisterCustomer({super.key});

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}

class _RegisterCustomerState extends State<RegisterCustomer> {
  final usernameController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final teleponController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void register() async {
    if (usernameController.text.isEmpty ||
        namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Username, nama, email, dan password wajib diisi",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.postData(
        "insertCustomer",
        {
          "username": usernameController.text.trim(),
          "nama_customer": namaController.text.trim(),
          "email": emailController.text.trim(),
          "telepon": teleponController.text.trim(),
          "alamat": alamatController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      setState(() => isLoading = false);

      if (result['status'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Registrasi berhasil, silakan login",
              ),
            ),
          );

          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? "Registrasi gagal",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Akun"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            CustomTextField(
              controller: usernameController,
              label: "Username",
            ),

            CustomTextField(
              controller: namaController,
              label: "Nama Lengkap",
            ),

            CustomTextField(
              controller: emailController,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
            ),

            CustomTextField(
              controller: teleponController,
              label: "No. Telepon",
              keyboardType: TextInputType.phone,
            ),

            CustomTextField(
              controller: alamatController,
              label: "Alamat",
            ),

            CustomTextField(
              controller: passwordController,
              label: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 16),

            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomButton(
                    text: "Daftar",
                    onPressed: register,
                  ),
          ],
        ),
      ),
    );
  }
}