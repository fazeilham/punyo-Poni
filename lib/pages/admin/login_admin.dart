import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'dashboard_admin.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan password wajib diisi"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.postData("loginAdmin", {
        "username": usernameController.text.trim(),
        "password": passwordController.text.trim(),
      });

      setState(() => isLoading = false);

      if (result['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardAdmin(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(result['message'] ?? "Login gagal"),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Login Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFE1F5FE),
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
            ],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Card(
              elevation: 12,
              shadowColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF90CAF9),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 65,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Silakan login sebagai admin",
                      style: TextStyle(
                        color: Color(0xFF607D8B),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: usernameController,
                      label: "Username",
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1976D2),
                              ),
                            )
                          : CustomButton(
                              text: "Login",
                              onPressed: login,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}