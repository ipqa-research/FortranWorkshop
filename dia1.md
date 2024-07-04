# Workshop Fortran: Conceptos medios-altos de Fortran

## Contenido
- Módulos
- Opciones de argumentos en procedimientos
- Arrays allocatables
- Namelist
- Tipos derivados

## Módulos
![image](https://github.com/ipqa-research/FortranWorkshop/assets/24468661/a167257d-b058-417c-809d-704e45a8be6f)

La mayoría de los presentes puede darse cuenta que significa esto:

```fortran
  SUBROUTINE F(X, Y)
  COMMON / PARAMETERS / A, B, C
  Y = A*X + B/X + C
  END SUBROUTINE
```

Desde la existencia de Fortran90 nuestro código puede estructurarse en una
lógica de módulos.
Los módulos en Fortran pueden pensarse como una caja donde tenemos un conjunto
de variables y rutinas que pueden reutilizarse. Un módulo se define como:

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

> Tip: Una buena práctica es tener un módulo donde se guardan las cosas que son constantes.

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

### Argumentos opcionales
A veces no queremos utilizar todas las variables de un procedimiento. Así
que podemos darle la opción de `optional` a nuestros argumentos.

```fortran
subroutine f(x, y, z)
  real, intent(in) :: x
  real, optional, intent(in) :: y
  real, intent(out) :: z

  if (present(y)) then
    z = x*y
  else
    z = x/2
  end if
end subroutine
```

## Allocables
Siempre odiamos que hay que definir el tamaño de los arrays, o a veces hay casos
que en que nos gustaría poder variar la dimensión de uno. 
Desde Fortran90 podemos definiendolos como `allocatables` (`allocatable`
significa que su lugar y/o tamaño en memoria puede variar)

```fortran
program main
  implicit none
  real, allocatable :: x(:)
  x = [1, 2, 3]
  print *, x

  x = [1, 3]
  print *, x
end program
```

Es posible pre-asignar el tamaño de un allocatable, sin necesariamente
explicitar su contenido:

```fortran
program main
  implicit none
  real, allocatable :: x(:)
  allocate(x(5)) ! Le doy un tamaño pero no especifico contenido
  print *, x
end program
```

Los `allocatables` permiten hacer arrays que crecen sobre la marcha. Añadiendo
valores según sea conveniente.
```fortran
program main
  implicit none
  real, allocatable :: x(:)
  integer :: i

  allocate(x(0)) ! Inicio con tamaño 0
  do i=1,5
      x = [x, 2.4+i]
  end do
  print *, x
end program
```

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


> Detalles:
> - Cuando trabajamos con cosas de dimensión variable hay que tener en
>   cuenta algunos detalles y puede ocasionar errores difíciles de preveer y
>   resolver.
> - Por algún motivo es necesario terminar con una línea vacía al final de 
>   los archivos nml

## Tipos derivados (objetos)
Así como ya vimos que usar módulos nos permite organizar mejor nuestro código,
ahora vamos a un paso más a hablar de tipos derivados. En Fortran existen los
tipos intrínsecos (`real`, `integer`, `etc`). Los tipos derivados vendrían a
ser un tipo extra definido por el usuario, que permite encapsular distintos
valores (_atributos_) y comportamientos (_métodos_)

Arranquemos con un ejemplo

Llega una rutina horrible que recibe mil argumentos al momento de escribirla
```fortran
subroutine foo(x, a, b, c, d, e, f, y)
    real, intent(in) :: x
    real, intent(in) :: a, b, c, d, e, f
    real, intent(out) :: y
    y = a * b *x + c*x**2 + e * f
end subroutine
```

Si bien este ejemplo es dentro de todo minimalista, creo que podemos
imaginarnos como cosas de este estilo se vuelven ilegibles o molestas de
trabajar. En este ejemplo podemos ver claramente que se trata de alguna función
que usa un conjunto de parámetros. Tranquilamente podríamos encapsular estos
parámetros en una única variable, no?

```fortran
type :: Parameters
    real :: a, b, c, d, e, f
end type

subroutine foo(x, params, y)
    real, intent(in) :: x
    type(Parameters) :: params
    real, intent(out) :: y

    y = params%a * params%b *x + params%c*x**2 + params%e * params%f
end subroutine
```

La ecuación en si quizás quedó un poquito más fea (ya vamos ver como se arregla
eso), pero no podemos negar que el uso de la rutina quedó más estructurado. De
paso va a ser más dificil confundirse en cuanto a qué términos se pasan a la
rutina (recibe un conjunto de parámetros y listo).

Bueno, y qué era lo que me refería como comportamiento?

```fortran
type :: Parameters
    real :: a, b, c, d, e, f
contains
    procedure :: foo
end type

subroutine foo(params, x, y)
    class(Parameters) :: params
    real, intent(in) :: x
    real, intent(out) :: y

    y = params%a * params%b *x + params%c*x**2 + params%e * params%f
end subroutine

program main
    type(Parameters) :: regresion
    regression = Parameters(a=2.4, b=5.3, c=3.6, d=3.4, f=2.1)
    call regression%foo(x, y)
end program
```

La persona que está usando nuestros códigos solo ve esta ultima parte.

