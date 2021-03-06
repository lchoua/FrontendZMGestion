import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/Tareas.dart';
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
    return null;
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    return null;
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
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
    return OrdenesProduccion();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
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

  DoMethodConfiguration crearLineaOrdenProduccion(LineasProducto lineaProducto, List<Map<String, dynamic>> stockUbicaciones) {
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
      payload: {
        "LineasProducto": {
          "IdReferencia": lineaProducto.idReferencia,
          "Cantidad": lineaProducto.cantidad,
          "PrecioUnitario": lineaProducto.precioUnitario
        },
        "ProductosFinales": {
          "IdProducto": lineaProducto.productoFinal.idProducto,
          "IdTela": lineaProducto.productoFinal.idTela,
          "IdLustre": lineaProducto.productoFinal.idLustre,
        },
        "Ubicaciones": stockUbicaciones
      },
    );
  }

  DoMethodConfiguration cancelarLineaOrdenProduccio(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/cancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de orden de producción se ha cancelado con éxito"
      )
    );
  }

  DoMethodConfiguration reanudarLineaOrdenProduccion(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/reanudar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de orden de producción se ha reanudado con éxito"
      )
    );
  }

  DoMethodConfiguration verificarLineaOrdenProduccion(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/verificar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de orden de producción se ha verificado con éxito"
      )
    );
  }

  DoMethodConfiguration modificarLineaOrdenProduccion(LineasProducto lineaProducto) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "La linea de ordenProduccion se ha modificado con éxito"
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

  DoMethodConfiguration pasarAPendiente(Map<String, dynamic> payload) {
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

  DoMethodConfiguration borrarLineaOrdenProduccion(Map<String, dynamic> payload) {
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

  ListMethodConfiguration listarTareas(int idLineaOrdenProduccion) {
    return ListMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se listaban las tareas"
      ),
      payload:{
        "LineasProducto": {
          "IdLineaProducto": idLineaOrdenProduccion
        }
      },
    );
  }

  DoMethodConfiguration crearTarea(Tareas tarea) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se creaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration eliminarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/borrar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se eliminaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration ejecutarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/ejecutar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se iniciaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration pausarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/pausar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se pausaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration reanudarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/reanudar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se reanudaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration cancelarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/cancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se cancelaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration finalizarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/finalizar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se finalizaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }

  DoMethodConfiguration verificarTarea(Tareas tarea){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ordenesProduccion/lineasOrdenProduccion/tareas/verificar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: Tareas(),
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        errorMessage: "Ha ocurrido un error mientras se verificaba la tarea"
      ),
      payload: tarea.toMap(),
    );
  }
}