#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_tlh-X-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-X-scf.in > OUTPUT_PG_tlh-X-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-X-pp.in > OUTPUT_PG_tlh-X-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-X-pp-up.in > OUTPUT_PG_tlh-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-X-pp-dn.in > OUTPUT_PG_tlh-X-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG_tlh-X-bader.in > OUTPUT_PG_tlh-X-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-X-nscf.in > OUTPUT_PG_tlh-X-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_tlh-X-pdos.in > OUTPUT_PG_tlh-X-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_tlh-X-bands1.in > OUTPUT_PG_tlh-X-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_tlh-X-bands2-up.in > OUTPUT_PG_tlh-X-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_tlh-X-bands2-dn.in > OUTPUT_PG_tlh-X-bands2-dn

rm -r tmp/

