#!/bin/bash

modify_lines() {
	# H pseudopotential and template
	psH='    H   1.008000  H.revpbe-kjpaw_psl.0.1.UPF'
	tmH='H        '

	# get ATOMIC_POSITIONS from scf
	TAIL=$(grep -A 33 "ATOMIC_POSITIONS" *scf.in)
	
	# edit relax
	sed -i 's/nat = 33/nat = 34/' *relax.in
	sed -i 's/ntyp = 3/ntyp = 4/' *relax.in
	sed -i '/ATOMIC_POSITIONS/,+33d' *relax.in	
	awk -v s="${TAIL}" '/K_POINTS/{print s} {print}' *relax.in > tmp && mv tmp *relax.in
	awk -v s="${tmH}" '/K_POINTS/{print s} {print}' *relax.in > tmp && mv tmp *relax.in
	awk -v s="${psH}" '/ATOMIC_POSITIONS/{print s} {print}' *relax.in > tmp && mv tmp *relax.in
}

copy_files() {
	# copy files
	cp -t ./ ../../../../ADSORPTION_O2/DATA_RAW/SPNPOL/G${X}_${g}/top_${s}/${i}/*.in
	cp -t ./ ../../../../ADSORPTION_O2/DATA_RAW/SPNPOL/G${X}_${g}/top_${s}/${i}/*.csh
	cp -t ./nscf ../../../../ADSORPTION_O2/DATA_RAW/SPNPOL/G${X}_${g}/top_${s}/${i}/nscf/*.in
	cp -t ./bands ../../../../ADSORPTION_O2/DATA_RAW/SPNPOL/G${X}_${g}/top_${s}/${i}/bands/*.in
}

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
# geometry
read -p '[ip/op]: ' g

mkdir -p G${X}_${g}
cd G${X}_${g}
for s in 'C' 'LH' 'opp' 'vac' 'X' 'XC'; do
	case $s in
		'C' )
			sl='c' ;;
		'LH' )
			sl='lh' ;;
		'opp' )
			sl='o' ;;
		'vac' )
			sl='v' ;;
		'X' )
			sl='x' ;;
		'XC' )
			sl='xc' ;;
	esac
	
	mkdir -p top_${s}
	cd top_${s}
	printf 'top_'${s}'\n\n'
	if [ $s == 'XC' ]; then
		for i in 'N' 'P' 'Z'; do
			mkdir -p $i
			cd $i
			mkdir -p nscf
			mkdir -p bands
			copy_files
			modify_lines
			cd ..
		done
	else
		for i in 'X' 'Y' 'Z'; do
			mkdir -p $i
			cd $i
			mkdir -p nscf
			mkdir -p bands
			copy_files
			modify_lines
			cd ..
		done
	fi
	cd ..
done
cd ..
