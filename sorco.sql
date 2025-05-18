CREATE DATABASE SPI_SAR;
USE SPI_SAR;

-- Tabla Nodo
CREATE TABLE IF NOT EXISTS nodo (
  id_nodo BIGINT NOT NULL AUTO_INCREMENT,
  nombre_ciudad VARCHAR(100) DEFAULT NULL,
  latitud DOUBLE DEFAULT NULL,
  longitud DOUBLE DEFAULT NULL,
  PRIMARY KEY (id_nodo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla Ruta
CREATE TABLE IF NOT EXISTS ruta (
  id_ruta BIGINT NOT NULL AUTO_INCREMENT,
  origen_id BIGINT NOT NULL,
  destino_id BIGINT NOT NULL,
  distancia DOUBLE NOT NULL,
  PRIMARY KEY (id_ruta),
  FOREIGN KEY (origen_id) REFERENCES nodo(id_nodo) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (destino_id) REFERENCES nodo(id_nodo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla HistorialRuta
CREATE TABLE IF NOT EXISTS historial_ruta (
  id_historial BIGINT NOT NULL AUTO_INCREMENT,
  rutaConsultada BIGINT NOT NULL,
  fecha_consulta DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_historial),
  FOREIGN KEY (rutaConsultada) REFERENCES ruta(id_ruta) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla EstadisticaRuta
CREATE TABLE IF NOT EXISTS estadistica_ruta (
  id_estadistica BIGINT NOT NULL AUTO_INCREMENT,
  ruta_id BIGINT NOT NULL UNIQUE,
  cantidadConsultas INT DEFAULT 0,
  PRIMARY KEY (id_estadistica),
  FOREIGN KEY (ruta_id) REFERENCES ruta(id_ruta) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- Insertar nodos
INSERT INTO nodo (nombre_ciudad, latitud, longitud)
VALUES ('Córdoba', -31.4201, -64.1888),
       ('Rosario', -32.9442, -60.6505);

-- Insertar rutas
INSERT INTO ruta (origen_id, destino_id, distancia)
VALUES (1, 2, 400.65);

-- Insertar historial
INSERT INTO historial_ruta (rutaConsultada , fecha_consulta)
VALUES (1 , '2025/05/17');

-- Insertar estadística
INSERT INTO estadistica_ruta (ruta_id, cantidadConsultas)
VALUES (1, 24);



-- Ver todas las rutas con ciudades
SELECT r.id_ruta, nodo1.nombre_ciudad AS origen, nodo2.nombre_ciudad AS destino, r.distancia
FROM ruta r
JOIN nodo nodo1 ON r.origen_id = n1.id_nodo
JOIN nodo nodo2 ON r.destino_id = n2.id_nodo;

-- Ver historial de consultas
SELECT hr.id_historial, hr.fecha_consulta, r.id_ruta, n1.nombre_ciudad AS origen, n2.nombre_ciudad AS destino
FROM historial_ruta hr
JOIN ruta r ON hr.rutaConsultada = r.id_ruta
JOIN nodo n1 ON r.origen_id = n1.id_nodo
JOIN nodo n2 ON r.destino_id = n2.id_nodo;

-- Ver estadísticas de ruta
SELECT er.ruta_id, er.cantidadConsultas, n1.nombre_ciudad AS origen, n2.nombre_ciudad AS destino
FROM estadistica_ruta er
JOIN ruta r ON er.ruta_id = r.id_ruta
JOIN nodo n1 ON r.origen_id = n1.id_nodo
JOIN nodo n2 ON r.destino_id = n2.id_nodo;



-- Borrar historial específico
DELETE FROM historial_ruta WHERE id_historial = 1;

-- Borrar una ruta (se eliminará también de historial y estadísticas si están referenciadas)
DELETE FROM ruta WHERE id_ruta = 1;


