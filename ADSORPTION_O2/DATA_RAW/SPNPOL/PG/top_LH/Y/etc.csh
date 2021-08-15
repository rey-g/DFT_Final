#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_tlh-Y-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-Y-scf.in > OUTPUT_PG_tlh-Y-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-Y-pp.in > OUTPUT_PG_tlh-Y-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-Y-pp-up.in > OUTPUT_PG_tlh-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-Y-pp-dn.in > OUTPUT_PG_tlh-Y-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-Y-bader.in > OUTPUT_PG_tlh-Y-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-Y-nscf.in > OUTPUT_PG_tlh-Y-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_tlh-Y-pdos.in > OUTPUT_PG_tlh-Y-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-Y-bands1.in > OUTPUT_PG_tlh-Y-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_tlh-Y-bands2-up.in > OUTPUT_PG_tlh-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_tlh-Y-bands2-dn.in > OUTPUT_PG_tlh-Y-bands2-dn

rm -r tmp/

