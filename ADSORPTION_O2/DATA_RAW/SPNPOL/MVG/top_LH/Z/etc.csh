#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tlh-Z-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-Z-scf.in > OUTPUT_MVG_tlh-Z-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-Z-pp.in > OUTPUT_MVG_tlh-Z-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-Z-pp-up.in > OUTPUT_MVG_tlh-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-Z-pp-dn.in > OUTPUT_MVG_tlh-Z-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tlh-Z-bader.in > OUTPUT_MVG_tlh-Z-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-Z-nscf.in > OUTPUT_MVG_tlh-Z-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tlh-Z-pdos.in > OUTPUT_MVG_tlh-Z-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tlh-Z-bands1.in > OUTPUT_MVG_tlh-Z-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tlh-Z-bands2-up.in > OUTPUT_MVG_tlh-Z-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tlh-Z-bands2-dn.in > OUTPUT_MVG_tlh-Z-bands2-dn

rm -r tmp/

