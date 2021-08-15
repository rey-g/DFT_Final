#!/bin/bash
# adds X/Y/Z/N/P affix to file names

gen_etc () {
	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}t${ilc}-${j}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${ilc}-${j}-scf_ads.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-scf_ads
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${ilc}-${j}-scf_subs.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-scf_subs

# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${ilc}-${j}-pp_ads.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-pp_ads
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${ilc}-${j}-pp_subs.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-pp_subs

# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${ilc}-${j}-bader_ads.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-bader_ads
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${ilc}-${j}-bader_subs.in | tee OUTPUT_G${X}_${g}t${ilc}-${j}-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/" > etc2.csh
}

read -p 'Species [F/Cl/Br/I]: ' X

for g in 'ip' 'op'; do
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
				gen_etc
				cd ..
			done
		else
			for j in 'N' 'P' 'Z'; do
				cd $j
				gen_etc
				cd ..
			done
		fi
		
		cd ..
	done
	cd ..
done
