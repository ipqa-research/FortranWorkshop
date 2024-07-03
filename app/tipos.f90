module dt
   type :: Regression
      !! Tipo que maneja la lógica de una regresión
      real :: a !! parametro a
      real :: b, c, d, e, f
   contains
      procedure :: foo
   end type Regression
contains
   subroutine foo(params, x, y)
      class(Regression) :: params
      real, intent(in) :: x
      real, intent(out) :: y
      y = params%a * params%b *x + params%c*x**2 + params%e * params%f
   end subroutine foo
end module dt

program main
    use dt
    implicit none
    type(Regression) :: mis_parametros, mis_otros_parametros
    real :: x, y
  
    ! Seteo parametros
    mis_parametros = Regression(a=0.1, b=0.5, c=0.3, d=0.5, e=0.2, f=5.0)
    mis_otros_parametros = Regression(a=0.5, b=8.5, c=1.3, d=0.5, e=0.2, f=5.0)
   
    ! Con % puedo acceder a cualquier elemento
    print *, mis_parametros%a

    x = 5
    
    ! Tambien puedo llamar a las rutinas que tengan
    call mis_parametros%foo(x, y)
    print *, y
    
    call mis_otros_parametros%foo(x, y)
    print *, y

    ! No quita que la rutina sigue funcionando "aislada".
    call foo(mis_parametros, x, y)
end program main
