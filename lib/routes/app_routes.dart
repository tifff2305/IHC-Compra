import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/buscar_producto/buscar_producto_page.dart';
import 'package:ihc_inscripciones/page/home/home_page.dart';
import 'package:ihc_inscripciones/page/vista_producto/vista_producto_page.dart';
import 'package:ihc_inscripciones/page/compra/compra_page.dart';
import 'package:ihc_inscripciones/page/pagar/pagar_page.dart';

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


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomePage(),
      buscar_producto: (context) => const BuscarProductoPage(),
      vista_producto: (context) => const VistaProductoPage(),
      compra: (context) => const CompraPage(),
      pagar: (context) => const PagarPage(), 
    };
  }
}
