## M_pixel Changelog

The intent of this log is to keep everyone in the loop about what's new
in the M_pixel  project. It is a curated, chronologically ordered list
of notifications of notable events such as bug fixes, new features,
and usage changes.

"Do unto others as you would have them do unto you", as they say. When I
find OS (Open Source) resources, I am hoping a lot of these boxes can be
checked ...
   - [x] git repository on WWW (github)
   - [x] annotated source files with an open license
   - [ ] unit test
   - [x] make(1) build
   - [x] fpm(1) build
   - [x] user manual (on-line)
   - [x] man-page
   - [x] app program
   - [x] demo program for public procedures
   - [x] developer documents (ford(1))
   - [ ] CI/CD(Continious Integration/Development) verification (github actions)
   - [ ] registered in fpm(1) repository
---
**2021-11-20**  John S. Urban  <https://github.com/urbanjost>

### :green_circle: ADD:
   -  mapcolor(3f), draw2(3f), rdraw2(3f), point2(3f) are now elemental procedures.
      This is primarily most useful with point2(3f)
---
**2021-02-06**  John S. Urban  <https://github.com/urbanjost>

### :green_circle: ADD:
   - modern PPM output, P3 and P6 output, routine pixel() added
---
**2020-11-21**  John S. Urban  <https://github.com/urbanjost>

### :red_circle: FIX:
   -  a non-standard logical format was changed. "L0" is a common
      extension but not standard. Might have caused a compile error
      in some programming environments.
---
**2020-08-23**  John S. Urban  <https://github.com/urbanjost>

### :green_circle: ADD:
     initial release on github
---
<!--
### :orange_circle: DIFF:
       + renamed ADVICE(3f) to ALERT(3f)
### :green_circle: ADD:
       + advice(3f) was added to provide a standardized message format simply.
### :red_circle: FIX:
       + </bo> did not work on several terminal types, changed it to a more
         universally accepted value.
-->
