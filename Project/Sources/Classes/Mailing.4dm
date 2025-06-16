shared singleton constructor()

/** In order to use the mailing class, you'll have to create an account with your email in the sendgrid email api , store your credentials in an env file somewhere in your project structure*\
*/

var server : Object
var transporter : Object
var credentials=ds:C1482.getCredentials()
server=newObject()
server.host=credentials.host
server.port=credentials.port
server.user=credentials.user
server.password=credentials.password
This:C1470.server=objectCopy(server, kShared, this)


Function sendMails(subject : string, body : string, receiver : string)
	var transporter : 4D:C1709.SMTPTransporter=4D:C1709.SMTPTransporter.new(This:C1470.server)
	var email : Object={}
	var status : Object
	var info : string
	email.from=""  //add the mail by which the api was created
	email.to=receiver
	email.subject=subject
	email.htmlBody="<h2>"+String:C10(subject)+"</h2><hr><p>"+String:C10(body)+"</p>"
	status=transporter.send(email)
	If (Not:C34(status.success))
		info="An error occurred: "+String:C10(status.message)
		webForm.setWarning(info)
		end