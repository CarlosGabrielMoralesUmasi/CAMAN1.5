import 'package:empresas_cliente/screens/screen_handler.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> askForLocPermission() async{
  var status = await Permission.location.status;
  if (status.isDenied) {
    await Permission.location.request();
    status = await Permission.location.status;
    if(status.isGranted){
      return true;
    }else{
      return false;
    }
  }else if(status.isGranted){
    return true;
  }else{
    return false;
  }
}

class PermissionHandler extends StatefulWidget {
  const PermissionHandler({super.key});

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  
  @override
  void initState() {
    askForLocPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: askForLocPermission(),
        builder: (context, snapshot) {
          if(snapshot.data == true){
            return const Screenhandler();
          }else if(snapshot.data == false){
            return const Text("No se pudo obtener permiso de ubicación");
          }else{
            return const CircularProgressIndicator();
        }
      }
      ),
    );
  }
}