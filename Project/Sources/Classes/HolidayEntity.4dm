Class extends Entity

exposed Function add($rangeDate : Collection)
	If (This:C1470.name="")
		Web Form:C1735.setError("The name of the holiday must be filled in!")
	Else 
		If ($rangeDate.length>0)
			This:C1470.startDate:=Date:C102($rangeDate.at(0))
			This:C1470.endDate:=($rangeDate.length=2) ? Date:C102($rangeDate.at(1)) : Date:C102($rangeDate.at(0))
			This:C1470.save()
			Web Form:C1735["addHoliday"].hide()
			Web Form:C1735.setMessage("Public holiday added successfully !")
		Else 
			Web Form:C1735.setWarning("Fill the required fields!")
		End if 
	End if 
	
	
exposed Function update($rangeDate : Collection)
	If ($rangeDate.length>0)
		This:C1470.startDate:=$rangeDate[0]
		This:C1470.endDate:=($rangeDate.length=2) ? $rangeDate[1] : $rangeDate[0]
		This:C1470.save()
		Web Form:C1735.setMessage("Public holiday updated successfully!")
	Else 
		Web Form:C1735.setWarning("Fill the required fields!")
	End if 
	
exposed Function getRangeDate()->$rangeDate : Collection
	$rangeDate:=[]
	$rangeDate.push(This:C1470.startDate; This:C1470.endDate)
	
	