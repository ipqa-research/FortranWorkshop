# Parámetros de UNIFAC: caso ejemplo de que un objeto bien pensado hace bien

Dentro de mi propio aprendizaje de Fortran se me presentó este problema. Por lo
que me pareció interesante compartir el camino lógico utilizando las 
herramientas de Fortran moderno a disposición (Tipos derivados / objetos)


## Análisis del problema

Podemos encontrar todos los parámetros de interaccion del modelo UNIFAC clásico
aquí: https://www.ddbst.com/published-parameters-unifac.html

En el modelo UNIFAC, las moléculas se encuentran representadas por un conjunto
de subgrupos:

![image](https://raw.githubusercontent.com/ipqa-research/ugropy/db4bf7218af1b92bd5e5d9a3090b03dda525dc11/logo.svg)

Información que posee cada subgrupo:

- ID (1, 2, 3, 4, etc)
- Nombre (CH3, CH2, CH, etc) (EN FORTRAN MOLESTAN LOS STRINGS)
- R (Volumen reducido de Van der Waals)
- Q (Area reducida de Van der Waals)

Y lo más importante, cada subgrupo pretenece a un grupo principal. Por 
ejemplo:

Grupo principal 1: [CH3, CH2, CH, C]

Luego cada grupo principal tiene un parámetro de interacción con cada otro 
grupo principal.

**Por lo tanto para encontrar el parámetro de interacción entre dos subgrupos.
Debemos consultar a que grupo principal pertenece cada uno y encontrar el 
parametro entre dichos grupos principales.**


## ¿Cómo se llega a la desicion de implementar un objeto?

La programación orientada a objetos es un paradigma de programación. De manera
sencilla, es simplemente una forma de organizar el código.

En programación solo existen dos cosas: datos y funciones.

A alguien inteligente (o no) se le ocurrió que sería una buena idea juntar en
una misma referencia de memoria los datos y las funciones que operan sobre esos
datos.

Los objetos permiten realizar abstracciones de problemas de la vida real de
manera consiza, ordenada y que reutilice código.

Por ejemplo:
  
Si en nuetro programa tenemos que representar diferentes autos. Y todos los
autos que necesitamos representar tienen las mismas propiedades/atributos
(marca, modelo, cilindrada del motor, etc) y además tienen los mismos
comportamientos (acelerar, frenar, etc). Entonces podemos crear un tipo de dato
`Car` que pueda representar tanto a un Ford Fiesta como a un Ferrari.


> **Nota**: En Fortran los objetos son representados por tipos derivados. Pero
> en el momento que los tipos derivados tienen procedimientos asociados, es
> cuando pueden empezar a denominarse `Clase`. Una `Clase` es la definición de
> nuestros objetos. Y se dice que un objeto es una instancia de una `Clase`.


### ¿Existen múltiples instancias de `parámetros de UNIFAC`?
Si, tenemos:

LV-UNIFAC, LL-UNIFAC, Dortmund-UNIFAC, Lyngby-UNIFAC, PSRK-UNIFAC, PPR-UNIFAC
VTPR-UNIFAC, NIST-UNIFAC, NIST KT-UNIFAC...

Todos se estructuran de la misma manera. Subgrupos, grupos principales, R, Q y
parámetros de interacción entre grupos principales.

### ¿La API de `yaeos` se simplifica con un objeto `UNIFACParameters`?

Si y lo vamos a ver de a poco.


### Definicion de la clase `GeGCModelParameters`

- Documentación  
[https://ipqa-research.github.io/yaeos/module/yaeos__models_ge_group_contribution_model_parameters.html](https://ipqa-research.github.io/yaeos/module/yaeos__models_ge_group_contribution_model_parameters.html)

- Código  
[https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/model_parameters.f90](https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/model_parameters.f90)


### Funcion constructora `GeGCModelParameters` -> `UNIFACParameters`

- Código  
[https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/unifac_parameters.f90](https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/unifac_parameters.f90)

Ejemplo:

```fortran
use yaeos__models_ge_group_contribution_unifac_parameters, only: UNIFACParameters
use yaeos__models_ge_group_contribution_model_parameters, only: GeGCModelParameters

type(GeGCModelParameters) :: parameters

parameters = UNIFACParameters()

! Get the subgroups i:1, j:16 interaction parameter aij (CH3-H2O)
! with maingroups 1 and 7 respectively.
print *, parameters%get_subgroups_aij(1, 16) ! prints: 1318.0000
```

### Analisis del código de la Implementación de UNIFAC
- Código

[https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/unifac.f90](https://github.com/ipqa-research/yaeos/blob/main/src/models/excess_gibbs/group_contribution/unifac.f90)