#!/bin/bash
# processes bader files

# run bader app
function run_bader(){
	for S in 'A' 'B1' 'B2'; do
		cd $S
		for X in 'F' 'Cl' 'Br' 'I'; do
			for g in 'ip' 'op'; do
				pref=G${X}_$g

				# run bader program	
				../bader_app -vac off ${pref}-bader.cube
				
				# rename bader files
				mv ACF.dat ${pref}-ACF.dat
				mv AVF.dat ${pref}-AVF.dat
				mv BCF.dat ${pref}-BCF.dat
			done
		done
		cd ..
	done
}

run_bader
