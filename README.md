# 🛒 Ecommerce Demo – SQL + Diagrama

Este repositorio contiene una demo de base de datos para un sistema de ecommerce, desarrollada como ejercicio de diseño y práctica de SQL.

## 💡 Objetivo

Simular el backend de una tienda online desde el punto de vista del modelado de datos y las operaciones SQL más comunes, incluyendo el uso de CTEs (Common Table Expressions) y procedimientos almacenados para inserciones.

## 📁 Contenido

- `diagram.jpg`: Diagrama entidad-relación del modelo propuesto (productos, usuarios, órdenes, etc.)
- `ecommerce-demo-create.sql`: Script SQL para crear las tablas necesarias
- `ecommerce-demo-cte-procedure-to-insert.sql`: Script que implementa inserciones usando procedimientos almacenados y CTEs

## 🧠 Aprendizajes clave

- Modelado de relaciones 1:N y N:M en bases de datos relacionales
- Creación de esquemas SQL bien estructurados
- Uso de CTEs para estructurar inserciones complejas
- Implementación de procedimientos almacenados para encapsular lógica de inserción

## 🚀 Cómo usarlo

1. Abrí tu cliente de base de datos (como pgAdmin, DBeaver o la CLI de PostgreSQL).
2. Ejecutá el script `ecommerce-demo-create.sql` para crear las tablas.
3. Luego ejecutá `ecommerce-demo-cte-procedure-to-insert.sql` para cargar los datos de prueba usando procedimientos.
4. Explorá la base con queries propias para analizar las relaciones y estructuras.

## 🧩 Ideas para extender

- Agregar más lógica a los procedimientos almacenados (validaciones, logs, etc.)
- Crear vistas para consultar ventas por usuario/producto
- Desarrollar una API sobre esta base de datos
- Conectarlo con un frontend simple

---

### 📫 Sobre mí

Soy analista funcional y data engineer con experiencia en el diseño de soluciones de datos, modelado eficiente y automatización de procesos. Este tipo de ejercicios me permite reforzar los fundamentos que aplico en proyectos reales.

