#!/bin/bash

gen_csh() {
	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${i///}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
cd ..
mpirun -np \$NSLOTS pw.x -inp INPUT_${i///}-B1-scf.in > OUTPUT_${i///}-B1-scf

# copy tmp folder
cp -r tmp/ bands
rm -r tmp/

# chdir to bands dir
cd bands/

# bands1
mpirun -np \$NSLOTS pw.x -inp INPUT_${i///}-B1-bands1.in > OUTPUT_${i///}-B1-bands1

# bands2
mpirun -np \$NSLOTS bands.x -inp INPUT_${i///}-B1-bands2-up.in > OUTPUT_${i///}-B1-bands2-up
mpirun -np \$NSLOTS bands.x -inp INPUT_${i///}-B1-bands2-dn.in > OUTPUT_${i///}-B1-bands2-dn

# delete tmp
rm -r tmp/" > etc2.csh
}

for i in */; do
	cd $i/bands
	gen_csh
	cd ../.. # end GX_g/bands
done
