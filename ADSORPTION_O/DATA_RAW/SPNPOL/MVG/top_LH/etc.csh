#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tlh-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-scf.in | tee OUTPUT_MVG_tlh-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-pp.in | tee OUTPUT_MVG_tlh-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-pp-up.in | tee OUTPUT_MVG_tlh-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-pp-dn.in | tee OUTPUT_MVG_tlh-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-bader.in | tee OUTPUT_MVG_tlh-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-nscf.in | tee OUTPUT_MVG_tlh-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tlh-pdos.in | tee OUTPUT_MVG_tlh-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-bands1.in | tee OUTPUT_MVG_tlh-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tlh-bands2-up.in | tee OUTPUT_MVG_tlh-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tlh-bands2-dn.in | tee OUTPUT_MVG_tlh-bands2-dn

rm -r tmp/

