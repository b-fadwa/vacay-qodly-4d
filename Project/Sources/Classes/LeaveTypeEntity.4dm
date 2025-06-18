Class extends Entity

exposed Function addLeaveType()
	If (This:C1470.name=Null:C1517)
		Web Form:C1735.setError("The type name must be filled in !")
	Else 
		This:C1470.save()
		Web Form:C1735["addLeaveType"].hide()
		Web Form:C1735.setMessage("This leave type has been successfully created !")
	End if 
	
exposed Function deleteLeaveType()
	var $leavesStatus : cs:C1710.LeaveSelection
	var $balanceStatus : cs:C1710.LeaveBalanceSelection
	var $result : Object
	$leavesStatus:=This:C1470.leaves.drop()
	$balanceStatus:=This:C1470.leaveBalances.drop()
	If ($leavesStatus.length=0 && $balanceStatus.length=0)
		$result:=This:C1470.drop()
		If ($result.success)
			Web Form:C1735.setMessage("Leave Type was removed successfully!")
		Else 
			Web Form:C1735.setError("Removal impossible !")
		End if 
	Else 
		Web Form:C1735.setError("Error while removing this leave type!")
	End if 
	