import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
   LatLng _currentPosition = LatLng(51.1128, 17.0592);
  late GoogleMapController mapController;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getLocation() async {
   // ignore: unused_local_variable
   LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      mapController.animateCamera(CameraUpdate.newLatLng(location));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeMarkers();
  }

  Future<void> _initializeMarkers() async {
    final double iconWidth = (MediaQuery.of(context).size.width * 0.1).toInt().toDouble();
    final double iconHeight = (MediaQuery.of(context).size.width * 0.1).toInt().toDouble();
    Uint8List? markerIcon = await getMarkerIconFromAsset('images/logo.png', iconWidth.toInt(), iconHeight.toInt());
    if (markerIcon != null) {
      BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(markerIcon);
      Marker marker1 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker1'),
        position: const LatLng(51.1128, 17.0592),
        infoWindow: const InfoWindow(
          title: 'Pasaż Grunwaldzki',
          snippet: 'Wrocław',
        ),
      );

      Marker marker2 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker2'),
        position: const LatLng(51.1085, 17.0404),
        infoWindow: const InfoWindow(
          title: 'galeria Dominikańska',
          snippet: 'Wrocław',
        ),
      );
      Marker marker3 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker3'),
        position: const LatLng(51.1422, 17.0872),
        infoWindow: const InfoWindow(
          title: 'Centrum Handlowe Korona',
          snippet: 'Wrocław',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker4 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker4'),
        position: const LatLng(51.1185, 16.9897),
        infoWindow: const InfoWindow(
          title: 'Magnolia Park',
          snippet: 'Wrocław',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker5 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker5'),
        position: const LatLng(51.0489, 16.9600),
        infoWindow: const InfoWindow(
          title: 'Aleja Bielany',
          snippet: 'Wrocław',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker6 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker6'),
        position: const LatLng(51.3533, 19.3761),
        infoWindow: const InfoWindow(
          title: 'Galeria Olimpia',
          snippet: 'Bełchatów',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker7 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker7'),
        position: const LatLng(51.4112, 19.6672),
        infoWindow: const InfoWindow(
          title: 'Focus',
          snippet: 'Piotrków Trybunalski',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker8 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker8'),
        position: const LatLng(51.4158, 21.9699),
        infoWindow: const InfoWindow(
          title: 'Galeria Zielona',
          snippet: 'Puławy',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker9 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker9'),
        position: const LatLng(50.0273, 22.0140),
        infoWindow: const InfoWindow(
          title: 'Millenium Hall',
          snippet: 'Rzeszów',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker10 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker10'),
        position: const LatLng(52.3042, 21.0585),
        infoWindow: const InfoWindow(
          title: 'Atrium Targówek',
          snippet: 'Warszawa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker11 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker11'),
        position: const LatLng(54.4544, 16.9895),
        infoWindow: const InfoWindow(
          title: 'Centrum handlowe Jantar',
          snippet: 'Słupsk',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker12 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker12'),
        position: const LatLng(50.3002, 18.6828),
        infoWindow: const InfoWindow(
          title: 'Forum',
          snippet: 'Gliwice',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker13 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker13'),
        position: const LatLng(53.4854, 18.7470),
        infoWindow: const InfoWindow(
          title: 'Alfa centrum',
          snippet: 'Grudiządz',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker14 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker14'),
        position: const LatLng(52.7281, 15.2409),
        infoWindow: const InfoWindow(
          title: 'Nova Park',
          snippet: 'Gorzów Wielkopolski',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker15 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker15'),
        position: const LatLng(52.1685, 22.2707),
        infoWindow: const InfoWindow(
          title: 'Galeria Siedlice',
          snippet: 'Siedlice',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker16 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker16'),
        position: const LatLng(53.0255, 18.6377),
        infoWindow: const InfoWindow(
          title: 'Copernicus',
          snippet: 'Toruń',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker17 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker17'),
        position: const LatLng(51.4064, 21.1552),
        infoWindow: const InfoWindow(
          title: 'Galeria Słoneczna',
          snippet: 'Radom',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker18 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker18'),
        position: const LatLng(52.0501, 23.1108),
        infoWindow: const InfoWindow(
          title: 'Carrefour',
          snippet: 'Biała Podlaska',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker19 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker19'),
        position: const LatLng(53.1372, 23.1624),
        infoWindow: const InfoWindow(
          title: 'Galeria Jurowiecka',
          snippet: 'Białystok',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker20 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker20'),
        position: const LatLng(53.1160, 18.0107),
        infoWindow: const InfoWindow(
          title: 'Zielone Arkady',
          snippet: 'Białystok',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker21 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker21'),
        position: const LatLng(50.3191, 19.1054),
        infoWindow: const InfoWindow(
          title: 'Centrum handlowe Galeria Północna',
          snippet: 'Czeladź',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker22 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker22'),
        position: const LatLng(50.8369, 19.1154),
        infoWindow: const InfoWindow(
          title: 'Centrum handlowe Galeria Północna',
          snippet: 'Częstochowa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker23 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker23'),
        position: const LatLng(53.8229, 22.3603),
        infoWindow: const InfoWindow(
          title: 'Brama Mazur',
          snippet: 'Ełk',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker24 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker24'),
        position: const LatLng(54.3828, 18.6005),
        infoWindow: const InfoWindow(
          title: 'Galeria Bałtycka',
          snippet: 'Gdańśk',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker25 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker25'),
        position: const LatLng(54.5029, 18.5316),
        infoWindow: const InfoWindow(
          title: 'Riviera',
          snippet: 'Gdynia',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker26 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker26'),
        position: const LatLng(53.0255, 18.6377),
        infoWindow: const InfoWindow(
          title: 'Copernicus',
          snippet: 'Toruń',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker27 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker27'),
        position: const LatLng(51.4064, 21.1552),
        infoWindow: const InfoWindow(
          title: 'Galeria Słoneczna',
          snippet: 'Radom',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker28 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker28'),
        position: const LatLng(52.0501, 23.1108),
        infoWindow: const InfoWindow(
          title: 'Carrefour',
          snippet: 'Biała Podlaska',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker29 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker29'),
        position: const LatLng(53.1372, 23.1624),
        infoWindow: const InfoWindow(
          title: 'Galeria Jurowiecka',
          snippet: 'Białystok',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker30 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker30'),
        position: const LatLng(52.1355, 20.8900),
        infoWindow: const InfoWindow(
          title: 'Centrum handlowe Janki',
          snippet: 'Janki',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker31 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker31'),
        position: const LatLng(50.2593, 19.0180),
        infoWindow: const InfoWindow(
          title: 'Galeria katowicka',
          snippet: 'Katowice',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker32 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker32'),
        position: const LatLng(52.2387, 18.2611),
        infoWindow: const InfoWindow(
          title: 'Galeria Nad Jeziorem',
          snippet: 'Konin',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker33 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker33'),
        position: const LatLng(50.0675, 19.9460),
        infoWindow: const InfoWindow(
          title: 'Galeria Krakowksa',
          snippet: 'Kraków',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker34 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker34'),
        position: const LatLng(50.0882, 19.9859),
        infoWindow: const InfoWindow(
          title: 'Centrum Serenda',
          snippet: 'Kraków',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker35 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker35'),
        position: const LatLng(51.7792, 19.4449),
        infoWindow: const InfoWindow(
          title: 'Centrum Handlowe Manufaktura',
          snippet: 'Łódź',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker36 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker36'),
        position: const LatLng(51.7590, 19.4652),
        infoWindow: const InfoWindow(
          title: 'Galeria Łódzka',
          snippet: 'Łódź',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker37 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker37'),
        position: const LatLng(52.5376, 19.7506),
        infoWindow: const InfoWindow(
          title: 'Galeria Mazovia',
          snippet: 'Płock',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker38 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker38'),
        position: const LatLng(52.3820, 16.9923),
        infoWindow: const InfoWindow(
          title: 'Galeria Północna',
          snippet: 'Poznań',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker39 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker39'),
        position: const LatLng(52.3965, 16.9554),
        infoWindow: const InfoWindow(
          title: 'Posnania',
          snippet: 'Poznań',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker40 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker40'),
        position: const LatLng(49.7910, 22.7833),
        infoWindow: const InfoWindow(
          title: 'Galeria Sanowa',
          snippet: 'Przemyśl',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker41 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker41'),
        position: const LatLng(49.6240, 20.7066),
        infoWindow: const InfoWindow(
          title: 'Galeria Trzy Korony',
          snippet: 'Nowy Sącz',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker42 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker42'),
        position: const LatLng(52.4012, 16.9280),
        infoWindow: const InfoWindow(
          title: 'Stary Browar',
          snippet: 'Poznań',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker43 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker43'),
        position: const LatLng(50.0419, 21.9982),
        infoWindow: const InfoWindow(
          title: 'Galeria Rzeszów',
          snippet: 'Rzeszów',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker44 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker44'),
        position: const LatLng(50.5846, 22.0642),
        infoWindow: const InfoWindow(
          title: 'Vivo Stalowa Wola',
          snippet: 'Stalowa Wola',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker45 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker45'),
        position: const LatLng(51.7792, 19.4449),
        infoWindow: const InfoWindow(
          title: 'Galeria Plaza',
          snippet: 'Suwałki',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker46 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker46'),
        position: const LatLng(50.0294, 21.0020),
        infoWindow: const InfoWindow(
          title: 'Gemini Park',
          snippet: 'Tarnów',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker47 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker47'),
        position: const LatLng(50.0965, 19.0102),
        infoWindow: const InfoWindow(
          title: 'Gemini Park',
          snippet: 'Tychy',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker48 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker48'),
        position: const LatLng(52.3174, 20.9670),
        infoWindow: const InfoWindow(
          title: 'Galeria Północna',
          snippet: 'Warszawa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker49 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker49'),
        position: const LatLng(52.6551, 19.0631),
        infoWindow: const InfoWindow(
          title: 'Wzorcownia',
          snippet: 'Włocławek',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker50 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker50'),
        position: const LatLng(50.3177, 18.7519),
        infoWindow: const InfoWindow(
          title: 'M1',
          snippet: 'Zabrze',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker51 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker51'),
        position: const LatLng(49.8273, 19.0496),
        infoWindow: const InfoWindow(
          title: 'Galeria Sfera II',
          snippet: 'Bielsko-Biała',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker52 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker52'),
        position: const LatLng(53.1246, 18.0182),
        infoWindow: const InfoWindow(
          title: 'Focus',
          snippet: 'Bydgoszcz',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker53 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker53'),
        position: const LatLng(51.6452, 16.0974),
        infoWindow: const InfoWindow(
          title: 'Family Point',
          snippet: 'Głogów',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker54 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker54'),
        position: const LatLng(49.6770, 21.7758),
        infoWindow: const InfoWindow(
          title: 'Vivo Krosno',
          snippet: 'Krosno',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker55 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker55'),
        position: const LatLng(50.6813, 17.8845),
        infoWindow: const InfoWindow(
          title: 'Karolinka',
          snippet: 'Opole',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker56 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker56'),
        position: const LatLng(52.2301, 21.0027),
        infoWindow: const InfoWindow(
          title: 'Złote Tarasy',
          snippet: 'Warszawa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker57 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker57'),
        position: const LatLng(52.7840, 18.2405),
        infoWindow: const InfoWindow(
          title: 'Galeria Solna',
          snippet: 'Inowrocław',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker58 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker58'),
        position: const LatLng(50.2713, 19.0057),
        infoWindow: const InfoWindow(
          title: 'Silesia',
          snippet: 'Katowice',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker59 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker59'),
        position: const LatLng(52.1795, 21.0042),
        infoWindow: const InfoWindow(
          title: 'Galeria Mokotów',
          snippet: 'Warszawa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker60 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker60'),
        position: const LatLng(54.3493, 18.6434),
        infoWindow: const InfoWindow(
          title: 'Forum',
          snippet: 'Gdańsk',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker61 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker61'),
        position: const LatLng(53.1230, 23.1790),
        infoWindow: const InfoWindow(
          title: 'Atrium Biała',
          snippet: 'Białystok',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker62 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker62'),
        position: const LatLng(52.2564, 20.9838),
        infoWindow: const InfoWindow(
          title: 'Arkadia',
          snippet: 'Warszawa',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker63 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker63'),
        position: const LatLng(50.0704, 19.9981),
        infoWindow: const InfoWindow(
          title: 'M1',
          snippet: 'Kraków',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker64 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker64'),
        position: const LatLng(50.7662, 16.2660),
        infoWindow: const InfoWindow(
          title: 'Victoria',
          snippet: 'Wałbrzych',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker65 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker65'),
        position: const LatLng(53.4285, 14.5515),
        infoWindow: const InfoWindow(
          title: 'Kaskada',
          snippet: 'Szczecin',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker66 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker66'),
        position: const LatLng(50.7165, 23.2571),
        infoWindow: const InfoWindow(
          title: 'Twierdza',
          snippet: 'Zamość',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker67 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker67'),
        position: const LatLng(53.7771, 20.4829),
        infoWindow: const InfoWindow(
          title: 'Aura',
          snippet: 'Olsztyn',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker68 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker68'),
        position: const LatLng(53.0155, 18.5621),
        infoWindow: const InfoWindow(
          title: 'Plaza',
          snippet: 'Toruń',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      Marker marker69 = Marker(
        icon: customIcon,
        markerId: const MarkerId('marker69'),
        position: const LatLng(50.0149, 22.6813),
        infoWindow: const InfoWindow(
          title: 'Stara Ujeżdżalnia',
          snippet: 'Jarosław',
        ),
        onTap: () {
          // Handle marker tap
        },
      );
      setState(() {
        _markers.add(marker1);
        _markers.add(marker2);
        _markers.add(marker3);
        _markers.add(marker4);
        _markers.add(marker5);
        _markers.add(marker6);
        _markers.add(marker7);
        _markers.add(marker8);
        _markers.add(marker9);
        _markers.add(marker10);
        _markers.add(marker11);
        _markers.add(marker12);
        _markers.add(marker13);
        _markers.add(marker14);
        _markers.add(marker15);
        _markers.add(marker16);
        _markers.add(marker17);
        _markers.add(marker18);
        _markers.add(marker19);
        _markers.add(marker20);
        _markers.add(marker21);
        _markers.add(marker22);
        _markers.add(marker23);
        _markers.add(marker24);
        _markers.add(marker25);
        _markers.add(marker26);
        _markers.add(marker27);
        _markers.add(marker28);
        _markers.add(marker29);
        _markers.add(marker30);
        _markers.add(marker31);
        _markers.add(marker32);
        _markers.add(marker33);
        _markers.add(marker34);
        _markers.add(marker35);
        _markers.add(marker36);
        _markers.add(marker37);
        _markers.add(marker38);
        _markers.add(marker39);
        _markers.add(marker40);
        _markers.add(marker41);
        _markers.add(marker42);
        _markers.add(marker43);
        _markers.add(marker44);
        _markers.add(marker45);
        _markers.add(marker46);
        _markers.add(marker47);
        _markers.add(marker48);
        _markers.add(marker49);
        _markers.add(marker50);
        _markers.add(marker51);
        _markers.add(marker52);
        _markers.add(marker53);
        _markers.add(marker54);
        _markers.add(marker55);
        _markers.add(marker56);
        _markers.add(marker57);
        _markers.add(marker58);
        _markers.add(marker59);
        _markers.add(marker60);
        _markers.add(marker61);
        _markers.add(marker62);
        _markers.add(marker63);
        _markers.add(marker64);
        _markers.add(marker65);
        _markers.add(marker66);
        _markers.add(marker67);
        _markers.add(marker68);
        _markers.add(marker69);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0,backgroundColor: const ui.Color.fromARGB(0, 255, 255, 255),elevation: 0,),
      body: GoogleMap(
        padding: EdgeInsets.only(bottom: 60),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}

Future<Uint8List?> getMarkerIconFromAsset(
    String path, int width, int height) async {
  ByteData? byteData = await rootBundle.load(path);
  Uint8List imageData = byteData.buffer.asUint8List();
  ui.Codec codec = await ui.instantiateImageCodec(imageData,
      targetWidth: width, targetHeight: height);
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  ByteData? resizedByteData =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  if (resizedByteData != null) {
    return resizedByteData.buffer.asUint8List();
  }
  return null;
}
