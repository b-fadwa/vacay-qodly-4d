Class constructor
	This:C1470.sentences=[]
	
	This:C1470.words=[]
	
Function dropData()
	var $trash : Object
	
	$trash:=ds:C1482.Employees.all().drop()
	$trash:=ds:C1482.LeaveTypes.all().drop()
	$trash:=ds:C1482.Holidays.all().drop()
	$trash:=ds:C1482.Teams.all().drop()
	$trash:=ds:C1482.LeaveBalances.all().drop()
	$trash:=ds:C1482.Leaves.all().drop()
	$trash:=ds:C1482.Comments.all().drop()
	$trash:=ds:C1482.LeaveActions.all().drop()
	$trash:=ds:C1482.LeaveHistory.all().drop()
	$trash:=ds:C1482.LeaveNotifications.all().drop()
	
	
Function createData()
	
	This:C1470.generateUsers()
	This:C1470.generateLeavesTypes()
	This:C1470.generateHolidays()
	This:C1470.generateTeams()
	This:C1470.linkToTeam()
	This:C1470.generateLeaveBalances()
	This:C1470.generateLeaves()
	
Function generateUsers()
	//var $userClass : cs.Qodly.Users
	//var $cloudUsers : Collection
	//var $oneUser; $info : Object
	//var $newUser : cs.EmployeesEntity
	//$userClass:=cs.Qodly.Users.me
	//$cloudUsers:=userClass.allUsers()
	//For each ($oneUser;$cloudUsers)
	//$newUser:=ds.Employees.new()
	//$newUser.email:=oneUser.email
	//$info=$newUser.save()
	//End for each 
	
Function generateLeavesTypes()
	var $types : Collection
	var $item : Object
	var $LeaveType : cs:C1710.LeaveTypesEntity
	$types=[\
		{name: "Annual paid leave"; color: "#30BCAF"; descritpion: "Annual paid leave is a period of time granted to an employee by his or her employer;during which the employee is authorized not to work while receiving remuneration. This type of leave is generally provided for by law or company policy;and is design"+"ed to enable employees to take regular breaks to rest;recharge and enjoy their free time."}; \
		{name: "Recovery"; color: "#7B61FF"; descritpion: "Recuperation is a type of leave granted to an employee to compensate for overtime or days worked beyond regular hours. It is common practice in many organizations to recognize and reward employees' extra efforts."}; \
		{name: "Medical leave"; color: "#E25618"; descritpion: "Medical leave is a period of leave granted to an employee due to his or her own illness or injury. It may be provided for under company leave policies or government regulations to enable employees to recover fully before returning to work."}; \
		{name: "Maternity"; color: "#F5768D"; descritpion: "Maternity leave is granted to a pregnant woman to enable her to care for her health and her baby before and after childbirth. It is generally provided for by law;and may include special provisions for job protection and continued benefits during the "+"period of maternity-related absence."}; \
		{name: "Paternity"; color: "#6584F2"; descritpion: "Paternity leave is granted to a father or partner to enable him to support his family during the birth or adoption of a child. The duration and remuneration of this leave may vary according to company laws and policies."}; \
		{name: "Marriage"; color: "#64BBFF"; descritpion: "Wedding leave is granted to employees to enable them to get married and celebrate this important event in their lives. It is generally provided for in the company's leave policies and may vary in terms of duration and conditions according to local cus"+"toms and regulations."}; \
		{name: "Birth"; color: "#EA9E3E"; descritpion: "Birth leave is granted to employees to enable them to care for their family and adjust to the arrival of a newborn child. It can be granted to both parents and may include special provisions for parental support and flexible working hours."}; \
		{name: "Death"; color: "#A0AEC0"; descritpion: "Bereavement leave is granted to an employee in the event of the death of a close family member;such as a spouse;child or parent. The purpose of bereavement leave is to enable the employee to cope with this difficult situation and make the necessary "+"arrangements without worrying about work for a certain period of time."}; \
		{name: "Unpaid leave"; color: "#EAEBED"; descritpion: "Unpaid leave is a period of leave during which an employee takes an extended break from work without receiving pay. These leaves are generally taken for personal or family reasons that are not covered by regular paid leave or other types of paid leave"+". They often need to be approved by the employer;and may have implications for the employee's benefits and employment status during the period of absence."}]
	
	For each ($item; $types)
		$LeaveType:=ds:C1482.LeaveTypes.new()
		$LeaveType.name:=item.name
		$LeaveType.description:=item.descritpion
		$LeaveType.color:=item.color
		$LeaveType.save()
	End for each 
	
Function generateHolidays()
	var $holidays : Collection
	var $item : Object
	var $holiday : cs:C1710.HolidaysEntity
	$holidays=[\
		{name: "New year"; startDate: "01/01/2024"}; \
		{name: "Labor day"; startDate: "05/01/2024"}; \
		{name: "Feast of the Throne"; startDate: "07/30/2024"}; \
		{name: "Youth day"; startDate: "08/21/2024"}; \
		{name: "Anniversary of the green march"; startDate: "11/06/2024"}; \
		{name: "Independance day"; startDate: "11/18/2024"}; \
		{name: "Victory day celebration"; startDate: "11/27/2024"}; \
		{name: "Feast of the sacrifice (Eid-al-Adha)"; startDate: "12/30/2024"; endDate: "12/31/2024"}; \
		{name: "Annunciation feast"; startDate: "03/25/2024"}; \
		{name: "Anniversary of the revolution of the king and the people"; startDate: "08/20/2024"}]
	
	For each ($item; holidays)
		$holiday:=ds:C1482.Holidays.new()
		$holiday.name:=$item.name
		$holiday.startDate:=Date:C102($item.startDate)
		$holiday.endDate:=($item.endDate#Null:C1517) ? Date:C102($item.endDate) : Date:C102($item.startDate)
		$holiday.save()
	End for each 
	
Function generateTeams()
	var $teams : Collection
	var $item : Text
	var $team : cs:C1710.TeamsEntity
	$teams=["4D Product-QA"; "4D Product Customer Support"; "SI 4D"; "PS 4D"; "Administration service"; "4D Product RD - Web Studio"; "Cloud"]
	var $managers : cs:C1710.EmployeesSelection:=ds:C1482.Employees.query("role == 'Manager'")
	$managers:=managers.length#0 ? $managers : ds:C1482.Employees.query("role = 'Admin")
	For each ($item; $teams)
		$team:=ds:C1482.Teams.new()
		$team.name:=item
		$team.manager:=$managers.at(Random:C100%$managers.length)
		$team.save()
	End for each 
	
Function generateLeaveBalances()
	var $users : cs:C1710.EmployeesSelection:=ds:C1482.Employees.all()
	var $user : cs:C1710.EmployeesEntity
	var $LeaveTypes : cs:C1710.LeaveTypesSelection:=ds:C1482.LeaveTypes.all()
	var $LeaveType
	var $leaveBalance : cs:C1710.LeaveBalancesEntity
	
	For each ($user; $users)
		For each ($LeaveType; $LeaveTypes)
			$leaveBalance:=ds:C1482.LeaveBalances.new()
			$leaveBalance.employee:=$user
			$leaveBalance.leaveType:=$LeaveType
			$leaveBalance.balance:=(Random:C100%(16-4+1))+4
			$leaveBalance.save()
		End for each 
	End for each 
	
Function generateLeaves()
	var $users : cs:C1710.EmployeesSelection:=ds:C1482.Employees.all()
	var $user : cs:C1710.EmployeesEntity
	var $LeaveTypes : cs:C1710.LeaveTypesSelection:=ds:C1482.LeaveTypes.all()
	var $leave : cs:C1710.LeavesEntity
	
	For each ($user; $users)
		$leave:=ds:C1482.Leaves.new()
		$leave.employee:=$user
		$leave.requestDate:=Current date:C33()
		$leave.startDate:=Current date:C33()+10
		$leave.endDate:=Current date:C33()+13
		$leave.isAbsence:=False:C215
		$leave.status:="to be approved"
		$leave.leaveType:=$LeaveTypes.at(Random:C100%$LeaveTypes.length)
		$leave.rangeLength:=$leave.endDate-leave.startDate
		$leave.save()
	End for each 
	
	
Function linkToTeam()
	var $employees : cs:C1710.EmployeesSelection:=ds:C1482.Employees.all()
	var $teams : cs:C1710.TeamsSelection:=ds:C1482.Teams.all()
	var $employee : cs:C1710.EmployeesEntity
	For each ($employee; $employees)
		$employee.team:=$teams.at(Random:C100%($teams.length))
		$employee.save()
	End for each 