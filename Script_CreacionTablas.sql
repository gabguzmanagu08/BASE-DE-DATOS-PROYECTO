--MAESTRAS

create schema Gguzman;
--CLIENTES
CREATE TABLE Gguzman.clientes (
    id_cliente SERIAL PRIMARY KEY,
    cedula VARCHAR(15) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(150),
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP
);

--EMPLEADOS
CREATE TABLE Gguzman.empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP
);

---CATEGORIAS
CREATE TABLE Gguzman.categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP
);

--PRODUCTOS
CREATE TABLE Gguzman.productos (
    id_producto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES Gguzman.categorias(id_categoria)
);

--TRANSACCIONALESSS

-- VENTAS
CREATE TABLE Gguzman.ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Gguzman.clientes(id_cliente),

    CONSTRAINT fk_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES Gguzman.empleados(id_empleado)

);

--DETALLE_VENTAS
CREATE TABLE Gguzman.detalle_venta (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP,

    CONSTRAINT fk_venta
        FOREIGN KEY (id_venta)
        REFERENCES Gguzman.ventas(id_venta),

    CONSTRAINT fk_producto
        FOREIGN KEY (id_producto)
        REFERENCES Gguzman.productos(id_producto)
);
