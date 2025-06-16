Class extends Entity

exposed Function add($rangeDate : Collection)
	If (This:C1470.name="")
		web Form.setError("The name of the holiday must be filled in!")
	Else 
		If ($rangeDate.length>0)
			This:C1470.startDate:=Date:C102($rangeDate.at(0))
			This:C1470.endDate:=($rangeDate.length=2) ? Date:C102($rangeDate.at(1)) : Date:C102($rangeDate.at(0))
			This:C1470.save()
			web Form["addHoliday"].hide()
			web Form.setMessage("Public holiday added successfully !")
		Else 
			web Form.setWarning("Fill the required fields!")
			end if
			end if
			
			
exposed Function update($rangeDate : Collection)
	If ($rangeDate.length>0)
		This:C1470.startDate:=$rangeDate[0]
		This:C1470.endDate:=($rangeDate.length=2) ? $rangeDate[1] : $rangeDate[0]
		This:C1470.save()
		web Form.setMessage("Public holiday updated successfully!")
	Else 
		web Form.setWarning("Fill the required fields!")
		end if
		
exposed Function getRangeDate()->$rangeDate : Collection
	$rangeDate=[]
	$rangeDate.push(This:C1470.startDate; this.endDate)
	
	