#!/bin/bash

modify_etc2() {
	sed -i -e '/# pp/,+2d' etc2.csh
	sed -i -e '/# bader/,+1d' etc2.csh
	sed -i -e '/cp -r tmp\/ bands/d' etc2.csh
	sed -i -e '/# chdir to bands dir/,+11d' etc2.csh
}

for i in */; do
	cd $i
	for j in */; do
		cd $j
		for k in */; do
			cd $k
			cp etc.csh etc2.csh
			modify_etc2
			cd ..
		done
		cd ..
	done
	cd ..
done
