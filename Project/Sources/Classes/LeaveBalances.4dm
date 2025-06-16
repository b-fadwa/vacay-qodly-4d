Class extends DataClass

Function createDateArray($startdate : date; $enddate : Date)->$arrayDate : Collection
	var indate : Date
	$arrayDate:=new Collection()
	While ($enddate>=$startdate)
		$indate:=$startdate
		$arrayDate.push($indate)
		$startdate+=1
		end while
		
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
		end if 
		If ($isSaved.success)
			web Form.setMessage("Leave balance saved successfully!")
			end if
			
			
exposed Function newYearBalance()
	var $employees : cs:C1710.EmployeesSelection:=ds:C1482.Employees.all()
	var $employee : cs:C1710.EmployeesEntity
	var $congeAnnuel : cs:C1710.LeaveBalancesEntity
	If (current Date()=Date:C102("01/01/"+String:C10(year Of(current Date()))))
		for Each($employee; $employees)
		$congeAnnuel:=This:C1470.query("leaveType.name=:1 and employee.ID=:2 ";"Annual paid leave"; employee.ID).first()
		If ($congeAnnuel.balance+18>=32)
			$congeAnnuel.balance:=32
			$congeAnnuel.save()
		Else 
			$congeAnnuel.balance+=18
			$congeAnnuel.save()
			end if
			
			end for each
			end if
			