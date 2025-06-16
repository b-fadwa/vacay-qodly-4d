Class extends EntitySelection

exposed Function leavesCollections()->$leavesCollection : Collection
	var $leave : cs:C1710.LeavesEntity
	var $item : Object
	$leavesCollection:=New collection:C1472()
	For each ($leave; This:C1470)
		$item:={startDate: ""; endDate: ""; employee: ""; status: ""; title: ""; color: ""}
		$item.startDate:=$leave.startDate
		$item.endDate:=$leave.endDate
		$item.status:=$leave.status
		$item.employee:=$leave.employee.fullName
		$item.title:=$leave.leaveType.name
		$item.color:=$leave.leaveType.color
		$leavesCollection.push(item)
	End for each 
	
	
	