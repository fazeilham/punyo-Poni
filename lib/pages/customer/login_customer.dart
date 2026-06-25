import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/customer_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'dashboard_customer.dart';
import 'register_customer.dart';

class LoginCustomer extends StatefulWidget {
  const LoginCustomer({super.key});

  @override
  State<LoginCustomer> createState() => _LoginCustomerState();
}

class _LoginCustomerState extends State<LoginCustomer> {
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
      final data = await ApiService.getData("getCustomer");

      final customers =
          data.map((e) => CustomerModel.fromJson(e)).toList();

      final found = customers.where(
        (c) =>
            c.username.trim().toLowerCase() ==
                usernameController.text.trim().toLowerCase() &&
            c.password == passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (found.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DashboardCustomer(customer: found.first),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username atau password salah"),
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
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Login Customer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
              Color(0xFF90CAF9),
            ],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Card(
              elevation: 12,
              shadowColor: Colors.black12,

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
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.lightBlue,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Silakan login untuk mulai berbelanja",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
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
                              child:
                                  CircularProgressIndicator(),
                            )
                          : CustomButton(
                              text: "Login",
                              onPressed: login,
                            ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const RegisterCustomer(),
                          ),
                        );
                      },
                      child: const Text(
                        "Belum punya akun? Daftar",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
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