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

module dia_1_allocatables
   use dia_1_constants, only: pr
   implicit none
contains
   subroutine set_dim(x, dim)
      real(pr), allocatable, intent(in out):: x(:)
      integer, intent(in) ::dim 
      if (allocated(x)) deallocate(x)
      allocate(x(dim))
   end subroutine

   subroutine agrandar(array, nuevo_valor)
      real(pr), allocatable, intent(in out) :: array(:)
      real(pr), intent(in) :: nuevo_valor
      array = [array, nuevo_valor]
   end subroutine
end module

module dia_1
   use dia_1_constants
   use dia_1_variables
   use dia_1_subroutines
   use dia_1_allocatables
   implicit none
end module dia_1
