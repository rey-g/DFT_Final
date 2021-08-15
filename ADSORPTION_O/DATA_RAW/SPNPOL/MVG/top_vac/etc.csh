#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tv-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-scf.in | tee OUTPUT_MVG_tv-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-pp.in | tee OUTPUT_MVG_tv-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-pp-up.in | tee OUTPUT_MVG_tv-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-pp-dn.in | tee OUTPUT_MVG_tv-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-bader.in | tee OUTPUT_MVG_tv-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-nscf.in | tee OUTPUT_MVG_tv-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tv-pdos.in | tee OUTPUT_MVG_tv-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-bands1.in | tee OUTPUT_MVG_tv-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-bands2-up.in | tee OUTPUT_MVG_tv-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-bands2-dn.in | tee OUTPUT_MVG_tv-bands2-dn

rm -r tmp/

