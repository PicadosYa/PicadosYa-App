import json
import mysql.connector
import subprocess
import requests
import time

### ****************************************************** ###
###                FIELDS - JSON DATA IMPORT               ###
### ****************************************************** ###

# Create the database from the SQL file
subprocess.run(["mysql", "-u", "root", "-p", "password", "<", "/mnt/data/picadosYa.sql"], shell=True)

# Read data from JSON
with open('/mnt/data/canchas_info.json', 'r') as file:
    fields_data = json.load(file)

# Function to get latitude and longitude using Google Maps API
def get_coordinates(address):
    api_key = "Google_maps_api_key_XXXXXXXXXXXXXX"
    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {"address": address, "key": api_key}
    response = requests.get(base_url, params=params)
    result = response.json()
    if result['status'] == 'OK':
        location = result['results'][0]['geometry']['location']
        return location['lat'], location['lng']
    else:
        return None, None

# Connect to MySQL database
connection = mysql.connector.connect(
    host='localhost',  # Change this to your database address
    user='root',  # Change this to your MySQL user
    password='password',  # Change this to your MySQL password
    database='picadosYa'
)
cursor = connection.cursor()

# Insert data into "fields" table
for field in fields_data:
    # Extract necessary data from JSON
    name = field.get('nombre')
    address = field.get('direccion')
    neighborhood = field.get('barrio', '')
    phone = field.get('telefono', '')
    description = field.get('detalle', '')
    logo_url = field.get('logo_url', '')
    type = field.get('tipo', '5')  # Default field type "5" if not provided
    price = field.get('precio', 1000.0)  # Default price if not provided
    services = field.get('servicios', '')
    image_urls = field.get('image_urls', [])  # List of image URLs

    # Get latitude and longitude from address using Google Maps API
    latitude, longitude = get_coordinates(address)
    if latitude is None or longitude is None:
        print(f"Unable to get coordinates for address: {address}")
        continue

    # Insert data into "fields" table
    insert_query = (
        "INSERT INTO fields (name, address, neighborhood, phone, latitude, longitude, type, price, description, logo_url, services) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    )
    cursor.execute(insert_query, (name, address, neighborhood, phone, latitude, longitude, type, price, description, logo_url, services))
    field_id = cursor.lastrowid

    # Insert image URLs into "field_photos" table
    for url in image_urls:
        insert_photo_query = (
            "INSERT INTO field_photos (field_id, photo_url) "
            "VALUES (%s, %s)"
        )
        cursor.execute(insert_photo_query, (field_id, url))

    # Pause to avoid exceeding Google Maps API quota
    time.sleep(1)

# Commit changes and close connection
connection.commit()
cursor.close()
connection.close()

print("Data inserted successfully.")




