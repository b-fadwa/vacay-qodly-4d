Class extends DataClass

Function createDateArray($startdate : Date; $enddate : Date)->$arrayDate : Collection
	var $indate : Date
	$arrayDate:=New collection:C1472()
	While ($enddate>=$startdate)
		$indate:=$startdate
		$arrayDate.push($indate)
		$startdate+=1
	End while 
	
exposed Function decrementBalance($leave : cs:C1710.LeavesEntity)
	var $leaveBalance : cs:C1710.LeaveBalancesEntity
	var $counter : Integer:=0
	var $inDate : Date
	var $isSaved : Object
	var $dateArrays : Collection:=This:C1470.createDateArray($leave.startDate; $leave.endDate)
	$leaveBalance:=This:C1470.query("employee.ID =:1 and leaveType.name = :2"; $leave.employee.ID; $leave.leaveType.name).first()
	If ($leaveBalance.balance#0)
		$leaveBalance.balance-=$leave.rangeLength
		$isSaved:=$leaveBalance.save()
	End if 
	If ($isSaved.success)
		Web Form:C1735.setMessage("Leave balance saved successfully!")
	End if 
	
	
exposed Function newYearBalance()
	var $employees : cs:C1710.EmployeesSelection:=ds:C1482.Employees.all()
	var $employee : cs:C1710.EmployeesEntity
	var $congeAnnuel : cs:C1710.LeaveBalancesEntity
	If (Current date:C33()=Date:C102("01/01/"+String:C10(Year of:C25(Current date:C33()))))
		For each ($employee; $employees)
			$congeAnnuel:=This:C1470.query("leaveType.name=:1 and employee.ID=:2 "; "Annual paid leave"; $employee.ID).first()
			If ($congeAnnuel.balance+18>=32)
				$congeAnnuel.balance:=32
				$congeAnnuel.save()
			Else 
				$congeAnnuel.balance+=18
				$congeAnnuel.save()
			End if 
			
		End for each 
	End if 
	