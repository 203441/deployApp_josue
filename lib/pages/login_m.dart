import 'package:all4my/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool _showPassword = false;

class _PasswordVisibilityButton extends StatefulWidget {
  final bool showPassword;
  final Function(bool) onPressed;

  const _PasswordVisibilityButton({required this.showPassword, required this.onPressed});

  @override
  _PasswordVisibilityButtonState createState() => _PasswordVisibilityButtonState();
}

class _PasswordVisibilityButtonState extends State<_PasswordVisibilityButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.showPassword ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        widget.onPressed(!widget.showPassword);
      },
    );
  }
}


class LoginM extends StatefulWidget {
  const LoginM({Key? key}) : super(key: key);

  @override
  _LoginM createState() => _LoginM();
}

class _LoginM extends State<LoginM> {
  // guardar usuario y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
          leading: IconButton(
            color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 300, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                  ),
                ),
                const SizedBox(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 220,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      enabledBorder: OutlineInputBorder(
                        borderSide:const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword, // Añade la propiedad obscureText al TextField
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.password, color: Colors.grey),
                    suffixIcon: _PasswordVisibilityButton(
                      showPassword: _showPassword,
                      onPressed: (value) {
                        setState(() {
                          _showPassword = value;
                        });
                      },
                    ),
                    // Aquí puedes seguir agregando más propiedades de estilo
                  ),
                ),
              ),
                ElevatedButton(
                    onPressed: () async {
                      await signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                      // ignore: use_build_context_synchronously
                      // si el usuario no es nulo mostrar un mensaje de error
                      if (FirebaseAuth.instance.currentUser == null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario o contraseña incorrectos'),
                          ),
                        );
                      }
                      if (FirebaseAuth.instance.currentUser != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeW()),
                        );
                      }
                    },
                    // ignore: sort_child_properties_last
                    child: const Text('Inicio de sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 195, 0, 2),
                        onPrimary: const Color.fromRGBO(144, 12, 63, 2),
  ),
                    ),
                    
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}

// iniciar sesion con correo y contraseña
Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
