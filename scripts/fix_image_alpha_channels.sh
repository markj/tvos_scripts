#!/bin/sh

# Apple TV stack images can not contain an alpha channel on the back layer.  
# This script uses ImageMagic to detect and fix this problem as it can be hard to make apps not export the channel
# Install ImageMagic by `brew install ImageMagick`
#


export PATH=$PATH:/usr/local/bin

ROOT="$1"

function fix_alpha_channels_in_folder() {
	local folder=$1

	find "$folder" -name "*.png" -print0 |  while IFS= read -r -d $'\0' file; do 
		echo "  $file"
		check_and_fix_alpha_channel "$file"
	done
}

function fix_alpha_channels() {
	local asset=$1
	echo "Processing: $asset"


	find "$asset" -name "Back.imagestacklayer" -print0 |  while IFS= read -r -d $'\0' folder; do 
#		echo "  Checking: $folder"
		fix_alpha_channels_in_folder "$folder"
	done
}


function find_all_branded_assets() {
	find $ROOT -name "App Icon & Top Shelf Image.brandassets" -print0 |  while IFS= read -r -d $'\0' asset; do 
		fix_alpha_channels "$asset"
	done
}



function check_and_fix_alpha_channel() {
	local FILE=$1

	local channels=`identify -format '%[channels]' "$FILE"`

	# echo "Result = $channels"

	if [ "$channels" != "srgb" ]; then
		echo "    ***WARNING**** $FILE  has invalid channels : $channels"

		convert "$FILE" -alpha off output.png
		rm "$FILE"
		mv output.png "$FILE"

		echo "     Fixed.."
	else 
		echo "     OK"
	fi
}

find_all_branded_assets

exit






#check_no_alpha_channel "./MyPixPo/tvOS/Assets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon - Large.imagestack/Back.imagestacklayer/Content.imageset/main.png"
#check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon - Small.imagestack/Back.imagestacklayer/Content.imageset/main.png"




check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon - App Store.imagestack/Back.imagestacklayer/Content.imageset/Background.png"

check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon.imagestack/Back.imagestacklayer/Content.imageset/Background.png"
check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon.imagestack/Back.imagestacklayer/Content.imageset/Background@2x.png"

check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/Top Shelf Image Wide.imageset/Layer 0.png"
check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/Top Shelf Image Wide.imageset/Layer 0@2x.png"

check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/Top Shelf Image.imageset/Layer 0.png"
check_no_alpha_channel "./MyPixPo/tvOS//Assets.xcassets/App Icon & Top Shelf Image.brandassets/Top Shelf Image.imageset/Layer 0@2x.png"


