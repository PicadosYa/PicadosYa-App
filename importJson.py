import json
import mysql.connector
import subprocess

# Crear la base de datos desde el archivo SQL
subprocess.run(["mysql", "-u", "tu_usuario", "-p", "tu_contrasena", "<", "/mnt/data/picadosYa.sql"], shell=True)

# Leer los datos del JSON
with open('/mnt/data/canchas_info.json', 'r') as file:
    canchas_data = json.load(file)

# Conectar a la base de datos MySQL
connection = mysql.connector.connect(
    host='localhost',  # Cambia esto por la dirección de tu base de datos
    user='tu_usuario',  # Cambia esto por tu usuario de MySQL
    password='tu_contrasena',  # Cambia esto por tu contraseña de MySQL
    database='app_picadosYa'
)
cursor = connection.cursor()

# Insertar datos en la tabla "canchas"
for cancha in canchas_data:
    # Extraer los datos necesarios del JSON
    nombre = cancha.get('nombre')
    direccion = cancha.get('direccion')
    barrio = cancha.get('barrio', '')
    telefono = cancha.get('telefono', '')
    detalle = cancha.get('detalle', '')
    logo_url = cancha.get('logo_url', '')
    latitud = cancha.get('latitud', None)
    longitud = cancha.get('longitud', None)
    tipo = cancha.get('tipo', '5')  # Tipo de cancha, valor por defecto "5" si no se proporciona
    precio = cancha.get('precio', 1000.0)  # Un precio por defecto hasta que se proporcione
    image_urls = cancha.get('image_urls', [])  # Lista de URLs de las imágenes

    # Insertar datos en la tabla "canchas"
    insert_query = (
        "INSERT INTO canchas (nombre, direccion, latitud, longitud, tipo, precio, descripcion, logo_url) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    )
    cursor.execute(insert_query, (nombre, direccion, latitud, longitud, tipo, precio, detalle, logo_url))
    cancha_id = cursor.lastrowid

    # Insertar las URLs de las imágenes en la tabla "canchas_fotos"
    for url in image_urls:
        insert_foto_query = (
            "INSERT INTO canchas_fotos (cancha_id, url_foto) "
            "VALUES (%s, %s)"
        )
        cursor.execute(insert_foto_query, (cancha_id, url))

# Confirmar los cambios y cerrar la conexión
connection.commit()
cursor.close()
connection.close()

print("Datos insertados correctamente.")


