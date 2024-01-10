import 'package:flutter/material.dart';
import '../settings/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnadirNinoPage extends StatefulWidget {
  @override
  _AnadirNinoPageState createState() => _AnadirNinoPageState();
}

class _AnadirNinoPageState extends State<AnadirNinoPage> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _gradoController   = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();

  // Método para manejar el registro del niño
  void _registrarNino() {
    Crear creador = Crear();

    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';

    creador.registerNino(
      _correoController.text,
      _contrasenaController.text,
      _nombreController.text,
      _diagnosticoController.text,
      _fechaNacimientoController.text,
      int.parse(_gradoController.text),
      _grupoController.text,
      userId,
    );

    // Muestra un SnackBar indicando que el registro fue exitoso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro exitoso'),
      ),
    );

    // Puedes agregar más lógica aquí, como navegar a otra página.
  }

  bool _camposNoVacios() {
    return _correoController.text.isNotEmpty &&
        _contrasenaController.text.isNotEmpty &&
        _nombreController.text.isNotEmpty &&
        _diagnosticoController.text.isNotEmpty &&
        _fechaNacimientoController.text.isNotEmpty &&
        _gradoController.text.isNotEmpty &&
        _grupoController.text.isNotEmpty;
  }

  bool _validarCampos() {
    // Validar el formato de fecha
    RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(_fechaNacimientoController.text)) {
      _mostrarMensajeError('Formato de fecha no válido. Utiliza DD/MM/YYYY.');
      return false;
    }

    // Validar el límite de caracteres en grupo y grado
    if (_grupoController.text.length != 1) {
      _mostrarMensajeError(
          'El campo "Grupo" debe contener exactamente 1 letra.');
      return false;
    }

    if (_gradoController.text.isEmpty ||
        int.tryParse(_gradoController.text) == null) {
      _mostrarMensajeError('El campo "Grado" debe contener un número.');
      return false;
    }

    return true;
  }

  void _mostrarMensajeError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de Validación'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Niño'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Añade tus widgets para la entrada de datos, por ejemplo, TextFormField, etc.
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextFormField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del niño'),
              ),
              TextFormField(
                controller: _diagnosticoController,
                decoration: const InputDecoration(labelText: 'Diagnóstico'),
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento (DD/MM/YYYY)'),
              ),
              TextFormField(
                controller: _gradoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Grado'),
              ),
              TextFormField(
                controller: _grupoController,
                maxLength: 1,
                decoration: const InputDecoration(labelText: 'Grupo'),
              ),
              ElevatedButton(
                onPressed: () {
                  _registrarNino();
                },
                child: const Text('Registrar Niño'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
