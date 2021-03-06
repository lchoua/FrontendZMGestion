import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/CategoriasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/services/Services.dart';

class GruposProductoService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  GruposProductoService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }


  @override
  DoMethodConfiguration crearConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El grupo de producto se ha creado con éxito"
      ),
      attributes: {
        "GruposProducto": [
          "Grupo",
          "Descripcion"
        ]
      }
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "El grupo de producto se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar el grupo de producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "El grupo de producto se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja el grupo de producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El grupo de producto ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el grupo de producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    return GruposProducto();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El grupo de producto ha sido modificado con éxito"
      )
    );
  }

  DoMethodConfiguration modificarPreciosConfiguration(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/gruposProducto/modificarPrecios",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "Los precios de los productos se han actualizado con éxito"
      )
    );
  }

  ListMethodConfiguration buscar(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: GruposProducto(),
      path: "/gruposProducto",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba el grupo de producto"
      )
    );
  }

  GetMethodConfiguration dameConfiguration(int idGrupoProducto){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: GruposProducto(),
      path: "/gruposProducto/dame",
      payload: {
        "GruposProducto": {
          "IdGrupoProducto": idGrupoProducto
        }
      },
      scheduler: scheduler
    );
  }
}