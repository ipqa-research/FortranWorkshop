module dia1_allocatables
    use fortran_workshop_testing, only: test, assert

contains
    subroutine allocatables_1
        use dia_1, only: set_dim, pr
        real(pr), allocatable :: x(:)
        integer :: dim

        dim = 2
        call set_dim(x, dim)
        call assert("Allocatables 1, set", size(x) == 2)

        dim = 5
        call set_dim(x, dim)
        call assert("Allocatables 1, redefine", size(x) == 5)
    end subroutine

    subroutine allocatables_2
        use dia_1, only: agrandar, pr
        real(pr), allocatable :: x(:)
        x = [1.2_pr, 2.5_pr]
        call agrandar(x, 0.5_pr)
        call assert("Allocatables 2", maxval(abs(x - [1.2_pr, 2.5_pr, 0.5_pr])) < 1e-5)
    end subroutine

    subroutine run_tests
        call allocatables_1
        call allocatables_2
    end subroutine
end module