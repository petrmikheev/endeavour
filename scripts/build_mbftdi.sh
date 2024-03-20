#!/bin/bash

mkdir mbftdi && cd mbftdi

FTD2XX=libftd2xx-x86_64-1.4.27
wget https://ftdichip.com/wp-content/uploads/2022/07/$FTD2XX.tgz
tar xvzf $FTD2XX.tgz && rm $FTD2XX.tgz
mv release ftd2xx

wget -O mBlasterFtdi_v1_4.zip https://marsohod.org/downloads/category/16?download=129
unzip mBlasterFtdi_v1_4.zip && rm mBlasterFtdi_v1_4.zip
mv mBlasterFtdi_v1_4/MBFTDI-SVF-Player src && rmdir mBlasterFtdi_v1_4

rm src/common/ftd2xx.h && ln -s ../../ftd2xx/ftd2xx.h src/common/ftd2xx.h
sed -i 's/#include <string.h>/#include <string.h>\n#include <unistd.h>/g' src/common/mblastercore.c
cd src/linux
sed -i 's/LIBPATH =.*/LIBPATH = ..\/..\/ftd2xx\/build/g' Makefile
sed -i 's/INCPATH =.*/INCPATH = ..\/..\/ftd2xx/g' Makefile
sed -i '/CFLAGS  =-ldl -lrt -lpthread/d' Makefile
sed -i 's/CFLAGS += $(LIBPATH)\/libftd2xx.a/CFLAGS  = $(LIBPATH)\/libftd2xx.a -ldl -lrt -lpthread/g' Makefile

make
cp mbftdi ../../
