Class extends Entity

exposed Function addTeam(name : string, manager : cs:C1710.EmployeesEntity)
	var info : Object
	If (name=="")
		webForm.setError("You must assign a team's label !")
	Else 
		This:C1470.name=name
		This:C1470.manager=manager
		info=This:C1470.save()
		If (info.success)
			webForm.setMessage("Team created successfully!")
		Else 
			webForm.setError("Error while creating this team !")
			end
			end
			
			