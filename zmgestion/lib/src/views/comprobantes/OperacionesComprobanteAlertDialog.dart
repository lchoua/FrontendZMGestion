import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class OperacionesComprobanteAlertDialog extends StatefulWidget {
  final String title;
  final Comprobantes comprobante;
  final String operacion;

  const OperacionesComprobanteAlertDialog({Key key, this.title, this.comprobante, this.operacion}) : super(key: key);
  @override
  _OperacionesComprobanteAlertDialogState createState() => _OperacionesComprobanteAlertDialogState();
}

class _OperacionesComprobanteAlertDialogState extends State<OperacionesComprobanteAlertDialog> {

  final _formKey = GlobalKey<FormState>();
  String tipo =  'R'; 
  final TextEditingController numeroComprobanteController = new TextEditingController();
  final TextEditingController montoController = new TextEditingController();
  final TextEditingController observacionesController = new TextEditingController();
  Comprobantes comprobante;
  bool enable = false;

  @override
  void initState() {
    comprobante = widget.comprobante;
    // TODO: implement initState
    if (widget.operacion == 'Modificar'){
      numeroComprobanteController.text = comprobante.numeroComprobante.toString();
      tipo = comprobante.tipo;
      montoController.text = comprobante.monto.toString();
      observacionesController.text = comprobante.observaciones;
      enable = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler){
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
            title: widget.title
          ),
          content: Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: numeroComprobanteController,
                            validator: Validator.notEmptyValidator,
                            labelText: "Número de comprobante",
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(minWidth: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Tipo",
                                ),
                                Container(
                                  width: 250,
                                  child: DropDownMap(
                                    map: Comprobantes().mapTipos(),
                                    addAllOption: false,
                                    initialValue: "R",
                                    onChanged: (value) {
                                      setState(() {
                                        tipo = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: montoController,
                            validator: Validator.notEmptyValidator,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                            labelText: "Monto",
                            icon: Icon(Icons.attach_money),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: observacionesController,
                            labelText: "Observaciones",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZMStdButton(
                        color: Theme.of(mainContext).primaryColor,
                        text: Text(
                          widget.operacion +" Comprobante",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            
                          ),
                        ),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){
                            switch (widget.operacion){
                              case 'Crear':
                                {
                                  Map<String, dynamic> payload = {
                                    "Comprobantes":{
                                      "IdVenta": comprobante.idVenta,
                                      "Tipo": tipo,
                                      "NumeroComprobante": int.parse(numeroComprobanteController.text),
                                      "Monto": int.parse(montoController.text),
                                      "Observaciones":observacionesController.text
                                    }
                                  };
                                  await VentasService(scheduler: scheduler).doMethod(VentasService().crearComprobanteConfiguration(payload)).then((response){
                                    if (response.status == RequestStatus.SUCCESS){
                                      Navigator.of(context).pop(true);
                                    }
                                  });
                                }
                                break;
                              case 'Modificar':
                                {
                                  Map<String, dynamic> payload = {
                                    "Comprobantes":{
                                      "IdComprobante": comprobante.idComprobante,
                                      "IdVenta": comprobante.idVenta,
                                      "Tipo": tipo,
                                      "NumeroComprobante": int.parse(numeroComprobanteController.text),
                                      "Monto": int.parse(montoController.text),
                                      "Observaciones":observacionesController.text
                                    }                               
                                };
                                await VentasService(scheduler: scheduler).doMethod(VentasService().modificarComprobanteConfiguration(payload)).then((response){
                                    if (response.status == RequestStatus.SUCCESS){
                                      Navigator.of(context).pop(true);
                                    }
                                });
                                break;
                              }
                            }
                          }
                        },
                      ),
                    ],
                  )                
                ],
              )
            ),
          ),
        );
      },
    );
  }
}