Class extends Entity

// local Function aws()->$result : Object
// 	$result:=Null:C1517
// 	If (Session:C1714.storage.users=Null:C1517)
// 		ds:C1482.Employees.getCurrentUser()
// 		end if
// 		If (Session:C1714.storage.users!=Null:C1517)
// 			$result=Session:C1714.storage.users.query("email = :1", this.email).at(0)
// 			end if

//exposed Function get fullName()->$fullName : Text
//fullName=(This.firstName && This.lastName) ? (This.firstName+" "+Uppercase(This.lastName,*)) : (Uppercase(This.lastName,*) || This.firstName) || ""

// exposed Function get firstName()->firstname : string
// 	var aws : Object
// 	firstname=""
// 	aws=This:C1470.aws()
// 	If (aws !=Null:C1517)
// 		firstname=aws.firstname
// 		end

// exposed Function get lastName()->lastname : string
// 	var aws : Object
// 	lastname=""
// 	aws=This:C1470.aws()
// 	If (aws !=Null:C1517)
// 		lastname=aws.lastname
// 		end

// exposed Function get role()->role : string
// 	var aws : Object
// 	role=""
// 	aws=This:C1470.aws()
// 	If (aws !=Null:C1517)
// 		role=aws.role
// 		end


exposed Function get toValidateBalance()->$toValidateBalance : Integer
	$toValidateBalance:=This:C1470.leaves.query("status == 'to be approved'").length
	
exposed Function get approuvedBalance()->$approuvedBalance : Integer
	$approuvedBalance:=This:C1470.leaves.query("status == 'approved'").length
	
exposed Function get nonValideBalance()->$nonValideBalance : Integer
	$nonValideBalance:=This:C1470.leaves.query("status == 'rejected'").length
	
exposed Function get balance()->$balance : Integer
	$balance:=This:C1470.leaveBalances.sum("balance")
	
exposed Function addBalanceToNew($team : cs:C1710.TeamsEntity)
	var $leaveTypes : cs:C1710.LeaveTypesSelection:=ds:C1482.LeaveTypes.all()
	var $leaveCongeAnnuel : cs:C1710.LeaveTypesEntity=$leaveTypes.query("name = :1","Annual paid leave").first()
	var $leaveBalance : cs:C1710.LeaveBalancesEntity
	var $remainingDays : Integer
	$remainingDays:=(12-Month of:C24(Current date:C33()))*1.5
	If (This:C1470.team=Null:C1517)
		This:C1470.team:=$team
		This:C1470.save()
		$leaveBalance:=ds:C1482.LeaveBalances.new()
		$leaveBalance.employee:=This:C1470
		$leaveBalance.leaveType:=$leaveCongeAnnuel
		$leaveBalance.balance:=$remainingDays
		$leaveBalance.save()
	Else 
		This:C1470.team:=$team
		This:C1470.save()
	End if 
	
exposed Function getBalanceChart()->$pieChart : Collection
	var $balance : cs:C1710.LeaveBalancesSelection
	$balance:=This:C1470.leaveBalances
	$pieChart:=balance.extract("balance","value","leaveType.name","label","leaveType.color","color")
	
	
exposed Function getBalance($leaveType : cs:C1710.LeaveTypesEntity) : cs:C1710.LeaveBalancesEntity
	var $leave : cs:C1710.LeaveTypesEntity
	If ($leaveType !=Null:C1517)
		$leave:=This:C1470.leaveBalances.leaveType.query("name = :1", leaveType.name).first()
		If ($leave#Null:C1517)
			return $leave.leaveBalances.query("employee.ID = :1", this.ID).first()
		Else 
			return Null:C1517
			Web Form:C1735.setError("Not found")
		End if 
	End if 
	
exposed Function editBalance($leaveType : cs:C1710.LeaveTypesEntity,$balance : Integer)
	var $leaveT : cs:C1710.LeaveTypesEntity:=This:C1470.leaveBalances.leaveType.query("name = :1", leaveType.name).first()
	var $leaveBalance : cs:C1710.LeaveBalancesEntity
	If ($leaveT#Null:C1517)
		$leaveBalance=$leaveT.leaveBalances.query("employee.ID = :1", this.ID).first()
		$leaveBalance.balance=$balance
		$leaveBalance.save()
	Else 
		$leaveBalance:=ds:C1482.LeaveBalances.new()
		$leaveBalance.balance:=$balance
		$leaveBalance.employee:=This:C1470
		$leaveBalance.leaveType:=$leaveType
		$leaveBalance.save()
	End if 
	Web Form:C1735.setMessage("Balance updated successfully!")
	
	
exposed Function removeTeam()
	var $saved : Object
	This:C1470.team=Null:C1517
	$saved:=This:C1470.save()
	If ($saved.success)
		Web Form:C1735.setMessage("Team removed!")
	Else 
		Web Form:C1735.setError("Error!")
	End if 
	
exposed Function setTeam($selectedTeam : cs:C1710.TeamsEntity)
	var $saved : Object
	This:C1470.team=$selectedTeam
	$saved:=This:C1470.save()
	If ($saved.success)
		Web Form:C1735.setMessage("Team added!")
	Else 
		Web Form:C1735.setError("Error!")
	End if 
	