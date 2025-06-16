Class extends DataStoreImplementation

exposed Function setCss($serverRef : Text; $cssClass : Text)
	var $component : 4D:C1709.WebFormItem
	$component=Web Form:C1735[$serverRef]
	$component.addCSSClass($cssClass)
	
exposed Function noDATA($serverRef : Text; $cssClass : Text; $selectedLength : Variant)
	var $component : 4D:C1709.WebFormItem
	$component=Web Form:C1735[$serverRef]
	If (selectedLength=0)
		$component.addCSSClass($cssClass)
	Else 
		$component.removeCSSClass($cssClass)
	End if 
	
exposed Function removeCss($serverRef : Text; $cssClass : Text)
	var $component : 4D:C1709.WebFormItem
	$component=Web Form:C1735[$serverRef]
	$component.removeCSSClass($cssClass)
	
exposed Function Login() : Text
	var $user : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	var $page : Text
	Case of 
		: ($user.role="Admin")
			$page="AdminVue"
		: ($user.role="Employee")
			$page="EmployeeVue"
		: ($user.role="Manager")
			$page="ManagerVue"
		Else 
			$page="NotFound"
	End case 
	return $page
	
exposed Function navbar($serverRef : Text)
	var $component : 4D:C1709.WebFormItem
	Web Form:C1735[$serverRef].addCSSClass("activeNavButton")
	Case of 
		: ($serverRef="dashBoard")
			Web Form:C1735["calendar"].removeCSSClass("activeNavButton")
			Web Form:C1735["users"].removeCSSClass("activeNavButton")
			Web Form:C1735["settings"].removeCSSClass("activeNavButton")
			Web Form:C1735["requests"].removeCSSClass("activeNavButton")
		: ($serverRef="requests")
			Web Form:C1735["dashBoard"].removeCSSClass("activeNavButton")
			Web Form:C1735["calendar"].removeCSSClass("activeNavButton")
			Web Form:C1735["users"].removeCSSClass("activeNavButton")
			Web Form:C1735["settings"].removeCSSClass("activeNavButton")
		: ($serverRef="calendar")
			Web Form:C1735["dashBoard"].removeCSSClass("activeNavButton")
			Web Form:C1735["users"].removeCSSClass("activeNavButton")
			Web Form:C1735["settings"].removeCSSClass("activeNavButton")
			Web Form:C1735["requests"].removeCSSClass("activeNavButton")
		: ($serverRef="users")
			Web Form:C1735["dashBoard"].removeCSSClass("activeNavButton")
			Web Form:C1735["calendar"].removeCSSClass("activeNavButton")
			Web Form:C1735["settings"].removeCSSClass("activeNavButton")
			Web Form:C1735["requests"].removeCSSClass("activeNavButton")
		: ($serverRef="settings")
			Web Form:C1735["dashBoard"].removeCSSClass("activeNavButton")
			Web Form:C1735["users"].removeCSSClass("activeNavButton")
			Web Form:C1735["calendar"].removeCSSClass("activeNavButton")
			Web Form:C1735["requests"].removeCSSClass("activeNavButton")
	End case 
	
exposed Function breadcrumbs($path : Text) : Text
	return "Home/"+$path
	
exposed Function displayToRole($currentUser : cs:C1710.EmployeesEntity)
	Case of 
		: ($currentUser.role="Employee")
			Web Form:C1735["addHolidayButton"].hide()
			Web Form:C1735["editHolidayButton"].hide()
			Web Form:C1735["addLeaveTypeButton"].hide()
			Web Form:C1735["deleteLeaveTypeButton"].hide()
			Web Form:C1735["deleteTeamButton"].hide()
			Web Form:C1735["addTeamButton"].hide()
			Web Form:C1735["employeeSB"].hide()
			Web Form:C1735["leaveActions"].hide()
			Web Form:C1735["teamSB"].hide()
			Web Form:C1735["teamButton"].hide()
			Web Form:C1735["updateLeaveTypeButton"].hide()
			Web Form:C1735["filterCalendarByEmp"].hide()
		: ($currentUser.role="Manager")
			Web Form:C1735["addHolidayButton"].hide()
			Web Form:C1735["editHolidayButton"].hide()
			Web Form:C1735["addLeaveTypeButton"].hide()
			Web Form:C1735["deleteLeaveTypeButton"].hide()
			Web Form:C1735["deleteTeamButton"].hide()
			Web Form:C1735["addTeamButton"].hide()
			Web Form:C1735["teamSB"].hide()
			Web Form:C1735["teamButton"].hide()
			Web Form:C1735["updateLeaveTypeButton"].hide()
	End case 
	
exposed Function landingDetailPage($currentUser : cs:C1710.EmployeesEntity) : Text
	If ($currentUser.role="Employee")
		return "LeavesDetailEmployee"
	Else 
		return "LeavesDetailManager"
	End if 
	
exposed Function getManifestObject() : Object
	var $manifestFile : 4D:C1709.File
	var $manifestObject : Object
	$manifestFile:=File:C1566("/PACKAGE/Project/Sources/Shared/manifest.json")
	$manifestObject:=JSON Parse:C1218($manifestFile.getText())
	return $manifestObject
	
	
exposed Function generateData()
	var $generateData : cs:C1710.GenerateData:=cs:C1710.GenerateData.new()
	$generateData.dropData()
	$generateData.createData()
	Web Form:C1735.setMessage("Data generated!")
	
	
exposed Function getCredentials() : Object
	var $jsonFile : 4D:C1709.File
	var $text : Text
	var $fileContent : Object
	$jsonFile:=File:C1566("/PROJECT/Sources/Shared/assets/credentials/env.json")  //fill the json file with your sendGrid api credentials
	$text:=$jsonFile.getText()
	$fileContent:=JSON Parse:C1218($text; 38)
	return $fileContent
	
	