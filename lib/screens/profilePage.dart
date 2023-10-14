import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/screens/serviceForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

void serviceForm(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar servicio'),
        content: ServiceForm(
          workerId: id,
        ),
      );
    },
  );
}

class ProfilePage extends StatefulWidget {
  final String id;

  const ProfilePage({required this.id, Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>> getProfileData() async {
    final databaseReference =
        FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<String, dynamic> profileData = data.data() as Map<String, dynamic>;
    String workerName = profileData['name'] ?? '';
    String workerEmail = profileData['email'] ?? '';
    String description = profileData['description'] ?? '';

    return {
      'name': workerName,
      'email': workerEmail,
      'description': description,
    };
  }

  Future<String> getWorkerAddress() async {
    final databaseReference =
        FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<String, dynamic> profileData = data.data() as Map<String, dynamic>;
    String workerAddress = profileData['direccion'] ?? '';

    return workerAddress;
  }

  Future<String> getWorkerPrice(String priceType) async {
    final databaseReference =
        FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<String, dynamic> profileData = data.data() as Map<String, dynamic>;
    String price = profileData[priceType] ?? '';

    return price;
  }

  Future<String> getWorkerPhoneNumber() async {
    final databaseReference =
        FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<String, dynamic> profileData = data.data() as Map<String, dynamic>;
    String phoneNumber = profileData['numero'] ?? '';

    return phoneNumber;
  }

  Future<List<String>> getPhotos() async {
    final databaseReference =
        FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<String, dynamic> profileData = data.data() as Map<String, dynamic>;

    List<String> photoUrls = [];
    for (int i = 1; i <= 4; i++) {
      String photoUrl = profileData['foto$i'];
      if (photoUrl != null && photoUrl.isNotEmpty) {
        // Descargar la imagen y convertirla a base64
        String base64Image = await _getImageBase64(photoUrl);
        photoUrls.add(base64Image);
      }
    }

    return photoUrls;
  }

  Future<String> _getImageBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        return base64Encode(bytes);
      } else {
        throw 'Failed to load image: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error fetching image: $error';
    }
  }

  void launchMap() async {
    String workerAddress = await getWorkerAddress();

    if (workerAddress.isNotEmpty) {
      if (await canLaunch(workerAddress)) {
        await launch(workerAddress);
      } else {
        throw 'No se pudo abrir la dirección en Google Maps';
      }
    } else {
      throw 'La dirección está vacía en Firestore';
    }
  }

  void launchWhatsAppUri() async {
    String phoneNumber = await getWorkerPhoneNumber();

    if (phoneNumber.isNotEmpty) {
      final link = WhatsAppUnilink(
        phoneNumber: phoneNumber,
        text: "Hola! Vengo de CAMAN APP y quisiera separar cancha el día...",
      );

      final uriString = link.asUri().toString();

      await launch(uriString);
    } else {
      throw 'El número de teléfono está vacío en Firestore';
    }
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/imagen1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: getProfileData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    String workerName = snapshot.data!['name'] ?? '';
                    String workerEmail = snapshot.data!['email'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workerName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  workerEmail,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                launchWhatsAppUri();
                              },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Colors.blue, // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Bordes redondos
                                ),
                              ),
                              child: Text(
                                'SEPARA',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DescriptionWidget(
                          description: snapshot.data!['description'],
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<String>(
                          future: getWorkerPrice('preciodia'),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> priceDaySnapshot) {
                            if (priceDaySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (priceDaySnapshot.hasError) {
                              return Text("Error: ${priceDaySnapshot.error}");
                            } else {
                              return FutureBuilder<String>(
                                future: getWorkerPrice('precionoche'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> priceNightSnapshot) {
                                  if (priceNightSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (priceNightSnapshot.hasError) {
                                    return Text(
                                        "Error: ${priceNightSnapshot.error}");
                                  } else {
                                    String priceDay = priceDaySnapshot.data!;
                                    String priceNight =
                                        priceNightSnapshot.data!;

                                    return FeaturesWidget(
                                      priceDay: priceDay,
                                      priceNight: priceNight,
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            // Íconos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconCard(icon: Icons.restaurant, text: 'Parrilladas'),
                IconCard(icon: Icons.sports_soccer, text: 'Pelota'),
                IconCard(icon: Icons.bathtub, text: 'Duchas'),
                IconCard(icon: Icons.people, text: 'Vestidor'),
              ],
            ),
            // Carrusel de imágenes
            FutureBuilder<List<String>>(
              future: getPhotos(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay fotos disponibles'));
                } else {
                  return SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Decodificar la imagen base64 y mostrarla
                        return Image.memory(
                          base64Decode(snapshot.data![index]),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                }
              },
            ),
            // Botón de Google Maps
            Positioned(
              bottom: 30.0, // Ajusta este valor para posicionar verticalmente
              left: 20.0, // Ajusta este valor para posicionar horizontalmente
              child: InkWell(
                onTap: () {
                  launchMap();
                },
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/google_maps.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      /* floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              // Lógica para agregar un servicio
            },
            child: Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              // Lógica para abrir un chat
            },
            child: Icon(Icons.chat),
          ),
        ],
      ),*/
    );
  }
}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/imagen1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: getProfileData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        String workerName = snapshot.data!['name'] ?? '';
                        String workerEmail = snapshot.data!['email'] ?? '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workerName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      workerEmail,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    launchWhatsAppUri();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Colors.blue, // Color de fondo del botón
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Bordes redondos
                                    ),
                                  ),
                                  child: Text(
                                    'SEPARA',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DescriptionWidget(
                              description: snapshot.data!['description'],
                            ),
                            const SizedBox(height: 16),
                            FutureBuilder<String>(
                              future: getWorkerPrice('preciodia'),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> priceDaySnapshot) {
                                if (priceDaySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (priceDaySnapshot.hasError) {
                                  return Text(
                                      "Error: ${priceDaySnapshot.error}");
                                } else {
                                  return FutureBuilder<String>(
                                    future: getWorkerPrice('precionoche'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String>
                                            priceNightSnapshot) {
                                      if (priceNightSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (priceNightSnapshot.hasError) {
                                        return Text(
                                            "Error: ${priceNightSnapshot.error}");
                                      } else {
                                        String priceDay =
                                            priceDaySnapshot.data!;
                                        String priceNight =
                                            priceNightSnapshot.data!;

                                        return FeaturesWidget(
                                          priceDay: priceDay,
                                          priceNight: priceNight,
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                // Íconos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconCard(icon: Icons.restaurant, text: 'Parrilladas'),
                    IconCard(icon: Icons.sports_soccer, text: 'Pelota'),
                    IconCard(icon: Icons.bathtub, text: 'Duchas'),
                    IconCard(icon: Icons.people, text: 'Vestidor'),
                  ],
                ),
                // Carrusel de imágenes
                FutureBuilder<List<String>>(
                  future: getPhotos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No hay fotos disponibles'));
                    } else {
                      return SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // Decodificar la imagen base64 y mostrarla
                            return Image.memory(
                              base64Decode(snapshot.data![index]),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            child: InkWell(
              onTap: () {
                launchMap();
              },
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/google_maps.png',
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void launchWhatsApp(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class IconCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 48,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class DescriptionWidget extends StatefulWidget {
  final String description;

  const DescriptionWidget({required this.description});

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿QUIENES SOMOS?...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTapDown: (details) {
            toggleExpanded();
          },
          onTapUp: (details) {
            toggleExpanded();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.grey[700] : Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding: const EdgeInsets.all(16.0),
            child: AnimatedCrossFade(
              firstChild: Text(
                widget.description.substring(
                    0, 50), // Muestra solo los primeros 150 caracteres
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              secondChild: Text(
                widget.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTapDown: (details) {
            toggleExpanded();
          },
          onTapUp: (details) {
            toggleExpanded();
          },
          child: Text(
            isExpanded ? '' : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class FeaturesWidget extends StatelessWidget {
  final String priceDay;
  final String priceNight;

  FeaturesWidget({required this.priceDay, required this.priceNight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Características',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _buildFeatureItem('Dimensiones', '90m x 45m'),
          _buildFeatureItem('Tipo de Césped', 'Sintético'),
          _buildFeatureItem('Iluminación', 'Sí'),
          _buildFeatureItem('Zona de Espectadores', 'Sí'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PriceCard(
                label: 'Precio Día',
                price: priceDay,
                backgroundColor: Colors.green,
              ),
              PriceCard(
                label: 'Precio Noche',
                price: priceNight,
                backgroundColor: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200], // Color de fondo de cada característica
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String value;

  const FeatureItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title + ': ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Cambia a la fuente que desees
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Lato', // Cambia a la fuente que desees
          ),
        ),
      ],
    );
  }
}

class PriceCard extends StatelessWidget {
  final String label;
  final String price;
  final Color backgroundColor;

  const PriceCard({
    required this.label,
    required this.price,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
