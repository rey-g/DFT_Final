#! /bin/bash

read -p 'System [A/B*]: ' S
read -p 'Halogen [X]: ' X

coord_z (){
	case $h in
		'0.5/' )
			z='0.033333333';;
		'1.0/' )
			z='0.066666667';;
		'1.5/' )
			z='0.1';;
		'2.0/' )
			z='0.133333333';;
		'2.5/' )
			z='0.166666667';;
		'3.0/' )
			z='0.2';;
		'3.5/' )
			z='0.233333333';;
		'4.0/' )
			z='0.266666667';;
		'4.5/' )
			z='0.3';;
		'5.0/' )
			z='0.333333333';;
	esac
}

get_param (){
	case $S in
		'A' )
			na='50'
			k='0.5\ 0.5\ '${z}'';;
		'B1' )
			na='58'
			k='0.583333333\ 0.666666667\ '${z}'';;
		'B2' )
			na='41'
			k='0.333333333\ 0.166666667\ '${z}'';;
		'B3' )
			na='42'
			k='0.5\ 0.25\ '${z}'';;
	esac
}

cd G$X
for h in */; do
	cp *scf.in $h/INPUT_G${X}-${S}-${h///}-scf.in
	cp relax.csh $h/conv_${h///}.csh
	
	# edit files
	cd $h
	echo $h
	coord_z
	get_param
	
	sed -i -e 's/G'${X}'_op/G'${X}'-'${h///}'/g' *scf.in
	sed -i -e ${na}'d' *scf.in
	sed -i -e ${na}'i'${X}'\ \ \ '"${k}"'' *scf.in
	
	sed -i -e 's/_op-'${S}'-relax/-'${S}'-'${h///}'-scf/g' *.csh
	sed -i -e 's/_op-relax/-'${h///}'/g' *.csh
	cd ..
done
cd ..
