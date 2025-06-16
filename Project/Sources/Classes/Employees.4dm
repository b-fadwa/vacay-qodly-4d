Class extends DataClass


// exposed Function getCurrentUser()->user : cs:C1710.EmployeesEntity
// 	var $userCS : cs:C1710.Qodly.Users
// 	var userCloud : Object
// 	If (Session:C1714.storage.currentUser==Null:C1517)
// 		$userCS=cs:C1710.Qodly.Users.me
		
// 		userCloud=$userCS.currentUser()
// 		If (userCloud !=Null:C1517)
// 			user=This:C1470.query("email = :1"; userCloud.email).first()
// 			If (user==Null:C1517)
// 				user=ds:C1482.Employees.new()
// 				user.email=userCloud.email
// 				user.save()
// 				end
// 				Use (Session:C1714.storage)
// 					Session:C1714.storage.currentUser=newSharedObject("ID"; user.email)
// 					Session:C1714.storage.users=$userCS.allUsers().copy(kShared)
// 					end
// 					end
// 				Else 
// 					user=This:C1470.all().query("email = :1";session.storage.currentUser.ID).first()
// 					end
					
exposed Function getEmployees()->$employees : cs:C1710.EmployeesSelection
	$employees:=This:C1470.all()
	
	
exposed Function search($search : text) : cs:C1710.EmployeesSelection
	If ($search #"")
		return This:C1470.query("fullName = :1";"@"+$search+"@")
	Else 
		return This:C1470.all()
		end if
		
		
exposed Function getSBEmployees($currentUser : cs:C1710.EmployeesEntity) : cs:C1710.EmployeesSelection
	If ($currentUser.role="Admin")
		return This:C1470.all()
		end if
		If ($currentUser.role="Manager")
			return This:C1470.query("team.manager.ID = :1"; $currentUser.ID).or($currentUser)
			end if
			
exposed Function filterByTeam($team : cs:C1710.TeamsEntity; $currentUser : cs:C1710.EmployeesEntity) : cs:C1710.EmployeesSelection
	If ($team #Null:C1517)
		return This:C1470.query("team.ID = :1"; $team.ID)
	Else 
		return This:C1470.getSBEmployees($currentUser)
		end if
		
		
exposed Function filterEmployees($team : cs:C1710.TeamsEntity; $userName : text) : cs:C1710.EmployeesSelection
	case of
: (($team #Null:C1517) && ($userName#""))
	return This:C1470.query("fullName = :1 && team.name = :2";"@"+userName+"@";team.name)
: (($team #Null:C1517) && (userName=""))
	return This:C1470.query("team.name = :1";team.name)
: (($team=Null:C1517) && (userName #""))
	return This:C1470.query("fullName = :1";"@"+userName+"@")
Else 
	return This:C1470.all()
	end case
	