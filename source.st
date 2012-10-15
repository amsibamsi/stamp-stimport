SystemOrganization addCategory: #'Stamp-Configuration'!
SystemOrganization addCategory: #'Stamp-Mail-Client'!
SystemOrganization addCategory: #'Stamp-Mail-Server'!
SystemOrganization addCategory: #'Stamp-Model'!
SystemOrganization addCategory: #'Stamp-Tests'!

Object subclass: #SPKernel
	instanceVariableNames: 'listener queue listManager userManager'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPKernel commentStamp: '<historical>' prior: 0!
The core of a running Stamp application instance.!

!SPKernel methodsFor: 'initialize-release' stamp: 'as 3/14/2006 14:35'!
initialize

	listener := SPMailListener withKernel: self onPort: 2525.
	queue := SPMailQueue withKernel: self.
	listManager := SPListManager withKernel: self.
	userManager := SPUserManager withKernel: self.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:19'!
listener

	^ listener.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:22'!
listManager

	^ listManager.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:22'!
queue

	^ queue.! !

!SPKernel methodsFor: 'actions' stamp: 'as 3/14/2006 14:10'!
start

	listener start.! !

!SPKernel methodsFor: 'actions' stamp: 'as 3/14/2006 14:11'!
stop

	listener stop.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:23'!
userManager

	^ userManager.! !

Object subclass: #SPList
	instanceVariableNames: 'name users'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPList commentStamp: '<historical>' prior: 0!
A Stamp mailing list.!

!SPList class methodsFor: 'instance creation' stamp: 'as 3/20/2006 16:12'!
withName: aString

	^ self new
		name: aString;
		yourself.! !

!SPList methodsFor: 'private' stamp: 'as 3/21/2006 15:18'!
addNewUser: aSPUser

	users add: aSPUser.! !

!SPList methodsFor: 'operations' stamp: 'as 3/21/2006 14:54'!
addUser: aSPUser

	self shouldNotIncludeUser: aSPUser.
	self addNewUser: aSPUser.
	aSPUser addNewList: self.! !

!SPList methodsFor: 'accessing' stamp: 'as 3/21/2006 15:03'!
allUsers

	^ users.! !

!SPList methodsFor: 'comparing' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 3/10/2006 15:46'!
initialize

	users := Set new.! !

!SPList methodsFor: 'accessing' stamp: 'as 3/9/2006 16:53'!
name

	^ name.! !

!SPList methodsFor: 'accessing' stamp: 'as 3/20/2006 16:13'!
name: aString

	name := aString.! !

!SPList methodsFor: 'private' stamp: 'as 3/21/2006 15:18'!
removeExistingUser: aSPUser

	users remove: aSPUser.! !

!SPList methodsFor: 'operations' stamp: 'as 3/21/2006 14:57'!
removeUser: aSPUser

	self shouldIncludeUser: aSPUser.
	self removeExistingUser: aSPUser.
	aSPUser removeExistingList: self.! !

!SPList methodsFor: 'private' stamp: 'as 3/21/2006 14:56'!
shouldIncludeUser: aSPUser

	(users includes: aSPUser) ifFalse: [ SPUserNotIncludedException signal. ].
	self assert: (users includes: aSPUser).! !

!SPList methodsFor: 'private' stamp: 'as 3/21/2006 14:56'!
shouldNotIncludeUser: aSPUser

	(users includes: aSPUser) ifTrue: [ SPUserAlreadyIncludedException signal. ].
	self assert: (users includes: aSPUser) not.! !

!SPList methodsFor: 'comparing' stamp: 'as 3/9/2006 16:48'!
= aSPList

	^ name = aSPList name.! !

Object subclass: #SPListManager
	instanceVariableNames: 'kernel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPListManager commentStamp: '<historical>' prior: 0!
List manager for Stamp.!

!SPListManager class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:42'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPListManager methodsFor: 'accessing' stamp: 'as 3/14/2006 14:42'!
kernel: aSPKernel

	kernel := aSPKernel.! !

Object subclass: #SPMailQueue
	instanceVariableNames: 'kernel buffer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Handles incoming mail, e.g. storing/forwarding/...!

!SPMailQueue class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:41'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPMailQueue methodsFor: 'private' stamp: 'as 3/16/2006 16:00'!
handle: aMailMessage

	"fix me"
	(MailDB openOn: 'testing') addNewMessage: aMailMessage.
	SPMailSender deliverMessage: aMailMessage usingServer: 'ubecx.unibe.ch'.
	! !

!SPMailQueue methodsFor: 'accessing' stamp: 'as 3/14/2006 14:41'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPMailQueue methodsFor: 'actions' stamp: 'as 3/16/2006 15:42'!
queue: aMailMessage

	[ self handle: aMailMessage ] newProcess resume.! !

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message sender recipient dataMode quit kernel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server following RFC 2821 that only receives mail. One receiver serves one client connection, and the whole will usually be multithreaded.

A SPMailReceiver is created on a socket. Mail reception starts with the receive method. After its return received data is available in message, sender and receiver.

The receiver is normally in command mode, where it looks for client SMTP commands. It can switch to data mode, as stored in dataMode, to receive mail data and then switch back.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 3/16/2006 15:23'!
on: aSocketStream withKernel: aSPKernel

	^ self new
		stream: aSocketStream;
		kernel: aSPKernel;
		yourself.! !

!SPMailReceiver methodsFor: 'settings' stamp: 'as 2/6/2006 15:19'!
dataDelimiter

	"The delimiter string that will end mail data input."

	^ String crlf, '.', String crlf.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/14/2006 22:03'!
enterCommandMode

	dataMode := false.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/14/2006 22:02'!
enterDataMode

	dataMode := true.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/31/2006 14:57'!
gotoState: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/31/2006 16:18'!
initialize

	self reset.
	self gotoState: (SPReadySmtpState on: self).
	quit := false.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 3/16/2006 15:24'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/14/2006 22:14'!
mailFrom: aString

	sender := aString.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/14/2006 22:14'!
mailTo: aString

	recipient := aString.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 3/16/2006 15:25'!
queueMail

	kernel queue queue: message.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 3/10/2006 16:23'!
receive

	"Receive from client in command or data mode as long as connection is there and
	 quit is not requested."

	self reply: SPSmtpReply ready.
	[ quit not and: [ stream isConnected ] ] whileTrue: [
		dataMode ifFalse: [
			self receiveCommand.
		] ifTrue: [
			self receiveData.
			self queueMail.
			self reset.
		].
	].
	stream close.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/18/2006 16:27'!
receiveCommand

	"Find the apropriate command for a string line from the client and execute it."

	| line command |
	line := stream nextLineCrLf.
	[ command := SPSmtpCommand fromString: line target: self.
	 state execute: command. ]
		on: SPSmtpCommandException
		do: [ :ex | ex defaultAction. ex return. ].! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 3/10/2006 16:08'!
receiveData

	"Receive mail data as specified by the DATA SMTP command."

	message from: (stream upToAll: self dataDelimiter) convertToSqueakText.
	self reply: SPSmtpReply okay.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/31/2006 15:01'!
reply: aSPSmtpReply

	"Reply a message to the client."

	stream nextPutAll: aSPSmtpReply; crlf; flush.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/18/2006 17:10'!
requestQuit

	quit := true.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/18/2006 17:18'!
reset

	message := MailMessage new.
	sender := nil.
	recipient := nil.
	self enterCommandMode.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

Object subclass: #SPSmtpCommand
	instanceVariableNames: 'argument target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.

I'm abstract, don't instantiate me. The method fromString:target: will return an instance of the appropriate subclass.!

SPSmtpCommand subclass: #SPDataSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPDataSmtpCommand commentStamp: '<historical>' prior: 0!
The client wants to submit the mail message in data mode.!

!SPDataSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 21:40'!
verb

	^ 'data'.! !

!SPDataSmtpCommand methodsFor: 'executing' stamp: 'as 1/14/2006 22:17'!
doExecute

	target enterDataMode.! !

!SPDataSmtpCommand methodsFor: 'executing' stamp: 'as 1/14/2006 22:18'!
reply

	^ SPSmtpReply mailInput.! !

SPSmtpCommand subclass: #SPEhloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPEhloSmtpCommand commentStamp: 'as 3/6/2006 11:19' prior: 0!
The EHLO command unimplemented since no service extension are needed/implemented.!

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:00'!
verb

	^ 'ehlo'.! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:07'!
doExecute

	"nothing to do"! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 3/6/2006 11:19'!
reply

	^ SPSmtpReply notImplemented.! !

SPSmtpCommand subclass: #SPHeloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPHeloSmtpCommand commentStamp: '<historical>' prior: 0!
HELO command is used by the client to initiate a new session with the server.!

!SPHeloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/10/2006 21:46'!
verb

	^ 'helo'.! !

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:12'!
doExecute

	"nothing to do"! !

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:12'!
reply

	^ SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPMailSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailSmtpCommand commentStamp: '<historical>' prior: 0!
The MAIL command specifies the sender address.!

!SPMailSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:08'!
verb

	^ 'mail from:'.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:15'!
doExecute

	target mailFrom: argument.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:18'!
reply

	^ SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPNoopSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPNoopSmtpCommand commentStamp: '<historical>' prior: 0!
NOOP means no operation. This command is ignored and has no effect on the server.!

!SPNoopSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/12/2006 22:18'!
verb

	^ 'noop'.! !

!SPNoopSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:19'!
doExecute

	"nothing to do"! !

!SPNoopSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:20'!
reply

	^ SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPQuitSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPQuitSmtpCommand commentStamp: '<historical>' prior: 0!
The client wants to quit the session.!

!SPQuitSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:31'!
verb

	^ 'quit'.! !

!SPQuitSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 17:09'!
doExecute

	target requestQuit.! !

!SPQuitSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 17:09'!
reply

	^ SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPRecipientSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPRecipientSmtpCommand commentStamp: '<historical>' prior: 0!
Spcifies a recipient address.!

!SPRecipientSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:32'!
verb

	^ 'rcpt to:'.! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 16:39'!
doExecute

	target mailTo: argument.! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 16:39'!
reply

	^ SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPResetSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPResetSmtpCommand commentStamp: '<historical>' prior: 0!
Resets the server to start from beginning.!

!SPResetSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:32'!
verb

	^ 'rset'.! !

!SPResetSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 17:59'!
doExecute

	target reset.! !

!SPResetSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 17:27'!
reply

	^ SPSmtpReply okay.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/12/2006 17:18'!
argumentFor: aString command: aSmtpCommand

	"Find arguments in a line assuming the given verb for the command."

	^ aString copyFrom: (aSmtpCommand verb size + 1) to: aString size.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/31/2006 16:37'!
commandFor: aString target: aSPMailReceiver

	"Extract command and return an instance of the appropriate command class.
	 The verb string for a SMTP command is case insensitive."

	| class |
	class := self allSubclasses detect: [
		:each |
		aString asLowercase beginsWith: each verb asLowercase
	] ifNone: [
		nil	
	].
	class isNil ifTrue: [ (SPSmtpCommandNotFound on: aSPMailReceiver) signal. ].
	^ class new.! !

!SPSmtpCommand class methodsFor: 'instance creation' stamp: 'as 1/18/2006 15:55'!
fromString: aString target: aSPMailReceiver

	"Return a new command created from a given string."

	| command argument |
	command := self commandFor: aString target: aSPMailReceiver.
	argument := self argumentFor: aString command: command.
	command
		argument: argument;
		target: aSPMailReceiver.
	^ command.! !

!SPSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 15:38'!
verb

	"The string representation for this command in SMTP (case insensitive)."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/10/2006 21:49'!
argument: aString

	argument := aString.! !

!SPSmtpCommand methodsFor: 'private' stamp: 'as 1/31/2006 16:28'!
doExecute

	"Command-specific execution code."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 17:37'!
execute

	self doExecute.
	target reply: self reply.
	! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 15:18'!
reply

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/12/2006 17:37'!
target: aSPMailReceiver

	target := aSPMailReceiver.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 2/15/2006 18:16'!
verb

	^ self class verb.! !

SPSmtpCommand subclass: #SPVerifySmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPVerifySmtpCommand commentStamp: '<historical>' prior: 0!
VRFY allows clients to verify addresses. This is disabled for security reasons.!

!SPVerifySmtpCommand class methodsFor: 'smtp' stamp: 'as 1/12/2006 12:21'!
verb

	^ 'vrfy'.! !

!SPVerifySmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:13'!
doExecute

	"nothing to do"! !

!SPVerifySmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:14'!
reply

	^ SPSmtpReply cannotVerify.! !

Object subclass: #SPSmtpState
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpState commentStamp: '<historical>' prior: 0!
The state a SPMailReceiver is in when serving a client.!

SPSmtpState subclass: #SPMailSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailSmtpState commentStamp: '<historical>' prior: 0!
The server has received the mail command.!

!SPMailSmtpState methodsFor: 'transitions' stamp: 'as 2/15/2006 20:08'!
transitions

	^ self defaultTransitions
		at: SPRecipientSmtpCommand put: SPRecipientSmtpState;
		yourself.! !

SPSmtpState subclass: #SPReadySmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPReadySmtpState commentStamp: '<historical>' prior: 0!
The server waits for the client helo.!

!SPReadySmtpState methodsFor: 'transitions' stamp: 'as 3/7/2006 12:17'!
transitions

	^ self anytimeTransitions
		at: SPResetSmtpCommand put: self class;
		at: SPHeloSmtpCommand put: SPResetSmtpState;
		yourself.! !

SPSmtpState subclass: #SPRecipientSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPRecipientSmtpState commentStamp: '<historical>' prior: 0!
The client has received at least one recipient address.!

!SPRecipientSmtpState methodsFor: 'transitions' stamp: 'as 2/15/2006 20:06'!
transitions

	^ self defaultTransitions
		at: SPRecipientSmtpCommand put: self class;
		at: SPDataSmtpCommand put: SPResetSmtpState;
		yourself.! !

SPSmtpState subclass: #SPResetSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPResetSmtpState commentStamp: '<historical>' prior: 0!
The server is reset and can receive a new mail.!

!SPResetSmtpState methodsFor: 'transitions' stamp: 'as 1/31/2006 17:10'!
transitions

	^ self defaultTransitions
		at: SPMailSmtpCommand put: SPMailSmtpState;
		yourself.! !

!SPSmtpState class methodsFor: 'instance creation' stamp: 'as 1/16/2006 20:30'!
on: aSPMailReceiver

	^ self new
		owner: aSPMailReceiver;
		yourself.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/31/2006 17:01'!
allowedCommands

	"SMTP commands that are allowed in this state."

	^ self transitions keys.! !

!SPSmtpState methodsFor: 'transitions' stamp: 'as 2/15/2006 18:44'!
anytimeTransitions

	"Transitions that are always possible."

	^ Dictionary new
		at: SPVerifySmtpCommand put: self class;
		at: SPNoopSmtpCommand put: self class;
		at: SPQuitSmtpCommand put: self class;
		yourself.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/12/2006 16:23'!
commandAllowed: aSPSmtpCommand

	^ self allowedCommands includes: aSPSmtpCommand class.! !

!SPSmtpState methodsFor: 'transitions' stamp: 'as 1/31/2006 17:02'!
defaultTransitions

	"Default set of transitions, often used by other states."

	^ self anytimeTransitions
		at: SPResetSmtpCommand put: SPResetSmtpState;
		yourself.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/18/2006 15:39'!
execute: aSPSmtpCommand

	(self commandAllowed: aSPSmtpCommand) ifTrue: [
		aSPSmtpCommand execute.
		owner gotoState: (self nextStateFor: aSPSmtpCommand).
	] ifFalse: [
		(SPSmtpCommandNotAllowed on: owner) signal.
	].! !

!SPSmtpState methodsFor: 'state' stamp: 'as 1/31/2006 17:05'!
nextStateClassFor: aSPSmtpCommand

	^ self transitions at: aSPSmtpCommand class.! !

!SPSmtpState methodsFor: 'state' stamp: 'as 2/15/2006 18:21'!
nextStateFor: aSPSmtpCommand

	"The state follwing a transition/(SMTP command)."

	^ (self nextStateClassFor: aSPSmtpCommand) on: owner.! !

!SPSmtpState methodsFor: 'accessing' stamp: 'as 1/12/2006 15:57'!
owner: aSPMailReceiver

	owner := aSPMailReceiver.! !

!SPSmtpState methodsFor: 'transitions' stamp: 'as 2/6/2006 15:43'!
transitions

	"This must return a dictionary with mappings: SPSmtpCommand -> SPSmtpState.
	 The meaning is: SPSmtpCommand is an allowed command in this state and has
	 next state SPSmtpState."

	self subclassResponsibility.! !

Object subclass: #SPUser
	instanceVariableNames: 'name address lists'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPUser commentStamp: '<historical>' prior: 0!
A Stamp user.!

!SPUser class methodsFor: 'instance creation' stamp: 'as 3/20/2006 16:13'!
withName: nameString address: addressString

	^ self new
		name: nameString;
		address: addressString;
		yourself.! !

!SPUser methodsFor: 'operations' stamp: 'as 3/21/2006 14:51'!
addList: aSPList

	self shouldNotIncludeList: aSPList.
	self addNewList: aSPList.
	aSPList addNewUser: self.! !

!SPUser methodsFor: 'private' stamp: 'as 3/21/2006 14:43'!
addNewList: aSPList

	lists add: aSPList.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:54'!
address

	^ address.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:14'!
address: aString

	address := aString.! !

!SPUser methodsFor: 'comparing' stamp: 'as 3/9/2006 16:52'!
hash

	^ name hash.! !

!SPUser methodsFor: 'initialize-release' stamp: 'as 3/10/2006 15:41'!
initialize

	lists := Set new.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/20/2006 15:47'!
lists

	^ lists.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:54'!
name

	^ name.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:48'!
name: aString

	name := aString.! !

!SPUser methodsFor: 'private' stamp: 'as 3/21/2006 14:43'!
removeExistingList: aSPList

	lists remove: aSPList.! !

!SPUser methodsFor: 'operations' stamp: 'as 3/21/2006 14:51'!
removeList: aSPList

	self shouldIncludeList: aSPList.
	self removeExistingList: aSPList.
	aSPList removeExistingUser: self.! !

!SPUser methodsFor: 'private' stamp: 'as 3/21/2006 14:53'!
shouldIncludeList: aSPList

	(lists includes: aSPList) ifFalse: [ SPListNotIncludedException signal. ].
	self assert: (lists includes: aSPList).! !

!SPUser methodsFor: 'private' stamp: 'as 3/21/2006 14:53'!
shouldNotIncludeList: aSPList

	(lists includes: aSPList) ifTrue: [ SPListAlreadyIncludedException signal. ].
	self assert: (lists includes: aSPList) not.! !

!SPUser methodsFor: 'comparing' stamp: 'as 3/9/2006 16:51'!
= aSPUser

	^ name = aSPUser name.! !

Object subclass: #SPUserManager
	instanceVariableNames: 'kernel users'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPUserManager commentStamp: '<historical>' prior: 0!
User manager for Stamp.!

!SPUserManager class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:43'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPUserManager methodsFor: 'operations' stamp: 'as 3/21/2006 14:38'!
addUser: nameString address: addressString

	self userShouldNotExist: nameString.
	users add: (SPUser withName: nameString address: addressString).! !

!SPUserManager methodsFor: 'initialize-release' stamp: 'as 3/17/2006 11:08'!
initialize

	users := Set new.! !

!SPUserManager methodsFor: 'accessing' stamp: 'as 3/14/2006 14:43'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPUserManager methodsFor: 'operations' stamp: 'as 3/21/2006 14:38'!
removeUser: nameString

	users remove: (self userShouldExist: nameString).! !

!SPUserManager methodsFor: 'private' stamp: 'as 3/21/2006 14:27'!
userShouldExist: nameString

	| selectedUsers |
	selectedUsers := users select: [ :user | user name = nameString ].
	self assert: (selectedUsers size <= 1).
	selectedUsers isEmpty ifTrue: [ SPUserNotFoundException signal. ].
	self assert: (selectedUsers notEmpty).
	^ selectedUsers first.! !

!SPUserManager methodsFor: 'private' stamp: 'as 3/21/2006 14:23'!
userShouldNotExist: nameString

	| userExists |
	userExists := self userExists: nameString.
	userExists ifTrue: [ SPUserAlreadyExistsException signal ].
	self assert: userExists not.! !

!SPUserManager methodsFor: 'operations' stamp: 'as 3/21/2006 14:37'!
user: nameString

	^ self userShouldExist: nameString.! !

TcpService subclass: #SPMailListener
	instanceVariableNames: 'kernel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailListener commentStamp: '<historical>' prior: 0!
A TCP service accepting SMTP connections.!

!SPMailListener class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:35'!
withKernel: aSPKernel onPort: aNumber

	^ (self on: aNumber) kernel: aSPKernel.! !

!SPMailListener methodsFor: 'accessing' stamp: 'as 3/14/2006 14:36'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPMailListener methodsFor: 'conversation' stamp: 'as 3/16/2006 15:23'!
serve: aSocket

	| server |
	server := SPMailReceiver on: (SocketStream on: aSocket) withKernel: kernel.
	server receive.! !

WASystemConfiguration subclass: #SPSystemConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

String subclass: #SPSmtpReply
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpReply commentStamp: '<historical>' prior: 0!
SMTP replies are sent from the server to the client and are just strings.!

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:05'!
badSequence

	^ '503 Bad sequence of commands'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:15'!
cannotVerify

	^ '252 Verification is disabled'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:16'!
commandUnrecognized

	^ '500 Syntax error or command unrecognized'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:21'!
mailInput

	^ '354 Start mail input; end with <CRLF>.<CRLF>'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:22'!
notImplemented

	^ '502 Command not implemented'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 2/6/2006 15:23'!
okay

	^ '250 Okay'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/17/2006 16:09'!
ready

	^ '220 ', NetNameResolver localHostName.! !

!String methodsFor: '*Stamp' stamp: 'as 3/7/2006 12:09'!
convertToSmtpText

	"SMTP likes CRLF as end of line characters, so CR and LF are converted to CRLF."

	| convertedString cr lf |
	cr := String cr.
	lf := String lf.
	convertedString := self copyReplaceAll: lf with: cr.
	convertedString := convertedString copyReplaceAll: cr with: cr, lf.
	^ convertedString.! !

!String methodsFor: '*Stamp' stamp: 'as 3/7/2006 11:43'!
convertToSqueakText

	"Squeak likes CR as end of line character, so CRLF and LF are converted to CR."

	| convertedString cr lf |
	cr := String cr.
	lf := String lf.
	convertedString := self copyReplaceAll: cr, lf with: cr.
	convertedString := convertedString copyReplaceAll: lf with: cr.
	^ convertedString.! !

SMTPClient subclass: #SPMailSender
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPMailSender commentStamp: '<historical>' prior: 0!
Some changes to SMTPClient.!

!SPMailSender class methodsFor: 'sending mail' stamp: 'as 3/16/2006 15:58'!
deliverMessage: aMailMessage usingServer: aString

	self
		deliverMailFrom: aMailMessage from
		to: aMailMessage recipients
		text: aMailMessage text
		usingServer: aString.! !

!SPMailSender class methodsFor: 'instance creation' stamp: 'as 2/22/2006 15:08'!
openOnHost: hostIP port: portNumber

	^ self new openOnHost: hostIP port: portNumber! !

!SPMailSender methodsFor: 'private protocol' stamp: 'as 2/22/2006 14:43'!
login

	"anonymous"
	self initiateSession.! !

!SPMailSender methodsFor: 'actions' stamp: 'as 2/22/2006 15:48'!
reopen

	self close.
	self ensureConnection.! !

!SPMailSender methodsFor: 'private protocol' stamp: 'as 2/22/2006 15:15'!
reset

	self sendCommand: 'RSET'.
	self checkResponse.! !

TestCase subclass: #SPCodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPCodeTest commentStamp: '<historical>' prior: 0!
Test different coding style aspects of the implementation.!

!SPCodeTest methodsFor: 'configuration' stamp: 'as 1/11/2006 17:03'!
packageName

	^ 'Stamp'.! !

!SPCodeTest methodsFor: 'testing' stamp: 'as 1/11/2006 17:03'!
testClassComment

	"Each class should have a comment."

	(PackageInfo named: self packageName) classes do: [
		:each |
		self assert: each hasComment.
	].! !

TestCase subclass: #SPMailReceivingSendingTest
	instanceVariableNames: 'server client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPMailReceivingSendingTest commentStamp: '<historical>' prior: 0!
Test the mail receiving/sending subsystem.!

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 2/21/2006 10:15'!
findPortFor: aSPMailListener

	1024 to: 65536 do: [
		:port |
		[ aSPMailListener verifyPortAvailability: port. ^ port. ]
			on: Error
			do: [ :ex | ex return.]
	].! !

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 2/22/2006 16:01'!
setUp

	| port tries maxTries delay |
	server := SPMailListener new.
	port := self findPortFor: server.
	server startOn: port.

	tries := 0.
	maxTries := 10.
	delay := Delay forMilliseconds: 300.
	[
		[ client := SPMailSender openOnHostNamed: 'localhost' port: port. ]
			on: ConnectionTimedOut
			do: [ :ex | tries := tries + 1. ex return. ].
		delay wait.
	] doWhileTrue: [
		client == nil and: [ tries <= maxTries ].
	]! !

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 3/3/2006 16:02'!
tearDown

	client close.
	server unregister.! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:34'!
testBasic

	self shouldnt: [
		client
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			data: 'Subject: test';
			quit.
	] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:43'!
testQuit

	self shouldnt: [
		client
			reopen;
			quit;
			reopen;
			mailFrom: 'user@host.com';
			quit;
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			quit;
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			data: 'Subject: test';
			quit.
		] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:44'!
testRecipient

	self shouldnt: [
		client
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			recipient: 'user3@host.com';
			quit.
	] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:44'!
testReset

	self shouldnt: [
		client
			reopen;
			reset;
			mailFrom: 'user@host.com';
			reset;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			reset;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			data: 'Subject: test';
			reset;
			quit.
		] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:51'!
testSender

	self
		should: [ client reopen; mailFrom: 'me'; mailFrom: 'meAgain'. ]
		raise: TelnetProtocolError.
	self assert: (client responseCode = 503).
	! !

!SPMailReceivingSendingTest methodsFor: 'testing' stamp: 'as 2/22/2006 19:51'!
testUnrecognized

	self
		should: [ client reopen; sendCommand: 'unrecognized'; checkResponse. ]
		raise: TelnetProtocolError.
	self assert: (client responseCode = 500).! !

TestCase subclass: #SPSmtpTextConversionTest
	instanceVariableNames: 'cr lf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPSmtpTextConversionTest commentStamp: '<historical>' prior: 0!
Test text conversion from Squeak to SMTP.!

!SPSmtpTextConversionTest methodsFor: 'running' stamp: 'as 3/7/2006 12:11'!
setUp

	cr := String cr.
	lf := String lf.! !

!SPSmtpTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 12:15'!
testCombined

	self assert: (cr, cr, lf, lf) convertToSmtpText = (cr, lf, cr, lf, cr, lf, cr, lf).! !

!SPSmtpTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 12:12'!
testCr

	self assert: cr convertToSmtpText = (cr, lf).! !

!SPSmtpTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 12:12'!
testLf

	self assert: lf convertToSmtpText = (cr, lf).! !

TestCase subclass: #SPSqueakTextConversionTest
	instanceVariableNames: 'cr lf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPSqueakTextConversionTest commentStamp: '<historical>' prior: 0!
Test text conversion from SMTP to Squeak.!

!SPSqueakTextConversionTest methodsFor: 'running' stamp: 'as 3/7/2006 11:47'!
setUp

	cr := String cr.
	lf := String lf.! !

!SPSqueakTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 11:52'!
testCombined

	self assert: (lf, cr, cr, lf, lf, cr, lf ) convertToSqueakText = (cr, cr, cr, cr, cr).! !

!SPSqueakTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 11:52'!
testCrLf

	self assert: (cr, lf) convertToSqueakText = cr.! !

!SPSqueakTextConversionTest methodsFor: 'testing' stamp: 'as 3/7/2006 11:52'!
testLf

	self assert: lf convertToSqueakText = cr.! !

Exception subclass: #SPModelException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

SPModelException subclass: #SPListAlreadyIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

SPModelException subclass: #SPListNotIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

!SPModelException methodsFor: 'priv handling' stamp: 'as 3/20/2006 15:58'!
isResumable

	^ false.! !

SPModelException subclass: #SPUserAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

SPModelException subclass: #SPUserAlreadyIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

SPModelException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

SPModelException subclass: #SPUserNotIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Model'!

Exception subclass: #SPSmtpCommandException
	instanceVariableNames: 'server'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandException commentStamp: '<historical>' prior: 0!
Indicates that an SMTP command from the client failed on the server.!

!SPSmtpCommandException class methodsFor: 'instance creation' stamp: 'as 1/31/2006 11:22'!
on: aSPMailReceiver

	^ self new
		server: aSPMailReceiver;
		yourself.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:21'!
defaultAction

	server reply: self reply.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/17/2006 17:55'!
isResumable

	^ false.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:05'!
reply

	"Every command failure should be replied to the client."

	self subclassResponsibility.! !

!SPSmtpCommandException methodsFor: 'accessing' stamp: 'as 1/31/2006 11:24'!
server: aSPMailReceiver

	server := aSPMailReceiver.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotAllowed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandNotAllowed commentStamp: '<historical>' prior: 0!
The command is not allowed in the current state of the server.!

!SPSmtpCommandNotAllowed methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandNotFound commentStamp: '<historical>' prior: 0!
The specified command was not found.!

!SPSmtpCommandNotFound methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !
