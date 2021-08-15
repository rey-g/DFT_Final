#!/bin/bash

gen_csh() {
	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N ${X}_${g}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}-B1-relax.in > OUTPUT_G${X}_${g}-B1-relax

# delete tmp
rm -r tmp/" > relax.csh

	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}-B1-scf.in > OUTPUT_G${X}_${g}-B1-scf

# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}-B1-pp-up.in > OUTPUT_G${X}_${g}-B1-pp-up
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}-B1-pp-dn.in > OUTPUT_G${X}_${g}-B1-pp-dn

# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}-B1-bader.in > OUTPUT_G${X}_${g}-B1-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}-B1-nscf.in > OUTPUT_G${X}_${g}-B1-nscf

# pdos
mpirun -np \$NSLOTS projwfc.x -inp INPUT_G${X}_${g}-B1-pdos.in > OUTPUT_G${X}_${g}-B1-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}-B1-bands1.in > OUTPUT_G${X}_${g}-B1-bands1

# bands2
mpirun -np \$NSLOTS bands.x -inp INPUT_G${X}_${g}-B1-bands2-up.in > OUTPUT_G${X}_${g}-B1-bands2-up
mpirun -np \$NSLOTS bands.x -inp INPUT_G${X}_${g}-B1-bands2-dn.in > OUTPUT_G${X}_${g}-B1-bands2-dn

# delete tmp
rm -r tmp/" > etc.csh

	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_ADS_G${X}_${g}-B1-scf.in > OUTPUT_ADS_G${X}_${g}-B1-scf
mpirun -np \$NSLOTS pw.x -inp INPUT_SUBS_G${X}_${g}-B1-scf.in > OUTPUT_SUBS_G${X}_${g}-B1-scf

# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}-B1-pp.in > OUTPUT_ADS_G${X}_${g}-B1-pp
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}-B1-pp.in > OUTPUT_SUBS_G${X}_${g}-B1-pp

# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}-B1-bader.in > OUTPUT_ADS_G${X}_${g}-B1-bader
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}-B1-bader.in > OUTPUT_SUBS_G${X}_${g}-B1-bader

rm -r tmp_ads/
rm -r tmp_subs/" > etc2.csh
}

modify_lines() {
	# create files for up and dn
	cp *pp.in INPUT_G${X}_${g}-B1-pp-up.in
	cp *pp-up.in INPUT_G${X}_${g}-B1-pp-dn.in
	
	cd bands
	mv *bands2.in INPUT_G${X}_${g}-B1-bands2-up.in
	cp *bands2-up.in INPUT_G${X}_${g}-B1-bands2-dn.in
	cd ..
	
	# edit the smaller files
	sed -i 's/-dens/_chg-up/' *pp-up.in
	sed -i 's/spin_component = 0/spin_component = 1/' *pp-up.in
	sed -i 's/-dens/_chg-dn/' *pp-dn.in
	sed -i 's/spin_component = 0/spin_component = 2/' *pp-dn.in
	
	cd bands
	sed -i 's/_bands/_bands-up/' *bands2-up.in
	sed -i '6i \ \ \ \ spin_component = 1 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-up.in
	sed -i 's/_bands/_bands-dn/' *bands2-dn.in
	sed -i '6i \ \ \ \ spin_component = 2 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-dn.in
	cd ..
	
	# edit relax.in
	spn_param='    nspin = 2 ,\n    starting_magnetization(1) = 0.5,\n    starting_magnetization(2) = 0.5,'
	awk -v s="${spn_param}" '/vdW-DF/{print;print s;next}1' *relax.in > tmp && mv tmp *relax.in
}

copy_files() {
	# copy files
	cp -t ./ ../../NON-SPNPOL/B1/G${X}_${g}/*relax*.in
	cp -t ./ ../../NON-SPNPOL/B1/G${X}_${g}/*bader.in
	cp -t ./ ../../NON-SPNPOL/B1/G${X}_${g}/*pp.in
	rm INPUT_*relax[0-9].in
	
	cp -t ./nscf ../../NON-SPNPOL/B1/G${X}_${g}/nscf/*pdos.in
	cp -t ./bands ../../NON-SPNPOL/B1/G${X}_${g}/bands/*bands2.in
}

for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		# mkdir -p G${X}_${g}
		cd G${X}_${g}
		# mkdir -p nscf
		# mkdir -p bands
		# copy_files
		gen_csh
		# modify_lines
		cd ..
	done
done
