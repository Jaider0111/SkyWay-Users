import 'package:flutter/material.dart';

final List<String> categories = [
  "Alimentos",
  "Restaurantes",
  "Farmacia",
  "Varios",
];

final Map<String, List<String>> subcategories = {
  "Alimentos": [
    "Frutas",
    "Verduras",
    "Lacteos",
    "Carnicos",
    "Viveres",
    "Pasabocas",
    "Bebidas",
    "Panaderia",
  ],
  "Restaurantes": [
    "Desayunos",
    "Almuerzos",
    "Comidas Rapidas",
    "Comida de mar",
    "Parrilla",
    "Bebidas",
    "Postres",
    "Tipica",
  ],
  "Farmacia": [
    "Medicamentos",
    "Aseo personal",
    "Aseo del hogar",
    "Cosmeticos",
  ],
  "Varios": [
    "Ferreteria",
    "Papeleria",
    "Mascotas",
  ],
  "default": [],
};

final Map<String, IconData> catIcons = {
  "Alimentos": Icons.shopping_basket,
  "Restaurantes": Icons.restaurant,
  "Farmacia": Icons.medical_services,
  "Varios": Icons.add_to_photos,
};
