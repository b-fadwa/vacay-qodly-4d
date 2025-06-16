Class extends Entity


exposed Function create($newLeave : cs:C1710.LeavesEntity)
	var $saved : Object
	If (This:C1470.content#Null:C1517)
		This:C1470.creationDate:=Current date:C33()
		This:C1470.creationHour:=Current time:C178()
		eThis.leave:=$newLeave
		This:C1470.by:=ds:C1482.Employees.getCurrentUser()
		$saved:=This:C1470.save()
		If (saved.success)
			webForm.setMessage("Comment added successfully!")
		Else 
			webForm.setError("Error while adding the comment!")
		End if 
	End if 
	