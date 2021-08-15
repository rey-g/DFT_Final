#! /bin/bash

abbrev (){
	case $i in
		'top_C/' )
			sl='c' ;;
		'top_LH/' )
			sl='lh' ;;
		'top_opp/' )
			sl='o' ;;
		'top_vac/' )
			sl='v' ;;
		'top_X/' )
			sl='x' ;;
		'top_XC/' )
			sl='xc' ;;
	esac
}

copy_as (){
	abbrev
	
	cp *scf.in ../../G${X}_${g}_as/$i/INPUT_ADS_G${X}_${g}t${sl}-scf.in
	cp *scf.in ../../G${X}_${g}_as/$i/INPUT_SUBS_G${X}_${g}t${sl}-scf.in
	
	cp *pp-up.in ../../G${X}_${g}_as/$i/INPUT_ADS_G${X}_${g}t${sl}-pp-up.in
	cp *pp-up.in ../../G${X}_${g}_as/$i/INPUT_SUBS_G${X}_${g}t${sl}-pp-up.in
	
	cp *pp-dn.in ../../G${X}_${g}_as/$i/INPUT_ADS_G${X}_${g}t${sl}-pp-dn.in
	cp *pp-dn.in ../../G${X}_${g}_as/$i/INPUT_SUBS_G${X}_${g}t${sl}-pp-dn.in
}

edit_as (){
	# edit SUBS
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-subs/g' *SUBS*scf.in
	sed -i -e 's/tmp/tmp_subs/g' *SUBS*scf.in
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-subs/g' *SUBS*pp-up.in
	sed -i -e 's/G'${X}'_chg-up/G'${X}'_chg-up-subs/g' *SUBS*pp-up.in
	sed -i -e 's/tmp/tmp_subs/g' *SUBS*pp-up.in
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-subs/g' *SUBS*pp-dn.in
	sed -i -e 's/G'${X}'_chg-dn/G'${X}'_chg-dn-subs/g' *SUBS*pp-dn.in
	sed -i -e 's/tmp/tmp_subs/g' *SUBS*pp-dn.in
	
	sed -i -e 's/nat = 32/nat = 31/g' *SUBS*scf.in
	sed -i -e 's/ntyp = 3/ntyp = 2/g' *SUBS*scf.in
	
	sed -i -e '/15.99/d' *SUBS*scf.in # delete O
	sed -i -e '/O      /d' *SUBS*scf.in
	sed -i -e '/starting_magnetization(3)/d' *SUBS*scf.in
	
	# edit ADS
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-ads/g' *ADS*scf.in
	sed -i -e 's/tmp/tmp_ads/g' *ADS*scf.in
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-ads/g' *ADS*pp-up.in
	sed -i -e 's/G'${X}'_chg-up/G'${X}'_chg-up-ads/g' *ADS*pp-up.in
	sed -i -e 's/tmp/tmp_ads/g' *ADS*up.in
	sed -i -e 's/G'${X}'_'${g}'/G'${X}'_'${g}'-ads/g' *ADS*pp-dn.in
	sed -i -e 's/G'${X}'_chg-dn/G'${X}'_chg-dn-ads/g' *ADS*pp-dn.in
	sed -i -e 's/tmp/tmp_ads/g' *ADS*dn.in
	
	sed -i -e 's/nat = 32/nat = 1/g' *ADS*scf.in
	sed -i -e 's/ntyp = 3/ntyp = 1/g' *ADS*scf.in
	
	sed -i -e '/12.01/d' *ADS*scf.in # delete C
	sed -i -e '/C      /d' *ADS*scf.in
	sed -i -e '/18.99/d' *ADS*scf.in # delete F
	sed -i -e '/F      /d' *ADS*scf.in
	sed -i -e '/35.45/d' *ADS*scf.in # delete Cl
	sed -i -e '/Cl     /d' *ADS*scf.in
	sed -i -e '/79.90/d' *ADS*scf.in # delete Br
	sed -i -e '/Br     /d' *ADS*scf.in
	sed -i -e '/126.90/d' *ADS*scf.in # delete I
	sed -i -e '/I      /d' *ADS*scf.in
	sed -i -e '/starting_magnetization(2)/d' *ADS*scf.in
	sed -i -e '/starting_magnetization(3)/d' *ADS*scf.in
}

add_csh (){
abbrev

printf "#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N G${X}_${g}t${sl}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np \$NSLOTS pw.x -inp INPUT_ADS_G${X}_${g}t${sl}-scf.in >  OUTPUT_ADS_G${X}_${g}t${sl}-scf
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-pp-up.in >  OUTPUT_ADS_G${X}_${g}t${sl}-pp-up
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-pp-dn.in >  OUTPUT_ADS_G${X}_${g}t${sl}-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np \$NSLOTS pw.x -inp INPUT_SUBS_G${X}_${g}t${sl}-scf.in >  OUTPUT_SUBS_G${X}_${g}t${sl}-scf
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-pp-up.in >  OUTPUT_SUBS_G${X}_${g}t${sl}-pp-up
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-pp-dn.in >  OUTPUT_SUBS_G${X}_${g}t${sl}-pp-dn
rm -r tmp_subs/\n" > etc2.csh
}

read -p 'Halogen [X]: ' X

for g in 'ip' 'op'; do
	mkdir -p G${X}_${g}_as
	echo G${X}_${g}
	# copies files
	echo Copying files...
	cd G${X}_${g}
	for i in */; do
		echo $i
		mkdir -p ../G${X}_${g}_as/${i}
		cd $i
		copy_as
		cd ..
	done
	cd ..

	# edits files and adds csh
	echo Editing files...
	cd G${X}_${g}_as
	for i in */; do
		cd $i
		edit_as
		add_csh
		cd ..
	done
	cd ..
done
