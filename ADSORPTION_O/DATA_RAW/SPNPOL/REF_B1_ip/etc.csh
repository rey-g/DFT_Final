#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N B1_ip-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_B1_ip-scf.in > OUTPUT_B1_ip-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_B1_ip-pp-up.in > OUTPUT_B1_ip-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_B1_ip-pp-dn.in > OUTPUT_B1_ip-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_B1_ip-bader.in > OUTPUT_B1_ip-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_B1_ip-nscf.in > OUTPUT_B1_ip-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_B1_ip-pdos.in > OUTPUT_B1_ip-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_B1_ip-bands1.in > OUTPUT_B1_ip-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_B1_ip-bands2-up.in > OUTPUT_B1_ip-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_B1_ip-bands2-dn.in > OUTPUT_B1_ip-bands2-dn

rm -r tmp/

