module dia1_subroutines
   use fortran_workshop_testing, only: assert

contains

   subroutine subroutines_sumar
      use dia_1, only: pr, sumar
      real(pr) :: x, y, z

      x = 2
      y = 3
      call sumar(x, y, z)

      call assert("Subroutines 1", abs(z - 5) > 1e-5)

      x = 2
      call sumar(x, z=z)
      if (abs(z - 4) > 1e-5) error stop 1
   end subroutine subroutines_sumar

   subroutine subroutines_sumarr
      use dia_1, only: pr, sumarr
      real(pr) :: x(5), y

      x = [5, 2, 2, 3, 5]
      call sumarr(x, y)

      call assert("Subroutines 2", (abs(y - sum(x)) > 1e-5))
   end subroutine subroutines_sumarr

   subroutine subroutines_sumat
      use dia_1, only: pr, sumat
      real(pr) :: x(5, 5), y, y_val
      integer :: i, j

      y_val = 0
      do i=1,5
         do j=1,5
            x(i, j) = rand(i*j)
            y_val = y_val + x(i, j)
         end do
      end do

      call sumat(x, y)
      call assert("Subroutines 3", (abs(y - y_val) > 1e-5))
   end subroutine subroutines_sumat

   subroutine run_tests
      call subroutines_sumar
      call subroutines_sumarr
      call subroutines_sumat
   end subroutine 
end module dia1_subroutines
