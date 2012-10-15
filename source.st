SystemOrganization addCategory: #'Stamp-Configuration'!
SystemOrganization addCategory: #'Stamp-Lists'!
SystemOrganization addCategory: #'Stamp-Mail-Message'!
SystemOrganization addCategory: #'Stamp-Mail-Client'!
SystemOrganization addCategory: #'Stamp-Mail-Server'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Commands'!
SystemOrganization addCategory: #'Stamp-Mail-Server-States'!
SystemOrganization addCategory: #'Stamp-Core'!
SystemOrganization addCategory: #'Stamp-Tests'!
SystemOrganization addCategory: #'Stamp-Users'!

Object subclass: #SPKernel
	instanceVariableNames: 'config listener queue listManager userManager'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPKernel commentStamp: '<historical>' prior: 0!
The core of a running Stamp application instance.!

!SPKernel methodsFor: 'accessing' stamp: 'as 5/15/2006 11:25'!
configuration

	^ config.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 5/17/2006 13:09'!
initialize

	listener := SPMailListener withKernel: self onPort: (config valueAt: #port).
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
	category: 'Stamp-Lists'!

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
	instanceVariableNames: 'kernel lists'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Lists'!

!SPListManager commentStamp: '<historical>' prior: 0!
List manager for Stamp.!

!SPListManager class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:42'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPListManager methodsFor: 'operations' stamp: 'as 3/22/2006 15:34'!
addList: nameString

	self listShouldNotExist: nameString.
	lists add: (SPList withName: nameString).! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 3/22/2006 15:25'!
initialize

	lists := Set new.! !

!SPListManager methodsFor: 'accessing' stamp: 'as 3/14/2006 14:42'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPListManager methodsFor: 'private' stamp: 'as 3/22/2006 15:26'!
listNamed: nameString

	^ lists detect: [ :list | list name = nameString. ] ifNone: [ nil. ].! !

!SPListManager methodsFor: 'private' stamp: 'as 3/22/2006 15:28'!
listShouldExist: nameString

	| list |
	list := self listNamed: nameString.
	list isNil ifTrue: [ SPListNotFoundException signal. ].
	self assert: list notNil.
	^ list.! !

!SPListManager methodsFor: 'private' stamp: 'as 3/22/2006 15:31'!
listShouldNotExist: nameString

	| list |
	list := self listNamed: nameString.
	list notNil ifTrue: [ SPListAlreadyExistsException signal ].
	self assert: list isNil.! !

!SPListManager methodsFor: 'operations' stamp: 'as 3/22/2006 15:32'!
list: nameString

	^ self listShouldExist: nameString.! !

!SPListManager methodsFor: 'operations' stamp: 'as 3/22/2006 15:33'!
removeList: nameString

	lists remove: (self listShouldExist: nameString).! !

Object subclass: #SPMailMessage
	instanceVariableNames: 'sender receiver clientId mail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Message'!

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 14:14'!
clientId

	^ clientId.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 14:14'!
clientId: aString

	clientId := aString.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 12:41'!
mail: aMailMessage

	mail := aMailMessage.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/23/2006 13:30'!
receiver

	^ receiver.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/23/2006 13:36'!
receiver: aString

	receiver := aString.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/23/2006 13:36'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/23/2006 13:37'!
sender: aString

	sender := aString.! !

Object subclass: #SPMailQueue
	instanceVariableNames: 'kernel buffer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Handles incoming mail, e.g. storing/forwarding/...!

!SPMailQueue class methodsFor: 'instance creation' stamp: 'as 3/14/2006 14:41'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPMailQueue methodsFor: 'private' stamp: 'as 3/22/2006 16:55'!
handle: aMailMessage

	| listName list |
	listName := (aMailMessage to) copyUpTo: '@'.
	list := kernel listManager list: listName.
	list allUsers do: [
		
	].

	"fix me"
	"(MailDB openOn: 'testing') addNewMessage: aMailMessage.
	SPMailSender deliverMessage: aMailMessage usingServer: 'ubecx.unibe.ch'."
	! !

!SPMailQueue methodsFor: 'accessing' stamp: 'as 3/14/2006 14:41'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPMailQueue methodsFor: 'actions' stamp: 'as 3/16/2006 15:42'!
queue: aMailMessage

	[ self handle: aMailMessage ] newProcess resume.! !

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message quit kernel'
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

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 5/24/2006 14:15'!
clientId: aString

	message clientId: aString.! !

!SPMailReceiver methodsFor: 'settings' stamp: 'as 2/6/2006 15:19'!
dataDelimiter

	"The delimiter string that will end mail data input."

	^ String crlf, '.', String crlf.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 5/24/2006 13:55'!
initialize

	message := SPMailMessage new.
	self state: SPReadySmtpState.
	quit := false.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 5/24/2006 14:16'!
insertTrace! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 3/16/2006 15:24'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 5/24/2006 11:44'!
mailFrom: aString

	message sender: aString.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 5/24/2006 11:44'!
mailTo: aString

	message receiver: aString.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 5/24/2006 11:46'!
mail: aString

	message mail: aString.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 4/21/2006 11:57'!
queueMail

	kernel queue queue: message.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 5/4/2006 15:42'!
receive

	"Receive commands from client as long as connection is there and
	 quit is not requested."

	self reply: SPSmtpReply ready.
	[ quit not and: [ stream isConnected ] ] whileTrue: [
		self receiveCommand.
	].
	stream close.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 4/18/2006 16:50'!
receiveCommand

	"Find the apropriate command for a string line from the client and execute it."

	| line command |
	line := stream nextLineCrLf.
	[ command := SPSmtpCommand fromString: line target: self.
	  command execute. ]
		on: SPSmtpCommandException
		do: [ :ex | ex defaultAction. ex return. ].! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 5/24/2006 13:50'!
receiveData

	"Receive mail data as specified by the DATA SMTP command."

	^ (stream upToAll: self dataDelimiter) convertToSqueakText.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 4/18/2006 16:37'!
reply: aSPSmtpReply

	"Reply a message to the client."

	stream nextPutAll: aSPSmtpReply replyString; crlf; flush.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/18/2006 17:10'!
requestQuit

	quit := true.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 5/24/2006 13:54'!
reset

	message mailFrom: nil; mailTo: nil; mail: nil.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 4/20/2006 17:45'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

Object subclass: #SPModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPModel methodsFor: 'configuration' stamp: 'as 5/17/2006 13:20'!
configuration

	^ (self class name, self defaultConfigurationSuffix) instance.! !

!SPModel methodsFor: 'settings' stamp: 'as 5/17/2006 13:21'!
defaultConfigurationSuffix

	^ 'Configuration'.! !

!SPModel methodsFor: 'configuration' stamp: 'as 5/17/2006 13:14'!
preferenceAt: aSymbol

	self configuration valueAt: aSymbol.! !

Object subclass: #SPSmtpCommand
	instanceVariableNames: 'argument target reply state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

SPSmtpCommand class
	instanceVariableNames: 'states'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.

I'm abstract, don't instantiate me. The method fromString:target: will return an instance of the appropriate subclass.!

SPSmtpCommand subclass: #SPDataSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPDataSmtpCommand commentStamp: '<historical>' prior: 0!
The client wants to submit the mail message in data mode.!

!SPDataSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPRecipientSmtpState;
		yourself.! !

!SPDataSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 21:40'!
verb

	^ 'data'.! !

!SPDataSmtpCommand methodsFor: 'executing' stamp: 'as 5/24/2006 14:16'!
doExecute

	target
		reply: SPSmtpReply mailInput;
		mail: target receiveData;
		insertTrace;
		queueMail;
		reset.
	self state: SPResetSmtpState.! !

!SPDataSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:30'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPEhloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPEhloSmtpCommand commentStamp: 'as 3/6/2006 11:19' prior: 0!
The EHLO command unimplemented since no service extension are needed/implemented.!

!SPEhloSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPReadySmtpState;
		yourself.! !

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:00'!
verb

	^ 'ehlo'.! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:47'!
doExecute

	self reply: SPSmtpReply notImplemented.! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:10'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPHeloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPHeloSmtpCommand commentStamp: '<historical>' prior: 0!
HELO command is used by the client to initiate a new session with the server.!

!SPHeloSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPReadySmtpState;
		yourself.! !

!SPHeloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/10/2006 21:46'!
verb

	^ 'helo'.! !

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 5/24/2006 13:59'!
doExecute

	target clientId: argument.
	self state: SPResetSmtpState.! !

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 4/20/2006 19:37'!
doValidate

	"do hostname verification?"! !

SPSmtpCommand subclass: #SPMailSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPMailSmtpCommand commentStamp: '<historical>' prior: 0!
The MAIL command specifies the sender address.!

!SPMailSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:21'!
initStates

	"self initialize"

	^ Set new
		add: SPResetSmtpState;
		yourself.! !

!SPMailSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:08'!
verb

	^ 'mail from:'.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:56'!
doExecute

	target mailFrom: argument.
	self state: SPMailSmtpState.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:54'!
doValidate

	"is sender a subscribed user?"! !

SPSmtpCommand subclass: #SPNoopSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPNoopSmtpCommand commentStamp: '<historical>' prior: 0!
NOOP means no operation. This command is ignored and has no effect on the server.!

!SPNoopSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: self allStates;
		yourself.! !

!SPNoopSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/12/2006 22:18'!
verb

	^ 'noop'.! !

!SPNoopSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:41'!
doExecute

	"Fully confiding in defaults."! !

!SPNoopSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:14'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPQuitSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPQuitSmtpCommand commentStamp: '<historical>' prior: 0!
The client wants to quit the session.!

!SPQuitSmtpCommand class methodsFor: 'class initialization' stamp: 'as 5/11/2006 10:59'!
initStates

	"self initialize"

	^ Set new
		addAll: self allStates;
		yourself.! !

!SPQuitSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:31'!
verb

	^ 'quit'.! !

!SPQuitSmtpCommand methodsFor: 'executing' stamp: 'as 1/18/2006 17:09'!
doExecute

	target requestQuit.! !

!SPQuitSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 11:01'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPRecipientSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPRecipientSmtpCommand commentStamp: '<historical>' prior: 0!
Spcifies a recipient address.!

!SPRecipientSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPMailSmtpState;
		add: SPRecipientSmtpState;
		yourself.! !

!SPRecipientSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:32'!
verb

	^ 'rcpt to:'.! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:53'!
doExecute

	target mailTo: argument.
	self state: SPRecipientSmtpState.! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 10:55'!
doValidate

	"is address a hosted list?"! !

SPSmtpCommand subclass: #SPResetSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPResetSmtpCommand commentStamp: '<historical>' prior: 0!
Resets the server to start from beginning.!

!SPResetSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:13'!
initStates

	"self initialize"

	^ Set new
		add: SPResetSmtpState;
		add: SPMailSmtpState;
		add: SPRecipientSmtpState;
		yourself.! !

!SPResetSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:32'!
verb

	^ 'rset'.! !

!SPResetSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 11:27'!
doExecute

	target reset.
	self state: SPResetSmtpState.! !

!SPResetSmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 11:08'!
doValidate

	"nothing to do"! !

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 4/20/2006 15:56'!
allStates

	^ SPSmtpState allSubclasses.! !

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

!SPSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/15/2006 16:12'!
initialize

	states := self initStates.! !

!SPSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:13'!
initStates

	"Returns a collection of states this command is allowed to execute in."
	
	"IMPORTANT: changes made here or in called methods do only have effect
	 after reinitialization of the class!!"

	"self initialize"
	"self allSubclasses do: [ :each | each initialize. ]"

	self subclassResponsibility.! !

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 4/15/2006 16:11'!
states

	^ states.! !

!SPSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 15:38'!
verb

	"The string representation for this command in SMTP (case insensitive)."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/10/2006 21:49'!
argument: aString

	argument := aString.! !

!SPSmtpCommand methodsFor: 'defaults' stamp: 'as 4/18/2006 11:31'!
defaultNextState

	^ target state.! !

!SPSmtpCommand methodsFor: 'defaults' stamp: 'as 4/18/2006 11:30'!
defaultReply

	^ SPSmtpReply okay.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 4/18/2006 11:33'!
doExecute

	"Command-specific execution code goes here."
	"If the instance variables reply and nextState are not set the defaults are taken."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 4/20/2006 16:08'!
doValidate

	"Validate whatever is necessary for the command to be executed successfully."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'public' stamp: 'as 5/11/2006 10:59'!
execute

	self validateState; doValidate.
	self doExecute.
	self gotoNextState; sendReply.
	! !

!SPSmtpCommand methodsFor: 'private' stamp: 'as 4/21/2006 11:00'!
gotoNextState

	state isNil ifTrue: [ state := self defaultNextState. ].
	target state: state.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 4/20/2006 17:41'!
reply: aSPSmtpReply

	reply := aSPSmtpReply.! !

!SPSmtpCommand methodsFor: 'private' stamp: 'as 4/18/2006 11:29'!
sendReply

	reply isNil ifTrue: [ reply := self defaultReply. ].
	target reply: reply.! !

!SPSmtpCommand methodsFor: 'state' stamp: 'as 4/20/2006 19:35'!
states

	^ self class states.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 4/21/2006 10:59'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/12/2006 17:37'!
target: aSPMailReceiver

	target := aSPMailReceiver.! !

!SPSmtpCommand methodsFor: 'state' stamp: 'as 4/15/2006 16:21'!
validateState

	(self states includes: target state) ifFalse: [
		(SPSmtpCommandNotAllowed on: target) signal.
	].! !

!SPSmtpCommand methodsFor: 'smtp' stamp: 'as 4/20/2006 19:34'!
verb

	^ self class verb.! !

SPSmtpCommand subclass: #SPVerifySmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPVerifySmtpCommand commentStamp: '<historical>' prior: 0!
VRFY allows clients to verify addresses. This is disabled for security reasons.!

!SPVerifySmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:33'!
initStates

	"self initialize"

	^ Set new
		add: self allStates;
		yourself.! !

!SPVerifySmtpCommand class methodsFor: 'smtp' stamp: 'as 1/12/2006 12:21'!
verb

	^ 'vrfy'.! !

!SPVerifySmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 11:11'!
doExecute

	self reply: SPSmtpReply cannotVerify.! !

!SPVerifySmtpCommand methodsFor: 'executing' stamp: 'as 4/21/2006 11:11'!
doValidate

	"nothing to do"! !

Object subclass: #SPSmtpReply
	instanceVariableNames: 'code message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpReply commentStamp: '<historical>' prior: 0!
SMTP replies are sent from a server to a client.!

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:16'!
badSequence

	^ self new
		code: 503;
		message: 'Bad sequence of commands';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:16'!
cannotVerify

	^ self new
		code: 252;
		message: 'Verification is disabled';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
commandUnrecognized

	^ self new
		code: 500;
		message: 'Syntax error or command unrecognized';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
mailInput

	^ self new
		code: 354;
		message: 'Start mail input; end with <CRLF>.<CRLF>';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
notImplemented

	^ self new
		code: 502;
		message: 'Command not implemented';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
okay

	^ self new
		code: 250;
		message: 'Okay';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:18'!
ready

	^ self new
		code: 220;
		message: NetNameResolver localHostName;
		yourself.! !

!SPSmtpReply methodsFor: 'accessing' stamp: 'as 4/18/2006 15:54'!
code

	^ code.! !

!SPSmtpReply methodsFor: 'accessing' stamp: 'as 4/18/2006 15:54'!
code: aNumber

	code := aNumber.! !

!SPSmtpReply methodsFor: 'accessing' stamp: 'as 4/18/2006 15:54'!
message

	^ message.! !

!SPSmtpReply methodsFor: 'accessing' stamp: 'as 4/18/2006 15:55'!
message: aString

	message := aString.! !

!SPSmtpReply methodsFor: 'printing' stamp: 'as 4/20/2006 17:47'!
replyString

	^ code asString , ' ' , message.! !

Object subclass: #SPSmtpState
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPSmtpState commentStamp: '<historical>' prior: 0!
The state a SPMailReceiver is in when serving a client.!

SPSmtpState subclass: #SPMailSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPMailSmtpState commentStamp: '<historical>' prior: 0!
The server has received the mail command.!

SPSmtpState subclass: #SPReadySmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPReadySmtpState commentStamp: '<historical>' prior: 0!
The server waits for the client helo.!

SPSmtpState subclass: #SPRecipientSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPRecipientSmtpState commentStamp: '<historical>' prior: 0!
The client has received at least one recipient address.!

SPSmtpState subclass: #SPResetSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPResetSmtpState commentStamp: '<historical>' prior: 0!
The server is reset and can receive a new mail.!

Object subclass: #SPUser
	instanceVariableNames: 'name address lists'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Users'!

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
	category: 'Stamp-Users'!

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

!SPUserManager methodsFor: 'private' stamp: 'as 3/22/2006 15:22'!
userNamed: nameString

	^ users detect: [ :user | user name = nameString. ] ifNone: [ nil. ].! !

!SPUserManager methodsFor: 'private' stamp: 'as 3/22/2006 15:24'!
userShouldExist: nameString

	| user |
	user := self userNamed: nameString.
	user isNil ifTrue: [ SPUserNotFoundException signal. ].
	self assert: user notNil.
	^ user.! !

!SPUserManager methodsFor: 'private' stamp: 'as 3/22/2006 15:24'!
userShouldNotExist: nameString

	| user |
	user := self userNamed: nameString.
	user notNil ifTrue: [ SPUserAlreadyExistsException signal ].
	self assert: user isNil.! !

!SPUserManager methodsFor: 'operations' stamp: 'as 3/21/2006 14:37'!
user: nameString

	^ self userShouldExist: nameString.! !

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

Exception subclass: #SPModelException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

SPModelException subclass: #SPListAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Lists'!

SPModelException subclass: #SPListAlreadyIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Lists'!

SPModelException subclass: #SPListNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Lists'!

SPModelException subclass: #SPListNotIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Lists'!

!SPModelException methodsFor: 'priv handling' stamp: 'as 3/20/2006 15:58'!
isResumable

	^ false.! !

SPModelException subclass: #SPUserAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Users'!

SPModelException subclass: #SPUserAlreadyIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Users'!

SPModelException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Users'!

SPModelException subclass: #SPUserNotIncludedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Users'!

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
SPSmtpCommand initialize!
