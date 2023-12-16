import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Student {
  String name;
  Map<String, double> grades;

  Student({required this.name, required this.grades});
}

class Teacher {
  String name;
  String subject;

  Teacher({required this.name, required this.subject});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Sistema de Calificación'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final Map<String, double> _grades = {
    'AGENTES INTELIGENTES': 0.0,
    'COMPUTO EN LA NUBE': 0.0,
    'ARQUITECTURA DE SERVIDORES': 0.0,
    'INGLES': 0.0,
    'Mineria de Datos': 0.0,
    'SISTEMAS REACTIVOS': 0.0,
    'ANALISIS Y VISUALIZACION DE DATOS': 0.0,
  };

  List<Student> _students = [];
  Teacher? _teacher;

  int _totalGradesCount = 0;
  double _totalGradesSum = 0.0;

  void _addStudent(BuildContext context) {
    final String name = _nameController.text;
    final Map<String, double> grades = Map.from(_grades);

    setState(() {
      _students.add(Student(name: name, grades: grades));
      _totalGradesCount += grades.length;
      _totalGradesSum += grades.values.reduce((a, b) => a + b);
    });

    _nameController.clear();
    _grades.forEach((key, _) => _grades[key] = 0.0);
  }

  void _addTeacher(BuildContext context) {
    final String name = _nameController.text;
    final String subject = _subjectController.text;

    setState(() {
      _teacher = Teacher(name: name, subject: subject);
    });

    _nameController.clear();
    _subjectController.clear();
  }

  void _editStudent(BuildContext context, int index) {
    final TextEditingController _editNameController =
        TextEditingController(text: _students[index].name);
    final Map<String, double> _editGrades = Map.from(_students[index].grades);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar estudiante'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nombre del alumno:'),
              TextField(
                controller: _editNameController,
              ),
              SizedBox(height: 16.0),
              Text('Calificaciones:'),
              Column(
                children: _editGrades.entries.map((entry) {
                  final String subject = entry.key;
                  final double grade = entry.value;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            subject,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            initialValue: grade.toString(),
                            onChanged: (value) {
                              setState(() {
                                _editGrades[subject] =
                                    double.tryParse(value) ?? 0.0;
                              });
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _students[index].name = _editNameController.text;
                  _students[index].grades = _editGrades;
                });

                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
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
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            if (_teacher == null) ...[
              Text('Registro de Maestro', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del maestro'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Asignatura'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _addTeacher(context);
                },
                child: Text('Agregar maestro'),
              ),
            ],
            SizedBox(height: 32.0),
            Text('Registro de Alumnos', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre del alumno'),
            ),
            SizedBox(height: 16.0),
            Text('Calificaciones:', style: TextStyle(fontSize: 16.0)),
            Column(
              children: _grades.entries.map((entry) {
                final String subject = entry.key;
                final double grade = entry.value;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          subject,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          initialValue: grade.toString(),
                          onChanged: (value) {
                            setState(() {
                              _grades[subject] = double.tryParse(value) ?? 0.0;
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addStudent(context);
              },
              child: Text('Agregar alumno'),
            ),
            SizedBox(height: 32.0),
            if (_students.isNotEmpty) ...[
              Text('Lista de Alumnos', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              DataTable(
                columns: [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Calificación')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _students
                    .asMap()
                    .entries
                    .map(
                      (entry) => DataRow(
                        cells: [
                          DataCell(Text(entry.value.name)),
                          DataCell(Text(
                            entry.value.grades.values
                                .reduce((a, b) => a + b)
                                .toStringAsFixed(2),
                          )),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editStudent(context, entry.key);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                  'Calificación Total: ${(_totalGradesSum / _totalGradesCount).toStringAsFixed(2)}'),
              Text(
                  'Estado: ${(_totalGradesSum / _totalGradesCount) >= 6.0 ? "Aprobado" : "Reprobado"}'),
            ],
          ],
        ),
      ),
    );
  }
}
