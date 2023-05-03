import 'package:all4my/main.dart';
import 'package:all4my/pages/home.dart';
import 'package:all4my/pages/login_m.dart';
import 'package:all4my/pages/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'register_button.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUwu extends StatefulWidget {
  const LoginUwu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginUwu createState() => _LoginUwu();
}

class _LoginUwu extends State<LoginUwu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/logoBam.png',
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 20),

              // continuar con google
              RegisterButton(
                text: 'Continuar con Google',
                onTapCallback: () async {
                  await signInWithGoogle();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeW()),
                  );
                },
                color: const Color(0xFF4068EC),
                color_cont: const Color(0xFF4068EC),
                colorText: Colors.white,
                img_icon: Image.asset(
                  'assets/images/google.png',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(height: 20),
              // boton de registrarse con correo electronico
              RegisterButton(
                text: 'Registrarse con e-mail',
                onTapCallback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterDt() // RegisterForm()
                        ),
                  );
                },
                color: Colors.white,
                color_cont: const Color(0xFF62676D),
                colorText: const Color(0xFF62676D),
                img_icon: Image.asset(
                  'assets/images/email.png',
                  width: 20,
                  height: 20,
                ),
              ),

              const SizedBox(height: 20),

             
              // texto de ya tienes cuenta?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    '¿Ya tienes cuenta?',
                    style: TextStyle(
                      color: Color(0xFF4E4E4E),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginM()),
                      );
                    },
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Color.fromRGBO(151, 23, 56, 1),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

// eliminar el usuario de la base de datos
Future<void> deleteUser() async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    if (user.providerData.isEmpty) {
      await user.delete();
    } else {
      user.delete();
    }
  }
}

// registrar usuario con correo y contraseña
Future<void> registerUser() async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}
