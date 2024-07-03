program main
   implicit none
   real :: x, y(3) ! Defino variables
   real :: w

   real, allocatable :: vector_indefinido(:)
   integer :: dim

   namelist /mi_namelist/ x, y ! Las asigno al namelist mi_namelist
   namelist /otro_namelist / w


   ! Lectura de namelist
   open(1, file="files/namelist.nml")
   read(1, nml=mi_namelist)
   close(1) ! Siempre cerrar archivo tras leer namelist

   ! Escritura de namelist
   open(1, file="files/namelist.nml")
   write(1, nml=mi_namelist)
   close(1)

   print *, x
   print *, y
   print *, w
   print *, x
end program main