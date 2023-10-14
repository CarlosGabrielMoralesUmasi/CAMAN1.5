import 'package:flutter/material.dart';

class ListItem {
  final String id;
  final Widget content;

  ListItem(this.id, this.content);
}

class Prueba extends StatefulWidget {
  @override
  _PruebaState createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {

  List<ListItem> todosLosElementos = [
    ListItem(
      'Jardineria',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria1.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Jarinería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    ListItem(
      'Cocina',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Cocina",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    
    ListItem(
      'Gasfiteria',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Gasfitería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    ListItem(
      'Limpieza',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria4.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Limpieza",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
  ];

  String textoBusqueda = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filtrar elementos'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  textoBusqueda = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todosLosElementos.length,
                itemBuilder: (BuildContext context, int index) {
                  final elemento = todosLosElementos[index];

                  if (textoBusqueda.isEmpty) {
                    return todosLosElementos[index].content;
                  }

                  if (elemento.id.toLowerCase().contains(textoBusqueda.toLowerCase())) {
                    return todosLosElementos[index].content;
                  }
                  

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
