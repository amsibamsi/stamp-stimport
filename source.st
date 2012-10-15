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

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server following RFC 2821 that only receives mail.
The current state is tracked in the state variable that holds a symbol. State symbols should be obtained via the appropriate method.!

!SPMailReceiver class methodsFor: 'states' stamp: 'as 1/11/2006 14:04'!
initialState

	"The initial state before any communication with the client has been done."

	^ #initial.! !

!SPMailReceiver class methodsFor: 'states' stamp: 'as 1/11/2006 16:18'!
mailState

	^ #mail.! !

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 1/11/2006 16:20'!
on: aSocketStream

	"Return a new instance receiving/sending on the given stream"

	^ self new
		stream: aSocketStream;
		state: self initialState;
		message: MailMessage new;
		yourself.! !

!SPMailReceiver class methodsFor: 'states' stamp: 'as 1/11/2006 14:26'!
resetState

	"The state before starting a new mail transaction."

	^ #reset.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 1/11/2006 16:28'!
from: aString

	message from: aString.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:29'!
inState: aSymbol

	"Am I in the given state?"

	^ aSymbol = state.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/11/2006 16:20'!
message: aMailMessage

	message := aMailMessage.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/11/2006 14:35'!
processLine: aString

	"Find the apropriate command for a string line from the client and execute it."

	| command |
	command := SPSmtpCommand fromLine: aString receiver: self.
	command notNil ifTrue: [
		command execute.
	] ifFalse: [
		self reply: SPSmtpReply commandUnrecognized.
	].! !

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

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state: aSymbol

	state := aSymbol.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

Object subclass: #SPSmtpCommand
	instanceVariableNames: 'receiver reply outState argument'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.
Concrete subclasses implement the doExecute method that actually executes the command.!

SPSmtpCommand subclass: #SPEhloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPEhloSmtpCommand commentStamp: '<historical>' prior: 0!
The EHLO command is like HELO but allows to use service extensions. These extension are not needed and therefor the command is rejected.!

!SPEhloSmtpCommand class methodsFor: 'state' stamp: 'as 1/11/2006 15:59'!
inStates

	^ OrderedCollection new
		add: SPMailReceiver initialState;
		yourself.! !

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:00'!
verb

	^ 'ehlo'.! !

!SPEhloSmtpCommand methodsFor: 'executing' stamp: 'as 1/11/2006 16:03'!
doExecute

	outState := SPMailReceiver resetState.
	reply := SPSmtpReply notImplemented.! !

SPSmtpCommand subclass: #SPHeloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPHeloSmtpCommand commentStamp: '<historical>' prior: 0!
HELO command ist used by the client to initiate a new session with the server.!

!SPHeloSmtpCommand class methodsFor: 'state' stamp: 'as 1/10/2006 21:14'!
inStates

	^ OrderedCollection new
		add: SPMailReceiver initialState;
		yourself.! !

!SPHeloSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/10/2006 21:46'!
verb

	^ 'helo'.! !

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 1/10/2006 16:41'!
doExecute

	outState := SPMailReceiver resetState.
	reply := SPSmtpReply okay.! !

SPSmtpCommand subclass: #SPMailSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailSmtpCommand commentStamp: '<historical>' prior: 0!
The MAIL command specifies the sender address.!

!SPMailSmtpCommand class methodsFor: 'state' stamp: 'as 1/11/2006 16:13'!
inStates

	^ OrderedCollection new
		add: SPMailReceiver resetState;
		yourself.! !

!SPMailSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/11/2006 16:08'!
verb

	^ 'mail from:'.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 1/11/2006 16:18'!
doExecute

	receiver from: argument.
	reply := SPSmtpReply okay.
	outState := SPMailReceiver mailState.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/11/2006 14:59'!
argumentFor: aString verb: verbString

	"Find arguments in a line assuming the given verb for the command."

	^ aString copyFrom: (verbString size + 1) to: aString size.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/11/2006 15:38'!
commandFor: aString

	"Extract command and return appropriate command class. The verb string for a SMTP command ist case insensitive."

	^ self allSubclasses detect: [ :each | aString asLowercase beginsWith: each verb asLowercase ] ifNone: [ ^ nil ].! !

!SPSmtpCommand class methodsFor: 'instance creation' stamp: 'as 1/11/2006 15:05'!
fromLine: aString receiver: aSPSmtpReceiver

	"Return new command created from a given string line, or nil if no related command is found."

	| commandClass command argument |
	commandClass := self commandFor: aString.
	commandClass notNil ifTrue: [
		argument := self argumentFor: aString verb: commandClass verb.
		command := commandClass new
			receiver: aSPSmtpReceiver;
			argument: argument;
			yourself.
	].
	^ command.! !

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 1/11/2006 15:03'!
inStates

	"A collection of receiver states this command is allowed to execute in."

	self subclassResponsibility.! !

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

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/11/2006 15:14'!
execute

	"Execute command on receiver, reply to client and set new state of receiver."

	(self class inStates includes: receiver state)
	ifTrue: [
		self doExecute.
		receiver reply: reply.
		receiver state: outState.
	] ifFalse: [
		receiver reply: SPSmtpReply badSequence.
	]! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/9/2006 08:33'!
outState

	^ outState.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/5/2006 16:49'!
receiver: aSPSmtpReceiver

	receiver := aSPSmtpReceiver.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/11/2006 15:17'!
reply

	^ reply.! !

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
