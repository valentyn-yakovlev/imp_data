#!/bin/sh

mysql -B -N -u fnp -pfnp -D fnp_new -e 'select concat(pbirfnum," ", pbipdusprice," ","http://www.fnp.in/fnp/faces/tracker.jsp?mailerid=FNP_naaptol&linkid=naaptol&successurl=http://www.fnp.in/fnp/product/y/--pI~",pbirfnum,"-clI~2-/",pbititle,".html",pbititle) as " " from ISMPBI where isactive="Y" and pbimoderstatus="Y"' >/tmp/today_fnp

 #sed -e "s/'//g" /tmp/today_fnp >/fnp_octaincu/static/today_fnp

