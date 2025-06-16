Class extends DataClass

local Function add($employee : cs:C1710.EmployeesEntity; $leave : cs:C1710.LeavesEntity; $actionDate : Date; $actionType : Text)
	var $action : cs:C1710.LeaveActionsEntity:=ds:C1482.LeaveActions.new()
	$action.by:=$employee
	$action.date:=$actionDate
	$action.leave:=ds:C1482.Leaves.get($leave.ID)
	$action.type:=$actionType
	$action.save()
	
	
	