import 'package:all4my/pages/login_m.dart';
import 'package:flutter/material.dart';
import 'package:all4my/pages/login.dart';
import 'package:all4my/pages/button_next.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterDt extends StatefulWidget{ 
  @override
  State<RegisterDt> createState() => _RegisterDtState();
}

class _RegisterDtState extends State<RegisterDt> {
  // const RegisterDt({super.key});
  var _obscureText;
  @override
  void initState(){
    super.initState();
    _obscureText= true;
  }
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(144, 12, 63, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/images/google.png',
                width: 20,
                height: 20,
              ),
              color: Color.fromRGBO(216, 58, 111, 1),
              onPressed: () {},
            ),
          ],
          title: const Text(
            'Registrarse',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Text(
                  'Rellene los siguentes datos para crear la cuenta',
                  style: TextStyle(
                    color: Color(0xFF767676),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Nombre completo',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 186, 179, 179),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  'Correo electrónico',
                  style: TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 186, 179, 179),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // seccion para contraseña
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  'Contraseña',
                  style: TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    decoration:  InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 186, 179, 179),
                        fontSize: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: _obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), 
                        onPressed: () { 
                          setState(() {
                            _obscureText =!_obscureText;
                          }); 
                        },
                        ),
                    ),
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 0),
                child: NextButton(
                  text: 'Crear cuenta',
                  onTapCallback: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    await registerUser(email, password);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginM()),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          MaterialPageRoute(
                              builder: (context) => const LoginUwu()),
                        );
                      },
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Color.fromRGBO(199, 0, 57, 1),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// registrar usuario con firebase

Future<void> registerUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print('Usuario registrado');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('La contraseña es muy debil');
    } else if (e.code == 'email-already-in-use') {
      print('El correo ya esta en uso');
    }
  } catch (e) {
    print(e);
  }
}