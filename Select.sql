---SELECT
--1) Top 5 clientes por gasto total (solo ventas activas)
--Enunciado:
--La tienda quiere reconocer a los 5 clientes que más han gastado. Usa un CTE para calcular el total gastado por cliente (ventas con --activo = TRUE) y muestra nombres, apellidos, email y total gastado, ordenado de mayor a menor.
WITH gasto_total AS (
  SELECT 
    c.nombres, 
    c.apellidos, 
    c.email, 
    SUM(v.total) AS total_gastado
  FROM Gguzman.clientes c
  INNER JOIN Gguzman.ventas v ON c.id_cliente = v.id_cliente
  WHERE v.activo = TRUE  -- Solo ventas activas
  GROUP BY c.id_cliente, c.nombres, c.apellidos, c.email
)
SELECT nombres, apellidos, email, total_gastado
FROM gasto_total
ORDER BY total_gastado DESC
LIMIT 5;



--2) Productos más vendidos: cantidad y monto + ranking con ventana
--Enunciado:
--Gerencia quiere conocer los productos más vendidos en cantidad y los que más ingresos generan. Para cada producto, calcula cantidad total vendida y monto total (sumando subtotal), considerando ventas activas. Agrega ranking por cantidad y por monto con funciones de ventana.
WITH ProductosVendidos AS (
    SELECT 
        prod.id_producto,
        prod.nombre,
        SUM(dv.cantidad) AS cantidad_total,
        SUM(dv.subtotal) AS monto_total
    FROM Gguzman.detalle_venta dv
    INNER JOIN Gguzman.productos prod ON dv.id_producto = prod.id_producto
    INNER JOIN Gguzman.ventas v ON dv.id_venta = v.id_venta 
    WHERE v.total > 0  
    GROUP BY prod.id_producto, prod.nombre
)
SELECT 
    id_producto,
    nombre,
    cantidad_total,
    monto_total,
    ROW_NUMBER() OVER (ORDER BY cantidad_total DESC) AS ranking_cantidad,
    ROW_NUMBER() OVER (ORDER BY monto_total DESC) AS ranking_monto
FROM ProductosVendidos
ORDER BY ranking_cantidad;



--3) Productividad por empleado: número de ventas, total y ticket promedio
--Enunciado:
--La empresa desea evaluar la productividad de cada empleado de ventas. Para cada empleado, muestra: número de ventas, total vendido y ticket promedio (total / número de ventas), solo con ventas activas. Ordena por total vendido de mayor a menor.

WITH ProductividadEmpleados AS (
    SELECT 
        e.id_empleado,
        e.nombres,
        e.apellidos,
        e.cargo,
        COUNT(v.id_venta) AS num_ventas,
        SUM(v.total) AS total_vendido,
        ROUND(SUM(v.total) / COUNT(v.id_venta), 2) AS ticket_promedio
    FROM Gguzman.empleados e
    INNER JOIN Gguzman.ventas v ON e.id_empleado = v.id_empleado
    WHERE v.total > 0 
    GROUP BY e.id_empleado, e.nombres, e.apellidos, e.cargo
)
SELECT 
    id_empleado,
    nombres || ' ' || apellidos AS empleado,
    cargo,
    num_ventas,
    total_vendido,
    ticket_promedio
FROM ProductividadEmpleados
ORDER BY total_vendido DESC;


--4) Ingresos por categoría y participación (%)
--Enunciado:
--Marketing necesita saber qué categorías aportan más a los ingresos. Calcula el ingreso total por categoría (sumando subtotales del detalle) y la participación porcentual sobre el total de ingresos, considerando productos y ventas activos.

WITH IngresosPorCategoria AS (
    SELECT 
        cat.id_categoria,
        cat.nombre AS categoria,
        SUM(dv.subtotal) AS ingreso_total
    FROM Gguzman.detalle_venta dv
    INNER JOIN Gguzman.productos prod ON dv.id_producto = prod.id_producto
    INNER JOIN Gguzman.categorias cat ON prod.id_categoria = cat.id_categoria
    WHERE dv.subtotal > 0  
    GROUP BY cat.id_categoria, cat.nombre
)
SELECT 
    ipc.id_categoria,
    ipc.categoria,
    ipc.ingreso_total,
    ROUND((ipc.ingreso_total * 100.0 / 
        (SELECT SUM(ingreso_total) FROM IngresosPorCategoria)
    ), 2) AS participacion_porcentual
FROM IngresosPorCategoria ipc
ORDER BY ipc.ingreso_total DESC;


--5) Auditoría: ventas donde el total no coincide con la suma del detalle
--Enunciado:
--Contabilidad quiere detectar posibles inconsistencias: ventas cuyo total no coincide con la suma de subtotal del detalle. Lista el id_venta, total declarado y total calculado, solo para ventas activas.

WITH TotalesCalculados AS (
    SELECT 
        dv.id_venta,
        SUM(dv.subtotal) AS total_calculado
    FROM Gguzman.detalle_venta dv
    GROUP BY dv.id_venta
)
SELECT 
    v.id_venta,
    v.total AS total_declarado,
    tc.total_calculado,
    v.total - tc.total_calculado AS diferencia
FROM Gguzman.ventas v
INNER JOIN TotalesCalculados tc ON v.id_venta = tc.id_venta
WHERE v.total > 0
ORDER BY ABS(v.total - tc.total_calculado) DESC;  
