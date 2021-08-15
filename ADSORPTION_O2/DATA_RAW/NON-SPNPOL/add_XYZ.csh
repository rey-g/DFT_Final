#!/bin/bash
# adds X/Y/Z/N/P affix to file names

rename () {
	mv *bader.in INPUT_G${X}_${g}t${ilc}-${j}-bader.in 
	mv *pp.in INPUT_G${X}_${g}t${ilc}-${j}-pp.in 
	mv *relax.in INPUT_G${X}_${g}t${ilc}-${j}-relax.in 
	mv *scf.in INPUT_G${X}_${g}t${ilc}-${j}-scf.in 
			
	cd bands
	mv *bands1.in INPUT_G${X}_${g}t${ilc}-${j}-bands1.in 
	mv *bands2.in INPUT_G${X}_${g}t${ilc}-${j}-bands2.in 
	cd ../nscf
	mv *nscf.in INPUT_G${X}_${g}t${ilc}-${j}-nscf.in 
	mv *pdos.in INPUT_G${X}_${g}t${ilc}-${j}-pdos.in 
	cd ..
}

read -p 'Species [F/Cl/Br/I]: ' X
read -p '[ip/op]: ' g

cd G${X}_${g}
for i in 'C' 'LH' 'opp' 'vac' 'X' 'XC'; do
	cd top_${i}	
	
	case $i in
		'C' )
			ilc='c' ;;
		'LH' )
			ilc='lh' ;;
		'opp' )
			ilc='o' ;;
		'vac' )
			ilc='v' ;;
		'X' )
			ilc='x' ;;
		'XC' )
			ilc='xc' ;;
	esac
	
	printf 'site = '${i}' \n\n'
	if [ $i != 'XC' ]; then
		for j in 'X' 'Y' 'Z'; do
			cd $j
			rename
			cd ..
		done
	else
		for j in 'N' 'P' 'Z'; do
			cd $j
			rename
			cd ..
		done
	fi
	
	cd ..
done
cd ..
