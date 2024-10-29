## Dev

1. Clonar el repositorio
2. Crear un .env basado en el .env.example
3. Ejecutar el comando `git submodule update --init --recursive` para reconstruir los sub-módulos
4. Ejecutar el archivo Project-up-dev.sh, ejecutara el comando `docker compose up`

### Pasos para crear los Git Submodules

1. Crear un nuevo repositorio en GitHub
2. Clonar el repositorio en la máquina local
3. Añadir el submodule, donde `repository_url` es la url del repositorio y `directory_name` es el nombre de la carpeta donde quieres que se guarde el sub-módulo (no debe de existir en el proyecto)

```
git submodule add <repository_url> <directory_name>
```

4. Añadir los cambios al repositorio (git add, git commit, git push)
   Ej:

```
git add .
git commit -m "Add submodule"
git push
```

5. Inicializar y actualizar Sub-módulos, cuando alguien clona el repositorio por primera vez, debe de ejecutar el siguiente comando para inicializar y actualizar los sub-módulos

```
git submodule update --init --recursive
```

6. Para actualizar las referencias de los sub-módulos

```
git submodule update --remote
```

## Importante

Si se trabaja en el repositorio que tiene los sub-módulos, **primero actualizar y hacer push** en el sub-módulo y **después** en el repositorio principal.

Si se hace al revés, se perderán las referencias de los sub-módulos en el repositorio principal y tendremos que resolver conflictos.

## Levantar proyecto
### Crear .env
Para levantar el backend y la BD, es <b>CRUCIAL</b> crear un `.env` en la raiz de toda la app `./PicadosYa-App` con los valores que se especifican en el 
`.env.example`

### Levantar BD
Para levantar y <b>CARGAR AUTOMATICAMENTE LOS DATOS A LA BD LOCAL</b>, es necesario ejecutar `docker compose up -d` Esto borrará todos los datos y cargará todos nuevamente de `/migrations`

## Modificar DB
para modificar la DB, se usará el sistema de migraciones [(Mas información aquí)](https://github.com/PicadosYa/PicadosYa-App/pull/26])

- Se deberá ejecutar el script `./scripts/create_migration.sh NAME_OF_CHANGE` </br></br>
`NAME_OF_CHANGE`: Es el nombre de la modificacion ej: `./scripts/create_migration.sh create_user_table`

- Luego dentro de los scripts sql, generados debes colocar tus cambios [(Mas información aquí)](https://github.com/PicadosYa/PicadosYa-App/pull/26])

- Ejecutar `docker compose up -d`: Borrará TODO lo que haya y ejecutará los scripts nuevamente

### En caso de error
#### Volver atrás cambios
Si necesitas revertir los últimos N cambios, puedes usar:

```bash
./scripts/drop_migration.sh down N 
```
Donde N es el número de migraciones que quieres revertir

Ejemplo:

```bash
# Revertir la última migración
./scripts/drop_migration.sh down 1

# Revertir las últimas 3 migraciones
./scripts/drop_migration.sh down 3
```
#### Forzar una versión específica
Si hay problemas graves con las migraciones, puedes forzar una versión específica:

```bash
./scripts/drop_migration.sh force VERSION
```
Donde VERSION es el número de la versión a la que quieres forzar la base de datos.

Ejemplo:

```bash
# Forzar a la versión 5
./scripts/drop_migration.sh force 5
```
> ⚠️ IMPORTANTE: Usar `force` solo en casos donde las migraciones están en un estado inconsistente y no se pueden resolver con `down`. Este comando puede causar pérdida de datos si no se usa correctamente.

### [Mas información aquí](https://github.com/PicadosYa/PicadosYa-App/pull/26])


