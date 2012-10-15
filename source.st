SystemOrganization addCategory: #'Stamp-Tests'!
SystemOrganization addCategory: #'Stamp-Exceptions'!
SystemOrganization addCategory: #'Stamp-Testing'!
SystemOrganization addCategory: #'Stamp-Mail'!

TcpService subclass: #SPMailListener
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailListener commentStamp: '<historical>' prior: 0!
A TCP service accepting SMTP connections.!

!SPMailListener methodsFor: 'conversation' stamp: 'as 1/10/2006 21:53'!
serve: aSocket

	| receiver message |
	receiver := SPMailReceiver on: (SocketStream on: aSocket).
	message := receiver receive.! !

Exception subclass: #SPSmtpCommandException
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

!SPSmtpCommandException class methodsFor: 'instance creation' stamp: 'as 1/17/2006 17:54'!
on: aSPMailReceiver

	^ self new
		receiver: aSPMailReceiver;
		yourself.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/18/2006 16:00'!
defaultAction

	receiver reply: self reply.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/17/2006 17:55'!
isResumable

	^ false.! !

!SPSmtpCommandException methodsFor: 'accessing' stamp: 'as 1/17/2006 17:55'!
receiver: aSPMailReceiver

	receiver := aSPMailReceiver.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:01'!
reply

	self subclassResponsibility.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotAllowed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

!SPSmtpCommandNotAllowed methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

!SPSmtpCommandNotFound methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

TestCase subclass: #CodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!CodeTest commentStamp: '<historical>' prior: 0!
Test different aspects of the Smalltalk code in my implementation.!

!CodeTest methodsFor: 'configuration' stamp: 'as 1/11/2006 17:03'!
packageName

	^ 'Stamp'.! !

!CodeTest methodsFor: 'testing' stamp: 'as 1/11/2006 17:03'!
testClassComment

	"Each class should have a comment."

	(PackageInfo named: self packageName) classes do: [
		:each |
		self assert: each hasComment.
	].! !

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message sender recipient dataMode quit'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server following RFC 2821 that only receives mail.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 1/12/2006 21:14'!
on: aSocketStream

	"Return a new instance receiving/sending on the given stream."

	^ self new
		stream: aSocketStream;
		yourself.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 1/14/2006 22:03'!
enterCommandMode

	dataMode := false.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 1/14/2006 22:02'!
enterDataMode

	dataMode := true.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/12/2006 21:38'!
gotoState: aSPMailReceiverState

	state := aSPMailReceiverState.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/18/2006 17:10'!
initialize

	self reset.
	self gotoState: (SPReadySmtpState on: self).
	self enterCommandMode.
	quit := false.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 1/14/2006 22:14'!
mailFrom: aString

	sender := aString.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 1/14/2006 22:14'!
mailTo: aString

	recipient := aString.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/18/2006 17:13'!
receive

	"Receive mail message(s) from the client, line by line."

	self reply: SPSmtpReply ready.
	[ quit not and: [ stream isConnected ] ] whileTrue: [
		dataMode ifFalse: [
			self receiveCommand.
		] ifTrue: [
			self receiveData.
		]
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

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/18/2006 17:03'!
receiveData

	message from: (stream upToAll: String crlf, '.', String crlf).
	self reply: SPSmtpReply okay.
	message inspect.
	self reset.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/11/2006 14:31'!
reply: aString

	"Reply a message to the client."

	stream nextPutAll: aString; crlf; flush.! !

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
	category: 'Stamp-Mail'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.
I'm abstract, don't instantiate me. The method fromString:target: will return an instance of the appropriate subclass.!

SPSmtpCommand subclass: #SPDataSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

!SPEhloSmtpCommand commentStamp: '<historical>' prior: 0!
The EHLO command is like HELO but allows to use service extensions. These extension are not needed and therefor the command is rejected.!

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:00'!
verb

	^ 'ehlo'.! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:07'!
doExecute

	"nothing to do"! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 1/12/2006 22:08'!
reply

	^ SPSmtpReply notImplemented.! !

SPSmtpCommand subclass: #SPHeloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPHeloSmtpCommand commentStamp: '<historical>' prior: 0!
HELO command ist used by the client to initiate a new session with the server.!

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
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

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

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/18/2006 16:34'!
commandFor: aString target: aSPMailReceiver

	"Extract command and return appropriate command class. The verb string for a SMTP command is case insensitive."

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

!SPSmtpCommand methodsFor: 'private' stamp: 'as 1/11/2006 15:21'!
doExecute

	"Execute on receiver. This must also set reply string, that will be replied to the client, and outState that becomes the new state of the receiver."

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

!SPSmtpCommand methodsFor: 'smtp' stamp: 'as 1/12/2006 17:31'!
verb

	^ self class verb.! !

SPSmtpCommand subclass: #SPVerifySmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

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
	category: 'Stamp-Mail'!

SPSmtpState subclass: #SPMailSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailSmtpState class methodsFor: 'commands' stamp: 'as 1/14/2006 22:17'!
transitions

	^ self defaultTransitions
		at: SPRecipientSmtpCommand put: self;
		at: SPDataSmtpCommand put: SPResetSmtpState;
		yourself.! !

SPSmtpState subclass: #SPReadySmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPReadySmtpState class methodsFor: 'commands' stamp: 'as 1/19/2006 00:20'!
transitions

	^ self anytimeTransitions
		at: SPResetSmtpCommand put: self;
		at: SPHeloSmtpCommand put: SPResetSmtpState;
		at: SPEhloSmtpCommand put: self;
		yourself.! !

SPSmtpState subclass: #SPResetSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPResetSmtpState class methodsFor: 'commands' stamp: 'as 1/13/2006 23:52'!
transitions

	^ self defaultTransitions
		at: SPMailSmtpCommand put: SPMailSmtpState;
		yourself.! !

!SPSmtpState class methodsFor: 'commands' stamp: 'as 1/12/2006 16:42'!
allowedCommands

	^ self transitions keys.! !

!SPSmtpState class methodsFor: 'commands' stamp: 'as 1/18/2006 17:57'!
anytimeTransitions

	"Transitions that are always possible."

	^ Dictionary new
		at: SPVerifySmtpCommand put: self;
		at: SPNoopSmtpCommand put: self;
		at: SPQuitSmtpCommand put: self;
		yourself.! !

!SPSmtpState class methodsFor: 'commands' stamp: 'as 1/19/2006 00:18'!
defaultTransitions

	"Default set of transitions, often used by other states."

	^ self anytimeTransitions
		at: SPResetSmtpCommand put: SPResetSmtpState;
		yourself.! !

!SPSmtpState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:45'!
nextStateClassFor: aSPSmtpCommand

	^ self transitions at: aSPSmtpCommand class.! !

!SPSmtpState class methodsFor: 'instance creation' stamp: 'as 1/16/2006 20:30'!
on: aSPMailReceiver

	^ self new
		owner: aSPMailReceiver;
		yourself.! !

!SPSmtpState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:10'!
transitions

	"This must return a dictionary with mappings: 'command class' -> 'state class'.
	 The meaning is: 'command class' is an allowed command in this state and has
	 next state 'state class'."

	self subclassResponsibility.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/12/2006 16:06'!
allowedCommands

	^ self class allowedCommands.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/12/2006 16:23'!
commandAllowed: aSPSmtpCommand

	^ self allowedCommands includes: aSPSmtpCommand class.! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/18/2006 15:39'!
execute: aSPSmtpCommand

	(self commandAllowed: aSPSmtpCommand) ifTrue: [
		aSPSmtpCommand execute.
		owner gotoState: (self nextStateFor: aSPSmtpCommand).
	] ifFalse: [
		(SPSmtpCommandNotAllowed on: owner) signal.
	].! !

!SPSmtpState methodsFor: 'commands' stamp: 'as 1/12/2006 21:44'!
nextStateFor: aSPSmtpCommand

	^ (self class nextStateClassFor: aSPSmtpCommand) on: owner.! !

!SPSmtpState methodsFor: 'accessing' stamp: 'as 1/12/2006 15:57'!
owner: aSPMailReceiver

	owner := aSPMailReceiver.! !

Object subclass: #TestingSelf
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Testing'!

!TestingSelf class methodsFor: 'as yet unclassified' stamp: 'as 1/12/2006 21:40'!
method

	^ self.! !

!TestingSelf methodsFor: 'as yet unclassified' stamp: 'as 1/12/2006 21:40'!
method

	^ self.! !

!TestingSelf methodsFor: 'as yet unclassified' stamp: 'as 1/12/2006 21:42'!
test

	^ self method class == self class method.! !

Object subclass: #TestingSingleton
	instanceVariableNames: 'var1'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Testing'!

TestingSingleton class
	instanceVariableNames: 'uniqueInstance'!

!TestingSingleton class methodsFor: 'as yet unclassified' stamp: 'as 1/13/2006 09:42'!
uniqueInstance

	uniqueInstance isNil ifTrue: [
		uniqueInstance := self new.
	].
	^ uniqueInstance.! !

!TestingSingleton methodsFor: 'initialize-release' stamp: 'as 1/13/2006 09:44'!
initialize

	var1 := 1.! !

String subclass: #SPSmtpReply
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPSmtpReply commentStamp: '<historical>' prior: 0!
SMTP replies are sent from the server to the client and are just strings.!

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 22:01'!
badSequence

	^ '503'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/14/2006 13:02'!
cannotVerify

	^ '252'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:48'!
commandUnrecognized

	^ '500'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/14/2006 22:15'!
mailInput

	^ '354'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/11/2006 16:03'!
notImplemented

	^ '502'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:09'!
okay

	^ '250'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/17/2006 16:09'!
ready

	^ '220 ', NetNameResolver localHostName.! !
