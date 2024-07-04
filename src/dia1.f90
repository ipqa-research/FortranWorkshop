module dia_1_constants
   implicit none
   integer, parameter :: pr = selected_real_kind(15)
   real(pr), parameter :: R = 0.082
end module dia_1_constants

module dia_1_variables
   use dia_1_constants, only: pr
   implicit none
   real(pr) :: x=5

contains

   subroutine get_x(xx)
      real(pr), intent(out) :: xx

      !! Importante: Si definiese la variable de la rutina como `x`
      !! esta enmascaría a la variable del módulo (la que está definida en el
      !! modulo sería ignorada)
      xx = x
   end subroutine get_x
end module dia_1_variables

module dia_1_subroutines
   use dia_1_constants, only: pr


   interface suma
      !! Interface que permite que el compilador detecte automaticametne cual
      !! de las tres subrutinas llamar.
      module procedure :: sumar, sumarr, sumat
   end interface suma

contains

   subroutine sumar(x, y, z)
      real(pr), intent(in) :: x
      real(pr), optional, intent(in) :: y
      real(pr), intent(out) :: z

      if (present(y)) then
         z = x + y
      else
         z = x + x
      end if
   end subroutine sumar

   subroutine sumarr(x, y)
      real(pr), intent(in) :: x(:)
      real(pr), intent(out) :: y

      y = sum(x)
   end subroutine sumarr

   subroutine sumat(x, y)
      real(pr), intent(in) :: x(:, :)
      real(pr), intent(out) :: y

      y = sum(sum(x, dim=1))
   end subroutine sumat
end module dia_1_subroutines

module dia_1_derivados
   use dia_1_constants, only: pr
   implicit none

   type :: Margules
      real(pr) :: A12, A21
      real(pr) :: Psat(2)
   contains
      procedure :: lngamma => ln_gamma
   end type Margules

contains
   subroutine ln_gamma(model, x, lngamma)
      class(Margules), intent(in) :: model
      real(pr), intent(in) :: x(2)
      real(pr), intent(out) :: lngamma(2)

      ! Associate nos permite evitar escribri tanto choclo
      associate(A12 => model%A12, A21 => model%A21)
         lngamma(1) = (A12 + 2 * (A21 - A12)*x(1))*x(2)**2
         lngamma(2) = (A21 + 2 * (A12 - A21)*x(2))*x(1)**2
      end associate
   end subroutine ln_gamma

   subroutine pressure(model, x, P)
      class(Margules), intent(in) :: model
      real(pr), intent(in) :: x(2)
      real(pr), intent(out) :: P

      real(pr) :: lngammas(2), gammas(2)
      call model%lngamma(x, lngammas)

      gammas = exp(gammas)
      P = sum(x * gammas * model%Psat)
   end subroutine pressure
end module dia_1_derivados

module dia_1_allocatables
   use dia_1_constants, only: pr
   implicit none
contains
   subroutine set_dim(x, dim)
      real(pr), allocatable, intent(in out):: x(:)
      integer, intent(in) ::dim
      if (allocated(x)) deallocate(x)
      allocate(x(dim))
   end subroutine set_dim

   subroutine agrandar(array, nuevo_valor)
      real(pr), allocatable, intent(in out) :: array(:)
      real(pr), intent(in) :: nuevo_valor
      array = [array, nuevo_valor]
   end subroutine agrandar
end module dia_1_allocatables

module dia_1
   use dia_1_constants
   use dia_1_variables
   use dia_1_subroutines
   use dia_1_allocatables
   implicit none
end module dia_1
