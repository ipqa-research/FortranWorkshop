# Dia 3

## Contenidos

Primer parte: Nuevos modelos y ajuste de parámetros
- Cómo añadir nuevos modelos en yaeos
    - Lógica general usando derivadas analíticas
    - Añadir un modelo con diferenciación automática
Ajuste de parámetros:
     - Cómo ajustar parámetros binarios con la interface ya definida
     - Cómo extender el ajustador de parámetros para mi caso particular
 
Segunda parte
- Parámetros de UNIFAC: caso ejemplo de que un objeto bien pensado hace bien
  - Analisis del problema
  - Como se llega a la desicion de implementar un objeto
  - Analisis de la implementación actual

- Extendiendo GeModel: Analizando la implementación actual de UNIFAC
  - Analisis de API
  - Analisis del código implementado

# Primer parte
Vamos a  ver como se puede añadir un modelo nuevo aprovechando la funcionalidad
de la librería. Nos vamos a centrar en modelos de $A^r$ pero todo es casi igual
para $G^E$.

## Recordando `ArModel`
```fortran

type, abstract, extends(BaseModel) :: ArModel
    character(len=:), allocatable :: name !! Name of the model
contains
    ! Estas dos funciones deben ser definidas luego, solo se define su
    ! comportamiento
    procedure(abs_residual_helmholtz), deferred :: residual_helmholtz
    procedure(abs_volume_initializer), deferred :: get_v0
    
    ! Estas funciones se encuentran totalmente definidas
    procedure :: lnphi_vt
    procedure :: lnphi_pt
    procedure :: pressure
    procedure :: volume
    procedure :: enthalpy_residual_vt
    procedure :: gibbs_residual_vt
    procedure :: entropy_residual_vt
    procedure :: Cv_residual_vt
    procedure :: Cp_residual_vt
end type ArModel
```

## Añadir modelos nuevos

### Usando derivadas analíticas

La adición de modelos nuevos en `yaeos` puede hacerse sin problema desde 
"afuera" de la librería, extendiendo el modelo base `ArModel`. Brindandole
la función de energía residual de Helmholtz correspondiente y alguna función
que permita inicializar un volumen de líquido para el solver de volumen.

```fortran
! algun_archivo_por_ahi.f90
module nuevo_model
    use yaeos, only: pr, R, ArModel
    implicit none

    type, extends(ArModel) :: MiModelo
        real(pr), allocatable :: parametro1(:)
        real(pr), allocatable :: parametro2(:)
    contains
        procedure :: residual_helmholtz => residual_helmholtz
        procedure :: get_v0 => get_v0

    end type

contains

    subroutine residual_helmholtz(self, &
        n, V, T, &
        Ar, ArV, ArT, ArTV, ArV2, ArT2, Arn, ArVn, ArTn, Arn2&
    )
        ! Definicion de variables

        ! Calculo de derivadas aqui
    end subroutine

    function get_v0(self, n, P, T)
        ! Da un valor para inicializar, por ejemplo covol*1.01
    end function
end module
```

Para modelos que tienen el concepto de covolumen, es mejor utilizar el método
de solución de volumen propuesto por Michelsen y Møllerup, ya incluido
como subroutina en la libreria:

```fortran
! algun_archivo_por_ahi.f90
module nuevo_model
    use yaeos, only: pr, R, ArModel
    use yaeos__solvers, only: volume_michelsen
    implicit none

    type, extends(ArModel) :: MiModelo
        real(pr), allocatable :: parametro1(:)
        real(pr), allocatable :: parametro2(:)
    contains
        procedure :: residual_helmholtz => residual_helmholtz
        procedure :: get_v0 => get_v0

        ! Reemplazo la funcionalidad original de resolucion de volumen
        procedure :: volume => volume_michelsen
    end type

contains

    subroutine residual_helmholtz(self, &
        n, V, T, &
        Ar, ArV, ArT, ArTV, ArV2, ArT2, Arn, ArVn, ArTn, Arn2&
    )
        ! Definicion de variables

        ! Calculo de derivadas aqui
    end subroutine

    function get_v0(self, n, P, T)
        ! De algun lado sale el covol
        get_v0 = covolumen
    end function
end module
```


### Derivadas automáticas
En `yaeos` es posible usar diferenciación automática para definir modelos nuevos
sin necesidad de programar derivadas. Para este caso trabajamos con
`ArModelAdiff` en lugar de `ArModel`

```fortran
module adiff_model
    use yaeos, only: pr, R, ArModelAdiff

    type, extends(ArModelAdiff) :: MiModelo
        real(pr), allocatable :: params(:)
    contains
        procedure :: Ar
        procedure :: get_v0 
    end type

contains

    function Ar(self, n, V, T)
        ! Calculo de Ar(n, V, T)
    end function

    function get_v0(self, n, P, T)
        ! El inicializador de volumen
    end function
end module
```


Mostrandolo con un caso aplicado, veamos como se podría implementar
la PengRobinson76

```fortran
module autodiff_hyperdual_pr76
    use yaeos__constants, only: pr, R
    use yaeos__ar_models_hyperdual
    implicit none

    type, extends(ArModelAdiff) :: hdPR76
        real(pr), allocatable :: kij(:, :), lij(:, :)
        real(pr), allocatable :: ac(:), b(:), k(:)
    contains
        procedure :: Ar => arfun
        procedure :: get_v0 => v0
    end type

    real(pr), private, parameter :: del1 = 1._pr + sqrt(2._pr)
    real(pr), private, parameter :: del2 = 1._pr - sqrt(2._pr)

contains

    type(hdPR76) function setup(Tc, Pc, w, kij, lij) result(self)
        !! Seup an Autodiff_PR76 model
        real(pr) :: Tc(:)
        real(pr) :: Pc(:)
        real(pr) :: w(:)
        real(pr) :: kij(:, :)
        real(pr) :: lij(:, :)

        self%components%Tc = Tc
        self%components%Pc = Pc
        self%components%w = w

        self%ac = 0.45723553_pr * R**2 * tc**2 / pc
        self%b = 0.07779607_pr * R * tc/pc
        self%k = 0.37464_pr + 1.54226_pr * w - 0.26993_pr * w**2

        self%kij = kij
        self%lij = lij
    end function

    function arfun(self, n, V, T) result(ar)
        class(hdPR76) :: self
        type(hyperdual), intent(in) :: n(:), v, t
        type(hyperdual) :: ar
    
        type(hyperdual) :: amix, a(size(n)), ai(size(n))
        type(hyperdual) :: bmix
        type(hyperdual) :: b_v, nij

        integer :: i, j

        associate(pc => self%components%pc, ac => self%ac, b => self%b, k => self%k, &
                  kij => self%kij, lij => self%lij, tc => self%components%tc &

        )
            ! ==================================================================
            ! Funcion alpha
            ! ------------------------------------------------------------------
            a = 1.0_pr + k * (1.0_pr - sqrt(t/tc))
            a = ac * a ** 2
            ai = sqrt(a)


            ! ==================================================================
            ! Regla de mezclado 
            ! ------------------------------------------------------------------
            amix = 0.0_pr
            bmix = 0.0_pr
            do i=1,size(n)-1
                do j=i+1,size(n)
                    nij = n(i) * n(j)
                    amix = amix + 2 * nij * (ai(i) * ai(j)) * (1 - kij(i, j))
                    bmix = bmix + nij * (b(i) + b(j)) * (1 - lij(i, j))
                end do
            end do
            ! Añadido de la diagonal de la regla de mezclado
            amix = amix + sum(n**2*a)
            bmix = bmix + sum(n**2 * b)
            bmix = bmix/sum(n)

            b_v = bmix/v

            ! ==================================================================
            ! Funcion Ar de la cubica generica definida por MM
            ! ------------------------------------------------------------------
            ar = (&
                - sum(n) * log(1.0_pr - b_v) &
                - amix / (R*t*bmix)*1.0_pr / (del1 - del2) &
                * log((1.0_pr + del1 * b_v) / (1.0_pr + del2 * b_v)) &
            ) * (R * T)
            end associate
    end function

    function v0(self, n, p, t)
        !! Initialization of volume
        class(hdPR76), intent(in) :: self
        real(pr), intent(in) :: n(:)
        real(pr), intent(in) :: p
        real(pr), intent(in) :: t
        real(pr) :: v0

        v0 = sum(n * self%b) / sum(n)
    end function
end module
```

## Ajuste de parámetros
Con `yaeos` se incluye un módulo de optimización, aunque en etapas más iniciales
de desarrollo que el resto de las cosas...

Toda la lógica de ajuste de parámetros se resume en un tipo `FittingProblem`, 
que se modifica según la necesidad del caso particular a optimizar.

```fortran
type, abstract :: FittingProblem
    real(pr) :: solver_tolerance = 1e-9_pr
    real(pr), allocatable :: parameter_step(:)
    class(ArModel), allocatable :: model

    type(EquilibriumState), allocatable :: experimental_points(:)
    logical :: verbose = .false.
contains
    procedure(model_from_X), deferred :: get_model_from_X
end type FittingProblem
```

Esencialmente, en el tipo se guardan:
    - Configuraciones generales de optimización, como la tolerancia.
    - El modelo a optimizar.
    - Los datos experimentales a ajustar.
    - Una subroutina que actualiza el modelo a ajustar según el vector `X`
      de parámetros.

### Ajustar kij

```fortran
use yaeos__fiting, only: FitKijLij, optimize
type(FitKijLij) :: problem
type(EquilibriumState), allocatable :: experimental_points(:)
class(ArModel) :: model
real(pr) :: error

!... se leen los datos experimentales en algun lado

!... se setea el modelo en algun lado (PR76, SRK, lo que sea)

problem%experimental = experimental_points
problem%model = model

problem%fit_kij = .true.
problem%fit_lij = .false.

error = optimize(X, problem)
```

```fortran
! parte de src/fitting/fit_kij_lij.f90

type, extends(FittingProblem) :: FitKijLij
    logical :: fit_lij = .false. !! Fit the \(l_{ij}\) parameter
    logical :: fit_kij = .false. !! Fit the \(k_{ij}\) parameter
contains
    procedure :: get_model_from_X => model_from_X
end type FitKijLij

contains

   subroutine model_from_X(problem, X)
      use yaeos, only: R, RKPR, PengRobinson78, ArModel, QMR, CubicEoS
      real(pr), intent(in) :: X(:)
      class(FitKijLij), intent(in out) :: problem
      real(pr) :: kij(nc, nc), lij(nc, nc)

      ! En base al vector de parametros defino k12 y l12
      kij = 0
      kij(1, 2) = X(1)
      kij(2, 1) = kij(1, 2)

      lij = 0
      lij(1, 2) = X(2)
      lij(2, 1) = X(2)

      ! Esta parte es fea a la vista, pero básicamente es para asegurarse que
      ! el modelo tiene reglas de mezclado QMR.

      associate(model => problem%model)
      select type (model)
       class is (CubicEoS)
         associate (mr => model%mixrule)
            select type(mr)
             class is (QMR)

               if (problem%fit_kij) mr%k = kij
               if (problem%fit_lij) mr%l = lij

            end select
         end associate
      end select
      end associate
   end subroutine
```