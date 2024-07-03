program main
    ! Jugar con dimensiones y valores. Ejecutar muchas veces para ver
    ! como varia X interna e y
    implicit none
    real :: x(2), z(3)
    real :: y

    x = [1, 2]

    print *, "Incluye la basura en X interna"
    call f(5, x, y)
    print *, y

    print *, "Solo me va a tomar los dos primeros"
    call f(2, [1., 2., 6.], y)
    print *, y
    
    call fasum(x, y)
    print *, y
contains
    subroutine f(n, x, y)
        integer :: n
        real :: x(n)
        real :: y

        print *, "Internal X: ", x
        y = sum(x)
    end subroutine
    
    subroutine fasum(x, y)
        real :: x(:)
        real :: y
        real :: w(size(x))

        print *, "X asumida: ", x
        y = sum(x)
    end subroutine
end program