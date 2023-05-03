-- Creación de la base de datos

CREATE DATABASE "Desafio4-Victor-Martinez-374";

-- Ingresando a la base de datos

\c "Desafio4-Victor-Martinez-374" 

-- Creación de la tabla Peliculas y tags

CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32)
);

--1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las claves primarias, foráneas y tipos de datos.

CREATE TABLE peliculas_tags (
    id INTEGER PRIMARY KEY,
    pelicula_id INTEGER,
    tag_id INTEGER,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

--2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados. 

-- Insertar películas
INSERT INTO peliculas (id, nombre, anno) VALUES
(1, 'Titanic', 1997),
(2, 'El Padrino', 1972),
(3, 'Pulp Fiction', 1994),
(4, 'El Señor de los Anillos: El Retorno del Rey', 2003),
(5, 'La La Land', 2016);

-- Insertar tags
INSERT INTO tags (id, tag) VALUES
(1, 'Romance'),
(2, 'Drama'),
(3, 'Crimen'),
(4, 'Fantasía'),
(5, 'Musical');

-- Insertar tags para la primera película
INSERT INTO peliculas_tags (id, pelicula_id, tag_id) VALUES
(1, 1, 1), -- Tag 1 asociado a la película 1 (Titanic)
(2, 1, 2); -- Tag 2 asociado a la película 1 (Titanic)

-- Insertar tags para la tercera película
INSERT INTO peliculas_tags (id, pelicula_id, tag_id) VALUES
(6, 3, 3), -- Tag 3 asociado a la película 3 (Pulp Fiction)
(7, 3, 4), -- Tag 4 asociado a la película 3 (Pulp Fiction)
(8, 3, 5); -- Tag 5 asociado a la película 3 (Pulp Fiction)

--3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.

SELECT peliculas.id, peliculas.nombre, COUNT(peliculas_tags.tag_id) AS cantidad_tags
FROM peliculas
LEFT JOIN peliculas_tags ON peliculas.id = peliculas_tags.pelicula_id
GROUP BY peliculas.id, peliculas.nombre;

--4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos

-- Crear la tabla "preguntas" con clave primaria "id"
CREATE TABLE preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR(255)
);

-- Crear la tabla "usuarios" con clave primaria "id"
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

-- Crear la tabla "respuestas" con claves primarias "id" y claves foráneas referenciando a las tablas "usuarios" y "preguntas"
CREATE TABLE respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

--5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.

-- Insertar usuarios
INSERT INTO usuarios (id, nombre, edad) VALUES
(1, 'Juan', 25),
(2, 'Maria', 30),
(3, 'Carlos', 22),
(4, 'Laura', 28),
(5, 'Pedro', 35);

--Insertar preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Quién descubrió América?', 'Cristóbal Colón'),
(2, '¿Cuál es la capital de Chile?', 'Santiago'),
(3, '¿Cuántos días tiene el mes de febrero en un año no bisiesto?', '28'),
(4, '¿Cuál es el resultado de 2 + 2?', '4'),
(5, '¿En qué año se fundó la ciudad de Santiago?', '1541');

--Insertar respuestas
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(1, 'Cristóbal Colón', 1, 1), -- Respuesta correcta a la pregunta 1 por el usuario 1 (Juan)
(2, 'Cristóbal Colón', 2, 1), -- Respuesta correcta a la pregunta 1 por el usuario 2 (Maria)
(3, 'Napoleón Bonaparte', 3, 1), -- Respuesta incorrecta a la pregunta 1 por el usuario 3 (Carlos)
(4, 'Santiago', 2, 2), -- Respuesta correcta a la pregunta 2 por el usuario 2 (Maria)
(5, 'Lima', 4, 2), -- Respuesta incorrecta a la pregunta 2 por el usuario 4 (Laura)
(6, '30', 3, 3), -- Respuesta incorrecta a la pregunta 3 por el usuario 3 (Carlos)
(7, '4', 4, 4), -- Respuesta correcta a la pregunta 4 por el usuario 4 (Laura)
(8, '1541', 5, 5), -- Respuesta correcta a la pregunta 5 por el usuario 5 (Pedro)
(9, '1776', 1, 5); -- Respuesta incorrecta a la pregunta 5 por el usuario 1 (Juan)

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT usuarios.id, usuarios.nombre, COUNT(respuestas.id) AS cantidad_respuestas_correctas
FROM usuarios
JOIN respuestas ON usuarios.id = respuestas.usuario_id
JOIN preguntas ON respuestas.pregunta_id = preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.id, usuarios.nombre;

--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.

SELECT preguntas.id, preguntas.pregunta, COUNT(DISTINCT respuestas.usuario_id) AS cantidad_usuarios_correctos
FROM preguntas
JOIN respuestas ON preguntas.id = respuestas.pregunta_id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY preguntas.id, preguntas.pregunta;

--8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.

--Modificar la tabla "respuestas" y habilitar el borrado en cascada
ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey; -- Eliminar la restricción de clave foránea existente

ALTER TABLE respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON DELETE CASCADE; -- Habilitar el borrado en cascada al eliminar un usuario

DELETE FROM usuarios WHERE id = 1; -- Borrando el primer usuario

--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.

--Agregar la restricción de verificación

ALTER TABLE usuarios
ADD CONSTRAINT edad_mayor_de_18 CHECK (edad >= 18);

--Comprobando restriccion con edad menor a 18

INSERT INTO usuarios (id, nombre, edad) VALUES (6, 'Ana', 16);

--Deberia mostrar el siguiente error

--ERROR:  el nuevo registro para la relación «usuarios» viola la restricción «check» «edad_mayor_de_18»
--DETALLE:  La fila que falla contiene (6, Ana, 16).

--10. Altera la tabla existente de usuarios agregando el campo email con la restricción de único.

ALTER TABLE usuarios ADD COLUMN email VARCHAR(255), ADD CONSTRAINT u_email UNIQUE(email);

