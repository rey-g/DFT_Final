#! /bin/bash

copy_as (){
	cp *scf.in ../../${S}_as/$i/INPUT_ADS_${i///}-$S-scf.in
	cp *scf.in ../../${S}_as/$i/INPUT_SUBS_${i///}-$S-scf.in
	
	cp *pp.in ../../${S}_as/$i/INPUT_ADS_${i///}-$S-pp.in
	cp *pp.in ../../${S}_as/$i/INPUT_SUBS_${i///}-$S-pp.in
}

edit_as (){
	# edit SUBS
	sed -i -e 's/'${i///}'/'${i///}'-subs/g' *SUBS*scf.in
	sed -i -e 's/tmp/tmp_subs/g' *SUBS*scf.in
	sed -i -e 's/'${i///}'/'${i///}'-subs/g' *SUBS*pp.in
	sed -i -e 's/tmp/tmp_subs/g' *SUBS*pp.in
	
	if [ $S == 'A' ]; then
		sed -i -e 's/nat = 32/nat = 31/g' *SUBS*scf.in
	else
		sed -i -e 's/nat = 31/nat = 30/g' *SUBS*scf.in
	fi
	sed -i -e 's/ntyp = 2/ntyp = 1/g' *SUBS*scf.in
	
	sed -i -e '/18.99/d' *SUBS*scf.in # delete F
	sed -i -e '/F      /d' *SUBS*scf.in
	sed -i -e '/35.45/d' *SUBS*scf.in # delete Cl
	sed -i -e '/Cl     /d' *SUBS*scf.in
	sed -i -e '/79.90/d' *SUBS*scf.in # delete Br
	sed -i -e '/Br     /d' *SUBS*scf.in
	sed -i -e '/126.90/d' *SUBS*scf.in # delete I
	sed -i -e '/I      /d' *SUBS*scf.in
	
	# edit ADS
	sed -i -e 's/'${i///}'/'${i///}'-ads/g' *ADS*scf.in
	sed -i -e 's/tmp/tmp_ads/g' *ADS*scf.in
	sed -i -e 's/'${i///}'/'${i///}'-ads/g' *ADS*pp.in
	sed -i -e 's/tmp/tmp_ads/g' *ADS*pp.in
	
	if [ $S == 'A' ]; then
		sed -i -e 's/nat = 32/nat = 1/g' *ADS*scf.in
	else
		sed -i -e 's/nat = 31/nat = 1/g' *ADS*scf.in
	fi
	sed -i -e 's/ntyp = 2/ntyp = 1/g' *ADS*scf.in
	
	sed -i -e '/12.01/d' *ADS*scf.in # delete C
	sed -i -e '/C      /d' *ADS*scf.in
}

add_csh (){
printf "#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${i///}-as
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np \$NSLOTS pw.x -inp INPUT_ADS_${i///}-$S-scf.in >  OUTPUT_ADS_${i///}-$S-scf
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_${i///}-$S-pp.in >  OUTPUT_ADS_${i///}-$S-pp
rm -r tmp_ads/

# SUBS
mpirun -np \$NSLOTS pw.x -inp INPUT_SUBS_${i///}-$S-scf.in >  OUTPUT_SUBS_${i///}-$S-scf
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_${i///}-$S-pp.in >  OUTPUT_SUBS_${i///}-$S-pp
rm -r tmp_subs/\n" > etc2.csh
}

read -p 'System [A/B1/B2/B3]: ' S
mkdir -p ${S}_as

# copies files
echo Copying files...
cd $S
for i in */; do
	echo $i
	mkdir -p ../${S}_as/${i}
	cd $i
	copy_as
	cd ..
done
cd ..

# edits files and adds csh
echo Editing files...
cd ${S}_as
for i in */; do
	cd $i
	edit_as
	add_csh
	cd ..
done
cd ..
