import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMLineaProducto.dart';

class CrearLineaVenta extends StatefulWidget {
  final Function(LineasProducto lp) onAccept;

  const CrearLineaVenta({
    Key key,
    this.onAccept
  }):super(key:key);
  @override
  _CrearLineaVentaState createState() => _CrearLineaVentaState();
}

class _CrearLineaVentaState extends State<CrearLineaVenta> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: AlertDialogTitle(
        title: "Nueva Linea de Venta", 
        titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
      ),
      content: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
        ),
        child: Card(
          color: Theme.of(context).primaryColorLight,
          child: ZMLineaProducto(
            onAccept: (lineaProducto){
              print(lineaProducto.toMap());
              widget.onAccept(lineaProducto);
              Navigator.of(context).pop();
            },
          )
        ),
      ),
    );
  }
}