program flasher
  ! Programa ejemplo de calculo Flash con ecuacion de estado
  use yaeos, only: pr, EquilibriaState, flash, PengRobinson76, ArModel, CubicEoS
  implicit none

  integer, parameter :: nc = 2 ! Numero de componentes
  class(ArModel), allocatable :: model  ! Variable que aloja datos del modelo
  type(EquilibriaState) :: flash_result ! Variable que aloja datos de equilibrio

  real(pr) :: tc(nc), pc(nc), w(nc) ! Constantes criticas

  real(pr) :: n(nc), t, p ! Variables de EoS
  real(pr) :: k0(nc)
  integer :: iter

  print *, "FLASH EXAMPLE:"
  
  n = [0.4, 0.6]            ! Vector de moles
  tc = [190.564, 425.12]    ! Temperaturas criticas
  pc = [45.99, 37.96]       ! Presiones criticas
  w = [0.0115478, 0.200164] ! Factores acentricos

  ! Seteo el modelo como PengRobinson76
  model = PengRobinson76(Tc, Pc, w)

  P = 60
  T = 294

  ! Valores de inicializacion (K-Wilson)
  k0 = (Pc/P)*exp(5.373*(1 + w)*(1 - Tc/T))
  
  ! Llamado a funcion flash, especificando temperatura y presion
  flash_result = flash(model, n, t=T, p_spec=P, k0=k0, iters=iter)

  print *, "==================================================================="
  print *, "Resultado de Flash: "
  print *, "X:", flash_result%x, sum(flash_result%x)
  print *, "Y:", flash_result%y, sum(flash_result%y)
  print *, "Vx: ", flash_result%Vx
  print *, "Vy: ", flash_result%Vy
  print *, "P: ", flash_result%p
  print *, "T: ", flash_result%T
end program