# Workshop Fortran: Conceptos medios de Fortran

## Módulos

Desde la existencia de Fortran9090 nuestro código puede estructurarse en una lógica de
módulos. Los módulos en Fortran pueden pensarse como una caja donde tenemos un conjunto
de variables y rutinas que pueden reutilizarse. Un módulo se define como

```fortran
module nombre_modulo
  implicit none
  <Conjunto de variables>
contains
  <Conjunto de procedimientos>
end module
```
