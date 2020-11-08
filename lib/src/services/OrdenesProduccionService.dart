import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/services/Services.dart';

class OrdenesProduccionService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  OrdenesProduccionService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }

  GetMethodConfiguration dameConfiguration(int idOrdenProduccion){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: OrdenesProduccion(),
      path: "/ordenesProduccion/dame",
      payload: {
        "OrdenesProduccion": {
          "IdOrdenProduccion": idOrdenProduccion
        }
      },
      scheduler: scheduler
    );
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La orden de producción se ha creado con éxito"
      ),
      attributes: {
        "OrdenesProduccion": [
          "IdVenta", "Observaciones"
        ]
      }
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    return null;
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return null;
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "La orden de producción ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar la orden de producción, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return OrdenesProduccion();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La orden de producción ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarOrdenesProduccion(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: OrdenesProduccion(),
      path: "/ordenesProduccion",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba la orden de producción"
      )
    );
  }

  @override
  DoMethodConfiguration crearLineaOrdenProduccion(LineasProducto lineaProducto) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de ordenProduccion se ha creado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdReferencia", "Cantidad", "PrecioUnitario"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }

  @override
  DoMethodConfiguration modificarLineaOrdenProduccion(LineasProducto lineaProducto) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de ordenProduccion se ha modificado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdLineaProducto", "IdReferencia", "Cantidad", "PrecioUnitario"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }

  @override
  DoMethodConfiguration pasarAPendiente(Map<String, dynamic> payload) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/pasarAPendiente",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La orden de producción se ha creado con éxito"
      )
    );
  }

  @override
  DoMethodConfiguration borrarLineaOrdenProduccion(Map<String, dynamic> payload) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/borrar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de ordenProduccion se ha eliminado con éxito"
      )
    );
  }
}