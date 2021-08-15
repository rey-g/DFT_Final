#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tv-Y-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-Y-scf.in > OUTPUT_MVG_tv-Y-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-Y-pp.in > OUTPUT_MVG_tv-Y-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-Y-pp-up.in > OUTPUT_MVG_tv-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-Y-pp-dn.in > OUTPUT_MVG_tv-Y-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tv-Y-bader.in > OUTPUT_MVG_tv-Y-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-Y-nscf.in > OUTPUT_MVG_tv-Y-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tv-Y-pdos.in > OUTPUT_MVG_tv-Y-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-Y-bands1.in > OUTPUT_MVG_tv-Y-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-Y-bands2-up.in > OUTPUT_MVG_tv-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-Y-bands2-dn.in > OUTPUT_MVG_tv-Y-bands2-dn

rm -r tmp/

