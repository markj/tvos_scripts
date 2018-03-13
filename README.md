# tvOS scripts

Helper scripts and information for Apple TV development


**fix_image_alpha_channels.sh** - Script that checks all brand asset folders on the specified path and uses ImageMagic to check that the background layers are valid. If they have an alpha channel then the image will be stripped of it.

e.g.
	`fix_image_alpha_channels.sh  .`
