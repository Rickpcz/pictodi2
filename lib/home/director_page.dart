import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictodi2/login.dart';
import 'añadir/ananir_maestro.dart';
import 'añadir/ananir_psicologo.dart';
import 'añadir/ananir_nino.dart';
import 'añadir/ananir_padre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DirectorPage extends StatelessWidget {
  const DirectorPage({Key? key}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _showAccountMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await _signOut(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Director Page'),
      ),
      body: const Center(
        child: Text('Bienvenido, Director'),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Inicio'),
          TabItem(icon: Icons.add_reaction_rounded, title: 'Añadir'),
          TabItem(icon: Icons.auto_fix_normal_sharp, title: 'Editar'),
          TabItem(icon: Icons.exit_to_app, title: 'Salir'),
        ],
        onTap: (index) {
          if (index == 1) {
            _showAddOptions(context);
          } else if (index == 2) {
            _showEditOptions(context);
          } else if (index == 3) {
            _showAccountMenu(context);
          }
        },
      ),
    );
  }

  Future<void> _showAddOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              _buildAddCategoryTile(context, 'profesores'),
              _buildAddCategoryTile(context, 'directores'),
              _buildAddCategoryTile(context, 'niños'),
              _buildAddCategoryTile(context, 'padres'),
              _buildAddCategoryTile(context, 'psicologos'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryTile(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _navigateToAddCategory(context, category);
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCategoryIcon(category),
            SizedBox(height: 10),
            Text('Añadir $category', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _navigateToAddCategory(BuildContext context, String category) {
    if (category == 'profesores') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirMaestroPage(),
        ),
      );
    } else if (category == 'directores') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirPadrePage(),
        ),
      );
    } else if (category == 'niños') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirNinoPage(),
        ),
      );
    } else if (category == 'padres') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirPadrePage(),
        ),
      );
    } else if (category == 'psicologos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnadirPsicologoPage(),
        ),
      );
    }
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'profesores':
        return const Icon(Icons.school, size: 40, color: Colors.white);
      case 'directores':
        return const Icon(Icons.people, size: 40, color: Colors.white);
      case 'niños':
        return const Icon(Icons.person, size: 40, color: Colors.white);
      case 'padres':
        return const Icon(Icons.people, size: 40, color: Colors.white);
      case 'psicologos':
        return const Icon(Icons.psychology, size: 40, color: Colors.white);
      default:
        return const Icon(Icons.category, size: 40, color: Colors.white);
    }
  }

  Future<void> _showEditOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              _buildEditCategoryTile(context, 'profesores'),
              _buildEditCategoryTile(context, 'directores'),
              _buildEditCategoryTile(context, 'niños'),
              _buildEditCategoryTile(context, 'padres'),
              _buildEditCategoryTile(context, 'psicologos'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditCategoryTile(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _navigateToEditCategory(context, category);
      },
      child: ListTile(
        title: Text('Editar $category'),
        leading: _getCategoryIcon(category),
      ),
    );
  }

  void _navigateToEditCategory(BuildContext context, String category) {
    // Navega a la página ListaRegistrosPage con la categoría seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaRegistrosPage(category: category),
      ),
    );
  }
}

class ListaRegistrosPage extends StatelessWidget {
  final String category;

  ListaRegistrosPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de $category'),
      ),
      body: FutureBuilder(
        future: _getRegistros(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> registros =
                snapshot.data as List<DocumentSnapshot>;
            return ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(registros[index]['nombre']
                      .toString()), // Cambiar por el campo apropiado
                  // Agregar más detalles según sea necesario
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getRegistros(String category) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(category).get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Error al obtener registros: $e');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: DirectorPage(),
  ));
}
