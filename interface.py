import psycopg2

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

conn = psycopg2.connect(database="chinook",
                        host="localhost",
                        user="postgres",
                        password="1234",
                        port="5432")

cursor = conn.cursor()

cursor.execute('SELECT art.name AS nombre_artista, COUNT(ivl.*) track_vendidos \
                FROM invoice_line AS ivl \
                    JOIN track AS tr ON ivl.track_id = tr.track_id \
                    JOIN album AS al ON tr.album_id = al.album_id \
                    JOIN artist AS art ON al.artist_id = art.artist_id \
                GROUP BY art.name \
                HAVING COUNT(ivl.*) IS NOT NULL \
                ORDER BY track_vendidos DESC \
                LIMIT 10;')
artistas_vendidos = pd.DataFrame(cursor.fetchall(), columns=[desc[0] for desc in cursor.description])

plt.figure(figsize=(10, 10))
sns.barplot(data = artistas_vendidos, x = "nombre_artista", y = "track_vendidos")
plt.xlabel('Artistas')
plt.ylabel('Track vendidos')
plt.xticks(rotation = 35)
plt.title('Top 10 artistas más vendidos en la tienda')
plt.gcf().subplots_adjust(bottom=0.20)
plt.tight_layout()
plt.savefig("barplot_artistas.png", dpi=600)
plt.show()

cursor.execute('SELECT country, COUNT(*) cantidad FROM customer \
                GROUP BY country \
                ORDER BY cantidad DESC \
                LIMIT 6;')

paises_customer = pd.DataFrame(cursor.fetchall(), columns=[desc[0] for desc in cursor.description])

paleta = sns.color_palette('bright')
plt.pie(paises_customer['cantidad'], labels=paises_customer['country'],  colors=paleta, autopct='%.0f%%')
plt.title('Distribución de los clientes por paises')
plt.axis('equal')
plt.tight_layout()
plt.savefig("pieplot_customer.png", dpi=600)
plt.show()
