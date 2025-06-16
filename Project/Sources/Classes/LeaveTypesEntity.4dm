Class extends Entity

exposed Function addLeaveType()
	If (This:C1470.name==Null:C1517)
		webForm.setError("The type name must be filled in !")
	Else 
		This:C1470.save()
		webForm["addLeaveType"].hide()
		webForm.setMessage("This leave type has been successfully created !")
		end
		
exposed Function deleteLeaveType()
	var leavesStatus : cs:C1710.LeavesSelection
	var balanceStatus : cs:C1710.LeaveBalancesSelection
	var result : Object
	leavesStatus=This:C1470.leaves.drop()
	balanceStatus=This:C1470.leaveBalances.drop()
	If (leavesStatus.length==0 && balanceStatus.length==0)
		result=This:C1470.drop()
		If (result.success)
			webForm.setMessage("Leave Type was removed successfully!")
		Else 
			webForm.setError("Removal impossible !")
			end
		Else 
			webForm.setError("Error while removing this leave type!")
			end
			