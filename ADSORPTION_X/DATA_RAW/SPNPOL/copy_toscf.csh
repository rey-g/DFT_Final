#!/bin/bash

modify_lines() {
	# check existence of additional OUTPUT files and copy relaxed coordinates
	printf G${X}_${g}"\n"
	for n in '3' '2' ''; do
		if [ -e OUTPUT_*${n} ]; then
			# copy ATOMIC_POSITIONS section from OUTPUT_*
			COORD=$(grep -B 32 "End final coordinates" OUTPUT_*${n})
			printf "Success!\n\n"
			break
		fi
	done
	
	# edit basic parameters
	sed -i 's/relax/scf/' *scf.in
	sed -i -e '/&IONS/,/\//d' *scf.in
	sed -i 's/4 4 1/16 16 1/' *scf.in
	
	# insert relaxed coordinates
	sed -i '/ATOMIC_POSITIONS/,+31d' *scf.in
	awk -v s="${COORD}" '/K_POINTS/{print s} {print}' *scf.in > tmp && mv tmp *scf.in
	sed -i '/End final/d' *scf.in
	
	# copy scf to bands and nscf
	cp *scf.in ./nscf/INPUT_G${X}_${g}-B1-nscf.in
	cp *scf.in ./bands/INPUT_G${X}_${g}-B1-bands1.in
	cd bands
		sed -i 's/scf/bands/' *bands1.in
		sed -i 's/smearing/tetrahedra/' *bands1.in
		sed -i 's/16 16 1/20 20 1/' *bands1.in
	cd ../nscf/
		sed -i 's/relax/nscf/' *nscf.in
		sed -i 's/smearing/tetrahedra/' *nscf.in
		sed -i 's/16 16 1/20 20 1/' *nscf.in
	cd ..
}

copy_files() {
	# copy relax.in to [scf/nscf/bands1].in
	cp *relax.in INPUT_G${X}_${g}-B1-scf.in
}

for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		cd G${X}_${g}
		copy_files
		modify_lines
		cd ..
	done
done
