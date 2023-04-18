program plottests
use :: M_pixel
use :: M_pixel__writegif_animated, only : write_animated_gif
implicit none
integer,parameter  :: xx=600, yy=600 ! pixel array size
integer            :: movie(171,0:xx-1,0:yy-1)
integer            :: iframe
   call prefsize(xx,yy)
   call vinit()
   call ortho2(0.0,500.0,0.0,500.0)
   call linewidth(600)
   call centertext(.true.)
   do iframe=-85,85   ! animate cycling thru angle a
      p_pixel=3
      call color(7)
      call clear()
      call color(3)
      !call color(mod(iframe,7))
      call circle(250.0,250.0,3.0*iframe)
      call color(2)
      call move2(0.0,0.0)
      call draw2(500.0,500.0)
      call move2(0.0,500.0)
      call draw2(500.0,0.0)
      call color(1)
      call move2(250.0,250.0)
      !!call textsize(10.0*iframe,10.0*iframe)
      call textsize(abs(2.0*iframe),abs(2.0*iframe))
      call drawstr('NO')
      movie(iframe+85+1,:,:)=p_pixel(:,:)
   enddo
   call vexit()    ! close up plot package
   call write_animated_gif('no.gif',movie,p_colormap,delay=1)
end program plottests
