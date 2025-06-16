Class extends DataClass


exposed Function add($employee : cs:C1710.EmployeesEntity; $leaveBalance : cs:C1710.LeaveBalancesEntity; $$rangeDate : collection; $$newLeave : cs:C1710.LeavesEntity; $initialLength : number) : cs:C1710.LeavesEntity
	var $info : Object
	var $action : text
	var $receiver : text:=String:C10($employee.email)+";"+String:C10($employee.team.manager.email)
	
	var $isAlreadyDeclared : Integer
	If ($rangeDate.length#0)
		$isAlreadyDeclared=This:C1470.query("employee.ID = :1 and startDate >= :2 and endDate <= :3"; employee.ID; date($rangeDate[0]); date($rangeDate.length=1 ? $rangeDate[0] : $rangeDate[1])).length
		end
		case of
	: ($newLeave.rangeLength=0)
		web Form.setWarning("You either selected only weekends or holidays only!")
	: ($isAlreadyDeclared #0)
		web Form.setError("You already declared a break on that range")
	: ($leaveBalance.leaveType=Null:C1517)
		web Form.setError("You must select a type!")
	: ($leaveBalance.balance=0)
		web Form.setError("This type's balance is empty")
	: ($rangeDate.length<1)
		web Form.setError("You must select at least one date!")
	: (Date:C102($rangeDate[0])<current Date())
		web Form.setError("You must select a valid date.")
	: (($rangeDate.length=2) && ($leaveBalance.balance<$newLeave.rangeLength))
		web Form.setError("Type limit surpassed by "+String:C10(((Date:C102($rangeDate[1])-Date:C102($rangeDate[0]))+1)-leaveBalance.balance)+" days")
	: (employee=Null:C1517)
		web Form.setError("Check your connection!")
	: ((($newLeave.rangeLength>initialLength) || ($newLeave.rangeLength<initialLength)) && (Abs:C99($newLeave.rangeLength-initialLength)#0.5))
		web Form.setError(("The number of days selected is illogical!"))
	Else 
		$newLeave.employee:=$employee
		$newLeave.startDate:=$rangeDate[0]
		$newLeave.requestDate:=current Date()
		$newLeave.endDate:=($rangeDate.length=2) ? $rangeDate[1] : $rangeDate[0]
		$newLeave.leaveType:=$leaveBalance.leaveType
		$newLeave.status:="to be approved"
		$info:=$newLeave.save()
		If ($info.success)
			$employee.reload()
			web Form.setMessage("The leave request has been successfully created!")
			ds:C1482.LeaveActions.add($employee; $newLeave; current Date();"creation")
			web Form["declareLeave"].hide()
			$action:=$newLeave.employee.fullName+" created the leave <b>"+$newLeave.leaveType.name+" - "+$newLeave.employee.fullName+"</b> :<br><ul><li>Request Date : "\
				+String:C10($newLeave.requestDate; kInternalDateLong)+"</li><li>Start Date : "+String:C10($newLeave.startDate; kInternalDateLong)+\
				"</li><li>End Date : "+String:C10($newLeave.endDate; kInternalDateLong)+"</li><li>Status : <span style=\"color:#ECB22E;\">"+$newLeave.status+"</span></li></ul>"
			call Worker("workerTest"; formula(cs:C1710.Mailing.me.sendMails("Status Update"; $action; $receiver)))  //setup mailing class
			end if
			end case 
			return $newLeave
			
			
exposed Function teamLeaves($employee : cs:C1710.EmployeesEntity)->$leaves : cs:C1710.LeavesSelection
	If ($employee.teamsManage.length>0)
		$leaves:=$employee.team.employees.leaves
		end if
		
exposed Function allLeaves()->$leaves : cs:C1710.LeavesSelection
	$leaves:=ds:C1482.Leaves.all()
	
exposed Function filtering($selectedType : cs:C1710.LeaveTypesEntity; $employee : cs:C1710.EmployeesEntity; $status : Variant) : cs:C1710.LeavesSelection
	var $currentUser : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	If ($currentUser.role="employee")
		$employee:=currentUser
		end
		switch
	: ((selectedType #Null:C1517) && (employee #Null:C1517) && ((status #"") && (status #Null:C1517)))
		return This:C1470.query("employee.fullName = :1 and status = :2 and leaveType.name = :3"; employee.fullName; status; selectedType.name)
	: ((selectedType #Null:C1517) && ((employee #Null:C1517)))
		return This:C1470.query("employee.fullName = :1 and leaveType.name = :2"; employee.fullName; selectedType.name)
	: ((selectedType #Null:C1517) && ((status #"") && (status #Null:C1517)))
		return This:C1470.query("status = :1 and leaveType.name = :2"; status; selectedType.name)
	: ((employee #Null:C1517) && ((status #"") && (status #Null:C1517)))
		return This:C1470.query("employee.fullName = :1 and status = :2"; employee.fullName; status)
	: (((selectedType #Null:C1517)))
		return This:C1470.query(" leaveType.name = :1"; selectedType.name)
	: (employee #Null:C1517)
		return This:C1470.query("employee.fullName = :1"; employee.fullName)
	: ((status #"") && (status #Null:C1517))
		return This:C1470.query("status = :1"; status)
	Else 
		return This:C1470.all()
		end
		
exposed Function update(employee : cs:C1710.EmployeesEntity; $rangeDate : collection; selectedLeave : cs:C1710.LeavesEntity; status : string)
	var $info : Object
	switch
: ($rangeDate.length#2)
	web Form.setError("You must select two dates!")
Else 
	selectedLeave.startDate=Date:C102($rangeDate.at(0))
	selectedLeave.requestDate=currentDate()
	selectedLeave.endDate=Date:C102($rangeDate.at(1))
	selectedLeave.status=status
	$info=selectedLeave.save()
	If ($info.success)
		web Form.setMessage("This leave was successfully updated!")
		ds:C1482.LeaveActions.add(employee; selectedLeave; currentDate(); status)
		end
		end
		
exposed Function getLeavesByRole(currentUser : cs:C1710.EmployeesEntity) : cs:C1710.LeavesSelection
	var managerLeaves : cs:C1710.LeavesSelection
	var teamLeaves : cs:C1710.LeavesSelection
	switch
: (currentUser.role="Admin")
	return This:C1470.all()
: (currentUser.role="Employee")
	return currentUser.leaves
: (currentUser.role="Manager")
	managerLeaves=currentUser.leaves
	teamLeaves=This:C1470.query("employee.team.manager.ID = :1"; currentUser.ID)
	return managerLeaves.or(teamLeaves)
	end
	
	
exposed Function getRangeLength(dateRange : Collection) : number
	var newDate : Date
	var colLength : number=0
	If (dateRange.length=2)
		newDate=dateRange[0]
		While (newDate<=dateRange[1])
			If ((dayNumber(newDate)#1) && (dayNumber(newDate)#7) && (ds:C1482.Holidays.all().query("startDate <= :1  and endDate >= :1"; newDate).length=0))
				colLength+=1
				end
				newDate=addToDate(newDate; 0; 0; 1)
				end
				end
				If (dateRange.length=1)
					If ((dayNumber(newDate)#1) && (dayNumber(newDate)#7) && (ds:C1482.Holidays.all().query("startDate <= :1  and endDate >= :1"; newDate).length=0))
						colLength+=1
						end
						end
						return colLength
						
						
exposed Function filterInCalendar(selectedEmployee : cs:C1710.EmployeesEntity; leaveType : variant; currentUser : cs:C1710.EmployeesEntity) : cs:C1710.LeavesSelection
	var leaves : cs:C1710.LeavesSelection=This:C1470.getLeavesByRole(currentUser)
	switch
: ((selectedEmployee #Null:C1517) && (leaveType #Null:C1517))
	return leaves.query("status = 'approved' and leaveType.name = :1 and employee.ID = :2"; leaveType.name; selectedEmployee.ID)
: ((selectedEmployee #Null:C1517) && (leaveType=Null:C1517))
	return leaves.query("status = 'approved' and employee.ID = :1"; selectedEmployee.ID)
: ((leaveType #Null:C1517) && (selectedEmployee=Null:C1517))
	return leaves.query("status = 'approved' and leaveType.name = :1"; leaveType.name)
Else 
	return leaves.query("status = 'approved'")
	end
	
	
	
	