Class extends DataClass

local Function add($employee : cs:C1710.EmployeeEntity; $leave : cs:C1710.LeaveEntity; $actionDate : Date; $actionType : Text)
	var $action : cs:C1710.LeaveActionEntity:=ds:C1482.LeaveAction.new()
	$action.by:=$employee
	$action.date:=$actionDate
	$action.leave:=ds:C1482.Leave.get($leave.ID)
	$action.type:=$actionType
	$action.save()
	
	
	