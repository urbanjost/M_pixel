program demo_roman     !  Use the gif module to create a sample animated gif.
use M_writegif_animated, only : write_animated_gif
use m_pixel,  only : hershey,    color,   P_colormap, clear
use m_pixel,  only : linewidth,  circle,  vexit,      prefsize
use m_pixel,  only : P_pixel,    vinit,   ortho2,   viewport
implicit none
   integer,parameter                    :: n        = 200  ! size of image (square)
   integer,dimension(:,:,:),allocatable :: pixel    !! pixel values
   integer                              :: iframe
   integer,parameter                    :: nframes=127-32+1-3
   character(len=6)                     :: string

   ! create array of frames to copy array into to create animation
   allocate(pixel(nframes,0:n,0:n))

   ! create array to draw in
   call prefsize(n,n)
   call vinit()
   call clear(0)

   ! make world area from -100,-100 to 100,100
   call viewport(0.0,real(n),0.0,real(n))
   call ortho2(-100.0,100.0,-100.0,100.0)

   do iframe=1,nframes
      write(*,*)'frame',iframe
      pixel(iframe,:,:) = 0      !clear entire image:

      call color(3)
      call linewidth(250)
      call circle(0.0,0.0,45.0)

      call color(1)
      call linewidth(200)
     !call hershey( x, y,  height, itext,  theta, ntext )
      write(string,'("\",i4,"\")')1000+iframe
      call hershey( 0.0, 0.0, 45.0,    string, 0.0,   -1 )
      write(*,*)'P_pixel',size(P_pixel),ubound(P_pixel),lbound(P_pixel)
      write(*,*)'pixel',iframe,size(pixel),ubound(pixel),lbound(pixel)
      pixel(iframe,:,:)=P_pixel(:,:)
   end do

   call write_animated_gif('roman_animated.gif',pixel,P_colormap,delay=50)
   deallocate(pixel)
   call vexit()
end program demo_roman
