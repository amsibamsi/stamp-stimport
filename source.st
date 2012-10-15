SystemOrganization addCategory: #Stamp!

Object subclass: #Stamp
	instanceVariableNames: 'popServer popUser popPassword subscribers smtpServer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp'!

!Stamp commentStamp: '<historical>' prior: 0!
A mailing list manager for Squeak.
Check for new mails on a POP3 account and forward them to subscribers.!

!Stamp class methodsFor: 'instance creation' stamp: 'as 4/26/2005 14:38'!
new

	self error: 'Instance creation needs parameters.'.! !

!Stamp class methodsFor: 'instance creation' stamp: 'as 4/26/2005 14:38'!
withPopServer: popServerString popUser: popUserString popPassword: popPasswordString subscribers: aCollection smtpServer: smtpServerString

	self basicNew
		popServer: popServerString;
		popUser: popUserString;
		popPassword: popPasswordString;
		subscribers: aCollection;
		smtpServer: smtpServerString.! !

!Stamp methodsFor: 'mailing' stamp: 'as 4/26/2005 15:56'!
filterMessage: aString

	self halt.
	^ true.! !

!Stamp methodsFor: 'mailing' stamp: 'as 4/26/2005 16:10'!
forwardMessage: aString

	| smtpClient |
	smtpClient := SMTPClient openOnHostNamed: smtpServer.
	smtpClient login.
	smtpClient mailFrom: '' to: subscribers text: aString.
	smtpClient quit; close.! !

!Stamp methodsFor: 'mailing' stamp: 'as 4/26/2005 15:43'!
getMessages

	| popClient messages |
	popClient := POP3Client openOnHostNamed: popServer.
	messages := Set new.
	popClient loginUser: popUser password: popPassword.
	popClient messageCount do: [
		: messageIndex |
		messages add: (popClient retrieveMessage: messageIndex).
	].
	popClient quit; close.
	^ messages.! !

!Stamp methodsFor: 'accessing' stamp: 'as 4/26/2005 14:39'!
popPassword: aString

	popPassword = aString.! !

!Stamp methodsFor: 'accessing' stamp: 'as 4/26/2005 14:39'!
popServer: aString

	popServer = aString.! !

!Stamp methodsFor: 'accessing' stamp: 'as 4/26/2005 14:40'!
popUser: aString

	popUser = aString.! !

!Stamp methodsFor: 'public' stamp: 'as 4/26/2005 15:55'!
run

	"Get messages from pop account, filter and forward them to subscribers."

	| messages |
	messages := self getMessages.
	messages select: [
		: message |
		self filterMessage: message.
	] thenDo: [
		: message |
		self forwardMessage: message.
	].
! !

!Stamp methodsFor: 'accessing' stamp: 'as 4/26/2005 14:40'!
smtpServer: aString

	smtpServer := aString.! !

!Stamp methodsFor: 'accessing' stamp: 'as 4/26/2005 14:27'!
subscribers: aCollection

	subscribers = aCollection.! !
