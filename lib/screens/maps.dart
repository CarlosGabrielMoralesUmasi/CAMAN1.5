import 'dart:async';
import 'dart:ffi';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:empresas_cliente/providers/address_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  // final Map<String, dynamic> currentLocation;
  // final String currentAddress;
  // final ValueSetter<String> onVariableRetornada;

  const MapScreen({
    // required this.onVariableRetornada,
    // required this.currentAddress,
    // required this.currentLocation,
    super.key
    });
  
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =Completer<GoogleMapController>();
  late Map<String,dynamic> newLocation; 
  late LatLng _finalLocation;
  late String _address;
  
  @override
  void initState() {
    _finalLocation = LatLng(Provider.of<AddressProvider>(context, listen: false).addressData['latitude'], Provider.of<AddressProvider>(context, listen: false).addressData['longitude']);
    _address = Provider.of<AddressProvider>(context, listen: false).addressData['address'];
    super.initState();
  }

  getAddressFromCoordinates(dynamic longitude, dynamic latitude) async {
    
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0]; // Selecciona el primer resultado
    String addr = "${place.street}, ${place.locality}, ${place.country}";
    
    setState(() {
      _address = addr;
    });
  }

  Future<void> _delayedPop(BuildContext context) async {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => WillPopScope(
            onWillPop: () async => false,
            child: const Scaffold(  
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          transitionDuration: Duration.zero,
          barrierDismissible: false,
          barrierColor: Colors.black45,
          opaque: false,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(_finalLocation.latitude, _finalLocation.longitude),
                zoom: 17.4746),
              onCameraMove: (CameraPosition? position) {
                if(_finalLocation != position!.target){
                  setState(() {
                    _finalLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                getAddressFromCoordinates(_finalLocation.longitude, _finalLocation.latitude);
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            // Cuadro en la parte superior que muestra la ubicacion del centro de la camara
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text(
                            _address,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Boton que se encuentra en la parte inferior en el centro y que dice aceptar, sirve para regresar a la pantalla anterior
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  //verificar si se esta cargando aun el contexto
                  Map<String, dynamic> location = {
                    'latitude': _finalLocation.latitude,
                    'longitude': _finalLocation.longitude,
                    'address': _address
                  };
                  context.read<AddressProvider>().setAddressData(location);
                  // widget.onVariableRetornada(_address);
                  //_delayedPop(context);
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ),
            // Icono de ubicacion en el centro de la pantalla
            Positioned(
              top: MediaQuery.of(context).size.height/2 - 30,
              left: MediaQuery.of(context).size.width/2 - 15,
              child: const Icon(
                Icons.location_on,
                size: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
      )
    );
  }
  // SizedBox(
  //     height: 700,
  //     child: GoogleMap(
  //       myLocationEnabled: true,
  //       myLocationButtonEnabled: true,
  //       zoomControlsEnabled: false,
  //       mapType: MapType.hybrid,
  //       initialCameraPosition: CameraPosition(
  //         target: LatLng(widget.currentLocation['latitude'], widget.currentLocation['longitude']),
  //         zoom: 17.4746),
  //       onCameraMove: (CameraPosition position) {
          
  //       },
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //   );
}