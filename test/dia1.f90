program dia_1_evaluation
    implicit none
    call modules_constants

contains

    subroutine print_test(str)
        character(len=*), intent(in) :: str
        print *, str
    end subroutine

    subroutine modules_constants
        use dia_1_constants, only: R, pr
        use iso_fortran_env, only: real64

        if (abs(R-0.082) > 0.0004) error stop 1
        if (real64 - pr /= 0) error stop 1
    end subroutine

    subroutine modules_variables_subroutine
        use dia_1_variables, only: get_x, pr
        real(pr) :: x

        call get_x(x)
        if (abs(x - 5) > 0.01) error stop 1
    end subroutine
end program
