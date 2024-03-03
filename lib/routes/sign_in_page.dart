import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("signInScaffold"),
      body: Form(
        child: Column(
          children: [
            TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Email")),
                controller: emailController),
            TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Password")),
                controller: passwordController),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Submit"),
            ),
            TextButton(
              child: const Text(
                "Already have an account",
                style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 11),
              ),
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }
}
