# Workshop Fortran: Conceptos medios-altos de Fortran

## Módulos
Desde la existencia de Fortran90 nuestro código puede estructurarse en una
lógica de módulos. Los módulos en Fortran pueden pensarse como una caja donde
tenemos un conjunto de variables y rutinas que pueden reutilizarse.
Un módulo se define como:

```fortran
module nombre_modulo
  implicit none
  <Conjunto de variables>
contains
  <Conjunto de procedimientos>
end module
```

Podemos partir del ejemplo

```fortran
module mi_primer_modulo
  implicit none
  real :: x
end module

program main
  use mi_primer_modulo
  implicit none

  x = 5
  print *, "x vale: ", x
end program
```

## Procedimientos
A esta altura ya todos sabemos lo que es una subrutina o una función, pero ahora
vamos a ver alguno detalles particulares de ambos.


### Declaración de intención con las variables
Declarar que intención tenemos con cada variable permite asegurarse que no
rompemos nada sin darnos cuenta. Declarar intención de las variables nos
permite.

```fortran
subroutine f(x, y)
  real, intent(in) :: x
  real, intent(out) :: y

  ! Esto va a dar error, porque estoy
  ! modificando el valor de x
  x = 23
  y = 2*x
end subroutine
```

### Arrays de tamaño asumido
Una práctica muy común trabajando con arrays es usar una variable para 
especificar su tamaño.

```fortran
subroutine f(n, x, y)
  integer, intent(in) :: n
  real :: x(n)
  real :: y
end subroutine
```

Al principio esto puede parecer más seguro, pero en realidad el tamaño de los
arrays nunca es checkeado al momento de ejecutarse nuestro programa. Lo que puede
llevar a problemas:

```fortran
program main
    ! Jugar con dimensiones y valores
    implicit none
    real :: x(2)
    real :: y(3)

    x = [1, 2]

    call f(5, x, y)

    print *, y

contains

    subroutine f(n, x, y)
        integer :: n
        real :: x(n)
        real :: y(n)
        y = sum(x)
    end subroutine
end program
```

Desde Fortran90 esto puede simplificarse, dando tamaño asumido a los arreglos.
Esto permite que lleguen las cosas "como son", y no se hagan cosas raras
adentro.

```fortran
subroutine f(x, y)
  real :: x(:)
  real :: y
end subroutine
```

> **Actividad**: Modificar el programa ejemplo anterior para que use dimensiones
> asumidas

## Interfaces

## Allocables

## Input/Output con `namelist`
Muchas veces hemos usado archivos de input/output con alguna lógica particular.
Si bien no está mal (y hasta puede traer sus ventajas al ser algo totalmente
customizable), puede que se vuelva más complicado para que alguien más lo
utilize. O también puede ser dificil de modificar alguna funcionalidad,
teniendo que recurrir a parches sin mucha lógica, aportando más al quilombo.

En Fortran hay un método de estructurar archivos de input/output llamado
`namelist`, que de paso nos ahorra gran parte de la lectura de información.
Un archivo `namelist` se ve así:

```fortran
! input.nml

&mi_namelist
  x = 2
  y = 2 3 5
/

&mi_otro_namelist
  w = 1
  m = "holi"
/
```

Desde Fortran esto puede leerse como:

```fortran
program main
  implicit none
  real :: x, y(3) ! Defino variables
  namelist /mi_namelist/ x, y ! Las asigno al namelist mi_namelist

  open(1, file="input.nml")
    read(1, nml=mi_namelist)
  close(1)

  print *, x
  print *, y
end program
```

Y listo! Ya se leyó, no fue necesario escribir una lógica rebuscada. Y, a
diferencia de métodos convencionales de lectura/escritura, aquí el orden de los
factores no altera el producto.

> **Actividad**: 
>
> - Agregar la lógica de lectura de `mi_otro_namelist`.
> - Modificar las variables y escribir ambos namelist en un archivo `salida.nml`


> gotchas: Cuando trabajamos con cosas de dimensión variable hay que tener en
> cuenta algunos detalles y puede ocasionar errores difíciles de preveer y
> resolver.

## Tipos derivados (objetos)

## Trabajar con dependencias
