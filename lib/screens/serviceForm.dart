import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/providers/address_provider.dart';
import 'package:empresas_cliente/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

//! Stados de los servicios
//! 0: pending
//! 1: accepted
//! 2: finished
//! 3: cancelled

Logger logger = Logger();

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final hours = timeOfDay.hourOfPeriod.toString().padLeft(2, '0');
  final minutes = timeOfDay.minute.toString().padLeft(2, '0');
  final period = timeOfDay.period == DayPeriod.am ? 'am' : 'pm';
  return '$hours:$minutes $period';
}

void sendServiceToDataBase(Map<String, dynamic> serviceData) {
  final db = FirebaseFirestore.instance;
  db.collection('services').add(serviceData);
}

class ServiceForm extends StatefulWidget {
  final String workerId;

  const ServiceForm({super.key, required this.workerId});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 390,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              // no se puede editar
              readOnly: true,
              controller: _dateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today_rounded),
                labelText: "Fecha",
              ),
              onTap: () async {
                DateTime? pickDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickDate != null) {
                  setState(() {
                    _dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickDate);
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              readOnly: true,
              controller: _timeController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: "Hora",
              ),
              onTap: () async {
                TimeOfDay? pickTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (pickTime != null) {
                  setState(() {
                    _timeController.text = formatTimeOfDay(pickTime);
                  });
                }
              },
            ),
          ),
          // input de descripcion, es un texto largo por lo que se usa un textfield de varias lineas y altura maxima
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                labelText: "Descripción y comentarios",
              ),
            ),
          ),
          // Mostrar precio en el centro y con un tamaño grande
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Precio/hora: 60 SOLES.",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //const Spacer(),
          // Boton de confirmar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // Mapa con los datos del servicio
                  String clientId = context.read<UserProvider>().userId;
                  Map<String, dynamic> location =
                      context.read<AddressProvider>().addressData;

                  Map<String, dynamic> serviceData = {
                    "date": _dateController.text,
                    "time": _timeController.text,
                    "description": _descriptionController.text,
                    "price": 10,
                    "workerId": widget.workerId,
                    "clientId": clientId,
                    "status": "pending",
                    "longitude": location["longitude"],
                    "latitude": location["latitude"],
                  };
                  sendServiceToDataBase(serviceData);

                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
