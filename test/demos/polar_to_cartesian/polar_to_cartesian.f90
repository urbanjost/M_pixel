          program demo_polar_to_cartesian
          use M_pixel, only : polar_to_cartesian
          implicit none
          real    :: x,y
          real    :: r,i
          integer :: ios
          INFINITE: do
             read(*,*,iostat=ios) x, y
             if(ios.ne.0)exit INFINITE
             call polar_to_cartesian(r,i,x,y)
             write(*,*)'x=',x,' y=',y,'radius=',r,'inclination=',i
          enddo INFINITE
          end program demo_polar_to_cartesian
