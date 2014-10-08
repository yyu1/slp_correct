;Calling procedure for correcting height image using slope
;Assume that height file is floating point and slope_file is integer

PRO slope_correct_image, ht_file, slope_file, out_file
	;check if file sizes match
	ht_info = file_info(ht_file)
	slope_info = file_info(slope_file)

	if(ht_info.size ne (slope_info.size*2)) then begin
		print, 'Error:  Height file size should be twice slope file size assuming float and integer respectively.'
		exit
	endif

	;break file into 100 blocks

	nblocks = slope_file.size/2/100
	remainder = slope_file.size mod 200

	ht_block = fltarr(nblocks)
	slope_block = intarr(nblocks)
	out_block = fltarr(nblocks)
	
	openr, ht_lun, ht_file, /get_lun
	openr, slope_lun, slope_file, /get_lun
	openw, out_lun, out_file

	for i=0ULL, 99ULL do begin
		out_block[*] = 0
		print, i

		readu, ht_lun, ht_block
		readu, slope_lun, slope_block

		index = where((ht_block gt 0) and (slope_block ne -100), count)
		if (count gt 0) then begin
			out_block[index] = slope_corr(ht_block[index],slope_block[index])
		endif

		writeu, out_lun, out_block

	endfor

	if (remainder ne 0) then begin
		ht_block = fltarr(remainder/2)
		slope_block = intarr(remainder/2)
		out_block = fltarr(remainder/2)
		readu, ht_lun, ht_block
		readu, slope_lun, slope_block

		index = where((ht_block gt 0) and (slope_block ne -100), count)
		if (count gt 0) then begin
			out_block[index] = slope_corr(ht_block[index],slope_block[index])
		endif

		writeu, out_lun, out_block
	endif

	free_lun, ht_lun
	free_lun, slope_lun
	free_lun, out_lun

End
