Class extends DataClass


exposed Function add($employee : cs:C1710.EmployeesEntity; $leaveBalance : cs:C1710.LeaveBalancesEntity; $rangeDate : Collection; $newLeave : cs:C1710.LeavesEntity; $initialLength : Integer) : cs:C1710.LeavesEntity
	var $info : Object
	var $action : Text
	var $receiver : Text:=String:C10($employee.email)+";"+String:C10($employee.team.manager.email)
	
	var $isAlreadyDeclared : Integer
	If ($rangeDate.length#0)
		$isAlreadyDeclared=This:C1470.query("employee.ID = :1 and startDate >= :2 and endDate <= :3"; $employee.ID; Date:C102($rangeDate[0]); Date:C102($rangeDate.length=1 ? $rangeDate[0] : $rangeDate[1])).length
		end
		Case of 
			: ($newLeave.rangeLength=0)
				Web Form:C1735.setWarning("You either selected only weekends or holidays only!")
			: ($isAlreadyDeclared#0)
				Web Form:C1735.setError("You already declared a break on that range")
			: ($leaveBalance.leaveType=Null:C1517)
				Web Form:C1735.setError("You must select a type!")
			: ($leaveBalance.balance=0)
				Web Form:C1735.setError("This type's balance is empty")
			: ($rangeDate.length<1)
				Web Form:C1735.setError("You must select at least one date!")
			: (Date:C102($rangeDate[0])<Current date:C33())
				Web Form:C1735.setError("You must select a valid date.")
			: (($rangeDate.length=2) && ($leaveBalance.balance<$newLeave.rangeLength))
				Web Form:C1735.setError("Type limit surpassed by "+String:C10(((Date:C102($rangeDate[1])-Date:C102($rangeDate[0]))+1)-leaveBalance.balance)+" days")
			: ($employee=Null:C1517)
				Web Form:C1735.setError("Check your connection!")
			: ((($newLeave.rangeLength>initialLength) || ($newLeave.rangeLength<initialLength)) && (Abs:C99($newLeave.rangeLength-initialLength)#0.5))
				Web Form:C1735.setError(("The number of days selected is illogical!"))
			Else 
				$newLeave.employee:=$employee
				$newLeave.startDate:=$rangeDate[0]
				$newLeave.requestDate:=Current date:C33()
				$newLeave.endDate:=($rangeDate.length=2) ? $rangeDate[1] : $rangeDate[0]
				$newLeave.leaveType:=$leaveBalance.leaveType
				$newLeave.status:="to be approved"
				$info:=$newLeave.save()
				If ($info.success)
					$employee.reload()
					Web Form:C1735.setMessage("The leave request has been successfully created!")
					ds:C1482.LeaveActions.add($employee; $newLeave; Current date:C33(); "creation")
					Web Form:C1735["declareLeave"].hide()
					$action:=$newLeave.employee.fullName+" created the leave <b>"+$newLeave.leaveType.name+" - "+$newLeave.employee.fullName+"</b> :<br><ul><li>Request Date : "\
						+String:C10($newLeave.requestDate; Internal date short:K1:7)+"</li><li>Start Date : "+String:C10($newLeave.startDate; Internal date short:K1:7)+\
						"</li><li>End Date : "+String:C10($newLeave.endDate; Internal date short:K1:7)+"</li><li>Status : <span style=\"color:#ECB22E;\">"+$newLeave.status+"</span></li></ul>"
					CALL WORKER:C1389("workerTest"; Formula:C1597(cs:C1710.Mailing.me.sendMails("Status Update"; $action; $receiver)))  //setup mailing class
				End if 
		End case 
		return $newLeave
		
		
exposed Function teamLeaves($employee : cs:C1710.EmployeesEntity)->$leaves : cs:C1710.LeavesSelection
	If ($employee.teamsManage.length>0)
		$leaves:=$employee.team.employees.leaves
	End if 
	
exposed Function allLeaves()->$leaves : cs:C1710.LeavesSelection
	$leaves:=ds:C1482.Leaves.all()
	
exposed Function filtering($selectedType : cs:C1710.LeaveTypesEntity; $employee : cs:C1710.EmployeesEntity; $status : Variant) : cs:C1710.LeavesSelection
	var $currentUser : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	If ($currentUser.role="employee")
		$employee:=currentUser
	End if 
	Case of 
		: (($selectedType#Null:C1517) && ($employee#Null:C1517) && (($status#"") && ($status#Null:C1517)))
			return This:C1470.query("employee.fullName = :1 and status = :2 and leaveType.name = :3"; $employee.fullName; $status; $selectedType.name)
		: (($selectedType#Null:C1517) && ((employee#Null:C1517)))
			return This:C1470.query("employee.fullName = :1 and leaveType.name = :2"; $employee.fullName; $selectedType.name)
		: (($selectedType#Null:C1517) && (($status#"") && ($status#Null:C1517)))
			return This:C1470.query("status = :1 and leaveType.name = :2"; status; $selectedType.name)
		: (($employee#Null:C1517) && (($status#"") && ($status#Null:C1517)))
			return This:C1470.query("employee.fullName = :1 and status = :2"; $employee.fullName; $status)
		: ((($selectedType#Null:C1517)))
			return This:C1470.query(" leaveType.name = :1"; $selectedType.name)
		: ($employee#Null:C1517)
			return This:C1470.query("employee.fullName = :1"; $employee.fullName)
		: (($status#"") && ($status#Null:C1517))
			return This:C1470.query("status = :1"; $status)
		Else 
			return This:C1470.all()
	End case 
	
exposed Function update($employee : cs:C1710.EmployeesEntity; $rangeDate : Collection; $selectedLeave : cs:C1710.LeavesEntity; $status : Text)
	var $info : Object
	Case of 
		: ($rangeDate.length#2)
			Web Form:C1735.setError("You must select two dates!")
		Else 
			$selectedLeave.startDate:=Date:C102($rangeDate.at(0))
			$selectedLeave.requestDate:=Current date:C33()
			$selectedLeave.endDate:=Date:C102($rangeDate.at(1))
			$selectedLeave.status:=$status
			$info:=$selectedLeave.save()
			If ($info.success)
				Web Form:C1735.setMessage("This leave was successfully updated!")
				ds:C1482.LeaveActions.add($employee; $selectedLeave; Current date:C33(); $status)
			End if 
	End case 
	
exposed Function getLeavesByRole($currentUser : cs:C1710.EmployeesEntity) : cs:C1710.LeavesSelection
	var $managerLeaves : cs:C1710.LeavesSelection
	var $teamLeaves : cs:C1710.LeavesSelection
	Case of 
		: ($currentUser.role="Admin")
			return This:C1470.all()
		: ($currentUser.role="Employee")
			return $currentUser.leaves
		: ($currentUser.role="Manager")
			$managerLeaves=$currentUser.leaves
			$teamLeaves=This:C1470.query("employee.team.manager.ID = :1"; $currentUser.ID)
			return $managerLeaves.or($teamLeaves)
	End case 
	
	
exposed Function getRangeLength($dateRange : Collection) : Integer
	var $newDate : Date
	var $colLength : Integer:=0
	If ($dateRange.length=2)
		$newDate:=$dateRange[0]
		While ($newDate<=$dateRange[1])
			If ((Day number:C114($newDate)#1) && (Day number:C114($newDate)#7) && (ds:C1482.Holidays.all().query("startDate <= :1  and endDate >= :1"; $newDate).length=0))
				colLength+=1
			End if 
			$newDate=Add to date:C393($newDate; 0; 0; 1)
		End while 
	End if 
	If (dateRange.length=1)
		If ((Day number:C114($newDate)#1) && (Day number:C114($newDate)#7) && (ds:C1482.Holidays.all().query("startDate <= :1  and endDate >= :1"; $newDate).length=0))
			colLength+=1
		End if 
	End if 
	return $colLength
	
	
exposed Function filterInCalendar($selectedEmployee : cs:C1710.EmployeesEntity; $leaveType : Variant; $currentUser : cs:C1710.EmployeesEntity) : cs:C1710.LeavesSelection
	var $leaves : cs:C1710.LeavesSelection:=This:C1470.getLeavesByRole($currentUser)
	Case of 
		: (($selectedEmployee#Null:C1517) && (leaveType#Null:C1517))
			return $leaves.query("status = 'approved' and leaveType.name = :1 and employee.ID = :2"; $leaveType.name; $selectedEmployee.ID)
		: (($selectedEmployee#Null:C1517) && ($leaveType=Null:C1517))
			return $leaves.query("status = 'approved' and employee.ID = :1"; $selectedEmployee.ID)
		: (($leaveType#Null:C1517) && ($selectedEmployee=Null:C1517))
			return $leaves.query("status = 'approved' and leaveType.name = :1"; $leaveType.name)
		Else 
			return $leaves.query("status = 'approved'")
	End case 
	
	
	
	