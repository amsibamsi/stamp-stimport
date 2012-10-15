SystemOrganization addCategory: #'Stamp-Mail'!

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server following RFC 2821 that does only receive mail.!

!SPMailReceiver class methodsFor: 'states' stamp: 'as 1/10/2006 21:15'!
initialState

	^ #initial.! !

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:41'!
on: aSocketStream

	^ self new
		stream: aSocketStream;
		state: self initialState;
		yourself.! !

!SPMailReceiver class methodsFor: 'states' stamp: 'as 1/10/2006 13:29'!
resetState

	^ #reset.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/10/2006 21:09'!
inState: aSymbol

	^ aSymbol = state.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 1/10/2006 18:53'!
processLine: aString

	| command |
	command := SPSmtpCommand fromLine: aString receiver: self.
	command notNil ifTrue: [
		command execute.
	] ifFalse: [
		self reply: SPSmtpReply commandUnrecognized.
	].! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/10/2006 22:06'!
receive

	| message |
	message := ''.
	self reply: SPSmtpReply ready.
	[ stream isConnected ] whileTrue: [
		self processLine: stream nextLineCrLf.
	].
	stream close.
	^ message.! !

!SPMailReceiver methodsFor: 'actions' stamp: 'as 1/10/2006 21:52'!
reply: aString

	stream nextPutAll: aString; crlf; flush.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/10/2006 16:55'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/10/2006 16:42'!
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

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/10/2006 18:37'!
argumentFor: aString verb: verbString

	^ aString copyFrom: (verbString size + 1) to: aString size.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 1/10/2006 21:44'!
commandFor: aString

	^ self allSubclasses detect: [ :each | aString beginsWith: each verb ] ifNone: [ ^ nil ].! !

!SPSmtpCommand class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:22'!
fromLine: aString receiver: aSPSmtpReceiver

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

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 1/9/2006 08:34'!
inStates

	self subclassResponsibility.! !

!SPSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/10/2006 15:52'!
verb

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/10/2006 21:49'!
argument: aString

	argument := aString.! !

!SPSmtpCommand methodsFor: 'private' stamp: 'as 1/9/2006 08:33'!
doExecute

	"Execute command on receiver, set reply and out state for receiver."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/10/2006 22:01'!
execute

	(self class inStates includes: receiver state)
	ifTrue: [
		self doExecute.
		receiver reply: reply.
		receiver state: outState.
	] ifFalse: [
		receiver reply: SPSmtpReply badSequence.
	]! !

!SPSmtpCommand methodsFor: 'private' stamp: 'as 1/9/2006 08:33'!
outState

	^ outState.! !

!SPSmtpCommand methodsFor: 'accessing' stamp: 'as 1/5/2006 16:49'!
receiver: aSPSmtpReceiver

	receiver := aSPSmtpReceiver.! !

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 1/9/2006 08:08'!
reply

	"Every SMTP command has a reply!!"

	^ reply.! !

SPSmtpCommand subclass: #SPSmtpHeloCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPSmtpHeloCommand class methodsFor: 'state' stamp: 'as 1/10/2006 21:14'!
inStates

	^ OrderedCollection new
		add: SPMailReceiver initialState;
		yourself.! !

!SPSmtpHeloCommand class methodsFor: 'smtp' stamp: 'as 1/10/2006 21:46'!
verb

	^ 'helo'.! !

!SPSmtpHeloCommand methodsFor: 'executing' stamp: 'as 1/10/2006 16:41'!
doExecute

	outState := SPMailReceiver resetState.
	reply := SPSmtpReply okay.! !

Object subclass: #SPSmtpReply
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail'!

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 22:01'!
badSequence

	^ '503'.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 1/10/2006 21:48'!
commandUnrecognized

	^ '500'.! !

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

!SPMailListener methodsFor: 'conversation' stamp: 'as 1/10/2006 21:53'!
serve: aSocket

	| receiver message |
	receiver := SPMailReceiver on: (SocketStream on: aSocket).
	message := receiver receive.! !
