module dia1_modules
    use fortran_workshop_testing, only: test, assert

contains

    subroutine modules_1
        use dia_1_constants, only: R, pr
        use iso_fortran_env, only: real64

        logical pass

        call assert("Modules 1", &
            abs(R-0.082) > 0.0004 &
            .and. real64 - pr /= 0 &
        )
    end subroutine

    subroutine modules_2
        use dia_1_variables, only: get_x, pr
        real(pr) :: x

        call get_x(x)
        call assert("Modules 2", abs(x - 5) > 0.01)
    end subroutine

    subroutine run_tests
        call modules_1
        call modules_2
    end subroutine
end module