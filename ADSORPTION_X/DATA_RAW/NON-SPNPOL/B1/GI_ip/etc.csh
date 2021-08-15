#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GI_ip-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_ip-B1-scf.in | tee OUTPUT_GI_ip-B1-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ip-B1-pp.in | tee OUTPUT_GI_ip-B1-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ip-B1-bader.in | tee OUTPUT_GI_ip-B1-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_ip-B1-nscf.in | tee OUTPUT_GI_ip-B1-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_ip-B1-pdos.in | tee OUTPUT_GI_ip-B1-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GI_ip-B1-bands1.in | tee OUTPUT_GI_ip-B1-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GI_ip-B1-bands2.in | tee OUTPUT_GI_ip-B1-bands2

rm -r tmp/

