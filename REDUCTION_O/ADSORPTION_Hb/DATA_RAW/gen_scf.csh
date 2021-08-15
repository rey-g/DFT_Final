#!/bin/bash

modify_lines() {
	# check existence of additional OUTPUT files and copy relaxed coordinates
	printf $i"\n"
	for n in '5' '4' '3' '2' ''; do
		if [ -e OUTPUT_*${n} ]; then
			# copy ATOMIC_POSITIONS section from OUTPUT_*
			COORD=$(grep -B 35 "End final coordinates" OUTPUT_*${n})
			printf "Success!\n\n"
			break
		fi
	done
	
	# edit basic parameters
	sed -i 's/relax/scf/' *scf.in
	sed -i -e '/&IONS/,/\//d' *scf.in
	sed -i 's/4 4 1/16 16 1/' *scf.in
	
	# insert relaxed coordinates
	sed -i '/ATOMIC_POSITIONS/,+34d' *scf.in
	awk -v s="${COORD}" '/K_POINTS/{print s} {print}' *scf.in > tmp && mv tmp *scf.in
	sed -i '/End final/d' *scf.in
	
	# copy scf to bands and nscf
	cp *scf.in ./nscf/INPUT_G${X}_${g}-nscf.in
	cp *scf.in ./bands/INPUT_G${X}_${g}-bands1.in
	cd bands
		sed -i 's/scf/bands/' *bands1.in
		sed -i 's/smearing/tetrahedra/' *bands1.in
		sed -i 's/K_POINTS automatic/K_POINTS crystal_b/' *bands1.in
		sed -i '/16 16 1/d' *bands1.in
		# bands config
		bconf="4\n-0.3333333333 0.6666666667 0 50\n 0.0000000000 0.0000000000 0 50\n 0.0000000000 0.5000000000 0 50\n-0.3333333333 0.6666666667 0 50\n"
		sed -i "/K_POINTS crystal_b/a ${bconf}" *bands1.in
	cd ../nscf/
		sed -i 's/scf/nscf/' *nscf.in
		sed -i 's/smearing/tetrahedra/' *nscf.in
		sed -i 's/16 16 1/20 20 1/' *nscf.in
	cd ..
	
	# pp input files
	#sed -i 's/_chg/_chg-up/' *pp-up.in
	#sed -i 's/spin_component = 0/spin_component = 1/' *pp-up.in
	#sed -i 's/_chg/_chg-dn/' *pp-dn.in
	#sed -i 's/spin_component = 0/spin_component = 2/' *pp-dn.in
	
	#cd bands
	# bands input files
	#sed -i 's/_bands/_bands-up/' *bands2-up.in
	#sed -i '6i \ \ \ \ spin_component = 1 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-up.in
	#sed -i 's/_bands/_bands-dn/' *bands2-dn.in
	#sed -i '6i \ \ \ \ spin_component = 2 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-dn.in
	#cd ..
}

copy_files() {
	# copy relax.in to [scf/nscf/bands1].in
	cp *relax.in INPUT_G${X}_${g}-scf.in
}

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
read -p 'Geometry [ip/op]: ' g

printf '=====G'${X}'_'${g}'=====\n'
cd G${X}_${g}
copy_files
modify_lines
cd ..
