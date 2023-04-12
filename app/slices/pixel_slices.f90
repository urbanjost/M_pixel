!-----------------------------------------------------------------------------------------------------------------------------------
program plottests
use M_pixel, only : prefsize, vinit, vexit
use :: M_pixel, only : p_pixel, p_colormap
use :: m_writegif_animated, only : write_animated_gif
implicit none
integer,parameter   :: ix=34
integer,parameter   :: iz=45
real                :: SURFDAT(ix,iz) ! array of y values
real,parameter      :: pi=3.141592654
integer             :: i, j
integer             :: nx, nz
real                :: a, b
integer,parameter   :: xx=600, yy=600 ! pixel array size
integer,allocatable :: movie(:,:,:)
integer             :: iframe, ib, ia
integer             :: ia1=0,ia2=88,ia3=2,ib1=1,ib2=90,ib3=15,iasz,ibsz
   ! fill some arrays with data we can plot
   do j=1,ix
      do i=1,iz
         surfdat(j,i)=cos(pi*real(j-1)/12.0)*cos(pi*real(i-1)/12.0)
      enddo
   enddo
   nx=34
   nz=45
   !iterations = MAX(0,INT((final-value - initial-value + step-size)/step-size))
   iasz = MAX(0,INT( (ia2 - ia1 + ia3) /ia3))*2
   ibsz = MAX(0,INT( (ib2 - ib1 + ib3) /ib3))
   write(*,*)iasz,ibsz,iasz*ibsz

   allocate(movie(iasz*ibsz,0:xx-1,0:yy-1))
   call prefsize(xx,yy)
   call vinit()
   iframe=0
   do ib=ib1,ib2,ib3
      do ia=ia1,ia2,ia3   ! animate cycling thru angle a
         !draw something
         a=ia
         b=ib
         call pixel_slice(surfdat,ix,iz,nx,nz,a,b)
         iframe=iframe+1
         movie(iframe,:,:)=p_pixel(:,:)
         write(*,*)'IFRAME=',iframe,'ALPHA=',a,'BETA=',b
      enddo
      do ia=ia2,ia1,-ia3   ! animate cycling thru angle a
         !draw something
         a=ia
         b=ib
         call pixel_slice(surfdat,ix,iz,nx,nz,a,b)
         iframe=iframe+1
         movie(iframe,:,:)=p_pixel(:,:)
         write(*,*)'IFRAME=',iframe,'ALPHA=',a,'BETA=',b
      enddo
   enddo
   write(*,*)'LAST IFRAME=',iframe
   call vexit()    ! close up plot package
   call write_animated_gif('movie.gif',movie,p_colormap,delay=4)
end program plottests
subroutine pixel_SLICE(surfdat,kix,kiz,nx,nz,a0,b0)
   use M_pixel
   use :: M_pixel_slices, only : dl_slices, dl_init, dl_symbol
!-----------------------------------------------------------------------------------------------------------------------------------
   real,intent(in)              :: SURFDAT(kix,kiz) ! array of y values
   integer,intent(in)           :: kix              ! x dimension of surfdat array
   integer,intent(in)           :: kiz
   integer,intent(in)           :: nx               ! x size of surface to plot
   integer,intent(in)           :: nz
   real,intent(in)              :: a0               ! initial angle of x axis from horizontal 0-80 degrees
   real,intent(in)              :: b0               ! initial angle of z axis from horizontal 5-80 degrees
!-----------------------------------------------------------------------------------------------------------------------------------
   integer           :: ICOL(255)
   character(len=80) :: XT,YT,ZT                    ! axis titles
   real              :: a
   real              :: b
   integer           :: i
   integer           :: ix
   integer           :: iz
   integer           :: iflag
   integer           :: iax
   real              :: xh, yh, zh
!-----------------------------------------------------------------------------------------------------------------------------------
   a=a0                                             ! mutable copy of parameter A
   b=b0                                             ! mutable copy of parameter B
!-----------------------------------------------------------------------------------------------------------------------------------
!  initialize the color array
   DO I=1,255
      ICOL(I)=MOD(I,7)
   enddo
!-----------------------------------------------------------------------------------------------------------------------------------
   CALL DL_INIT(12.5,12.5,1.5,1.5,1.0)
!-----------------------------------------------------------------------------------------------------------------------------------
!     now plot 3-d surface using slices with axis
!-----------------------------------------------------------------------------------------------------------------------------------
! surface data
IX=KIX ! IX,IZ    (i): x and z dimensions of SURFDAT array
IZ=KIZ
! NX,NZ    (i): x and z sizes of surface to plot SURFDAT array
!-----------------------------------------------------------------------------------------------------------------------------------
! view angles
! A        (R): angle of x axis from horizontal 0-80 degrees
! B        (R): angle of z axis from horizontal 5-80 degrees
!               note: origin (1,1) is in lower-left corner
!                     x axis runs left to right on screen
!                     y axis runs up to down on screen
!                     z axis appears to run into the screen but is angled to the right
!-----------------------------------------------------------------------------------------------------------------------------------
! length of axis in window units
XH=6.0 ! xh,yh,zh (R): length of each axis
YH=3.8
ZH=5.0
!-----------------------------------------------------------------------------------------------------------------------------------
IFLAG=012
IFLAG=002
IFLAG=000
! iflag    (i): option flag
!               (1's digit) =2: use color array (need all parameters)
!                           =1: do not use color array
!               (10's digit)=0: Plot sides
!                           =1: Do not plot sides
!-----------------------------------------------------------------------------------------------------------------------------------
IAX=-11
IAX= 01
! SIGN:
! iax   (i): axis format control
!            < 0 : plot axes, use input scale factors dm and dx
!            = 0 : no axes plotted, optional parameters (xt...dx)
!                  not used, scaling computed from input array
!            > 0 : plot axes, use scaling computed from input array
!                  only axis parameters xt through smz accessed.
! DIGITS:
!  (1's digit)  = 1 : Plot actual max/min or input values for Y axis
!               = 2 : Plot smoothed values for Y axis
!  (10's digit) = 0 : Use default axis type
!               = 1 : Use input DL_AXISB-type axis parameters
!                      (nmx, nnx, mlx, tsx, ndx, etc.)
!-----------------------------------------------------------------------------------------------------------------------------------
!          (NOTE: the following optional parameters are accessed only if
!                 iax < 0 or mod(iflag,10)=1)
DM=-1.0   ! dm,dx (R): minimum and maximum values of SURFDAT array
DX=1.0
!-----------------------------------------------------------------------------------------------------------------------------------
! (NOTE: the following optional parameters are used if iax < 0 or mod(iflag,10)=1)
!        (see DL_AXISB for detailed description of axis parameters)
!-----------------------------------------------------------------------------------------------------------------------------------
! XAXIS:
XS=-10.0               ! xs,xe (R): starting and ending values displayed on x axis
XE=10.0
!-----------------------
NMX=4                  ! nmx   (i): number of minor ticks between major ticks on x axis
NNX=0                  ! nnx   (i): highlight length of nnx-th minor tick on x axis
MLX=4                  ! mlx   (i): number of major tick marks on x axis
TSX=-0.15              ! tsx   (R): size of title and numbers on x axis
!                         < 0 auto exponent scaling (x10 to power) disabled
!                         > 0 auto exponent scaling (x10 to power) enabled
NDX=1                  ! (i): number of digits to right of decimal point on x axis
SMX=0.1                ! (R): major tick length on x axis
!-----------------------
XT='X Axis'            ! xt    (C): title of x axis (width)
NXT=len_trim(xt)       ! nxt   (i): number of characters in xt ;nxt = 0 : no axis plotted ; nxt > 0 : normal
!-----------------------------------------------------------------------------------------------------------------------------------
! YAXIS:
YS=-10.0               ! ys,ye (R): starting and ending values displayed on y axis
YE=10.0
!-----------------------
NMY=1                  ! (i): number of minor ticks between major ticks on y axis
NNY=0                  ! (i): highlight length of nny-th minor tick on y axis
MLY=3                  ! (i): number of major tick marks on y axis
TSY=-0.15              ! (R): size of title and numbers on y axis
                       !      < 0 auto exponent scaling (x10 to power) disabled
                       !      > 0 auto exponent scaling (x10 to power) enabled
NDY=1                  ! ndy   (i): number of digits to right of decimal point on y axis
SMY=0.10               ! smy   (R): major tick length on y axis
!-----------------------
YT='Y Axis'            ! yt    (C): title of y axis (width)
NYT=len_trim(yt)       ! nyt   (i): number of characters in xt ;nyt = 0 : no axis plotted ; nyt > 0 : normal
!-----------------------------------------------------------------------------------------------------------------------------------
! ZAXIS:
ZS=1.0
ZE=NZ                  ! zs,ze (R): starting and ending value displayed on z axis
!-----------------------
NMZ=0                  ! nmz   (i): number of minor ticks between major ticks on z axis
NNZ=2                  ! nnz   (i): highlight length of nnz-th minor tick on z axis
MLZ=5                  ! mlz   (i): number of major tick marks on z axis
TSZ=-0.15              ! tsz   (R): size of title and numbers on z axis
!                         < 0 auto exponent scaling (x10 to power) disabled
!                         > 0 auto exponent scaling (x10 to power) enabled
NDZ=0                  ! ndz   (i): number of digits to right of decimal point on z axis
SMZ=0.1                ! smz   (R): major tick length on z axis
!-----------------------
ZT='SLICE'             ! zt    (C): title of z axis (width)
NZT=len_trim(zt)       ! nzt   (i): number of characters in xt ;nzt = 0 : no axis plotted ; nzt > 0 : normal
!-----------------------------------------------------------------------------------------------------------------------------------
! (NOTE: color array accessed only if mod(iflag,10)=1)
! ic    (i): color list
!            ic(1) : color for axis lines
!            ic(2) : color for axis numbers
!            ic(3) : color for axis titles
!            ic(4) : color for axis exponents
!            ic(5) : color index for lower plot surface (return)
!            ic(6) : color index for upper plot surface (return)
!-----------------------------------------------------------------------------------------------------------------------------------
   CALL COLOR(7)
   CALL CLEAR()
   CALL COLOR(0)
   CALL dl_slices(SURFDAT,IX,IZ,NX,NZ,A,B,XH,YH,ZH,IFLAG,IAX, &
     &    XT,NXT,                                                   &
     &    XS,XE,NMX,NNX,MLX,TSX,NDX,SMX,                            &
     &    YT,NYT,                                                   &
     &    NMY,NNY,MLY,TSY,NDY,SMY,                                  &
     &    ZT,NZT,                                                   &
     &    ZS,ZE,NMZ,NNZ,MLZ,TSZ,NDZ,SMZ,                            &
     &    DM,DX,ICOL)
!        add a label after master routine call
   CALL LINEWIDTH(3)
   CALL COLOR(4)
   CALL DL_SYMBOL(0.0,0.0,0.25,'dl_slices',0.0,9,-1)
END subroutine pixel_slice
