#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG-scf.in | tee OUTPUT_PG-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG-pp.in | tee OUTPUT_PG-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG-pp-up.in | tee OUTPUT_PG-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG-pp-dn.in | tee OUTPUT_PG-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG-bader.in | tee OUTPUT_PG-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG-nscf.in | tee OUTPUT_PG-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG-pdos.in | tee OUTPUT_PG-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG-bands1.in | tee OUTPUT_PG-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG-bands2-up.in | tee OUTPUT_PG-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG-bands2-dn.in | tee OUTPUT_PG-bands2-dn

rm -r tmp/

