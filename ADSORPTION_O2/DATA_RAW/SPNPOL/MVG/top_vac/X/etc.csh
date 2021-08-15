#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tv-X-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-X-scf.in > OUTPUT_MVG_tv-X-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-X-pp.in > OUTPUT_MVG_tv-X-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-X-pp-up.in > OUTPUT_MVG_tv-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-X-pp-dn.in > OUTPUT_MVG_tv-X-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-X-bader.in > OUTPUT_MVG_tv-X-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-X-nscf.in > OUTPUT_MVG_tv-X-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tv-X-pdos.in > OUTPUT_MVG_tv-X-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-X-bands1.in > OUTPUT_MVG_tv-X-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-X-bands2-up.in > OUTPUT_MVG_tv-X-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-X-bands2-dn.in > OUTPUT_MVG_tv-X-bands2-dn

rm -r tmp/

