-- Creacion de la BDD
CREATE DATABASE felipe_castaneda951;
-- Conexion a la BDD 
/c felipe_castaneda951;

--1- Creamos las tablas para el primer modelo
CREATE TABLE "peliculas" (
"id" Integer,
"nombre" Varchar(255),
"anno" integer,
PRIMARY KEY ("id")
);

CREATE TABLE "tags" (
"id" Integer,
"tag" Varchar(32),
PRIMARY KEY ("id")
);

-- y creamos la tercera tabla para relacionar N a 1

CREATE TABLE "clasificacion" (
"pelicula_id" Integer,
"tag_id" Integer,
FOREIGN KEY ("pelicula_id")
REFERENCES "peliculas"("id"),
FOREIGN KEY ("pelicula_id")
REFERENCES "peliculas"("id")
);

--2-  Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados. (1 punto)

-- Peliculas 
INSERT INTO peliculas (id, nombre, anno)
VALUES (1, 'Terminator', 1984),(2, 'Superman', 1990),(3, 'The_lord_of_the_rings', 1999),(4, 'Predator', 1994),(5, 'Rocky', 1985);


-- Tags 
INSERT INTO tags (id, tag)
VALUES (1, 'accion'),(2, 'drama'),(3, 'comedia'),(4, 'ciencia_ficcion'),(5, 'documental');


-- Tabla intermedia
INSERT INTO clasificacion (pelicula_id, tag_id)
VALUES (1, 1),(1,2),(1,3),(2,1),(2,2);

-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0. (1 punto)

SELECT peliculas.nombre, COUNT(clasificacion.tag_id) 
FROM peliculas LEFT JOIN clasificacion ON peliculas.id = clasificacion.pelicula_id 
GROUP BY peliculas.nombre;

-- 4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
-- datos. (1 punto)

CREATE TABLE preguntas (
    id SERIAL PRIMARY KEY, 
    pregunta VARCHAR(255), 
    respuesta_correcta VARCHAR
); 

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY, 
    nombre VARCHAR(255), 
    edad INTEGER
); 

CREATE TABLE respuestas (
	id SERIAL PRIMARY KEY, 
	respuesta VARCHAR(255), 
	usuario_id INT, 
	pregunta_id INT, 
	FOREIGN KEY (usuario_id) 
	REFERENCES usuarios(id), 
	FOREIGN KEY (pregunta_id) 
	REFERENCES preguntas(id)
); 

-- 5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
-- dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
-- correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
-- (1 punto)
-- a. Contestada correctamente significa que la respuesta indicada en la tabla
-- respuestas es exactamente igual al texto indicado en la tabla de preguntas.


INSERT INTO usuarios (nombre, edad)
VALUES ('Felipe', 38),('Marco', 36),('Juan', 32),('Diego', 23),('Pedro', 48);

INSERT INTO preguntas (pregunta, respuesta_correcta)
VALUES 
('¿De qué se alimentan los koalas?', 'Eucalipto'),
('¿Cuál fue la primera película de Walt Disney?', 'Blancanieves'),
('¿De dónde son originarios juegos olímpicos?', 'Grecia'),
('¿Ciudad más poblada mundo?', 'Tokio' ),
('¿Qué cantidad de huesos hay en el cuerpo humano?', '300 huesos');

INSERT INTO respuestas(respuesta, usuario_id, pregunta_id)
VALUES ('Eucalipto',1,1),('Eucalipto',2,1),('Blancanieves',3,2),('Italia',4,3),('Madagascar',5,4);

-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
-- pregunta). (1 punto)
SELECT usuarios.nombre, COUNT(preguntas.respuesta_correcta) AS respuestas_correctas
FROM preguntas RIGHT JOIN respuestas ON respuestas.respuesta = preguntas.respuesta_correcta
JOIN usuarios ON usuarios.id = respuestas.usuario_id 
GROUP BY usuario_id, usuarios.nombre;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
-- respuesta correcta. (1 punto)//// revisar
SELECT preguntas.pregunta, COUNT(DISTINCT usuarios.id) as num_usuarios
FROM preguntas
INNER JOIN respuestas ON preguntas.id = respuestas.pregunta_id
INNER JOIN usuarios ON respuestas.usuario_id = usuarios.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY preguntas.pregunta;

-- 8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación. (1 punto)

ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

-- PROBAMOS

DELETE FROM usuarios WHERE id = 1;

--REVISAMOS CASCADA

SELECT * from respuestas;

-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
-- datos. (1 punto)

ALTER TABLE usuarios ADD CHECK (edad >= 18);

--comprobamos

INSERT INTO usuarios (nombre, edad)
VALUES ('Benjamin', 17);

-- 10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
-- único. (1 punto)
ALTER TABLE usuarios ADD COLUMN email VARCHAR(255) UNIQUE;

-- comprobamos 

SELECT * from usuarios;

