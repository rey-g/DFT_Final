#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_ip-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_ip-A-scf.in | tee OUTPUT_GF_ip-A-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_ip-A-pp.in | tee OUTPUT_GF_ip-A-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_ip-A-bader.in | tee OUTPUT_GF_ip-A-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_ip-A-nscf.in | tee OUTPUT_GF_ip-A-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GF_ip-A-pdos.in | tee OUTPUT_GF_ip-A-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GF_ip-A-bands1.in | tee OUTPUT_GF_ip-A-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GF_ip-A-bands2.in | tee OUTPUT_GF_ip-A-bands2

rm -r tmp/

