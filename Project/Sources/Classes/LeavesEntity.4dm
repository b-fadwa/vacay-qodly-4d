Class extends Entity



exposed Function getRangeDate()->rangeDate : Collection
	rangeDate=[]
	rangeDate.push(This:C1470.startDate, this.endDate)
	
exposed Function changeStatus(employee : cs:C1710.EmployeesEntity, status : string)
	var info : Object
	var currentUser : cs:C1710.EmployeesEntity=ds:C1482.Employees.getCurrentUser()
	var action, receiver : string
	var leaveBalance : cs:C1710.LeaveBalancesEntity=This:C1470.leaveType.leaveBalances.query("employee.ID = :1", employee.ID).first()
	If ((leaveBalance.balance>=This:C1470.rangeLength) && (status=="approved"))
		This:C1470.status=status
		action=currentUser.fullName+" approved the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
			+String:C10(This:C1470.requestDate, kInternalDateLong)+"</li><li>Start Date : "+String:C10(This:C1470.startDate, kInternalDateLong)+\
			"</li><li>End Date : "+String:C10(This:C1470.endDate, kInternalDateLong)+"</li><li>Status : <span style=\"color:#119A8D;\">"+This:C1470.status+"</span></li></ul>"
		ds:C1482.LeaveBalances.decrementBalance(This:C1470)
	Else 
		webForm.setError("Your balance is lower then the request's range")
		This:C1470.status="rejected"
		action=currentUser.fullName+" rejected the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
			+String:C10(This:C1470.requestDate, kInternalDateLong)+"</li><li>Start Date : "+String:C10(This:C1470.startDate, kInternalDateLong)+\
			"</li><li>End Date : "+String:C10(This:C1470.endDate, kInternalDateLong)+"</li><li>Status : <span style=\"color:#F44C4C;\">"+This:C1470.status+"</span></li></ul>"
		If (status=="rejected")
			This:C1470.status=status
			end
			end
			info=This:C1470.save()
			If (info.success)
				webForm.setMessage("This leave has been successfully updated!")
				ds:C1482.LeaveActions.add(employee, this, currentDate(), status)
				receiver=String:C10(This:C1470.employee.email)+","+String:C10(This:C1470.employee.team.manager.email)
				callWorker("workerTest", formula(cs:C1710.Mailing.me.sendMails("Status Update", action, receiver)))  //setup mailing class
				end
				
				
exposed Function editLeave() : cs:C1710.LeavesEntity
	var status : Object
	var receiver : string=String:C10(This:C1470.employee.email)+","+String:C10(This:C1470.employee.team.manager.email)
	var currentUser : cs:C1710.EmployeesEntity=ds:C1482.Employees.getCurrentUser()
	var action : string=currentUser.fullName+" edited the leave <b>"+This:C1470.leaveType.name+"-"+This:C1470.employee.fullName+"</b> : <br><ul><li>Request Date : "\
		+String:C10(This:C1470.requestDate, kInternalDateLong)+"</li><li>Start Date : "+String:C10(This:C1470.startDate, kInternalDateLong)+\
		"</li><li>End Date : "+String:C10(This:C1470.endDate, kInternalDateLong)+"</li><li>Status : <span style=\"color:#ECB22E;\">"+This:C1470.status+"</span></li></ul>"
	var leaveBalance : cs:C1710.LeaveBalancesEntity=ds:C1482.LeaveBalances.all().query("employee.ID = :1 and leaveType.ID = :2", this.employee.ID, this.leaveType.ID).first()
	If ((This:C1470.endDate-This:C1470.startDate)>leaveBalance.balance)
		webForm.setError("You selected more then your balance!")
	Else 
		status=This:C1470.save()
		If (status.success)
			webForm.setMessage("This leave has been updated!")
			callWorker("workerTest", formula(cs:C1710.Mailing.me.sendMails("Leave Update", action, receiver)))  //setup mailing class
		Else 
			webForm.setError("Error while updating")
			end
			end
			return This:C1470
			