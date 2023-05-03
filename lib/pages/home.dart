import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:all4my/notificaciones.dart';

class HomeW extends StatefulWidget {
  const HomeW({super.key});

  @override
  _HomeW createState() => _HomeW();
}

class _HomeW extends State<HomeW> {
  late FirebaseAuth _auth;
  late CollectionReference _noteCollection;

  // guardar titulo y contenido de las notas
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    _noteCollection = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user?.uid)
        .collection('notas');
  }

  Future<void> agregarNota({
    required String title,
    required String description,
  }) async {
    final usuario = _auth.currentUser;
    final nota = {
      'titulo': title,
      'contenido': description,
    };
    await _noteCollection.add(nota);
    await showNotifications();
  }

  // eliminar nota
  Future<void> eliminarNota({
    required String id,
  }) async {
    final user = _auth.currentUser;
    await _noteCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar con un titulo y un boton para cerrar sesion
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(144, 12, 63, 1),
          title: const Text('Notas'),
          // boton para cerrar sesion con un texto y un icono
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await signOutGoogle();
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginUwu()),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(144, 12, 63, 1),
          onPressed: () {
            // mostrar un dialogo para agregar una nota
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Agregar nota'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: 'Titulo'),
                      ),
                      TextField(
                        controller: _contentController,
                        decoration:
                            const InputDecoration(hintText: 'Contenido'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await agregarNota(
                          title: _titleController.text,
                          description: _contentController.text,
                        );
                        _clearTextFields();
                        Navigator.pop(context);
                      },
                      child: const Text('Agregar'),
                    ),
                    // icono de agregar nota
                  ],
                );
              },
            );
          },
        ),
        // crear un boton para cerrar sesion de google y borrar el usuario de la base de datos
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // mostrar las notas de la base de datos del usuario actual
            StreamBuilder<QuerySnapshot>(
              stream: _noteCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo salio mal',
                      style: TextStyle(fontSize: 20, color: Colors.blue));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando',
                      style: TextStyle(fontSize: 20, color: Colors.blue));
                }

                if (snapshot.data?.docs.length == 0) {
                  return const Text('No hay tareas agregadas',
                      style: TextStyle(fontSize: 20, color: Colors.blue));
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final note = snapshot.data?.docs[index];
                      return Card(
                        child: ListTile(
                          title: Text(note?.get('titulo')),
                          subtitle: Text(note?.get('contenido')),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await eliminarNota(id: note?.id ?? '');
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        )));
  }

  // limpiar campos de texto
  void _clearTextFields() {
    _titleController.clear();
    _contentController.clear();
  }
}

Future<void> signOutGoogle() async {
  await GoogleSignIn().signOut();
  print('User Sign Out');
}
