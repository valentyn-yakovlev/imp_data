#!/bin/sh

DATA_DIR=/opt/mysql/data/fnp_new
DIR=$(date '+%s')
mkdir /tmp/TB_${DIR}

for f in ISMOTL.frm ISMOTL.ibd ISMPOT.frm ISMPOT.ibd ISMPST.frm ISMPST.ibd ISMSTL.frm ISMSTL.ibd
do
        scp $DATA_DIR/$f avasthi@192.168.55.118:
done

