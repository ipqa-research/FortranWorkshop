program main
  implicit none
  real, allocatable :: x(:)
  real :: y
  integer :: i

  ! Asigno una dimension a X
  allocate(x(2))
  x(1) = 2
  x(2) = 5

  ! Esta linea da error en runtime ya que no tiene indice 3
  ! x(3) = 2

  print *, x


  ! Si asigno la variable entera en una igualdad, se va a reestructurar segun
  ! esa igualdad
  x = [1, 3, 6]
  print *, x

  ! Desarmamos x
  deallocate(x)
  print *, x

  ! Asignamos x con dimension 0 y la vamos agrandando
  y = 2
  allocate(x(0))

  do i=1,5
    x = [x, real(i)]
    print *, x
  end do
  
end program