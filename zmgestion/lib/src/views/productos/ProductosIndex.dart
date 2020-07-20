import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/views/productos/CrearProductosAlertDialog.dart';
import 'package:zmgestion/src/views/productos/ModificarProductosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/FilterChoiceChip.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class ProductosIndex extends StatefulWidget {
  @override
  _ProductosIndexState createState() => _ProductosIndexState();
}

class _ProductosIndexState extends State<ProductosIndex> {
  Map<int, Productos> productos = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  String searchIdEstado = "T";
  /*Search filters*/
  bool showFilters = false;
  bool searchByProducto = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Buscar",
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                    alignLabelWithHint: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 0)),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        /*
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showFilters = !showFilters;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.filter,
                            size: 14,
                            color: showFilters
                                ? Colors.blueAccent.withOpacity(0.8)
                                : Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.7),
                          ),
                        ),
                        */
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            constraints: BoxConstraints(minWidth: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Estado",
                                ),
                                Container(
                                  width: 250,
                                  child: DropDownMap(
                                    map: Productos()
                                        .mapEstados(),
                                    addAllOption: true,
                                    addAllText: "Todos",
                                    addAllValue: "T",
                                    initialValue: "T",
                                    onChanged: (value) {
                                      setState(() {
                                        searchIdEstado =
                                            value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              AppLoader(builder: (scheduler) {
                return ZMTable(
                  key: Key(searchText + searchIdEstado.toString() + searchByProducto.toString() + refreshValue.toString()),
                  model: Productos(),
                  service: ProductosService(),
                  listMethodConfiguration: ProductosService().buscarProductos({
                    "Productos": {
                      "Producto": searchByProducto ? searchText : null,
                      "Estado": searchIdEstado
                    }
                  }),
                  pageLength: 12,
                  paginate: true,
                  cellBuilder: {
                    "Productos": {
                      "Producto": (value) {
                        return Text(
                          value.toString(),
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                    "Precios": {
                      "Precio": (value) {
                        return Text(
                            "\$ "+value.toString(),
                            textAlign: TextAlign.center);
                      },
                      "FechaAlta": (value){
                        if(value != null){
                          return Text(
                            Utils.cuteDateTimeText(DateTime.parse(value)),
                            textAlign: TextAlign.center);
                        }else{
                          return Text(
                            "-",
                            textAlign: TextAlign.center);
                        }
                        
                      },
                    }
                  },
                  tableLabels: {
                    "Precios": {
                      "FechaAlta": "Última actualización"
                    }
                  },
                  fixedActions: [
                    ZMStdButton(
                      color: Colors.green,
                      text: Text(
                        "Nuevo producto",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.5),
                          builder: (BuildContext context) {
                            return CrearProductosAlertDialog(
                              title: "Crear Productos",
                              onSuccess: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  refreshValue = Random().nextInt(99999);
                                });
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                  onSelectActions: (productos) {
                    bool estadosIguales = true;
                    String estado;
                    if (productos.length >= 1) {
                      Map<String, dynamic> anterior;
                      for (Productos producto in productos) {
                        Map<String, dynamic> mapProducto = producto.toMap();
                        if (anterior != null) {
                          if (anterior["Productos"]["Estado"] !=
                              mapProducto["Productos"]["Estado"]) {
                            estadosIguales = false;
                          }
                        }
                        if (!estadosIguales) break;
                        anterior = mapProducto;
                      }
                      if (estadosIguales) {
                        estado = productos[0].toMap()["Productos"]["Estado"];
                      }
                    }
                    return <Widget>[
                      Visibility(
                        visible: estadosIguales && estado != null,
                        child: Row(
                          children: [
                            ZMStdButton(
                              color: Colors.white,
                              text: Text(
                                (estado == "A"
                                        ? "Dar de baja"
                                        : "Dar de alta") +
                                    " (" +
                                    productos.length.toString() +
                                    ")",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(
                                estado == "A"
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color:
                                    estado == "A" ? Colors.red : Colors.green,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context)
                                      .backgroundColor
                                      .withOpacity(0.5),
                                  builder: (BuildContext context) {
                                    return MultipleRequestView(
                                      models: productos,
                                      title: (estado == "A"
                                              ? "Dar de baja"
                                              : "Dar de alta") +
                                          " " +
                                          productos.length.toString() +
                                          " productos",
                                      service: ProductosService(),
                                      doMethodConfiguration: estado == "A"
                                          ? ProductosService()
                                              .bajaConfiguration()
                                          : ProductosService()
                                              .altaConfiguration(),
                                      payload: (mapModel) {
                                        return {
                                          "Productos": {
                                            "IdProducto": mapModel["Productos"]["IdProducto"]
                                          }
                                        };
                                      },
                                      itemBuilder: (mapModel) {
                                        return Text(mapModel["Productos"]["Producto"]);
                                      },
                                      onFinished: () {
                                        setState(() {
                                          refreshValue =
                                              Random().nextInt(99999);
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ),
                      ZMStdButton(
                        color: Colors.red,
                        text: Text(
                          "Borrar (" + productos.length.toString() + ")",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            builder: (BuildContext context) {
                              return MultipleRequestView(
                                models: productos,
                                title: "Borrar " +
                                    productos.length.toString() +
                                    " productos",
                                service: ProductosService(),
                                doMethodConfiguration:
                                    ProductosService().borraConfiguration(),
                                payload: (mapModel) {
                                  return {
                                    "Productos": {
                                      "IdProducto": mapModel["Productos"]
                                          ["IdProducto"]
                                    }
                                  };
                                },
                                itemBuilder: (mapModel) {
                                  return Text(mapModel["Productos"]["Producto"]);
                                },
                                onFinished: () {
                                  setState(() {
                                    refreshValue = Random().nextInt(99999);
                                  });
                                },
                              );
                            },
                          );
                        },
                      )
                    ];
                  },
                  rowActions: (mapModel, index, itemsController) {
                    Productos producto;
                    String estado = "A";
                    int idProducto = 0;
                    if (mapModel != null) {
                      producto = Productos().fromMap(mapModel);
                      if (mapModel["Productos"] != null) {
                        if (mapModel["Productos"]["Estado"] != null) {
                          estado = mapModel["Productos"]["Estado"];
                        }
                        if (mapModel["Productos"]["IdProducto"] != null) {
                          idProducto = mapModel["Productos"]["IdProducto"];
                        }
                      }
                    }
                    return <Widget>[
                      IconButtonTableAction(
                        iconData: Icons.show_chart,
                        onPressed: () {
                          if (idProducto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return ModelViewDialog(
                                  content: ModelView(
                                    service: ProductosService(),
                                    getMethodConfiguration: ProductosService()
                                        .dameConfiguration(idProducto),
                                    isList: false,
                                    itemBuilder:
                                        (mapModel, index, itemController) {
                                      return Productos()
                                          .fromMap(mapModel)
                                          .viewModel(context);
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        }
                      ),
                      IconButtonTableAction(
                        iconData: (estado == "A"
                            ? Icons.arrow_downward
                            : Icons.arrow_upward),
                        color: estado == "A" ? Colors.redAccent : Colors.green,
                        onPressed: () {
                          if (idProducto != 0) {
                            if (estado == "A") {
                              ProductosService(scheduler: scheduler).baja({
                                "Productos": {"IdProducto": idProducto}
                              }).then((response) {
                                if (response.status == RequestStatus.SUCCESS) {
                                  itemsController.add(ItemAction(
                                      event: ItemEvents.Update,
                                      index: index,
                                      updateMethodConfiguration:
                                          ProductosService().dameConfiguration(
                                              producto.idProducto)));
                                }
                              });
                            } else {
                              ProductosService().alta({
                                "Productos": {"IdProducto": idProducto}
                              }).then((response) {
                                if (response.status == RequestStatus.SUCCESS) {
                                  itemsController.add(ItemAction(
                                      event: ItemEvents.Update,
                                      index: index,
                                      updateMethodConfiguration:
                                          ProductosService().dameConfiguration(
                                              producto.idProducto)));
                                }
                              });
                            }
                          }
                        },
                      ),
                      IconButtonTableAction(
                        iconData: Icons.edit,
                        onPressed: () {
                          if (idProducto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return ModelView(
                                  service: ProductosService(),
                                  getMethodConfiguration: ProductosService().dameConfiguration(idProducto),
                                  isList: false,
                                  itemBuilder: (updatedMapModel, internalIndex, itemController) => ModificarProductosAlertDialog(
                                    title: "Modificar producto",
                                    producto: Productos().fromMap(updatedMapModel),
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                      itemsController.add(ItemAction(
                                          event: ItemEvents.Update,
                                          index: index,
                                          updateMethodConfiguration:
                                              ProductosService().dameConfiguration(
                                                  producto.idProducto)));
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      IconButtonTableAction(
                        iconData: Icons.delete_outline,
                        onPressed: () {
                          if (idProducto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return DeleteAlertDialog(
                                  title: "Borrar producto",
                                  message:
                                      "¿Está seguro que desea eliminar la producto?",
                                  onAccept: () async {
                                    await ProductosService().borra({
                                      "Productos": {"IdProducto": idProducto}
                                    }).then((response) {
                                      if (response.status ==
                                          RequestStatus.SUCCESS) {
                                        itemsController.add(ItemAction(
                                            event: ItemEvents.Hide,
                                            index: index));
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                        },
                      )
                    ];
                  },
                  searchArea: TableTitle(
                    title: "Productos"
                  )
                );
              }),
            ],
          ),
        ));
  }
}
