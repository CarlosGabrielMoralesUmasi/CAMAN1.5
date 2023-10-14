import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class MatchInfoWidget extends StatelessWidget {
  final String formattedDateTime;
  final String homeTeam;
  final String awayTeam;

  MatchInfoWidget({
    required this.formattedDateTime,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch('https://librefutboltv.com/es/');
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF9799BA),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/ucl_logo.png',
              width: 65,
              height: 80,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDateTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  homeTeam,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  awayTeam,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleNotification(
    String matchTime, String homeTeam, String awayTeam) async {
  final DateTime scheduledNotificationDateTime = DateTime.now()
      .add(const Duration(minutes: 1)); // Cambiado a 1 minuto para pruebas

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel_id', // Identificación del canal
    'Default Channel', // Nombre del canal
    channelDescription:
        'Canal de notificaciones por defecto', // Descripción del canal
    importance: Importance.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Partido en 10 minutos',
    'El partido entre $homeTeam y $awayTeam comenzará a las $matchTime',
    tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

class CurvedSquareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Category()),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 200.0,
          decoration: BoxDecoration(
            color: Color(0xFF9799BA),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              'UEFA Champions League', // Nombre del torneo
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<dynamic> upcomingMatches = [];
  final apiKey =
      '3878f0e019704786ae39a2f3c805977a'; // Reemplaza con tu clave de API
  final uefaChampionsLeagueId = 2001; // ID de la UEFA Champions League

  @override
  void initState() {
    super.initState();
    fetchUpcomingMatches();
  }

  Future<void> fetchUpcomingMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.football-data.org/v2/competitions/$uefaChampionsLeagueId/matches?status=SCHEDULED'),
        headers: {
          'X-Auth-Token': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          upcomingMatches = List<dynamic>.from(jsonData['matches']);
        });
      } else {
        throw Exception('No se pudo obtener los próximos partidos.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getFormattedDateTime(String utcDate) {
    final DateTime dateTime = DateTime.parse(utcDate).toLocal();
    final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    final formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return '$formattedDate\n$formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UEFA Champions League'),
        backgroundColor: Color(0xFF9799BA),
      ),
      body: ListView.builder(
        itemCount: upcomingMatches.length > 10 ? 10 : upcomingMatches.length,
        itemBuilder: (context, index) {
          final match = upcomingMatches[index];
          final homeTeam = match['homeTeam']['name'];
          final awayTeam = match['awayTeam']['name'];
          final formattedDateTime = getFormattedDateTime(match['utcDate']);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MatchInfoWidget(
              homeTeam: homeTeam,
              awayTeam: awayTeam,
              formattedDateTime: formattedDateTime,
            ),
          );
        },
      ),
    );
  }
}

void _scheduleNotificationForTest() {
  // Obtén la hora actual y agrega 10 segundos
  final DateTime now = DateTime.now();
  final DateTime scheduledTime = now.add(Duration(seconds: 5));

  final String matchTime = '20:00'; // Un tiempo de partido de ejemplo
  final String homeTeam = 'Equipo Local'; // Nombre del equipo local
  final String awayTeam = 'Equipo Visitante'; // Nombre del equipo visitante

  scheduleNotification(matchTime, homeTeam, awayTeam);
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Cuadrado con bordes curvados'),
      ),
      body: CurvedSquareWidget(),
    ),
  ));

  // Llama a la función de notificación cuando se inicia la aplicación
  // _scheduleNotificationForTest();
}
