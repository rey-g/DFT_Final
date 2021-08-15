#! /bin/bash

write_relax () {
	cd $S
	for i in 'F' 'Cl' 'Br' 'I'; do
		for j in 'ip' 'op'; do
			cd G${i}_${j}
			
			printf "#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N G${i}_${j}-relax
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np \$NSLOTS pw.x -inp INPUT_G${i}_${j}-${S}-relax.in | tee OUTPUT_G${i}_${j}-${S}-relax

rm -r tmp/\n\n" > relax.csh

			cd .. # end G${i}_${j}
		done
	done
	cd .. # end $S
}

write_etc () {
	cd $S
	for i in 'F' 'Cl' 'Br' 'I'; do
		for j in 'ip' 'op'; do
			cd G${i}_${j}
			
			printf "#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N G${i}_${j}-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${i}_${j}-${S}-scf.in | tee OUTPUT_G${i}_${j}-${S}-scf
# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_G${i}_${j}-${S}-pp.in | tee OUTPUT_G${i}_${j}-${S}-pp
# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_G${i}_${j}-${S}-bader.in | tee OUTPUT_G${i}_${j}-${S}-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${i}_${j}-${S}-nscf.in | tee OUTPUT_G${i}_${j}-${S}-nscf
# pdos
mpirun -np \$NSLOTS projwfc.x -inp INPUT_G${i}_${j}-${S}-pdos.in | tee OUTPUT_G${i}_${j}-${S}-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np \$NSLOTS pw.x -inp INPUT_G${i}_${j}-${S}-bands1.in | tee OUTPUT_G${i}_${j}-${S}-bands1
# bands2
mpirun -np \$NSLOTS bands.x -inp INPUT_G${i}_${j}-${S}-bands2.in | tee OUTPUT_G${i}_${j}-${S}-bands2

rm -r tmp/\n\n" > etc.csh

			cd .. # end G${i}_${j}
		done
	done
	cd .. # end $S
}

# site; eg, B1
read -p 'Site [A/B1/B2]: ' S

write_relax
write_etc
