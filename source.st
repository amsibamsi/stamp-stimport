SystemOrganization addCategory: #'Stamp-Tests'!
SystemOrganization addCategory: #'Stamp-Exceptions'!
SystemOrganization addCategory: #'Stamp-Testing'!
SystemOrganization addCategory: #'Stamp-Mail'!

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server following RFC 2821 that only receives mail.
The current state is tracked in the state variable that holds a symbol. State symbols should be obtained via the appropriate method.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 1/12/2006 21:14'!
on: aSocketStream

	"Return a new instance receiving/sending on the given stream."

	^ self new
		stream: aSocketStream;
		yourself.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/12/2006 21:38'!
gotoState: aSPMailReceiverState

	state := aSPMailReceiverState.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/12/2006 21:57'!
initialize

	message := MailMessage new.
	state := SPReadyMailReceiverState on: self.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 1/12/2006 21:48'!
mailFrom: aString

	message from: aString.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/12/2006 17:39'!
processLine: aString

	"Find the apropriate command for a string line from the client and execute it."

	| command |
	command := SPSmtpCommand fromString: aString target: self.
	state execute: command. "todo: handle different exceptions here!!"! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/11/2006 16:19'!
receive

	"Receive mail message(s) from the client, line by line."

	self reply: SPSmtpReply ready.
	[ stream isConnected ] whileTrue: [
		self processLine: stream nextLineCrLf.
	].
	stream close.
	^ message.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/11/2006 14:31'!
reply: aString

	"Reply a message to the client."

	stream nextPutAll: aString; crlf; flush.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

Object subclass: #SPMailReceiverState
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

SPMailReceiverState subclass: #SPMailMailReceiverState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailReceiverState class methodsFor: 'commands' stamp: 'as 1/12/2006 16:42'!
allowedCommands

	^ self transitions keys.! !

!SPMailReceiverState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:09'!
defaultTransitions

	"Transitions that are usually always possible."

	^ Dictionary new
		at: SPVerifySmtpCommand put: self;
		at: SPNoopSmtpCommand put: self;
		at: SPQuitSmtpCommand put: self;
		yourself.! !

!SPMailReceiverState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:45'!
nextStateClassFor: aSPSmtpCommand

	^ self transitions at: aSPSmtpCommand class.! !

!SPMailReceiverState class methodsFor: 'instance creation' stamp: 'as 1/12/2006 21:37'!
on: aSPMailReceiver

	self new
		owner: aSPMailReceiver;
		yourself.! !

!SPMailReceiverState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:10'!
transitions

	"This must return a dictionary with mappings: 'command class' -> 'state class'.
	 The meaning is: 'command class' is an allowed command in this state and has
	 next state 'state class'."

	self subclassResponsibility.! !

!SPMailReceiverState methodsFor: 'commands' stamp: 'as 1/12/2006 16:06'!
allowedCommands

	^ self class allowedCommands.! !

!SPMailReceiverState methodsFor: 'commands' stamp: 'as 1/12/2006 16:23'!
commandAllowed: aSPSmtpCommand

	^ self allowedCommands includes: aSPSmtpCommand class.! !

!SPMailReceiverState methodsFor: 'commands' stamp: 'as 1/12/2006 21:54'!
execute: aSPSmtpCommand

	(self commandAllowed: aSPSmtpCommand) ifTrue: [
		aSPSmtpCommand execute.
		owner gotoState: (self nextStateFor: aSPSmtpCommand).
	] ifFalse: [
		SPSmtpCommandNotAllowed signal.
	].! !

!SPMailReceiverState methodsFor: 'commands' stamp: 'as 1/12/2006 21:44'!
nextStateFor: aSPSmtpCommand

	^ (self class nextStateClassFor: aSPSmtpCommand) on: owner.! !

!SPMailReceiverState methodsFor: 'accessing' stamp: 'as 1/12/2006 15:57'!
owner: aSPMailReceiver

	owner := aSPMailReceiver.! !

SPMailReceiverState subclass: #SPReadyMailReceiverState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPReadyMailReceiverState class methodsFor: 'commands' stamp: 'as 1/12/2006 21:59'!
transitions

	^ self defaultTransitions
		at: SPHeloSmtpCommand put: SPResetMailReceiverState;
		at: SPEhloSmtpCommand put: self;
		yourself.! !

SPMailReceiverState subclass: #SPResetMailReceiverState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

Object subclass: #SPSmtpCommand
	instanceVariableNames: 'argument target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.
I'm abstract, don't instantiate me.!

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

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/12/2006 17:18'!
argumentFor: aString command: aSmtpCommand

	"Find arguments in a line assuming the given verb for the command."

	^ aString copyFrom: (aSmtpCommand verb size + 1) to: aString size.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/12/2006 17:20'!
commandFor: aString

	"Extract command and return appropriate command class. The verb string for a SMTP command is case insensitive."

	| class |
	class := self allSubclasses detect: [
		:each |
		aString asLowercase beginsWith: each verb asLowercase
	] ifNone: [
		SPSmtpCommandNotFound signal.	
	].
	^ class new.! !

!SPSmtpCommand class methodsFor: 'instance creation' stamp: 'as 1/12/2006 21:46'!
fromString: aString target: aSPMailReceiver

	"Return a new command created from a given string."

	| command argument |
	command := self commandFor: aString.
	self assert: [ command notNil. ].
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

Exception subclass: #SPSmtpCommandFailed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

Exception subclass: #SPSmtpCommandNotAllowed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

Exception subclass: #SPSmtpCommandNotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Exceptions'!

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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/12/2006 12:19'!
cannotVerify
	^ '252'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:48'!
commandUnrecognized

	^ '500'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/11/2006 16:03'!
notImplemented

	^ '502'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:09'!
okay

	^ '250'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 22:05'!
ready

	^ '220 anonymous.xx'.! !

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
