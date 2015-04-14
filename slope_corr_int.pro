;Slope values are pct slope x 100 (designed to take int input whose value is slope x 100)

Function slope_corr_int, height, slope
	scale1 = 4000 ; start correcting at 40% slope
	scale2 = 6000 ; ramp up to full correction by 60% slope
	
	if n_elements(height) gt 1 then begin
		;array input
		index1 = where((slope ge scale1) and (slope le scale2), count1)
		index2 = where((slope gt scale2), count2)

		coeff = fltarr(n_elements(height))
		coeff[*] = 0

		if (count1 gt 0) then begin
			coeff[index1] = float(slope[index1]-scale1)/float(scale2-scale1)*float(slope[index1])/10000.
		endif
		if (count2 gt 0) then begin
			coeff[index2] = float(slope[index2])/10000.
		endif

		return, fix(height * (1.-coeff))

	endif else begin
		coeff = 0.
		if (slope ge scale1) then begin
			if (slope le scale2) then begin
				coeff = float(slope-scale1)/float(scale2-scale1) * float(slope)/10000.
				return, fix(height * (1.-coeff))
			endif
			coeff = float(slope)/10000.
		endif
		return, fix(height * (1.-coeff))
	endelse

End
