import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../settings/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnadirPadrePage extends StatefulWidget {
  @override
  _AnadirPadrePageState createState() => _AnadirPadrePageState();
}

class _AnadirPadrePageState extends State<AnadirPadrePage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  List<String> _ninosSeleccionados = [];
  List<Nino> _ninos = []; // Asegúrate de obtener esta lista de Firestore

  // Método para cargar la lista de niños desde Firestore
  Future<void> _cargarNinosDesdeFirestore() async {
    // Puedes personalizar esta lógica según tu estructura de Firestore
    QuerySnapshot ninosSnapshot =
        await FirebaseFirestore.instance.collection('niños').get();

    setState(() {
      _ninos = ninosSnapshot.docs.map((doc) {
        return Nino(id: doc.id, nombre: doc['nombre']);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Llama a la carga de niños al inicializar el widget
    _cargarNinosDesdeFirestore();
  }

  void _registrarPadre() {
    Crear creador = Crear();

    creador.registerPadre(
      _correoController.text,
      _contrasenaController.text,
      _nombreController.text,
      _ninosSeleccionados,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Padre registrado exitosamente.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Padre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Padre'),
            ),
            TextFormField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo del Padre'),
            ),
            TextFormField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña del Padre'),
            ),
            SizedBox(height: 20),
            MultiSelectDialogField(
              items: _ninos
                  .map((nino) => MultiSelectItem<Nino>(nino, nino.nombre))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                setState(() {
                  _ninosSeleccionados =
                      values.whereType<Nino>().map((nino) => nino.id).toList();
                });
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                  setState(() {
                    _ninosSeleccionados.remove(value);
                  });
                },
              ),
              buttonText: Text('Seleccionar Niños'),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _registrarPadre();
              },
              child: const Text('Registrar Padre'),
            ),
          ],
        ),
      ),
    );
  }
}

class Nino {
  final String id;
  final String nombre;

  Nino({required this.id, required this.nombre});
}
