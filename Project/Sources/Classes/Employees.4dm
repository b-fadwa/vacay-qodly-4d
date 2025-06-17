Class extends DataClass


exposed Function getCurrentUser() : cs:C1710.EmployeesEntity
	return This:C1470.get(Session:C1714.storage.payLoad.UUID)
	
exposed Function getEmployees()->$employees : cs:C1710.EmployeesSelection
	$employees:=This:C1470.all()
	
	
exposed Function search($search : Text) : cs:C1710.EmployeesSelection
	If ($search#"")
		return This:C1470.query("fullName = :1"; "@"+$search+"@")
	Else 
		return This:C1470.all()
	End if 
	
	
exposed Function getSBEmployees($currentUser : cs:C1710.EmployeesEntity) : cs:C1710.EmployeesSelection
	If ($currentUser.role="Admin")
		return This:C1470.all()
	End if 
	If ($currentUser.role="Manager")
		return This:C1470.query("team.manager.ID = :1"; $currentUser.ID).or($currentUser)
	End if 
	
exposed Function filterByTeam($team : cs:C1710.TeamsEntity; $currentUser : cs:C1710.EmployeesEntity) : cs:C1710.EmployeesSelection
	If ($team#Null:C1517)
		return This:C1470.query("team.ID = :1"; $team.ID)
	Else 
		return This:C1470.getSBEmployees($currentUser)
	End if 
	
	
exposed Function filterEmployees($team : cs:C1710.TeamsEntity; $userName : Text) : cs:C1710.EmployeesSelection
	Case of 
		: (($team#Null:C1517) && ($userName#""))
			return This:C1470.query("fullName = :1 && team.name = :2"; "@"+userName+"@"; team.name)
		: (($team#Null:C1517) && (userName=""))
			return This:C1470.query("team.name = :1"; team.name)
		: (($team=Null:C1517) && (userName#""))
			return This:C1470.query("fullName = :1"; "@"+userName+"@")
		Else 
			return This:C1470.all()
	End case 
	