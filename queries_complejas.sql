
-- El promedio de ventas de todos los empleados que hayan vendido productos.
SELECT em.first_name, em.last_name, AVG(iv.total) avg_ventas FROM employee AS em
	JOIN customer AS cust ON em.employee_id = cust.support_rep_id
	JOIN invoice AS iv ON iv.customer_id = cust.customer_id
GROUP BY em.first_name, em.last_name
HAVING AVG(iv.total) IS NOT NULL
ORDER BY avg_ventas DESC;

-- Géneros que no hayan sido comprados por ningún cliente.
SELECT gn.name
FROM genre AS gn
WHERE NOT EXISTS (
  SELECT cust.customer_id
  FROM customer AS cust
  WHERE EXISTS (
    SELECT tr.genre_id
    FROM track AS tr
    	JOIN invoice_line AS ivl ON tr.track_id = ivl.track_id
    	JOIN invoice AS iv ON ivl.invoice_id = iv.invoice_id
    WHERE iv.customer_id = cust.customer_id
    AND tr.genre_id = gn.genre_id
  )
);

-- Las canciones agrupadas por géneros que hayan sido vendidos más de 40
-- veces pero menos de 1000 veces.
SELECT gn.name, SUM(ivl.quantity) AS veces_comprado FROM genre AS gn
	JOIN track AS tr ON gn.genre_id = tr.genre_id
	JOIN invoice_line AS ivl ON tr.track_id = ivl.track_id
GROUP BY gn.name
HAVING SUM(ivl.quantity) BETWEEN 40 AND 1000
ORDER BY veces_comprado DESC;

-- Ejercicio 7
-- Clientes que han comprado una canción de más de 3 minutos y que son de Estados Unidos (USA)
SELECT cust.first_name, cust.last_name, tr.name, (tr.milliseconds / 1000) duracion_en_s, gn.name 
FROM customer AS cust
	JOIN invoice AS iv ON cust.customer_id = iv.customer_id
	JOIN invoice_line AS ivl ON iv.invoice_id = ivl.invoice_id
	JOIN track AS tr ON ivl.track_id = tr.track_id
	JOIN genre AS gn ON tr.genre_id = gn.genre_id
WHERE cust.country = 'USA' AND tr.milliseconds >= 180000;

-- Consulta optimizada por álgebra relacional
SELECT CS7.first_name, CS7.last_name, CS7.name, CS7.duracion_en_s, CS8.genre_name
FROM
	(SELECT CS5.first_name, CS5.last_name, CS6.track_id, CS6.genre_id, CS6.name, CS6.duracion_en_s FROM
		(SELECT CS3.first_name, CS3.last_name, CS4.track_id 
		FROM
			(SELECT CS1.first_name, CS1.last_name, CS2.invoice_id 
			FROM 
				(SELECT cust.customer_id, cust.first_name, cust.last_name 
				FROM customer AS cust
				WHERE cust.country = 'USA') AS CS1,
				(SELECT iv.customer_id, iv.invoice_id
				FROM invoice AS iv) AS CS2
			WHERE SC1.customer_id = SC2.customer_id) AS CS3,
			(SELECT ivl.invoice_id, ivl.track_id
			FROM invoice_line AS ivl) AS CS4
		WHERE CS3.invoice_id = CS4.invoice_id) AS CS5,
		(SELECT tr.track_id, tr.genre_id, tr.name, (tr.milliseconds / 1000) AS duracion_en_s
		FROM track AS tr
		WHERE tr.milliseconds >= 180000) AS CS6
	WHERE CS5.track_id = CS6.track_id) AS CS7,
	(SELECT gn.genre_id, gn.name AS genre_name FROM genre AS gn) AS CS8
WHERE CS7.genre_id = CS8.genre_id;
