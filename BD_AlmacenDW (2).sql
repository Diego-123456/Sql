--[Usando base de datos por defecto]
USE master;
GO
--[Validar existencia]
IF DB_ID(N'almacen_dw')IS NOT NULL BEGIN
     DROP DATABASE almacen_dw;
END
GO
--[Crear base de datos]
CREATE DATABASE almacen_dw;
GO
USE almacen_dw;
GO
CREATE SCHEMA tabla;
GO
CREATE SCHEMA procedimiento;
GO

CREATE TABLE tabla.dimension_marca
(
    id INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_dimension_marca_id PRIMARY KEY CLUSTERED(id)
);
GO
CREATE TABLE tabla.dimension_categoria
(
    id INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_dimension_categoria_id PRIMARY KEY CLUSTERED(id)
);
GO
CREATE TABLE tabla.dimension_subcategoria
(
    id INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    categoria INT NOT NULL,
    CONSTRAINT pk_dimension_subcategoria_id PRIMARY KEY CLUSTERED(id),
    CONSTRAINT fk_dimension_subcategoria_categoria FOREIGN KEY(categoria) REFERENCES tabla.dimension_categoria(id)
    --[Relacionado con el Foreign Key si es eliminado o actualizado]
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO
CREATE TABLE tabla.dimension_tiempo
(
    id INT IDENTITY(1,1),
    fecha DATE NOT NULL,
    dia INT NOT NULL,
    nombre_dia VARCHAR(50) NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    CONSTRAINT pk_dimension_tiempo_id PRIMARY KEY CLUSTERED(id)
);
GO
--[Limitación de esquema]
CREATE TABLE tabla.dimension_producto
(
    id INT IDENTITY(1,1),
    marca INT NOT NULL,
    subcategoria INT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    peso INT NOT NULL,
    altura INT NOT NULL,
    anchura INT NOT NULL,
    profundidad INT NOT NULL,
    CONSTRAINT pk_dimension_producto_id PRIMARY KEY CLUSTERED(id),
    CONSTRAINT fk_dimension_producto_marca FOREIGN KEY(marca) REFERENCES tabla.dimension_marca(id),
    CONSTRAINT fk_dimension_producto_subcategoria FOREIGN KEY(subcategoria) REFERENCES tabla.dimension_subcategoria(id)
    --[Relacionado con el Foreign Key si es eliminado o actualizado]
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

CREATE TABLE tabla.dimension_guia(
    id_guia int identity (1,1),
	nro_doc char(7) not null,
	fec_guia date not null
	CONSTRAINT pk_dimension_guia_id_guia PRIMARY KEY CLUSTERED(id_guia)
);
GO

CREATE TABLE tabla.dimension_proveedor(
	id_prov int identity (1,1),
	ruc_prov char(11) not null,
	nom_prov varchar(40) not null,
	dir_prov varchar(40) not null,
	tel_prov varchar (9) not null,
	region char(1) not null,
	correo_prov varchar(40) not null,
	CONSTRAINT pk_dimension_proveedor_id_prov PRIMARY KEY CLUSTERED(id_prov)
);
GO

--[Tabla central de las dimensiones]
CREATE TABLE tabla.hechos_almacen(
    tiempo INT NOT NULL,
    producto INT NOT NULL,
	guia INT NOT NULL,
	prov INT NOT NULL,
	CONSTRAINT fk_hechos_almacen_guia FOREIGN KEY(guia) REFERENCES tabla.dimension_guia(id_guia),
    CONSTRAINT fk_hechos_almacen_prov FOREIGN KEY(prov) REFERENCES tabla.dimension_proveedor(id_prov),
    CONSTRAINT fk_hechos_almacen_tiempo FOREIGN KEY(tiempo) REFERENCES tabla.dimension_tiempo(id),
    CONSTRAINT fk_hechos_almacen_producto FOREIGN KEY(producto) REFERENCES tabla.dimension_producto(id)
    --[Relacionado con el Foreign Key si es eliminado o actualizado]
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO
