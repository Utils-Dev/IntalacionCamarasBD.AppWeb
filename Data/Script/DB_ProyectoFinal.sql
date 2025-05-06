CREATE DATABASE InstalacionCamarasDB;
GO
USE InstalacionCamarasDB;
GO

--  esquemas
CREATE SCHEMA Configuracion;
CREATE SCHEMA RecursosHumanos;
CREATE SCHEMA Inventario;
CREATE SCHEMA Ventas;
CREATE SCHEMA Compras;
GO

-- Tabla Roles dentro del esquema Configuracion
CREATE TABLE Configuracion.Roles (
    IdRol INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

-- Tabla Estados dentro del esquema Configuracion
CREATE TABLE Configuracion.Estados (
    IdEstado INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

-- Tabla Usuarios dentro del esquema RecursosHumanos
CREATE TABLE RecursosHumanos.Usuarios (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    IdRol INT NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
	IdEstado INT DEFAULT 1,
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (IdRol) REFERENCES Configuracion.Roles(IdRol),
	CONSTRAINT FK_Usuarios_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Empleados dentro del esquema RecursosHumanos
CREATE TABLE RecursosHumanos.Empleados (
    IdEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NULL,
    Correo VARCHAR(100) UNIQUE NULL,
    FechaContratacion DATETIME DEFAULT GETDATE(),
    IdUsuario INT NULL,
    IdEstado INT DEFAULT 1,
	CONSTRAINT FK_Empleados_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado),
    CONSTRAINT FK_Empleados_Usuarios FOREIGN KEY (IdUsuario) REFERENCES RecursosHumanos.Usuarios(IdUsuario)
);
GO

-- Tabla Categorias dentro del esquema Inventario
CREATE TABLE Inventario.Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) UNIQUE NOT NULL,
    Descripcion VARCHAR(255) NULL,
     IdEstado INT DEFAULT 1,
	CONSTRAINT FK_Categorias_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Marcas dentro del esquema Inventario
CREATE TABLE Inventario.Marcas (
    IdMarca INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
     IdEstado INT DEFAULT 1,
	CONSTRAINT FK_Marcas_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Productos dentro del esquema Inventario
CREATE TABLE Inventario.Productos (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    IdCategoria INT NOT NULL,
    IdMarca INT NULL,
    IdEstado INT DEFAULT 1,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (IdCategoria) REFERENCES Inventario.Categorias(IdCategoria),
    CONSTRAINT FK_Productos_Marcas FOREIGN KEY (IdMarca) REFERENCES Inventario.Marcas(IdMarca),
	CONSTRAINT FK_Productos_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Servicios dentro del esquema Inventario
CREATE TABLE Inventario.Servicios (
    IdServicio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Precio DECIMAL(10,2) NOT NULL,
    IdEstado INT DEFAULT 1,
	CONSTRAINT FK_Servicios_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Clientes dentro del esquema Ventas
CREATE TABLE Ventas.Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NULL,
    DUI CHAR(9) UNIQUE NULL,
    Correo VARCHAR(100) UNIQUE NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    IdUsuarioModificacion INT NULL,
    IdEstado INT DEFAULT 1,
    CONSTRAINT FK_Clientes_Usuarios FOREIGN KEY (IdUsuarioModificacion) REFERENCES RecursosHumanos.Usuarios(IdUsuario) ON DELETE SET NULL,
	CONSTRAINT FK_Clientes_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Ventas dentro del esquema Ventas
CREATE TABLE Ventas.Ventas (
    IdVenta INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdUsuarioCreacion INT NOT NULL,
    IdUsuarioModificacion INT NULL,
    FechaVenta DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    IVA DECIMAL(10,2) NOT NULL,
    IdEstado INT NOT NULL,
    CONSTRAINT FK_Ventas_Clientes FOREIGN KEY (IdCliente) REFERENCES Ventas.Clientes(IdCliente),
    CONSTRAINT FK_Ventas_UsuariosCreacion FOREIGN KEY (IdUsuarioCreacion) REFERENCES RecursosHumanos.Usuarios(IdUsuario),
    CONSTRAINT FK_Ventas_UsuariosModificacion FOREIGN KEY (IdUsuarioModificacion) REFERENCES RecursosHumanos.Usuarios(IdUsuario),
    CONSTRAINT FK_Ventas_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla DetalleVentas dentro del esquema Ventas
CREATE TABLE Ventas.DetalleVentas (
    IdDetalleVenta INT IDENTITY(1,1) PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdProducto INT NULL,
    IdServicio INT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleVentas_Ventas FOREIGN KEY (IdVenta) REFERENCES Ventas.Ventas(IdVenta),
    CONSTRAINT FK_DetalleVentas_Productos FOREIGN KEY (IdProducto) REFERENCES Inventario.Productos(IdProducto),
    CONSTRAINT FK_DetalleVentas_Servicios FOREIGN KEY (IdServicio) REFERENCES Inventario.Servicios(IdServicio)
);
GO

-- Tabla Devoluciones dentro del esquema Ventas
CREATE TABLE Ventas.Devoluciones (
    IdDevolucion INT IDENTITY(1,1) PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdUsuario INT NOT NULL, -- quién procesó la devolución
    FechaDevolucion DATETIME DEFAULT GETDATE(),
    TotalDevuelto DECIMAL(10,2) NOT NULL,
    Observaciones VARCHAR(255) NULL, 
    IdEstado INT DEFAULT 1,
    CONSTRAINT FK_Devoluciones_Ventas FOREIGN KEY (IdVenta) REFERENCES Ventas.Ventas(IdVenta),
    CONSTRAINT FK_Devoluciones_Usuarios FOREIGN KEY (IdUsuario) REFERENCES RecursosHumanos.Usuarios(IdUsuario),
    CONSTRAINT FK_Devoluciones_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);

-- Tabla DetalleDevoluciones dentro del esquema Ventas
CREATE TABLE Ventas.DetalleDevoluciones (
    IdDetalleDevolucion INT IDENTITY(1,1) PRIMARY KEY,
    IdDevolucion INT NOT NULL,
    IdProducto INT NULL,
    IdServicio INT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    Motivo VARCHAR(255) NULL, 
    CONSTRAINT FK_DetalleDevoluciones_Devoluciones FOREIGN KEY (IdDevolucion) REFERENCES Ventas.Devoluciones(IdDevolucion),
    CONSTRAINT FK_DetalleDevoluciones_Productos FOREIGN KEY (IdProducto) REFERENCES Inventario.Productos(IdProducto),
    CONSTRAINT FK_DetalleDevoluciones_Servicios FOREIGN KEY (IdServicio) REFERENCES Inventario.Servicios(IdServicio)
);

-- Tabla Proveedores dentro del esquema Compras
CREATE TABLE Compras.Proveedores (
    IdProveedor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NULL,
    Correo VARCHAR(100) UNIQUE NULL,
    Direccion VARCHAR(255) NULL,
    IdEstado INT DEFAULT 1,
	CONSTRAINT FK_Proveedores_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla Compras dentro del esquema Compras
CREATE TABLE Compras.Compras (
    IdCompra INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuarioCreacion INT NOT NULL,
    IdUsuarioModificacion INT NULL,
    IdProveedor INT NOT NULL,
    IVA DECIMAL(10,2) NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    IdEstado INT NOT NULL,
    CONSTRAINT FK_Compras_UsuariosCreacion FOREIGN KEY (IdUsuarioCreacion) REFERENCES RecursosHumanos.Usuarios(IdUsuario),
    CONSTRAINT FK_Compras_UsuariosModificacion FOREIGN KEY (IdUsuarioModificacion) REFERENCES RecursosHumanos.Usuarios(IdUsuario),
    CONSTRAINT FK_Compras_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Compras.Proveedores(IdProveedor),
    CONSTRAINT FK_Compras_Estados FOREIGN KEY (IdEstado) REFERENCES Configuracion.Estados(IdEstado)
);
GO

-- Tabla DetalleCompras dentro del esquema Compras
CREATE TABLE Compras.DetalleCompras (
    IdDetalleCompra INT IDENTITY(1,1) PRIMARY KEY,
    IdCompra INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleCompras_Compras FOREIGN KEY (IdCompra) REFERENCES Compras.Compras(IdCompra),
    CONSTRAINT FK_DetalleCompras_Productos FOREIGN KEY (IdProducto) REFERENCES Inventario.Productos(IdProducto)
);
GO

-- Tabla CierreCaja dentro del esquema Ventas
CREATE TABLE Ventas.CierreCaja (
    IdCierreCaja INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    FechaCierre DATETIME DEFAULT GETDATE(),
    TotalVentas DECIMAL(10,2) NOT NULL,
    TotalEfectivo DECIMAL(10,2) NOT NULL,
    TotalTarjeta DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_CierreCaja_Usuarios FOREIGN KEY (IdUsuario) REFERENCES RecursosHumanos.Usuarios(IdUsuario)
);
GO

-- Tabla Historial dentro del esquema Configuracion
CREATE TABLE Configuracion.Historial (
    IdHistorial INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    Accion VARCHAR(255) NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Historial_Usuarios FOREIGN KEY (IdUsuario) REFERENCES RecursosHumanos.Usuarios(IdUsuario)
);
GO




----PROCEDIMIENTOS ALMACENADOS------------
---:::::::::::::::::::::::::TABLA ROL::::::::::::::::::::::::::::::::::::::::-------------
-- Insertar un nuevo rol
CREATE PROCEDURE Configuracion.SP_InsertarRol
    @Nombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Configuracion.Roles WHERE Nombre = @Nombre)
        BEGIN
            PRINT 'AVISO: El rol que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Configuracion.Roles (Nombre)
            VALUES (@Nombre);
            PRINT 'AVISO: El rol se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un rol existente
CREATE PROCEDURE Configuracion.SP_ActualizarRol
    @IdRol INT,
    @NuevoNombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Configuracion.Roles WHERE Nombre = @NuevoNombre AND IdRol <> @IdRol)
        BEGIN
            PRINT 'AVISO: El rol que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Configuracion.Roles
            SET Nombre = @NuevoNombre
            WHERE IdRol = @IdRol;
            PRINT 'El rol se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todos los roles
CREATE PROCEDURE Configuracion.SP_ObtenerRoles
AS
BEGIN
    SELECT IdRol AS 'Código', Nombre
    FROM Configuracion.Roles;
END;
GO

-- Obtener un rol por ID
CREATE PROCEDURE Configuracion.SP_ObtenerRolPorId
    @IdRol INT
AS
BEGIN
    SELECT IdRol AS 'Código', Nombre
    FROM Configuracion.Roles
    WHERE IdRol = @IdRol;
END;
GO

CREATE PROCEDURE Configuracion.SP_EliminarRol
    @IdRol INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Configuracion.Roles
        WHERE IdRol = @IdRol;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

---:::::::::::::::::::::::::::FIN TABLA ROL ::::::::::::::::::::::::::::::::::::::-------------

---::::::::::::::::::::::::::::TABLA ESTADOS:::::::::::::::::::::::::::::::::::::-------------
-- Insertar un nuevo estado
CREATE PROCEDURE Configuracion.SP_InsertarEstado
    @Nombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Configuracion.Estados WHERE Nombre = @Nombre)
        BEGIN
            PRINT 'AVISO: El estado que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Configuracion.Estados (Nombre)
            VALUES (@Nombre);
            PRINT 'AVISO: El estado se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un estado existente
CREATE PROCEDURE Configuracion.SP_ActualizarEstado
    @IdEstado INT,
    @NuevoNombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Configuracion.Estados WHERE Nombre = @NuevoNombre AND IdEstado <> @IdEstado)
        BEGIN
            PRINT 'AVISO: El estado que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Configuracion.Estados
            SET Nombre = @NuevoNombre
            WHERE IdEstado = @IdEstado;
            PRINT 'El estado se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todos los estados
CREATE PROCEDURE Configuracion.SP_ObtenerEstados
AS
BEGIN
    SELECT IdEstado AS 'Código', Nombre
    FROM Configuracion.Estados;
END;
GO

-- Obtener un estado por ID
CREATE PROCEDURE Configuracion.SP_ObtenerEstadoPorId
    @IdEstado INT
AS
BEGIN
    SELECT IdEstado AS 'Código', Nombre
    FROM Configuracion.Estados
    WHERE IdEstado = @IdEstado;
END;
GO

CREATE PROCEDURE Configuracion.SP_EliminarEstado
    @IdEstado INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Configuracion.Estados
        WHERE IdEstado = @IdEstado;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

---:::::::::::::::::::::::::FIN TABLA ESTADOS ::::::::::::::::::::::::::::::::::::::::-------------


---::::::::::::::::::::::::: TABLA USUARIOS ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo usuario
CREATE PROCEDURE RecursosHumanos.SP_InsertarUsuario
    @Nombre VARCHAR(100),
    @Correo VARCHAR(100),
    @Password VARCHAR(255),
    @IdRol INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM RecursosHumanos.Usuarios WHERE Correo = @Correo)
        BEGIN
            PRINT 'AVISO: El usuario que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO RecursosHumanos.Usuarios (Nombre, Correo, Password, IdRol, FechaRegistro, IdEstado)
            VALUES (@Nombre, @Correo, @Password, @IdRol, GETDATE(), @IdEstado);
            PRINT 'AVISO: El usuario se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un usuario existente
CREATE PROCEDURE RecursosHumanos.SP_ActualizarUsuario
    @IdUsuario INT,
    @NuevoNombre VARCHAR(100),
    @NuevoCorreo VARCHAR(100),
    @NuevoPassword VARCHAR(255),
    @NuevoIdRol INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM RecursosHumanos.Usuarios WHERE Correo = @NuevoCorreo AND IdUsuario <> @IdUsuario)
        BEGIN
            PRINT 'AVISO: El usuario que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE RecursosHumanos.Usuarios
            SET Nombre = @NuevoNombre, Correo = @NuevoCorreo, Password = @NuevoPassword, IdRol = @NuevoIdRol, IdEstado = @IdEstado
            WHERE IdUsuario = @IdUsuario;
            PRINT 'El usuario se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todos los usuarios por estado
CREATE PROCEDURE RecursosHumanos.SP_ObtenerUsuariosPorEstado
    @Estado TINYINT
AS
BEGIN
    SELECT
        u.IdUsuario AS 'Código',
        u.Nombre,
        u.Correo,
        r.Nombre AS 'Rol',  
        u.FechaRegistro,
        u.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        RecursosHumanos.Usuarios u
    JOIN
        Configuracion.Estados e ON u.IdEstado = e.IdEstado
    JOIN
        Configuracion.Roles r ON u.IdRol = r.IdRol 
    WHERE
        u.IdEstado = @Estado;
END;
GO


-- Obtener un usuario por ID
CREATE PROCEDURE RecursosHumanos.SP_ObtenerUsuarioPorId
    @IdUsuario INT
AS
BEGIN
    SELECT
        u.IdUsuario AS 'Código',
        u.Nombre,
        u.Correo,
        r.Nombre AS 'Rol',  
        u.FechaRegistro,
        u.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        RecursosHumanos.Usuarios u
    JOIN
        Configuracion.Estados e ON u.IdEstado = e.IdEstado
    JOIN
        Configuracion.Roles r ON u.IdRol = r.IdRol  
    WHERE
        u.IdUsuario = @IdUsuario;
END;
GO



---:::::::::::::::::::::::::FIN TABLA USUARIOS ::::::::::::::::::::::::::::::::::::::::-------------



---::::::::::::::::::::::::: TABLA EMPLEADOS ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo empleado
CREATE PROCEDURE RecursosHumanos.SP_InsertarEmpleado
    @Nombre VARCHAR(100),
    @Telefono VARCHAR(15),
    @Correo VARCHAR(100),
    @FechaContratacion DATETIME,
    @IdUsuario INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM RecursosHumanos.Empleados WHERE Correo = @Correo)
        BEGIN
            PRINT 'AVISO: El empleado que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO RecursosHumanos.Empleados (Nombre, Telefono, Correo, FechaContratacion, IdUsuario, IdEstado )
            VALUES (@Nombre, @Telefono, @Correo, @FechaContratacion, @IdUsuario, @IdEstado);
            PRINT 'AVISO: El empleado se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un empleado existente
CREATE PROCEDURE RecursosHumanos.SP_ActualizarEmpleado
    @IdEmpleado INT,
    @NuevoNombre VARCHAR(100),
    @NuevoTelefono VARCHAR(15),
    @NuevoCorreo VARCHAR(100),
    @NuevaFechaContratacion DATETIME,
    @NuevoIdUsuario INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM RecursosHumanos.Empleados WHERE Correo = @NuevoCorreo AND IdEmpleado <> @IdEmpleado)
        BEGIN
            PRINT 'AVISO: El empleado que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE RecursosHumanos.Empleados
            SET Nombre = @NuevoNombre, Telefono = @NuevoTelefono, Correo = @NuevoCorreo, FechaContratacion = @NuevaFechaContratacion,
			IdUsuario = @NuevoIdUsuario, IdEstado = @IdEstado
            WHERE IdEmpleado = @IdEmpleado;
            PRINT 'El empleado se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todos los empleados 
CREATE PROCEDURE RecursosHumanos.SP_ObtenerEmpleados
    @Estado TINYINT = NULL,      
    @Nombre NVARCHAR(100) = NULL, 
    @Correo NVARCHAR(100) = NULL, 
    @Telefono NVARCHAR(15) = NULL
AS
BEGIN
    SELECT
        e.IdEmpleado AS 'Código',
        e.Nombre,
        e.Telefono,
        e.Correo,
        e.FechaContratacion,
        e.IdUsuario,
        e.IdEstado,
        es.Nombre AS 'Estado' 
    FROM
        RecursosHumanos.Empleados e
    JOIN
        Configuracion.Estados es ON e.IdEstado = es.IdEstado
    WHERE
        (@Estado IS NULL OR e.IdEstado = @Estado) AND
        (@Nombre IS NULL OR e.Nombre LIKE '%' + @Nombre + '%') AND
        (@Correo IS NULL OR e.Correo LIKE '%' + @Correo + '%') AND
        (@Telefono IS NULL OR e.Telefono LIKE '%' + @Telefono + '%');
END;
GO



-- Obtener un empleado por ID
CREATE PROCEDURE RecursosHumanos.SP_ObtenerEmpleadoPorId
    @IdEmpleado INT
AS
BEGIN
    SELECT
        e.IdEmpleado AS 'Código',
        e.Nombre,
        e.Telefono,
        e.Correo,
        e.FechaContratacion,
        e.IdUsuario,
        e.IdEstado,
        es.Nombre AS 'ESTADO'
    FROM
        RecursosHumanos.Empleados e
    JOIN
        Configuracion.Estados es ON e.IdEstado = es.IdEstado
    WHERE
        e.IdEmpleado = @IdEmpleado;
END;
GO

CREATE PROCEDURE RecursosHumanos.SP_EliminarEmpleado
    @IdEmpleado INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM RecursosHumanos.Empleados WHERE IdEmpleado = @IdEmpleado)
        BEGIN
            PRINT 'AVISO: El empleado no existe';
            RETURN;
        END

        DELETE FROM RecursosHumanos.Empleados
        WHERE IdEmpleado = @IdEmpleado;

        PRINT 'El empleado se ha eliminado  correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---:::::::::::::::::::::::::FIN TABLA EMPLEADOS ::::::::::::::::::::::::::::::::::::::::-------------



---::::::::::::::::::::::::: TABLA CATEGORIAS ::::::::::::::::::::::::::::::::::::::::-------------


-- Insertar una nueva categoría
CREATE PROCEDURE Inventario.SP_InsertarCategoria
    @Nombre VARCHAR(100),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Categorias WHERE Nombre = @Nombre)
        BEGIN
            PRINT 'AVISO: La categoría que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Inventario.Categorias (Nombre, IdEstado)
            VALUES (@Nombre, @IdEstado);
            PRINT 'AVISO: La categoría se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar una categoría existente
CREATE PROCEDURE Inventario.SP_ActualizarCategoria
    @IdCategoria INT,
    @NuevoNombre VARCHAR(100),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Categorias WHERE Nombre = @NuevoNombre AND IdCategoria <> @IdCategoria)
        BEGIN
            PRINT 'AVISO: La categoría que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Inventario.Categorias
            SET Nombre = @NuevoNombre, IdEstado = @IdEstado
            WHERE IdCategoria = @IdCategoria;
            PRINT 'La categoría se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todas las categorías 
CREATE PROCEDURE Inventario.SP_ObtenerCategorias
    @Estado INT = NULL,       
    @Nombre NVARCHAR(100) = NULL, 
    @Descripcion NVARCHAR(255) = NULL
AS
BEGIN
    SELECT
        c.IdCategoria AS 'Código',
        c.Nombre,
        c.Descripcion,
        c.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Inventario.Categorias c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR c.IdEstado = @Estado) AND
        (@Nombre IS NULL OR c.Nombre LIKE '%' + @Nombre + '%') AND
        (@Descripcion IS NULL OR c.Descripcion LIKE '%' + @Descripcion + '%');
END;
GO


-- Obtener una categoría por Id
CREATE PROCEDURE Inventario.SP_ObtenerCategoriaPorId
    @IdCategoria INT
AS
BEGIN
    SELECT
        c.IdCategoria AS 'Código',
        c.Nombre,
        c.Descripcion,
        c.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Inventario.Categorias c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    WHERE
        c.IdCategoria = @IdCategoria;
END;
GO

CREATE PROCEDURE Inventario.SP_EliminarCategoria
    @IdCategoria INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Inventario.Categorias WHERE IdCategoria = @IdCategoria)
        BEGIN
            PRINT 'AVISO: La categoría no existe';
            RETURN;
        END

        DELETE FROM Inventario.Categorias
        WHERE IdCategoria = @IdCategoria;

        PRINT 'La categoría se ha eliminado físicamente correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


---:::::::::::::::::::::::::FIN TABLA CATEGORIAS ::::::::::::::::::::::::::::::::::::::::-------------


---::::::::::::::::::::::::: TABLA MARCA ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar una nueva marca
CREATE PROCEDURE Inventario.SP_InsertarMarca
    @Nombre VARCHAR(100),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Marcas WHERE Nombre = @Nombre)
        BEGIN
            PRINT 'AVISO: La marca que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Inventario.Marcas (Nombre, IdEstado)
            VALUES (@Nombre, @IdEstado);
            PRINT 'AVISO: La marca se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar una marca existente
CREATE PROCEDURE Inventario.SP_ActualizarMarca
    @IdMarca INT,
    @NuevoNombre VARCHAR(100),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Marcas WHERE Nombre = @NuevoNombre AND IdMarca <> @IdMarca)
        BEGIN
            PRINT 'AVISO: La marca que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Inventario.Marcas
            SET Nombre = @NuevoNombre, IdEstado = @IdEstado  WHERE IdMarca = @IdMarca;
            PRINT 'La marca se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todas las marcas 
CREATE PROCEDURE Inventario.SP_ObtenerMarcas
    @Estado INT = NULL,    
    @Nombre NVARCHAR(100) = NULL 
AS
BEGIN
    SELECT
        m.IdMarca AS 'Código',
        m.Nombre,
        m.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Inventario.Marcas m
    JOIN
        Configuracion.Estados e ON m.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR m.IdEstado = @Estado) AND
        (@Nombre IS NULL OR m.Nombre LIKE '%' + @Nombre + '%');
END;
GO


-- Obtener una marca por ID
CREATE PROCEDURE Inventario.SP_ObtenerMarcaPorId
    @IdMarca INT
AS
BEGIN
    SELECT
        m.IdMarca AS 'Código',
        m.Nombre,
        m.IdEstado,
        e.Nombre AS 'Estado'
    FROM
        Inventario.Marcas m
    JOIN
        Configuracion.Estados e ON m.IdEstado = e.IdEstado
    WHERE
        m.IdMarca = @IdMarca;
END;
GO


CREATE PROCEDURE Inventario.SP_EliminarMarca
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Inventario.Marcas WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'AVISO: La marca no existe';
            RETURN;
        END

        DELETE FROM Inventario.Marcas
        WHERE IdMarca = @IdMarca;

        PRINT 'La marca se ha eliminado  correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---:::::::::::::::::::::::::FIN TABLA MARCAS ::::::::::::::::::::::::::::::::::::::::-------------


---::::::::::::::::::::::::: TABLA PRODUCTOS ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo producto
CREATE PROCEDURE Inventario.SP_InsertarProducto
    @Nombre VARCHAR(150),
    @Descripcion VARCHAR(255),
    @Precio DECIMAL(10,2),
    @Stock INT,
    @IdCategoria INT,
    @IdMarca INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Inventario.Productos (Nombre, Descripcion, Precio, Stock, IdCategoria, IdMarca, IdEstado)
        VALUES (@Nombre, @Descripcion, @Precio, @Stock, @IdCategoria, @IdMarca, @IdEstado);
        PRINT 'AVISO: El producto se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un producto existente
CREATE PROCEDURE Inventario.SP_ActualizarProducto
    @IdProducto INT,
    @NuevoNombre VARCHAR(150),
    @NuevaDescripcion VARCHAR(255),
    @NuevoPrecio DECIMAL(10,2),
    @NuevoStock INT,
    @NuevoIdCategoria INT,
    @NuevoIdMarca INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        UPDATE Inventario.Productos
        SET Nombre = @NuevoNombre, Descripcion = @NuevaDescripcion, Precio = @NuevoPrecio, Stock = @NuevoStock, IdCategoria = @NuevoIdCategoria, IdMarca = @NuevoIdMarca, IdEstado = @IdEstado
        WHERE IdProducto = @IdProducto;
        PRINT 'El producto se ha actualizado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todos los productos 
CREATE PROCEDURE Inventario.SP_ObtenerProductos
    @Estado TINYINT = NULL,      
    @Nombre NVARCHAR(100) = NULL, 
    @Descripcion NVARCHAR(255) = NULL, 
    @IdCategoria INT = NULL,     
    @IdMarca INT = NULL         
AS
BEGIN
    SELECT
        p.IdProducto AS 'Código',
        p.Nombre,
        p.Descripcion,
        p.Precio,
        p.Stock,
        p.IdCategoria,
        c.Nombre AS 'Categoria',  
        p.IdMarca,
        m.Nombre AS 'Marca',      
        p.IdEstado,
        e.Nombre AS 'Estado'      
    FROM
        Inventario.Productos p
    JOIN
        Configuracion.Estados e ON p.IdEstado = e.IdEstado
    LEFT JOIN
        Inventario.Categorias c ON p.IdCategoria = c.IdCategoria
    LEFT JOIN
        Inventario.Marcas m ON p.IdMarca = m.IdMarca
    WHERE
        (@Estado IS NULL OR p.IdEstado = @Estado) AND
        (@Nombre IS NULL OR p.Nombre LIKE '%' + @Nombre + '%') AND
        (@Descripcion IS NULL OR p.Descripcion LIKE '%' + @Descripcion + '%') AND
        (@IdCategoria IS NULL OR p.IdCategoria = @IdCategoria) AND
        (@IdMarca IS NULL OR p.IdMarca = @IdMarca);
END;
GO



-- Obtener un producto por ID
CREATE PROCEDURE Inventario.SP_ObtenerProductoPorId
    @IdProducto INT
AS
BEGIN
    SELECT
        p.IdProducto AS 'Código',
        p.Nombre,
        p.Descripcion,
        p.Precio,
        p.Stock,
        p.IdCategoria,
        c.Nombre AS 'Categoria', 
        p.IdMarca,
        m.Nombre AS 'Marca', 
        p.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Inventario.Productos p
    JOIN
        Configuracion.Estados e ON p.IdEstado = e.IdEstado
    LEFT JOIN
        Inventario.Categorias c ON p.IdCategoria = c.IdCategoria
    LEFT JOIN
        Inventario.Marcas m ON p.IdMarca = m.IdMarca
    WHERE
        p.IdProducto = @IdProducto;
END;
GO

CREATE PROCEDURE Inventario.SP_EliminarProducto
    @IdProducto INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Inventario.Productos WHERE IdProducto = @IdProducto)
        BEGIN
            PRINT 'AVISO: El producto no existe';
            RETURN;
        END

        DELETE FROM Inventario.Productos
        WHERE IdProducto = @IdProducto;

        PRINT 'El producto se ha eliminado físicamente correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


---:::::::::::::::::::::::::FIN TABLA PRODUCTOS ::::::::::::::::::::::::::::::::::::::::-------------


---::::::::::::::::::::::::: TABLA SERVICIOS ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo servicio
CREATE PROCEDURE Inventario.SP_InsertarServicio
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255),
    @Precio DECIMAL(10,2),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Servicios WHERE Nombre = @Nombre)
        BEGIN
            PRINT 'AVISO: El servicio que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Inventario.Servicios (Nombre, Descripcion, Precio, IdEstado)
            VALUES (@Nombre, @Descripcion, @Precio, @IdEstado);
            PRINT 'AVISO: El servicio se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un servicio existente
CREATE PROCEDURE Inventario.SP_ActualizarServicio
    @IdServicio INT,
    @NuevoNombre VARCHAR(100),
    @NuevaDescripcion VARCHAR(255),
    @NuevoPrecio DECIMAL(10,2),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Inventario.Servicios WHERE Nombre = @NuevoNombre AND IdServicio <> @IdServicio)
        BEGIN
            PRINT 'AVISO: El servicio que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Inventario.Servicios
            SET Nombre = @NuevoNombre, Descripcion = @NuevaDescripcion, Precio = @NuevoPrecio,  IdEstado = @IdEstado
            WHERE IdServicio = @IdServicio;
            PRINT 'El servicio se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todos los servicios 
CREATE PROCEDURE Inventario.SP_ObtenerServicios
    @Estado INT = NULL,       
    @Nombre NVARCHAR(100) = NULL, 
    @Descripcion NVARCHAR(255) = NULL 
AS
BEGIN
    SELECT
        s.IdServicio AS 'Código',
        s.Nombre,
        s.Descripcion,
        s.Precio,
        s.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Inventario.Servicios s
    JOIN
        Configuracion.Estados e ON s.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR s.IdEstado = @Estado) AND
        (@Nombre IS NULL OR s.Nombre LIKE '%' + @Nombre + '%') AND
        (@Descripcion IS NULL OR s.Descripcion LIKE '%' + @Descripcion + '%');
END;
GO


-- Obtener un servicio por ID
CREATE PROCEDURE Inventario.SP_ObtenerServicioPorId
    @IdServicio INT
AS
BEGIN
    SELECT
        s.IdServicio AS 'Código',
        s.Nombre,
        s.Descripcion,
        s.Precio,
        s.IdEstado,
        e.Nombre AS 'Estado'
    FROM
        Inventario.Servicios s
    JOIN
        Configuracion.Estados e ON s.IdEstado = e.IdEstado
    WHERE
        s.IdServicio = @IdServicio;
END;
GO

CREATE PROCEDURE Inventario.SP_EliminarServicio
    @IdServicio INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Inventario.Servicios WHERE IdServicio = @IdServicio)
        BEGIN
            PRINT 'AVISO: El servicio no existe';
            RETURN;
        END

        DELETE FROM Inventario.Servicios
        WHERE IdServicio = @IdServicio;
        PRINT 'El servicio se ha eliminado físicamente correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


---:::::::::::::::::::::::::FIN TABLA SERVICIOS ::::::::::::::::::::::::::::::::::::::::-------------


---::::::::::::::::::::::::: TABLA CLIENTES ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo cliente
CREATE PROCEDURE Ventas.SP_InsertarCliente
    @Nombre VARCHAR(100),
    @Telefono VARCHAR(15),
    @Correo VARCHAR(100),
    @DUI CHAR(9),
    @IdUsuarioModificacion INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Ventas.Clientes WHERE Correo = @Correo OR DUI = @DUI)
        BEGIN
            PRINT 'AVISO: El cliente que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Ventas.Clientes (Nombre, Telefono, Correo, DUI, FechaRegistro, FechaModificacion, IdUsuarioModificacion, IdEstado)
            VALUES (@Nombre, @Telefono, @Correo, @DUI, GETDATE(), GETDATE(), @IdUsuarioModificacion, @IdEstado);
            PRINT 'AVISO: El cliente se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un cliente existente
CREATE PROCEDURE Ventas.SP_ActualizarCliente
    @IdCliente INT,
    @NuevoNombre VARCHAR(100),
    @NuevoTelefono VARCHAR(15),
    @NuevoCorreo VARCHAR(100),
    @NuevoDUI CHAR(9),
    @IdUsuarioModificacion INT,
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Ventas.Clientes WHERE (Correo = @NuevoCorreo OR DUI = @NuevoDUI) AND IdCliente <> @IdCliente)
        BEGIN
            PRINT 'AVISO: El cliente que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Ventas.Clientes
            SET Nombre = @NuevoNombre, Telefono = @NuevoTelefono, Correo = @NuevoCorreo, DUI = @NuevoDUI, FechaModificacion = GETDATE(), IdUsuarioModificacion = @IdUsuarioModificacion,
			IdEstado = @IdEstado
            WHERE IdCliente = @IdCliente;
            PRINT 'El cliente se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Obtener todos los clientes 
CREATE PROCEDURE Ventas.SP_ObtenerClientes
    @Estado INT = NULL,       
    @Nombre NVARCHAR(100) = NULL, 
    @Correo NVARCHAR(100) = NULL, 
    @DUI CHAR(9) = NULL            
AS
BEGIN
    SELECT
        c.IdCliente AS 'Código',
        c.Nombre,
        c.Telefono,
        c.Correo,
        c.DUI,
        c.FechaRegistro,
        c.FechaModificacion,
        c.IdUsuarioModificacion,
        c.IdEstado,
        e.Nombre AS 'Estado'
    FROM
        Ventas.Clientes c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR c.IdEstado = @Estado) AND
        (@Nombre IS NULL OR c.Nombre LIKE '%' + @Nombre + '%') AND
        (@Correo IS NULL OR c.Correo LIKE '%' + @Correo + '%') AND
        (@DUI IS NULL OR c.DUI = @DUI);
END;
GO


-- Obtener un cliente por ID
CREATE PROCEDURE Ventas.SP_ObtenerClientePorId
    @IdCliente INT
AS
BEGIN
    SELECT
        c.IdCliente AS 'Código',
        c.Nombre,
        c.Telefono,
        c.Correo,
        c.DUI,
        c.FechaRegistro,
        c.FechaModificacion,
        c.IdUsuarioModificacion,
        c.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Ventas.Clientes c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    WHERE
        c.IdCliente = @IdCliente;
END;
GO

-- Obtener un cliente por ID

CREATE PROCEDURE Ventas.SP_EliminarCliente
    @IdCliente INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Ventas.Clientes WHERE IdCliente = @IdCliente)
        BEGIN
            PRINT 'AVISO: El cliente no existe';
            RETURN;
        END

        DELETE FROM Ventas.Clientes WHERE IdCliente = @IdCliente;

        PRINT 'El cliente se ha eliminado físicamente correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

---:::::::::::::::::::::::::FIN  TABLA CLIENTES ::::::::::::::::::::::::::::::::::::::::-------------




---:::::::::::::::::::::::::  TABLA VENTAS ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar una nueva venta
CREATE PROCEDURE Ventas.SP_InsertarVenta
    @IdCliente INT,
    @IdUsuarioCreacion INT,
    @IdUsuarioModificacion INT,
    @Total DECIMAL(10,2),
    @IVA DECIMAL(10,2),
    @IdEstado INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Ventas.Ventas (IdCliente, IdUsuarioCreacion, IdUsuarioModificacion, FechaVenta, FechaModificacion, Total, IVA, IdEstado)
        VALUES (@IdCliente, @IdUsuarioCreacion, @IdUsuarioModificacion, GETDATE(), GETDATE(), @Total, @IVA, @IdEstado);
        PRINT 'AVISO: La venta se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar una venta existente
CREATE PROCEDURE Ventas.SP_ActualizarVenta
    @IdVenta INT,
    @NuevoIdCliente INT,
    @NuevoIdUsuarioModificacion INT,
    @NuevoTotal DECIMAL(10,2),
    @NuevoIVA DECIMAL(10,2),
    @NuevoIdEstado INT
AS
BEGIN
    BEGIN TRY
        UPDATE Ventas.Ventas
        SET IdCliente = @NuevoIdCliente, IdUsuarioModificacion = @NuevoIdUsuarioModificacion, FechaModificacion = GETDATE(), Total = @NuevoTotal, IVA = @NuevoIVA, IdEstado = @NuevoIdEstado
        WHERE IdVenta = @IdVenta;
        PRINT 'La venta se ha actualizado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Cambiar estado de una venta
CREATE PROCEDURE Ventas.SP_CambiarEstadoVenta
    @IdVenta INT,
    @NuevoEstado TINYINT
AS
BEGIN
    BEGIN TRY
        UPDATE Ventas.Ventas
        SET IdEstado = @NuevoEstado, FechaModificacion = GETDATE()
        WHERE IdVenta = @IdVenta;
        PRINT 'El estado de la venta se ha cambiado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todas las ventas 
CREATE PROCEDURE Ventas.SP_ObtenerVentas
    @Estado INT = NULL,
    @IdCliente INT = NULL,
    @IdUsuarioCreacion INT = NULL,
    @IdUsuarioModificacion INT = NULL,
    @FechaVentaInicio DATE = NULL,  
    @FechaVentaFin DATE = NULL,     
    @FechaModificacionInicio DATE = NULL,  
    @FechaModificacionFin DATE = NULL     
AS
BEGIN
    SELECT
        v.IdVenta AS 'Código',
        v.IdCliente,
        v.IdUsuarioCreacion,
        v.IdUsuarioModificacion,
        v.FechaVenta,
        v.FechaModificacion,
        v.Total,
        v.IVA,
        v.IdEstado,
        e.Nombre AS 'Estado'
    FROM
        Ventas.Ventas v
    JOIN
        Configuracion.Estados e ON v.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR v.IdEstado = @Estado) AND
        (@IdCliente IS NULL OR v.IdCliente = @IdCliente) AND
        (@IdUsuarioCreacion IS NULL OR v.IdUsuarioCreacion = @IdUsuarioCreacion) AND
        (@IdUsuarioModificacion IS NULL OR v.IdUsuarioModificacion = @IdUsuarioModificacion) AND
        (@FechaVentaInicio IS NULL OR v.FechaVenta >= @FechaVentaInicio) AND
        (@FechaVentaFin IS NULL OR v.FechaVenta <= @FechaVentaFin) AND
        (@FechaModificacionInicio IS NULL OR v.FechaModificacion >= @FechaModificacionInicio) AND
        (@FechaModificacionFin IS NULL OR v.FechaModificacion <= @FechaModificacionFin);
END;
GO



-- Obtener una venta por ID
CREATE PROCEDURE Ventas.SP_ObtenerVentaPorId
    @IdVenta INT
AS
BEGIN
    SELECT
        v.IdVenta AS 'Código',
        v.IdCliente,
        cl.Nombre AS 'Cliente',
        v.IdUsuarioCreacion,
        uc.Nombre AS 'UsuarioCreacion', 
        v.IdUsuarioModificacion,
        um.Nombre AS 'UsuarioModificacion', 
        v.FechaVenta,
        v.FechaModificacion,
        v.Total,
        v.IVA,
        v.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Ventas.Ventas v
    JOIN
        Configuracion.Estados e ON v.IdEstado = e.IdEstado
    LEFT JOIN
        Ventas.Clientes cl ON v.IdCliente = cl.IdCliente
    LEFT JOIN
        RecursosHumanos.Empleados uc ON v.IdUsuarioCreacion = uc.IdEmpleado
    LEFT JOIN
        RecursosHumanos.Empleados um ON v.IdUsuarioModificacion = um.IdEmpleado
    WHERE
        v.IdVenta = @IdVenta;
END;
GO


---:::::::::::::::::::::::::FIN  TABLA VENTAS ::::::::::::::::::::::::::::::::::::::::-------------


---:::::::::::::::::::::::::  TABLA DETALLE VENTAS ::::::::::::::::::::::::::::::::::::::::-------------
-- Insertar un nuevo detalle de venta
CREATE PROCEDURE Ventas.SP_InsertarDetalleVenta
    @IdVenta INT,
    @IdProducto INT,
    @IdServicio INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10,2),
    @Subtotal DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Ventas.DetalleVentas (IdVenta, IdProducto, IdServicio, Cantidad, PrecioUnitario, Subtotal)
        VALUES (@IdVenta, @IdProducto, @IdServicio, @Cantidad, @PrecioUnitario, @Subtotal);
        PRINT 'AVISO: El detalle de la venta se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener detalles de una venta por ID de venta
CREATE PROCEDURE Ventas.SP_ObtenerDetalleVentaPorIdVenta
    @IdVenta INT
AS
BEGIN
    SELECT
        dv.IdDetalleVenta AS 'Código',
        dv.IdVenta,
        dv.IdProducto,
        p.Nombre AS 'Producto', 
        dv.IdServicio,
        s.Nombre AS 'Servicio', 
        dv.Cantidad,
        dv.PrecioUnitario,
        dv.Subtotal
    FROM
        Ventas.DetalleVentas dv
    LEFT JOIN
        Inventario.Productos p ON dv.IdProducto = p.IdProducto
    LEFT JOIN
        Inventario.Servicios s ON dv.IdServicio = s.IdServicio
    WHERE
        dv.IdVenta = @IdVenta;
END;
GO


CREATE PROCEDURE Ventas.SP_ObtenerDetallesVentas
    @IdVenta INT = NULL,          
    @IdProducto INT = NULL,        
    @IdServicio INT = NULL,        
    @FechaVentaInicio DATE = NULL, 
    @FechaVentaFin DATE = NULL     
AS
BEGIN
    SELECT
        dv.IdDetalleVenta AS 'Código',
        dv.IdVenta,
        dv.IdProducto,
        p.Nombre AS 'Producto', 
        dv.IdServicio,
        s.Nombre AS 'Servicio', 
        dv.Cantidad,
        dv.PrecioUnitario,
        dv.Subtotal,
        v.FechaVenta
    FROM
        Ventas.DetalleVentas dv
    LEFT JOIN
        Inventario.Productos p ON dv.IdProducto = p.IdProducto
    LEFT JOIN
        Inventario.Servicios s ON dv.IdServicio = s.IdServicio
    JOIN
        Ventas.Ventas v ON dv.IdVenta = v.IdVenta
    WHERE
        (@IdVenta IS NULL OR dv.IdVenta = @IdVenta) AND
        (@IdProducto IS NULL OR dv.IdProducto = @IdProducto) AND
        (@IdServicio IS NULL OR dv.IdServicio = @IdServicio) AND
        (@FechaVentaInicio IS NULL OR v.FechaVenta >= @FechaVentaInicio) AND
        (@FechaVentaFin IS NULL OR v.FechaVenta <= @FechaVentaFin);
END;
GO

---::::::::::::::::::::::::: FIN TABLA DETALLE VENTAS ::::::::::::::::::::::::::::::::::::::::-------------

---:::::::::::::::::::::::::  TABLA  PROVEEDOR ::::::::::::::::::::::::::::::::::::::::-------------


-- Insertar un nuevo proveedor
CREATE PROCEDURE Compras.SP_InsertarProveedor
    @Nombre VARCHAR(100),
    @Telefono VARCHAR(15),
    @Correo VARCHAR(100),
    @Direccion VARCHAR(255),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Compras.Proveedores WHERE Nombre = @Nombre OR Correo = @Correo)
        BEGIN
            PRINT 'AVISO: El proveedor que intenta registrar ya existe';
        END
        ELSE
        BEGIN
            INSERT INTO Compras.Proveedores (Nombre, Telefono, Correo, Direccion, IdEstado)
            VALUES (@Nombre, @Telefono, @Correo, @Direccion, @IdEstado);
            PRINT 'AVISO: El proveedor se ha registrado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar un proveedor existente
CREATE PROCEDURE Compras.SP_ActualizarProveedor
    @IdProveedor INT,
    @NuevoNombre VARCHAR(100),
    @NuevoTelefono VARCHAR(15),
    @NuevoCorreo VARCHAR(100),
    @NuevaDireccion VARCHAR(255),
	@IdEstado INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Compras.Proveedores WHERE (Nombre = @NuevoNombre OR Correo = @NuevoCorreo) AND IdProveedor <> @IdProveedor)
        BEGIN
            PRINT 'AVISO: El proveedor que intenta modificar ya existe en la base de datos';
        END
        ELSE
        BEGIN
            UPDATE Compras.Proveedores
            SET Nombre = @NuevoNombre, Telefono = @NuevoTelefono, Correo = @NuevoCorreo, Direccion = @NuevaDireccion, IdEstado = @IdEstado
            WHERE IdProveedor = @IdProveedor;
            PRINT 'El proveedor se ha actualizado correctamente!';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



-- Obtener todos los proveedores 
CREATE PROCEDURE Compras.SP_ObtenerProveedores
    @Estado INT = NULL,      
    @Nombre NVARCHAR(100) = NULL,
    @Correo NVARCHAR(100) = NULL,
    @Telefono NVARCHAR(15) = NULL, 
    @Direccion NVARCHAR(255) = NULL 
AS
BEGIN
    SELECT
        p.IdProveedor AS 'Código',
        p.Nombre,
        p.Telefono,
        p.Correo,
        p.Direccion,
        p.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Compras.Proveedores p
    JOIN
        Configuracion.Estados e ON p.IdEstado = e.IdEstado
    WHERE
        (@Estado IS NULL OR p.IdEstado = @Estado) AND
        (@Nombre IS NULL OR p.Nombre LIKE '%' + @Nombre + '%') AND
        (@Correo IS NULL OR p.Correo LIKE '%' + @Correo + '%') AND
        (@Telefono IS NULL OR p.Telefono LIKE '%' + @Telefono + '%') AND
        (@Direccion IS NULL OR p.Direccion LIKE '%' + @Direccion + '%');
END;
GO


-- Obtener un proveedor por ID
CREATE PROCEDURE Compras.SP_ObtenerProveedorPorId
    @IdProveedor INT
AS
BEGIN
    SELECT
        p.IdProveedor AS 'Código',
        p.Nombre,
        p.Telefono,
        p.Correo,
        p.Direccion,
        p.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Compras.Proveedores p
    JOIN
        Configuracion.Estados e ON p.IdEstado = e.IdEstado
    WHERE
        p.IdProveedor = @IdProveedor;
END;
GO

CREATE PROCEDURE Compras.SP_EliminarProveedor
    @IdProveedor INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Compras.Proveedores WHERE IdProveedor = @IdProveedor)
        BEGIN
            PRINT 'AVISO: El proveedor no existe';
            RETURN;
        END

        DELETE FROM Compras.Proveedores
        WHERE IdProveedor = @IdProveedor;

        PRINT 'El proveedor se ha eliminado físicamente correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


---:::::::::::::::::::::::::  TABLA  COMPRA ::::::::::::::::::::::::::::::::::::::::-------------
-- Insertar una nueva compra
CREATE PROCEDURE Compras.SP_InsertarCompra
    @IdUsuarioCreacion INT,
    @IdUsuarioModificacion INT,
    @IdProveedor INT,
    @IVA DECIMAL(10,2),
    @Total DECIMAL(10,2),
    @IdEstado INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Compras.Compras (IdUsuarioCreacion, IdUsuarioModificacion, IdProveedor, IVA, Fecha, Total, IdEstado)
        VALUES (@IdUsuarioCreacion, @IdUsuarioModificacion, @IdProveedor, @IVA, GETDATE(), @Total, @IdEstado);
        PRINT 'AVISO: La compra se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Actualizar una compra existente
CREATE PROCEDURE Compras.SP_ActualizarCompra
    @IdCompra INT,
    @NuevoIdUsuarioModificacion INT,
    @NuevoIdProveedor INT,
    @NuevoIVA DECIMAL(10,2),
    @NuevoTotal DECIMAL(10,2),
    @NuevoIdEstado INT
AS
BEGIN
    BEGIN TRY
        UPDATE Compras.Compras
        SET IdUsuarioModificacion = @NuevoIdUsuarioModificacion, IdProveedor = @NuevoIdProveedor, IVA = @NuevoIVA, Total = @NuevoTotal, IdEstado = @NuevoIdEstado
        WHERE IdCompra = @IdCompra;
        PRINT 'La compra se ha actualizado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Cambiar estado de una compra
CREATE PROCEDURE Compras.SP_CambiarEstadoCompra
    @IdCompra INT,
    @NuevoEstado TINYINT
AS
BEGIN
    BEGIN TRY
        UPDATE Compras.Compras
        SET IdEstado = @NuevoEstado WHERE IdCompra = @IdCompra;
        PRINT 'El estado de la compra se ha cambiado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todas las compras 
CREATE PROCEDURE Compras.SP_ObtenerCompras
    @Estado TINYINT = NULL,      
    @IdUsuarioCreacion INT = NULL,   
    @IdUsuarioModificacion INT = NULL,
    @IdProveedor INT = NULL, 
    @IVA DECIMAL(10, 2) = NULL,
    @FechaInicio DATE = NULL,         
    @FechaFin DATE = NULL,           
    @Total DECIMAL(10, 2) = NULL
AS
BEGIN
    SELECT
        c.IdCompra AS 'Código',
        c.IdUsuarioCreacion,
        uc.Nombre AS 'UsuarioCreacion',
        c.IdUsuarioModificacion,
        um.Nombre AS 'UsuarioModificacion', 
        c.IdProveedor,
        p.Nombre AS 'Proveedor', 
        c.IVA,
        c.Fecha,
        c.Total,
        c.IdEstado,
        e.Nombre AS 'Estado' 
    FROM
        Compras.Compras c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    LEFT JOIN
        RecursosHumanos.Empleados uc ON c.IdUsuarioCreacion = uc.IdEmpleado
    LEFT JOIN
        RecursosHumanos.Empleados um ON c.IdUsuarioModificacion = um.IdEmpleado
    LEFT JOIN
        Compras.Proveedores p ON c.IdProveedor = p.IdProveedor
    WHERE
        (@Estado IS NULL OR c.IdEstado = @Estado) AND
        (@IdUsuarioCreacion IS NULL OR c.IdUsuarioCreacion = @IdUsuarioCreacion) AND
        (@IdUsuarioModificacion IS NULL OR c.IdUsuarioModificacion = @IdUsuarioModificacion) AND
        (@IdProveedor IS NULL OR c.IdProveedor = @IdProveedor) AND
        (@IVA IS NULL OR c.IVA = @IVA) AND
        (@FechaInicio IS NULL OR c.Fecha >= @FechaInicio) AND
        (@FechaFin IS NULL OR c.Fecha <= @FechaFin) AND
        (@Total IS NULL OR c.Total = @Total);
END;
GO


-- Obtener una compra por ID
CREATE PROCEDURE Compras.SP_ObtenerCompraPorId
    @IdCompra INT
AS
BEGIN
    SELECT
        c.IdCompra AS 'Código',
        c.IdUsuarioCreacion,
        uc.Nombre AS 'UsuarioCreacion',
        c.IdUsuarioModificacion,
        um.Nombre AS 'UsuarioModificacion',
        c.IdProveedor,
        p.Nombre AS 'Proveedor',
        c.IVA,
        c.Fecha,
        c.Total,
        c.IdEstado,
        e.Nombre AS 'Estado'
    FROM
        Compras.Compras c
    JOIN
        Configuracion.Estados e ON c.IdEstado = e.IdEstado
    LEFT JOIN
        RecursosHumanos.Empleados uc ON c.IdUsuarioCreacion = uc.IdEmpleado
    LEFT JOIN
        RecursosHumanos.Empleados um ON c.IdUsuarioModificacion = um.IdEmpleado
    LEFT JOIN
        Compras.Proveedores p ON c.IdProveedor = p.IdProveedor
    WHERE
        c.IdCompra = @IdCompra;
END;
GO




---::::::::::::::::::::::::: FIN TABLA  COMPRA ::::::::::::::::::::::::::::::::::::::::-------------



---:::::::::::::::::::::::::  TABLA  DETALLECOMPRA ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo detalle de compra
CREATE PROCEDURE Compras.SP_InsertarDetalleCompra
    @IdCompra INT,
    @IdProducto INT,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10,2),
    @Subtotal DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Compras.DetalleCompras (IdCompra, IdProducto, Cantidad, PrecioUnitario, Subtotal)
        VALUES (@IdCompra, @IdProducto, @Cantidad, @PrecioUnitario, @Subtotal);
        PRINT 'AVISO: El detalle de la compra se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener detalles de una compra por ID de compra
CREATE PROCEDURE Compras.SP_ObtenerDetalleCompraPorIdCompra
    @IdCompra INT
AS
BEGIN
    SELECT
        dc.IdDetalleCompra AS 'Código',
        dc.IdCompra,
        dc.IdProducto,
        p.Nombre AS 'Producto',
        dc.Cantidad,
        dc.PrecioUnitario,
        dc.Subtotal
    FROM
        Compras.DetalleCompras dc
    LEFT JOIN
        Inventario.Productos p ON dc.IdProducto = p.IdProducto
    WHERE
        dc.IdCompra = @IdCompra;
END;
GO

---::::::::::::::::::::::::: FIN  TABLA  DETALLECOMPRA ::::::::::::::::::::::::::::::::::::::::-------------


---:::::::::::::::::::::::::   TABLA  CIERRE CAJA ::::::::::::::::::::::::::::::::::::::::-------------

-- Insertar un nuevo cierre de caja
CREATE PROCEDURE Ventas.SP_InsertarCierreCaja
    @IdUsuario INT,
    @TotalVentas DECIMAL(10,2),
    @TotalCompras DECIMAL(10,2),
    @TotalEfectivo DECIMAL(10,2),
    @TotalTarjeta DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Ventas.CierreCaja (IdUsuario, FechaCierre, TotalVentas, TotalEfectivo, TotalTarjeta)
        VALUES (@IdUsuario, GETDATE(), @TotalVentas, @TotalEfectivo, @TotalTarjeta);
        PRINT 'AVISO: El cierre de caja se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener todos los cierres de caja
CREATE PROCEDURE Ventas.SP_ObtenerCierresCaja
AS
BEGIN
    SELECT
        cc.IdCierreCaja AS 'Código',
        cc.IdUsuario,
        u.Nombre AS 'Usuario',
        cc.FechaCierre,
        cc.TotalVentas,
        cc.TotalEfectivo,
        cc.TotalTarjeta
    FROM
        Ventas.CierreCaja cc
    LEFT JOIN
        RecursosHumanos.Usuarios u ON cc.IdUsuario = u.IdUsuario;
END;
GO


-- Obtener un cierre de caja por ID
CREATE PROCEDURE Ventas.SP_ObtenerCierreCajaPorId
    @IdCierreCaja INT
AS
BEGIN
    SELECT
        cc.IdCierreCaja AS 'Código',
        cc.IdUsuario,
        u.Nombre AS 'Usuario',
        cc.FechaCierre,
        cc.TotalVentas,
        cc.TotalEfectivo,
        cc.TotalTarjeta
    FROM
        Ventas.CierreCaja cc
    LEFT JOIN
        RecursosHumanos.Usuarios u ON cc.IdUsuario = u.IdUsuario
    WHERE
        cc.IdCierreCaja = @IdCierreCaja;
END;
GO


---::::::::::::::::::::::::: FIN  TABLA  CIERRE CAJA ::::::::::::::::::::::::::::::::::::::::-------------
-- Insertar una nueva acción en el historial
CREATE PROCEDURE Configuracion.SP_InsertarHistorial
    @IdUsuario INT,
    @Accion VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Configuracion.Historial (IdUsuario, Accion, Fecha)
        VALUES (@IdUsuario, @Accion, GETDATE());
        PRINT 'AVISO: La acción se ha registrado en el historial correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Obtener el historial de acciones
CREATE PROCEDURE Configuracion.SP_ObtenerHistorial
AS
BEGIN
    SELECT
        h.IdHistorial AS 'Código',
        h.IdUsuario,
        u.Nombre AS 'Usuario',
        h.Accion,
        h.Fecha
    FROM
        Configuracion.Historial h
    LEFT JOIN
        RecursosHumanos.Usuarios u ON h.IdUsuario = u.IdUsuario;
END;
GO


-- Obtener el historial de acciones por ID de usuario
CREATE PROCEDURE Configuracion.SP_ObtenerHistorialPorUsuario
    @IdUsuario INT
AS
BEGIN
    SELECT
        h.IdHistorial AS 'Código',
        h.IdUsuario,
        u.Nombre AS 'Usuario',
        h.Accion,
        h.Fecha
    FROM
        Configuracion.Historial h
    LEFT JOIN
        RecursosHumanos.Usuarios u ON h.IdUsuario = u.IdUsuario
    WHERE
        h.IdUsuario = @IdUsuario;
END;
GO


CREATE PROCEDURE Ventas.SP_RegistrarDevolucion
    @IdVenta INT,
    @IdUsuario INT,
    @TotalDevuelto DECIMAL(10,2),
    @Observaciones VARCHAR(255),
    @IdEstado INT 
AS
BEGIN
    INSERT INTO Ventas.Devoluciones (IdVenta, IdUsuario, TotalDevuelto, Observaciones, IdEstado)
    VALUES (@IdVenta, @IdUsuario, @TotalDevuelto, @Observaciones, @IdEstado);
END;
GO


CREATE PROCEDURE Ventas.SP_InsertarDetalleDevolucion
    @IdDevolucion INT,
    @IdProducto INT = NULL,
    @IdServicio INT = NULL,
    @Cantidad INT,
    @PrecioUnitario DECIMAL(10,2),
    @Subtotal DECIMAL(10,2),
    @Motivo VARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Ventas.DetalleDevoluciones (IdDevolucion, IdProducto, IdServicio, Cantidad, PrecioUnitario, Subtotal, Motivo)
        VALUES (@IdDevolucion, @IdProducto, @IdServicio, @Cantidad, @PrecioUnitario, @Subtotal, @Motivo);

        PRINT 'AVISO: El detalle de la devolución se ha registrado correctamente!';
    END TRY
    BEGIN CATCH
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE Ventas.SP_ObtenerDevolucionesYDetalles
AS
BEGIN
    SELECT 
        d.IdDevolucion AS 'CódigoDevolucion', 
        d.IdVenta, 
        v.FechaVenta AS 'FechaVenta', 
        d.IdUsuario, 
        u.Nombre AS 'Usuario', 
        d.TotalDevuelto, 
        d.Observaciones, 
        d.FechaDevolucion, 
        d.IdEstado, 
        e.Nombre AS 'Estado',
        dd.IdDetalleDevolucion AS 'CódigoDetalle', 
        dd.IdProducto, 
        p.Nombre AS 'Producto', 
        dd.IdServicio, 
        s.Nombre AS 'Servicio', 
        dd.Cantidad, 
        dd.PrecioUnitario, 
        dd.Subtotal, 
        dd.Motivo
    FROM 
        Ventas.Devoluciones d
    JOIN 
        Ventas.Ventas v ON d.IdVenta = v.IdVenta
    JOIN 
        RecursosHumanos.Usuarios u ON d.IdUsuario = u.IdUsuario
    JOIN 
        Configuracion.Estados e ON d.IdEstado = e.IdEstado
    LEFT JOIN 
        Ventas.DetalleDevoluciones dd ON dd.IdDevolucion = d.IdDevolucion
    LEFT JOIN 
        Inventario.Productos p ON dd.IdProducto = p.IdProducto
    LEFT JOIN 
        Inventario.Servicios s ON dd.IdServicio = s.IdServicio;
END;
GO


----TRIGGERS-------
CREATE TRIGGER TgAfterInsertDetalleCompra
ON Compras.DetalleCompras
AFTER INSERT
AS
BEGIN
    UPDATE Inventario.Productos  SET Stock = Stock + (SELECT Cantidad FROM inserted WHERE inserted.IdProducto = Inventario.Productos.IdProducto)
    WHERE IdProducto IN (SELECT IdProducto FROM inserted);
END;
GO


CREATE TRIGGER TgAfterInsertDetalleVenta
ON Ventas.DetalleVentas
AFTER INSERT
AS
BEGIN
    UPDATE Inventario.Productos SET Stock = Stock - (SELECT Cantidad FROM inserted WHERE inserted.IdProducto = Inventario.Productos.IdProducto)
    WHERE IdProducto IN (SELECT IdProducto FROM inserted);
END;
GO


CREATE TRIGGER TgAfterInsertDetalleDevolucion
ON Ventas.DetalleDevoluciones
AFTER INSERT
AS
BEGIN
    UPDATE Inventario.Productos SET Stock = Stock + (SELECT Cantidad FROM inserted WHERE inserted.IdProducto = Inventario.Productos.IdProducto)
    WHERE IdProducto IN (SELECT IdProducto FROM inserted);
END;
GO


CREATE TRIGGER TgAfterInsertVenta
ON Ventas.Ventas
AFTER INSERT
AS
BEGIN
    INSERT INTO Configuracion.Historial (Fecha, Accion, IdUsuario)
    SELECT GETDATE(), 
           'Venta Ingresada: ' + CAST(IdVenta AS VARCHAR) + ' - Cliente: ' + CAST(IdCliente AS VARCHAR), 
           IdUsuarioCreacion
    FROM inserted;
END;
GO

CREATE TRIGGER TgAfterInsertCompra
ON Compras.Compras
AFTER INSERT
AS
BEGIN
    INSERT INTO Configuracion.Historial (Fecha, Accion, IdUsuario)
    SELECT GETDATE(), 
           'Compra Ingresada: ' + CAST(IdCompra AS VARCHAR) + ' - Proveedor: ' + CAST(IdProveedor AS VARCHAR), 
           IdUsuarioCreacion
    FROM inserted;
END;
GO


CREATE TRIGGER TgAfterInsertDevolucion
ON Ventas.Devoluciones
AFTER INSERT
AS
BEGIN
    INSERT INTO Configuracion.Historial (Fecha, Accion, IdUsuario)
    SELECT GETDATE(), 
           'Devolución Ingresada: ' + CAST(IdDevolucion AS VARCHAR) + ' - Venta: ' + CAST(IdVenta AS VARCHAR), 
           IdUsuario
    FROM inserted;
END;
GO
