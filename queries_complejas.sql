
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

-- Las canciones agrupadas por géneros que hayan sido vendidos más de 40 veces pero menos de 1000 veces.
SELECT gn.name, SUM(ivl.quantity) AS veces_comprado FROM genre AS gn
	JOIN track AS tr ON gn.genre_id = tr.genre_id
	JOIN invoice_line AS ivl ON tr.track_id = ivl.track_id
GROUP BY gn.name
HAVING SUM(ivl.quantity) BETWEEN 40 AND 1000
ORDER BY veces_comprado DESC;

-- Ejercicio 7
-- Clientes que han comprado una canción de más de 3 minutos y que son de Estados Unidos (USA)
SELECT cust.first_name, cust.last_name, tr.name, (tr.milliseconds / 1000) duracion_en_s FROM customer AS cust
	JOIN invoice AS iv ON cust.customer_id = iv.customer_id
	JOIN invoice_line AS ivl ON iv.invoice_id = ivl.invoice_id
	JOIN track AS tr ON ivl.track_id = tr.track_id
WHERE cust.country LIKE 'USA' AND tr.milliseconds >= 180000;
