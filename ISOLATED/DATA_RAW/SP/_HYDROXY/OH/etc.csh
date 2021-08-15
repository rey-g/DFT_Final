#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N OH-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_OH-scf.in | tee OUTPUT_OH-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_OH-pp.in | tee OUTPUT_OH-pp
mpirun -np $NSLOTS pp.x -inp INPUT_OH-pp-up.in | tee OUTPUT_OH-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_OH-pp-dn.in | tee OUTPUT_OH-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_OH-bader.in | tee OUTPUT_OH-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_OH-nscf.in | tee OUTPUT_OH-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_OH-pdos.in | tee OUTPUT_OH-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_OH-bands1.in | tee OUTPUT_OH-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_OH-bands2-up.in | tee OUTPUT_OH-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_OH-bands2-dn.in | tee OUTPUT_OH-bands2-dn

rm -r tmp/

