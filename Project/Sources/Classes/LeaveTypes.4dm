Class extends DataClass

exposed Function searchByName($search : Text) : cs:C1710.LeaveTypesSelection
	If ($search#"")
		return This:C1470.query("name = :1"; "@"+$search+"@")
	Else 
		return This:C1470.all()
	End if 
	
	
	