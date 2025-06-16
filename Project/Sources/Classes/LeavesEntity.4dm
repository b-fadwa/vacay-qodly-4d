Class extends Entity



exposed Function getRangeDate()->$rangeDate : Collection
	$rangeDate=[]
	$rangeDate.push(This:C1470.startDate; This:C1470.endDate)
	
exposed Function changeStatus($employee : cs:C1710.EmployeesEntity; $status : Text)
	var $info : Object
	var $currentUser : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	var $action; $receiver : Text
	var $leaveBalance : cs:C1710.LeaveBalancesEntity:=This:C1470.leaveType.leaveBalances.query("employee.ID = :1"; employee.ID).first()
	If (($leaveBalance.balance>=This:C1470.rangeLength) && ($status="approved"))
		This:C1470.status:=$status
		$action:=$currentUser.fullName+" approved the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
			+String:C10(This:C1470.requestDate; Internal date short:K1:7)+"</li><li>Start Date : "+String:C10(This:C1470.startDate; Internal date short:K1:7)+\
			"</li><li>End Date : "+String:C10(This:C1470.endDate; Internal date short:K1:7)+"</li><li>Status : <span style=\"color:#119A8D;\">"+This:C1470.status+"</span></li></ul>"
		ds:C1482.LeaveBalances.decrementBalance(This:C1470)
	Else 
		Web Form:C1735.setError("Your balance is lower then the request's range")
		This:C1470.status="rejected"
		$action:=currentUser.fullName+" rejected the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
			+String:C10(This:C1470.requestDate; Internal date short:K1:7)+"</li><li>Start Date : "+String:C10(This:C1470.startDate; Internal date short:K1:7)+\
			"</li><li>End Date : "+String:C10(This:C1470.endDate; Internal date short:K1:7)+"</li><li>Status : <span style=\"color:#F44C4C;\">"+This:C1470.status+"</span></li></ul>"
		If ($status="rejected")
			This:C1470.status=status
		End if 
	End if 
	$info:=This:C1470.save()
	If ($info.success)
		Web Form:C1735.setMessage("This leave has been successfully updated!")
		ds:C1482.LeaveActions.add($employee; This:C1470; Current date:C33(); $status)
		$receiver:=String:C10(This:C1470.employee.email)+";"+String:C10(This:C1470.employee.team.manager.email)
		CALL WORKER:C1389("workerTest"; Formula:C1597(cs:C1710.Mailing.me.sendMails("Status Update"; action; receiver)))  //setup mailing class
	End if 
	
	
exposed Function editLeave() : cs:C1710.LeavesEntity
	var $status : Object
	var $receiver : Text:=String:C10(This:C1470.employee.email)+";"+String:C10(This:C1470.employee.team.manager.email)
	var $currentUser : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	var $action : Text:=$currentUser.fullName+" edited the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
		+String:C10(This:C1470.requestDate; Internal date short:K1:7)+"</li><li>Start Date : "+String:C10(This:C1470.startDate; Internal date short:K1:7)+\
		"</li><li>End Date : "+String:C10(This:C1470.endDate; Internal date short:K1:7)+"</li><li>Status : <span style=\"color:#ECB22E;\">"+This:C1470.status+"</span></li></ul>"
	var $leaveBalance : cs:C1710.LeaveBalancesEntity:=ds:C1482.LeaveBalances.all().query("employee.ID = :1 and leaveType.ID = :2"; This:C1470.employee.ID; This:C1470.leaveType.ID).first()
	If ((This:C1470.endDate-This:C1470.startDate)>$leaveBalance.balance)
		Web Form:C1735.setError("You selected more then your balance!")
	Else 
		$status:=This:C1470.save()
		If ($status.success)
			Web Form:C1735.setMessage("This leave has been updated!")
			CALL WORKER:C1389("workerTest"; Formula:C1597(cs:C1710.Mailing.me.sendMails("Leave Update"; $action; $receiver)))  //setup mailing class
		Else 
			Web Form:C1735.setError("Error while updating")
		End if 
	End if 
	return This:C1470
	