#! /bin/bash

read -p 'Halogen [X]: ' X

cd G$X
for h in */; do
	he=${h//.}
	cp *scf.in $h/INPUT_G${X}-B3-${h///}-scf.in
	cp relax.csh $h/conv_${h///}.csh
	
	# edit files
	cd $h
	sed -i -e 's/G'${X}'_op/G'${X}'-'${h///}'/g' *scf.in
	sed -i -e '42d' *scf.in
	sed -i -e '42i'${X}'\ \ \ \ 0.5\ 0.25\ ' *scf.in
	
	sed -i -e 's/_op-B3-relax/-B3-'${h///}'-scf/g' *.csh
	sed -i -e 's/_op-relax/-'${h///}'/g' *.csh
	cd ..
done
cd ..
