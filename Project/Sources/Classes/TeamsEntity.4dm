Class extends Entity

exposed Function addTeam($name : Text; $manager : cs:C1710.EmployeesEntity)
	var $info : Object
	If ($name="")
		Web Form:C1735.setError("You must assign a team's label !")
	Else 
		This:C1470.name:=$name
		This:C1470.manager:=$manager
		$info:=This:C1470.save()
		If ($info.success)
			Web Form:C1735.setMessage("Team created successfully!")
		Else 
			Web Form:C1735.setError("Error while creating this team !")
		End if 
	End if 
	
	