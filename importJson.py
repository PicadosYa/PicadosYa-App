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
    database='app_reservas'
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
    tipo = '5'  # Asumiremos que todas las canchas son de tipo "5" hasta que se indique otro valor
    precio = 1000.0  # Un precio por defecto hasta que se proporcione

    # Insertar datos en la tabla "canchas"
    insert_query = (
        "INSERT INTO canchas (propietario_id, nombre, direccion, latitud, longitud, tipo, precio, descripcion) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    )
    propietario_id = 1  # Asumimos un propietario temporalmente, actualiza esto según corresponda
    cursor.execute(insert_query, (propietario_id, nombre, direccion, latitud, longitud, tipo, precio, detalle))

# Confirmar los cambios y cerrar la conexión
connection.commit()
cursor.close()
connection.close()

print("Datos insertados correctamente.")
