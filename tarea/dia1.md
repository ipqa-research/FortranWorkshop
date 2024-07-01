# Actividades del día 1

Todas estas actividades pueden verificarse mediante el comando:

```bash
fpm test dia1
```

Para que el sistema de evaluación funcione correctamente, todo debe juntarse
en un módulo `dia1`.

## Modulos

1. Crear un módulo llamado `dia_1_constants` que guarde las constantes:
   - `R = 0.082`.
   - `pr` que corresponda a la selección de doble precisión.

2. Crear otro módulo (que use el módulo anterior) llamado `dia_1_variables` 
   e incluya:
   - Una variable llamada `x` con el valor de precisión del módulo constantes
     y que empiece con un valor predeterminado de `5`. 
   - Una subroutina `get_x(x)` que asigne el valor de la variable `x` del módulo
     a la variable `x` de salida de la rutina.

3. Finalmente, generar un módulo `dia_1` que junte a todos los módulos
   definidos.

## Subroutinas

1. Escribir una subroutina `sumar`, que tome dos argumentos `x`, e `y` y
   devuelva un tercer argumento `z` corresponidente a la suma entre ambos.
   `y` debe ser un argumento opcional, si no está presente se debe hacer la 
   suma de `x` consigo misma.

2. Escribir una subroutina `sumarr` que tome un array `x` de tamaño asumido y
   que devuelva una variable `y` correspondiente a la suma de todos los
   elementos de la misma.

3. Definir otra subrutina `sumat` donde en lugar de un array sea una matriz.
   
4. Implementar una interface `suma` que abarque a todas las rutinas definidas
   en esta sección.

## Allocatables
1. Escribir una subrutina `set_dim`, que reciba un array allocatable y un entero
   `dim` y que le asigne el tamaño `dim` al array que recibe. Ojo, tiene
   que checkear que el array no haya estado previamente alocado, si lo estaba
   es necesario desalocar!

2. Escribir una subrutina `agrandar` que reciba un array real de la precisión
   definida en el módulo y de una dimensión, una variable x y que devuelva el 
   array habiéndole agregado el valor `x` 

## Namelist

## Tipos derivados
