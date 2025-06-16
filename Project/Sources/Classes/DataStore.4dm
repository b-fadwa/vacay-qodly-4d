Class extends DataStoreImplementation

exposed Function setCss($serverRef : Text; $cssClass : text)
	var $component : 4D:C1709.WebFormItem
	$component=web Form[$serverRef]
	$component.addCSSClass($cssClass)
	
exposed Function noDATA($serverRef : text; $cssClass : text; $selectedLength : Variant)
	var $component : 4D:C1709.WebFormItem
	$component=web Form[$serverRef]
	If (selectedLength=0)
		$component.addCSSClass($cssClass)
	Else 
		$component.removeCSSClass($cssClass)
		end if
		
exposed Function removeCss($serverRef : text; $cssClass : text)
	var $component : 4D:C1709.WebFormItem
	$component=web Form[$serverRef]
	$component.removeCSSClass($cssClass)
	
exposed Function Login() : text
	var $user : cs:C1710.EmployeesEntity:=ds:C1482.Employees.getCurrentUser()
	var $page : text
	case of
: ($user.role="Admin")
	$page="AdminVue"
: ($user.role="Employee")
	$page="EmployeeVue"
: ($user.role="Manager")
	$page="ManagerVue"
Else 
	$page="NotFound"
	end case 
	return $page
	
exposed Function navbar($serverRef : text)
	var $component : 4D:C1709.WebFormItem
	web Form[$serverRef].addCSSClass("activeNavButton")
	case of
: ($serverRef="dashBoard")
	web Form["calendar"].removeCSSClass("activeNavButton")
	web Form["users"].removeCSSClass("activeNavButton")
	web Form["settings"].removeCSSClass("activeNavButton")
	web Form["requests"].removeCSSClass("activeNavButton")
: ($serverRef="requests")
	web Form["dashBoard"].removeCSSClass("activeNavButton")
	web Form["calendar"].removeCSSClass("activeNavButton")
	web Form["users"].removeCSSClass("activeNavButton")
	web Form["settings"].removeCSSClass("activeNavButton")
: ($serverRef="calendar")
	web Form["dashBoard"].removeCSSClass("activeNavButton")
	web Form["users"].removeCSSClass("activeNavButton")
	web Form["settings"].removeCSSClass("activeNavButton")
	web Form["requests"].removeCSSClass("activeNavButton")
: ($serverRef="users")
	web Form["dashBoard"].removeCSSClass("activeNavButton")
	web Form["calendar"].removeCSSClass("activeNavButton")
	web Form["settings"].removeCSSClass("activeNavButton")
	web Form["requests"].removeCSSClass("activeNavButton")
: ($serverRef="settings")
	web Form["dashBoard"].removeCSSClass("activeNavButton")
	web Form["users"].removeCSSClass("activeNavButton")
	web Form["calendar"].removeCSSClass("activeNavButton")
	web Form["requests"].removeCSSClass("activeNavButton")
	end case
	
exposed Function breadcrumbs($path : text) : text
	return "Home/"+$path
	
exposed Function displayToRole($currentUser : cs:C1710.EmployeesEntity)
	case of
: ($currentUser.role="Employee")
	web Form["addHolidayButton"].hide()
	web Form["editHolidayButton"].hide()
	web Form["addLeaveTypeButton"].hide()
	web Form["deleteLeaveTypeButton"].hide()
	web Form["deleteTeamButton"].hide()
	web Form["addTeamButton"].hide()
	web Form["employeeSB"].hide()
	web Form["leaveActions"].hide()
	web Form["teamSB"].hide()
	web Form["teamButton"].hide()
	web Form["updateLeaveTypeButton"].hide()
	web Form["filterCalendarByEmp"].hide()
: ($currentUser.role="Manager")
	web Form["addHolidayButton"].hide()
	web Form["editHolidayButton"].hide()
	web Form["addLeaveTypeButton"].hide()
	web Form["deleteLeaveTypeButton"].hide()
	web Form["deleteTeamButton"].hide()
	web Form["addTeamButton"].hide()
	web Form["teamSB"].hide()
	web Form["teamButton"].hide()
	web Form["updateLeaveTypeButton"].hide()
	end case
	
exposed Function landingDetailPage($currentUser : cs:C1710.EmployeesEntity) : text
	If ($currentUser.role="Employee")
		return "LeavesDetailEmployee"
	Else 
		return "LeavesDetailManager"
		end if
		
exposed Function getManifestObject() : Object
	var $manifestFile : 4D:C1709.File
	var $manifestObject : Object
	$manifestFile:=File:C1566("/PACKAGE/Project/Sources/Shared/manifest.json")
	$manifestObject:=json Parse($manifestFile.getText())
	return $manifestObject
	
	
exposed Function generateData()
	var $generateData : cs:C1710.GenerateData:=cs:C1710.GenerateData.new()
	$generateData.dropData()
	$generateData.createData()
	web Form.setMessage("Data generated!")
	
	
exposed Function getCredentials() : Object
	var $jsonFile : 4D:C1709.File
	var $text : text
	var $fileContent : Object
	$jsonFile:=File:C1566("/PROJECT/Sources/Shared/assets/credentials/env.json")  //fill the json file with your sendGrid api credentials
	$text:=$jsonFile.getText()
	$fileContent:=json Parse(text; 38)
	return $fileContent
	
	