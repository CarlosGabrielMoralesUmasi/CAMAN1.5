import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:empresas_cliente/providers/user_provider.dart';

var logger = Logger(
  printer: PrettyPrinter(),
  filter: null,
  output: null,
);

class HistoryList extends StatefulWidget {
  final String type;

  const HistoryList({required this.type, super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

Widget nameBuilder(Map<String, dynamic> data) {
  return FutureBuilder<String>(
    future: workerName(data['workerId']),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data!);
      } else {
        return const Text('Loading...');
      }
    },
  );
}

Future<String> workerName(String workerId) async {
  final db = FirebaseFirestore.instance;
  final DocumentSnapshot snapshot =
      await db.collection('workers').doc(workerId).get();
  final Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
  return data['name'];
}

Widget _buildHistoryButton(BuildContext context, String clientId, String type) {
  final db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> serviceStream = db
      .collection('services')
      .where('clientId', isEqualTo: clientId)
      .where('status', isEqualTo: type)
      .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: serviceStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        logger.d(snapshot.error);
        return const Text('Something went wrong');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading");
      }
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Column(
            children: [
              //* Contenido de la lista
              ListTile(
                title: nameBuilder(data),
                subtitle: Text(data['date'] + ' - ' + data['time']),
                //* Boton de cancelar servicio
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cancelar reservación'),
                          content: const Text(
                              '¿Está seguro que desea cancelar su reserva?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                final db = FirebaseFirestore.instance;
                                db
                                    .collection('services')
                                    .doc(document.id)
                                    .update({
                                  'status': 'cancelled',
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Si'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Cancelar'),
                ),
              ),
              //* Linea de separacion gris
              const Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
            ],
          );
        }).toList(),
      );
    },
  );
}

Widget _buildHistoryItem(BuildContext context, String clientId, String type) {
  final db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> serviceStream = db
      .collection('services')
      .where('clientId', isEqualTo: clientId)
      .where('status', isEqualTo: type)
      .snapshots();

  return StreamBuilder(
    stream: serviceStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        logger.d(snapshot.error);
        return const Text('Something went wrong');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading");
      }
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: nameBuilder(data),
                subtitle: Text(data['date'] + ' - ' + data['time']),
              ),
              //* Linea de separacion gris
              const Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
            ],
          );
        }).toList(),
      );
    },
  );
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    String clientId = context.read<UserProvider>().userId;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 13, right: 16.0, bottom: 13),
              child: Text(
                widget.type == 'pending'
                    ? 'Reservas pendientes'
                    : widget.type == 'accepted'
                        ? 'Reservas aceptados'
                        : widget.type == 'cancelled'
                            ? 'Reservas cancelados'
                            : widget.type == 'finished'
                                ? 'Reservas finalizados'
                                : '',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            //* Linea de separacion gris
            const Divider(
              height: 1,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: widget.type == 'pending' || widget.type == 'accepted'
                  ? _buildHistoryButton(context, clientId, widget.type)
                  : _buildHistoryItem(context, clientId, widget.type),
            ),
          ],
        ),
      ),
    );
  }
}
