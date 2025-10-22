import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/buscar_producto/buscar_producto_page.dart';
import 'package:ihc_inscripciones/page/home/home_page.dart';
import 'package:ihc_inscripciones/page/navegador_page.dart';
import 'package:ihc_inscripciones/page/tarjeta/tarjeta_page.dart';
import 'package:ihc_inscripciones/page/pagar/pagar_page.dart';
import 'package:ihc_inscripciones/page/mapa/mapa_page.dart';
import 'package:ihc_inscripciones/page/compra/compra_page.dart';
import 'package:ihc_inscripciones/page/tracking/tracking_page.dart';
import 'package:ihc_inscripciones/page/vista_producto/vista_producto_page.dart';

class AppRoutes {
  static const home = '/home';
  static const buscar_producto = '/buscar_producto';
  static const vista_producto = '/vista_producto';
  static const compra = '/compra';
  static const pagar = '/pagar';
  static const qr = '/qr';
  static const tarjeta = '/tarjeta';
  static const mapa = '/mapa';
  static const tracking = '/tracking';
  static const navegador = '/navegador';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomePage(),
      navegador: (context) => const NavegadorPage(),
      tarjeta: (context) => const TarjetaPage(),
      vista_producto: (context) => const VistaProductoPage(),
      pagar: (context) => const PagarPage(),
      mapa: (context) => const MapaPage(),
      compra: (context) => const CompraPage(),
      buscar_producto: (context) => const BuscarProductoPage(),
      tracking: (context) => const TrackingPage(),
    };
  }
} 
