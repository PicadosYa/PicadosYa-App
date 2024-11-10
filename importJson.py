import json
import mysql.connector
import random
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FieldImporter:
    def __init__(self, host, user, password, database):
        self.conn = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database
        )

    def field_exists(self, name, address, phone):
        """Verifica si ya existe una cancha con el mismo nombre, dirección o teléfono"""
        try:
            logger.info(f"Verificando si la cancha '{name}' ya existe...")
            
            # Crear un nuevo cursor para esta consulta específica
            with self.conn.cursor(dictionary=True, buffered=True) as cursor:
                query = """
                SELECT name, address, phone 
                FROM fields 
                WHERE name = %s OR address = %s OR phone = %s
                """
                cursor.execute(query, (name, address, phone))
                result = cursor.fetchone()
                
                # Consumir cualquier resultado pendiente
                while cursor.nextset():
                    pass
                
                logger.info(f"Resultado de la búsqueda: {result}")
                
                if result:
                    match_details = []
                    if result['name'] == name:
                        match_details.append("nombre")
                    if result['address'] == address:
                        match_details.append("dirección")
                    if result['phone'] == phone:
                        match_details.append("teléfono")
                    
                    match_info = f"Coincidencia encontrada en: {', '.join(match_details)}"
                    logger.info(match_info)
                    return True, match_info
                
                logger.info("No se encontraron coincidencias")
                return False, ""
                
        except Exception as e:
            logger.error(f"Error al verificar si la cancha ya existe: {str(e)}")
            return True, f"Error en la verificación: {str(e)}"

    def get_or_create_services(self, service_names):
        """Obtiene o crea servicios y retorna sus IDs"""
        service_ids = []
        try:
            with self.conn.cursor(dictionary=True, buffered=True) as cursor:
                for service_name in service_names:
                    # Buscar si el servicio existe
                    cursor.execute("SELECT id FROM services WHERE name = %s", (service_name,))
                    result = cursor.fetchone()
                    
                    if result:
                        service_ids.append(str(result['id']))
                    else:
                        # Crear nuevo servicio
                        cursor.execute(
                            "INSERT INTO services (name) VALUES (%s)",
                            (service_name,)
                        )
                        self.conn.commit()
                        service_ids.append(str(cursor.lastrowid))
                        logger.info(f"Creado nuevo servicio: {service_name}")
                    
                    # Consumir cualquier resultado pendiente
                    while cursor.nextset():
                        pass
        
        except Exception as e:
            logger.error(f"Error al procesar servicios: {str(e)}")
            raise
            
        return service_ids

    def generate_random_data(self):
        """Genera datos aleatorios para campos faltantes"""
        field_types = ['5', '7', '11']
        prices = [800, 1000, 1200, 1500, 1800, 2000]
        
        start_date = datetime.now() - timedelta(days=3*365)
        end_date = datetime.now()
        days_between = (end_date - start_date).days
        random_date = start_date + timedelta(days=random.randint(0, days_between))
        
        available_days_patterns = [
            ['1', '2', '3', '4', '5', '6', '7'],
            ['1', '2', '3', '4', '5'],
            ['6', '7'],
            ['2', '3', '4', '5', '6']
        ]
        
        return {
            'type': random.choice(field_types),
            'price': random.choice(prices),
            'creation_date': random_date.strftime('%Y-%m-%d'),
            'available_days': random.choice(available_days_patterns)
        }

    def execute_procedure(self, query, params):
        """Ejecuta un procedimiento almacenado y maneja sus resultados"""
        try:
            with self.conn.cursor(buffered=True) as cursor:
                cursor.execute(query, params)
                
                # Consumir todos los resultados
                while cursor.nextset():
                    pass
                    
                self.conn.commit()
                return True
                
        except Exception as e:
            self.conn.rollback()
            raise e

    def import_field(self, field_data):
        """Importa un campo individual a la base de datos"""
        try:
            logger.info(f"Procesando cancha: {field_data['nombre']}")
            
            # Verificar si la cancha ya existe
            exists, match_info = self.field_exists(
                field_data['nombre'],
                field_data['direccion'],
                field_data['telefono']
            )
            
            if exists:
                logger.warning(f"Cancha '{field_data['nombre']}' ya existe. {match_info}")
                return False
            
            random_data = self.generate_random_data()
            service_ids = self.get_or_create_services(field_data['servicios'])
            
            query = "CALL InsertField(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            params = (
                field_data['nombre'],
                field_data['direccion'],
                field_data['barrio'],
                field_data['telefono'],
                0.0,  # latitude
                0.0,  # longitude
                random_data['type'],
                random_data['price'],
                field_data['detalle'],
                field_data['logo_url'],
                random_data['creation_date'],
                ','.join(random_data['available_days']),
                ','.join(field_data['image_urls']),
                ','.join(service_ids)
            )
            
            self.execute_procedure(query, params)
            logger.info(f"Importado campo: {field_data['nombre']}")
            return True
            
        except Exception as e:
            logger.error(f"Error importando campo {field_data['nombre']}: {str(e)}")
            return False

    def process_json_file(self, json_file_path):
        """Procesa el archivo JSON completo"""
        try:
            with open(json_file_path, 'r', encoding='utf-8') as file:
                fields_data = json.load(file)
            
            if isinstance(fields_data, dict):
                fields_data = [fields_data]
            
            total_fields = len(fields_data)
            imported_fields = 0
            skipped_fields = 0
            
            for field_data in fields_data:
                try:
                    if self.import_field(field_data):
                        imported_fields += 1
                    else:
                        skipped_fields += 1
                        
                except Exception as e:
                    logger.error(f"Error procesando campo {field_data.get('nombre', 'desconocido')}: {str(e)}")
                    skipped_fields += 1
                    continue
            
            logger.info(f"""
            Resumen de importación:
            - Total de canchas procesadas: {total_fields}
            - Canchas importadas exitosamente: {imported_fields}
            - Canchas omitidas (duplicadas o con error): {skipped_fields}
            """)
                
        finally:
            self.close()

    def close(self):
        """Cierra la conexión de base de datos"""
        if hasattr(self, 'conn') and self.conn:
            self.conn.close()

if __name__ == "__main__":
    DB_CONFIG = {
        'host': '127.0.0.1',
        'user': 'root',
        'password': 'pass123',
        'database': 'picadosya'
    }
    
    try:
        importer = FieldImporter(**DB_CONFIG)
        importer.process_json_file('canchas_info.json')
    except Exception as e:
        logger.error(f"Error en la importación: {str(e)}")