program dia_1_evaluation
    use fortran_workshop_testing, only: assert, test
    use dia1_modules, only: d1_mods => run_tests
    implicit none

    call d1_mods

    call subroutines_sumar
    call subroutines_sumarr
    call subroutines_sumat

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
    end subroutine

    subroutine subroutines_sumarr
        use dia_1, only: pr, sumarr
        real(pr) :: x(5), y

        x = [5, 2, 2, 3, 5]
        call sumarr(x, y)

        if (abs(y - sum(x)) > 1e-5) error stop 1
    end subroutine
    
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

        if (abs(y - y_val) > 1e-5) error stop 1
    end subroutine
end program
