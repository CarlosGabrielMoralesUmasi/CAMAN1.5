import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/providers/address_provider.dart';
import 'package:empresas_cliente/screens/maps.dart';
import 'package:empresas_cliente/screens/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class WorkerWidget extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  const WorkerWidget({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegación a la página del perfil del trabajador
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(id: id)),
        );
      },
      child: Container(
        height: 250,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(photoUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Fútbol", // Agrega el nombre de la empresa aquí
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            /* Text(
              "100\$",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> currentLocation;
  late TextEditingController _searchController;
  String _searchText = ''; // Estado para almacenar el texto de búsqueda

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  Future<Map<dynamic, dynamic>> getRecommendedFireStore() async {
    Map<dynamic, dynamic> recommended = {};

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('workers').get();

    for (var doc in querySnapshot.docs) {
      String id = doc.id;
      String name = doc['name'];
      String email = doc['email'];
      String photo = doc['photoUrl'];

      Map<String, dynamic> data = {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photo,
      };

      recommended[id] = data;
    }

    return recommended;
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Row(children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Text(
                        context
                                .watch<AddressProvider>()
                                .addressData['address'] ??
                            'Cargando...',
                        style: TextStyle(
                          fontSize: textScale * 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const MapScreen(),
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                        withNavBar: false,
                      );
                    },
                    icon: Icon(
                      Icons.location_on,
                      size: textScale * 30.0,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 13.0, top: 16.0, right: 13.0),
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(21.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.search,
                        size: textScale * 26.0,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged:
                              _onSearchTextChanged, // Llama a la función al cambiar el texto
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Busca tu cancha...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Text(
                'CANCHAS AREQUIPA',
                style: TextStyle(
                  fontSize: textScale * 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              thickness: 2.0,
              indent: 16.0,
              endIndent: 16.0,
            ),
            FutureBuilder(
              future: getRecommendedFireStore(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final filteredWorkers = snapshot.data!.values
                      .where((worker) => worker['name']
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredWorkers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final workerData = filteredWorkers[index];
                        return WorkerWidget(
                          id: workerData['id'],
                          name: workerData['name'],
                          email: workerData['email'],
                          photoUrl: workerData['photoUrl'],
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }
}
