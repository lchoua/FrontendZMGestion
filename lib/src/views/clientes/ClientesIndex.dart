import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/views/clientes/CrearClientesAlertDialog.dart';
import 'package:zmgestion/src/views/clientes/ModificarClientesAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/FilterChoiceChip.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class ClientesIndex extends StatefulWidget {
  @override
  _ClientesIndexState createState() => _ClientesIndexState();
}

class _ClientesIndexState extends State<ClientesIndex> {
  Map<int, Clientes> clientes = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  int searchIdRol = 0;
  int searchIdUbicacion = 0;
  String searchIdEstado = "T";
  String searchTipo = "T";
  String searchIdPais = "AR";
  /*Search filters*/
  bool showFilters = false;
  bool searchByNombres = true;
  bool searchByApellidos = true;
  bool searchByRazonSocial = true;
  bool searchByEmail = false;
  bool searchByDocumento = false;
  bool searchByTelefono = false;

  //List<String> columnNames = ["Nombres", "Apellidos","Usuario", "Telefono", "Email"];

  List<Widget> columns = new List<Widget>();
  Map<String, String> breadcrumb = new Map<String, String>();

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio",
      "Clientes": null,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ZMBreadCrumb(
                          config: breadcrumb,
                        ),
                      ),
                    ],
                  ),
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
                                      labelText: "Tipo de cliente",
                                    ),
                                    Container(
                                      width: 250,
                                      child: DropDownMap(
                                        map: Clientes().mapTipo(),
                                        addAllOption: true,
                                        addAllText: "Todos",
                                        addAllValue: "T",
                                        initialValue: "T",
                                        onChanged: (value) {
                                          setState(() {
                                            searchTipo = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  !showFilters
                      ? Container()
                      : Container(
                          height: 175,
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 6, right: 12),
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      showFilters = !showFilters;
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                      width: 0.25))),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            "Filtros de búsqueda",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                    Theme.of(context).primaryColor,
                                                fontSize: 12),
                                          )),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                      width: 0.25))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                      margin: EdgeInsets.only(right: 0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 12, 12, 6),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "Buscar por: ",
                                                      textAlign: TextAlign.right,
                                                    )),
                                                Expanded(
                                                  flex: 5,
                                                  child: Wrap(children: [
                                                    FilterChoiceChip(
                                                      text: "Nombres",
                                                      initialValue: searchByNombres,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByNombres = value;
                                                        });
                                                      },
                                                    ),
                                                    FilterChoiceChip(
                                                      text: "Apellidos",
                                                      initialValue:
                                                          searchByApellidos,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByApellidos = value;
                                                        });
                                                      },
                                                    ),
                                                    FilterChoiceChip(
                                                      text: "Razón Social",
                                                      initialValue:
                                                          searchByRazonSocial,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByRazonSocial =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                    FilterChoiceChip(
                                                      text: "Correo electrónico",
                                                      initialValue: searchByEmail,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByEmail = value;
                                                        });
                                                      },
                                                    ),
                                                    FilterChoiceChip(
                                                      text: "Documento",
                                                      initialValue:
                                                          searchByDocumento,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByDocumento = value;
                                                        });
                                                      },
                                                    ),
                                                    FilterChoiceChip(
                                                      text: "Teléfono",
                                                      initialValue:
                                                          searchByTelefono,
                                                      onSelected: (value) {
                                                        setState(() {
                                                          searchByTelefono = value;
                                                        });
                                                      },
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 6, 12, 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "Estado: ",
                                                      textAlign: TextAlign.right,
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 250,
                                                        child: DropDownMap(
                                                          map: Clientes()
                                                              .mapEstados(),
                                                          addAllOption: true,
                                                          addAllText: "Todos",
                                                          addAllValue: "T",
                                                          initialValue: "T",
                                                          onChanged: (value) {
                                                            setState(() {
                                                              searchIdEstado = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      TopLabel(
                                                        labelText: "Nacionalidad",
                                                        padding: EdgeInsets.all(0),
                                                      ),
                                                      CountryCodePicker(
                                                        onChanged: print,
                                                        countryFilter: ["AR"],
                                                        initialSelection: searchIdPais,
                                                        showCountryOnly: true,
                                                        showOnlyCountryWhenClosed: true,
                                                        alignLeft: false,
                                                        hideMainText: false,
                                                        dialogSize: Size(
                                                          SizeConfig.blockSizeHorizontal * 20,
                                                          SizeConfig.blockSizeVertical * 25
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            )
                          ]),
                        ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: AppLoader(builder: (scheduler) {
                      return ZMTable(
                        key: Key(searchText +
                            searchIdPais +
                            searchIdEstado.toString() +
                            refreshValue.toString() +
                            searchByNombres.toString() +
                            searchByApellidos.toString() +
                            searchTipo.toString() +
                            searchByRazonSocial.toString() +
                            searchByEmail.toString() +
                            searchByDocumento.toString() +
                            searchByTelefono.toString()),
                        model: Clientes(),
                        service: ClientesService(),
                        listMethodConfiguration: ClientesService().buscarClientes({
                          "Clientes": {
                            "Nombres": searchByNombres ? searchText : null,
                            "Apellidos": searchByApellidos ? searchText : null,
                            "RazonSocial": searchByRazonSocial ? searchText : null,
                            "Email": searchByEmail ? searchText : null,
                            "Documento": searchByDocumento ? searchText : null,
                            "Telefono": searchByTelefono ? searchText : null,
                            "Estado": searchIdEstado,
                            "Tipo": searchTipo
                          }
                        }),
                        pageLength: 12,
                        paginate: true,
                        cellBuilder: {
                          "Clientes": {
                            "Nombres": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center,
                              );
                            },
                            "Apellidos": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center
                              );
                            },
                            "RazonSocial": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center
                              );
                            },
                            "Tipo": (value) {
                              return Text(
                                Clientes().mapTipo()[value.toString()] != null ? Clientes().mapTipo()[value.toString()] : "-",
                                textAlign: TextAlign.center
                              )
                              ;
                            },
                            "Documento": (value) {
                              return Text(
                                value.toString(),
                                textAlign: TextAlign.center
                              );
                            },
                            "Telefono": (value) {
                              return Text(
                                value.toString(),
                                textAlign: TextAlign.center
                              );
                            },
                          },
                        },
                        tableLabels: {
                          "Clientes": {
                            "Telefono": "Teléfono",
                            "RazonSocial": "Razón Social"
                          }
                        },
                        fixedActions: [
                          ZMStdButton(
                            color: Colors.green,
                            text: Text(
                              "Crear cliente",
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
                                barrierDismissible: false,
                                barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return CrearClientesAlertDialog(
                                    title: "Crear cliente",
                                    onSuccess: () {
                                      Navigator.of(context).pop(true);
                                      setState(() {
                                        searchText = "";
                                        refreshValue = Random().nextInt(99999);
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          )
                        ],
                        onSelectActions: (clientes) {
                          bool estadosIguales = true;
                          String estado;
                          if (clientes.length >= 1) {
                            Map<String, dynamic> anterior;
                            for (Clientes cliente in clientes) {
                              Map<String, dynamic> mapCliente = cliente.toMap();
                              if (anterior != null) {
                                if (anterior["Clientes"]["Estado"] !=
                                    mapCliente["Clientes"]["Estado"]) {
                                  estadosIguales = false;
                                }
                              }
                              if (!estadosIguales) break;
                              anterior = mapCliente;
                            }
                            if (estadosIguales) {
                              estado = clientes[0].toMap()["Clientes"]["Estado"];
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
                                          clientes.length.toString() +
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
                                            models: clientes,
                                            title: (estado == "A"
                                                    ? "Dar de baja"
                                                    : "Dar de alta") +
                                                " " +
                                                clientes.length.toString() +
                                                " clientes",
                                            service: ClientesService(),
                                            doMethodConfiguration: estado == "A"
                                                ? ClientesService()
                                                    .bajaConfiguration()
                                                : ClientesService()
                                                    .altaConfiguration(),
                                            payload: (mapModel) {
                                              return {
                                                "Clientes": {
                                                  "IdCliente": mapModel["Clientes"]
                                                      ["IdCliente"]
                                                }
                                              };
                                            },
                                            itemBuilder: (mapModel) {
                                              if (mapModel["Clientes"]["Tipo"] ==
                                                  "F") {
                                                return Text(mapModel["Clientes"]
                                                        ["Nombres"] +
                                                    " " +
                                                    mapModel["Clientes"]
                                                        ["Apellidos"]);
                                              } else {
                                                return Text(mapModel["Clientes"]
                                                    ["RazonSocial"]);
                                              }
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
                                "Borrar (" + clientes.length.toString() + ")",
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
                                      models: clientes,
                                      title: "Borrar " +
                                          clientes.length.toString() +
                                          " clientes",
                                      service: ClientesService(),
                                      doMethodConfiguration:
                                          ClientesService().borraConfiguration(),
                                      payload: (mapModel) {
                                        return {
                                          "Clientes": {
                                            "IdCliente": mapModel["Clientes"]
                                                ["IdCliente"]
                                          }
                                        };
                                      },
                                      itemBuilder: (mapModel) {
                                        if (mapModel["Clientes"]["Tipo"] == "F") {
                                          return Text(mapModel["Clientes"]
                                                  ["Nombres"] +
                                              " " +
                                              mapModel["Clientes"]["Apellidos"]);
                                        } else {
                                          return Text(
                                              mapModel["Clientes"]["RazonSocial"]);
                                        }
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
                          Clientes cliente;
                          String estado = "A";
                          int idCliente = 0;
                          if (mapModel != null) {
                            cliente = Clientes().fromMap(mapModel);
                            if (mapModel["Clientes"] != null) {
                              if (mapModel["Clientes"]["Estado"] != null) {
                                estado = mapModel["Clientes"]["Estado"];
                              }
                              if (mapModel["Clientes"]["IdCliente"] != null) {
                                idCliente = mapModel["Clientes"]["IdCliente"];
                              }
                            }
                          }
                          return <Widget>[
                            
                            ZMTooltip(
                              message: "Ver domicilios",
                              visible: idCliente != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.home_outlined,
                                onPressed: idCliente == 0 ? null : () {
                                  if(idCliente != 0) {
                                    final NavigationService _navigationService = locator<NavigationService>();
                                    _navigationService.navigateTo("/domicilios?IdCliente="+idCliente.toString());
                                  }
                                }
                              ),
                            ),
                            ZMTooltip(
                              key: Key("EstadoCliente"+estado),
                              message: estado == "A" ? "Dar de baja" : "Dar de alta",
                              theme: estado == "A" ? ZMTooltipTheme.RED : ZMTooltipTheme.GREEN,
                              visible: idCliente != 0,
                              child: IconButtonTableAction(
                                iconData: (estado == "A"
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                                color: estado == "A" ? Colors.redAccent : Colors.green,
                                onPressed: idCliente == 0 ? null : () {
                                  if (idCliente != 0) {
                                    if (estado == "A") {
                                      ClientesService(scheduler: scheduler).baja({
                                        "Clientes": {"IdCliente": idCliente}
                                      }).then((response) {
                                        if (response.status == RequestStatus.SUCCESS) {
                                          itemsController.add(ItemAction(
                                              event: ItemEvents.Update,
                                              index: index,
                                              updateMethodConfiguration:
                                                  ClientesService().dameConfiguration(
                                                      cliente.idCliente)));
                                        }
                                      });
                                    } else {
                                      ClientesService(scheduler: scheduler).alta({
                                        "Clientes": {"IdCliente": idCliente}
                                      }).then((response) {
                                        if (response.status == RequestStatus.SUCCESS) {
                                          itemsController.add(ItemAction(
                                              event: ItemEvents.Update,
                                              index: index,
                                              updateMethodConfiguration:
                                                  ClientesService().dameConfiguration(
                                                      cliente.idCliente)));
                                        }
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            ZMTooltip(
                              message: "Modificar",
                              visible: idCliente != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.edit,
                                onPressed: idCliente == 0 ? null : () {
                                  if (idCliente != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return ModelView(
                                          service: ClientesService(),
                                          getMethodConfiguration: ClientesService()
                                              .dameConfiguration(idCliente),
                                          isList: false,
                                          itemBuilder: (mapModel, internalIndex,
                                              itemController) {
                                            return ModificarClientesAlertDialog(
                                              title: "Modificar Cliente",
                                              cliente: Clientes().fromMap(mapModel),
                                              onSuccess: () {
                                                Navigator.of(context).pop();
                                                itemsController.add(ItemAction(
                                                    event: ItemEvents.Update,
                                                    index: index,
                                                    updateMethodConfiguration:
                                                        ClientesService()
                                                            .dameConfiguration(
                                                                cliente.idCliente)));
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            ZMTooltip(
                              message: "Borrar",
                              theme: ZMTooltipTheme.RED,
                              visible: idCliente != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.delete_outline,
                                onPressed: idCliente == 0 ? null : () {
                                  if (idCliente != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return DeleteAlertDialog(
                                          title: "Borrar cliente",
                                          message:
                                              "¿Está seguro que desea eliminar el cliente?",
                                          onAccept: () async {
                                            await ClientesService().borra({
                                              "Clientes": {"IdCliente": idCliente}
                                            }).then((response) {
                                              if (response.status ==RequestStatus.SUCCESS) {
                                                itemsController.add(
                                                  ItemAction(
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
                              ),
                            )
                          ];
                        },
                        searchArea: TableTitle(title: "Clientes"),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
