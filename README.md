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
Para levantar y <b>CARGAR AUTOMATICAMENTE LOS DATOS A LA BD LOCAL</b>, es necesario ejcutar el script `./Project-up-dev.sh --with-mysql` Esto levantará la BD y cargará los datos en ella

#### <i><b>ATENCIÓN:</b> Ejecutar el script con la opcion  `--with-mysql` borrará todos los cambios que hayas realizado en la bd y los remplazará. Si solo quieres levantar la BD sin cargar lo datos de `picadosya_latest.sql` ejecuta el script sin la opción `--with-mysql` Osea únicamente: `./Project-up-dev.sh`</i>

## Guardar data
Si has hecho cambios en la BD, y quieres guardarlos solo ejecuta `./save_db.sh` Este creará un script sql `picadosya_latest.sql`.

<i><b>NOTA:</b> Los otros scripts sql, son versiones anteriores que se van guardando por si el script principal se rompe, no se pierdan todos los datos</i>

## Uso de la API
La API esta documentada en el `README.md` del submódulo de Backend