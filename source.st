SystemOrganization addCategory: #'Stamp-Configuration'!
SystemOrganization addCategory: #'Stamp-Core'!
SystemOrganization addCategory: #'Stamp-ListManager'!
SystemOrganization addCategory: #'Stamp-ListManager-Tests'!
SystemOrganization addCategory: #'Stamp-Mail-Client'!
SystemOrganization addCategory: #'Stamp-Mail-Server'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Commands'!
SystemOrganization addCategory: #'Stamp-Mail-Server-States'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Tests'!
SystemOrganization addCategory: #'Stamp-Storage'!
SystemOrganization addCategory: #'Stamp-Tests'!
SystemOrganization addCategory: #'Stamp-Web'!

!String methodsFor: '*Stamp' stamp: 'as 10/18/2006 00:40'!
convertSmtpToSqueakText

	"Squeak likes CR as end of line character, so CRLF and LF are converted to CR."
	"CR.CR in SMTP has a special meaning and is escaped with CR..CR."

	| convertedString cr lf |
	cr := String cr.
	lf := String lf.
	convertedString := self copyReplaceAll: cr, lf with: cr.
	convertedString := convertedString copyReplaceAll: lf with: cr.
	convertedString := convertedString copyReplaceAll: cr, '..', cr with: cr, '.', cr.
	^ convertedString.! !

!String methodsFor: '*Stamp' stamp: 'as 10/18/2006 00:39'!
convertSqueakToSmtpText

	"SMTP likes CRLF as end of line characters, so CR and LF are converted to CRLF."
	"CR..CR is the escape sequence for CR.CR, since this one has a special meaning in SMTP."

	| convertedString cr lf |
	cr := String cr.
	lf := String lf.
	convertedString := self copyReplaceAll: lf with: cr.
	convertedString := convertedString copyReplaceAll: cr with: cr, lf.
	convertedString := convertedString copyReplaceAll: cr, lf, '.', cr, lf with: cr, lf, '..', cr, lf.
	^ convertedString.! !

TcpService subclass: #SPMailService
	instanceVariableNames: 'listener connections'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailService commentStamp: '<historical>' prior: 0!
A TCP service listening for incoming SMTP connections.!

!SPMailService class methodsFor: 'instance creation' stamp: 'as 12/13/2006 11:01'!
withListener: aSPMailListener

	^ self new
		listener: aSPMailListener;
		yourself.! !

!SPMailService methodsFor: 'access' stamp: 'as 5/30/2006 09:17'!
listener: aSPMailListener

	listener := aSPMailListener.! !

!SPMailService methodsFor: 'conversation' stamp: 'as 11/8/2006 22:43'!
serve: aSocket

	| receiver |
	[
		receiver := SPMailReceiver
			withKernel: listener kernel
			stream: (SocketStream on: aSocket).
		receiver receive.
	]
		on: SPTooManyConnectionsException
		do: [ :ex | ex defaultAction; return. ].! !

!MailMessage methodsFor: '*Stamp' stamp: 'as 9/19/2006 18:11'!
addField: nameString fromString: valueString

	"Add a field. If any field of the specified name exists, it will not be overwritten."

	| field key value |
	key := nameString asLowercase.
	field := fields at: key ifAbsent: [
		fields at: key put: OrderedCollection new.
	].
	value := MIMEHeaderValue forField: nameString fromString: valueString.
	field add: value.
	text := nil.
	tokens := nil.! !

!MailMessage methodsFor: '*Stamp' stamp: 'as 9/19/2006 18:25'!
received: aString

	self addField: 'received' fromString: aString.! !

!MailMessage methodsFor: '*Stamp' stamp: 'as 10/17/2006 14:17'!
returnPath: aString

	self setField: 'return-path' toString: aString.! !

!MailMessage methodsFor: '*Stamp' stamp: 'as 10/17/2006 14:19'!
subject: aString

	self setField: 'subject' toString: aString.! !

TestCase subclass: #SPCodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPCodeTest commentStamp: '<historical>' prior: 0!
Test different coding style aspects of the implementation.!

!SPCodeTest methodsFor: 'run' stamp: 'as 1/11/2006 17:03'!
packageName

	^ 'Stamp'.! !

!SPCodeTest methodsFor: 'test' stamp: 'as 1/11/2006 17:03'!
testClassComment

	"Each class should have a comment."

	(PackageInfo named: self packageName) classes do: [
		:each |
		self assert: each hasComment.
	].! !

TestCase subclass: #SPListTest
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Tests'!

!SPListTest commentStamp: '<historical>' prior: 0!
Test SPList.!

!SPListTest methodsFor: 'run' stamp: 'as 9/18/2006 14:58'!
listName

	^ 'mylist'.! !

!SPListTest methodsFor: 'run' stamp: 'as 9/18/2006 14:56'!
setUp

	list := SPList withName: self listName.! !

!SPListTest methodsFor: 'test' stamp: 'as 9/18/2006 15:02'!
testActivation

	list activate.
	self assert: list isActive.
	list deactivate.
	self deny: list isActive.! !

!SPListTest methodsFor: 'test' stamp: 'as 9/18/2006 15:04'!
testEqual

	| list2 |
	list2 := SPList withName: self listName.
	self assert: list = list2.
	self deny: list ~= list2.! !

!SPListTest methodsFor: 'test' stamp: 'as 9/18/2006 15:00'!
testInitialization

	self assert: list isActive.
	self deny: list isModerated.! !

!SPListTest methodsFor: 'test' stamp: 'as 9/18/2006 15:02'!
testModeration

	list moderate.
	self assert: list isModerated.
	list unmoderate.
	self deny: list isModerated.! !

!SPListTest methodsFor: 'test' stamp: 'as 9/18/2006 15:03'!
testName

	self assert: list name = self listName.! !

TestCase subclass: #SPMailReceivingSendingTest
	instanceVariableNames: 'server client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Tests'!

!SPMailReceivingSendingTest commentStamp: '<historical>' prior: 0!
Test the mail receiving/sending subsystem.!

!SPMailReceivingSendingTest methodsFor: 'run' stamp: 'as 2/21/2006 10:15'!
findPortFor: aSPMailListener

	1024 to: 65536 do: [
		:port |
		[ aSPMailListener verifyPortAvailability: port. ^ port. ]
			on: Error
			do: [ :ex | ex return.]
	].! !

!SPMailReceivingSendingTest methodsFor: 'run' stamp: 'as 10/5/2006 13:24'!
setUp

	| port tries maxTries delay |
	server := SPMailListener withKernel: SPDummy new.
	port := self findPortFor: server service.
	server service portNumber: port.
	server start.

	tries := 0.
	maxTries := 10.
	delay := Delay forMilliseconds: 300.
	[
		[ client := SPSmtpClient openOnHostNamed: 'localhost' port: port. ]
			on: ConnectionTimedOut
			do: [ :ex | tries := tries + 1. ex return. ].
		delay wait.
	] doWhileTrue: [
		client == nil and: [ tries <= maxTries ].
	]! !

!SPMailReceivingSendingTest methodsFor: 'run' stamp: 'as 9/14/2006 10:04'!
tearDown

	client close.
	server destroy.! !

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:34'!
testBasic

	self shouldnt: [
		client
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			data: 'Subject: test';
			quit.
	] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:43'!
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

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:44'!
testRecipient

	self shouldnt: [
		client
			reopen;
			mailFrom: 'user@host.com';
			recipient: 'user2@host.com';
			recipient: 'user3@host.com';
			quit.
	] raise: TelnetProtocolError.! !

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:44'!
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

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:51'!
testSender

	self
		should: [ client reopen; mailFrom: 'me'; mailFrom: 'meAgain'. ]
		raise: TelnetProtocolError.
	self assert: (client responseCode = 503).
	! !

!SPMailReceivingSendingTest methodsFor: 'test' stamp: 'as 2/22/2006 19:51'!
testUnrecognized

	self
		should: [ client reopen; sendCommand: 'unrecognized'; checkResponse. ]
		raise: TelnetProtocolError.
	self assert: (client responseCode = 500).! !

TestCase subclass: #SPPasswordTest
	instanceVariableNames: 'password1 password2 password'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Tests'!

!SPPasswordTest commentStamp: '<historical>' prior: 0!
Stamp password test.!

!SPPasswordTest methodsFor: 'run' stamp: 'as 9/26/2006 14:48'!
setUp

	password1 := 'password1'.
	password2 := 'password2'.
	password := SPPassword withPassword: password1.! !

!SPPasswordTest methodsFor: 'test' stamp: 'as 9/26/2006 14:50'!
testCheck

	self assert: (password check: password1).
	self deny: (password check: password2).! !

!SPPasswordTest methodsFor: 'test' stamp: 'as 9/26/2006 14:51'!
testSetting

	self shouldnt: [ password new: password2 old: password1. ] raise: SPWrongPasswordException.
	self assert: (password check: password2).
	self should: [ password new: password2 old: password1. ] raise: SPWrongPasswordException.! !

TestCase subclass: #SPTextConversionTest
	instanceVariableNames: 'cr lf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPTextConversionTest commentStamp: '<historical>' prior: 0!
Test text conversion from SMTP to Squeak and back.!

!SPTextConversionTest methodsFor: 'run' stamp: 'as 3/7/2006 11:47'!
setUp

	cr := String cr.
	lf := String lf.! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:28'!
testSmtpCombined

	self assert: (cr, cr, lf, lf) convertSqueakToSmtpText = (cr, lf, cr, lf, cr, lf, cr, lf).! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:28'!
testSmtpCrLf

	self assert: cr convertSqueakToSmtpText = (cr, lf).! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:28'!
testSmtpLf

	self assert: lf convertSqueakToSmtpText = (cr, lf).! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:28'!
testSqueakCombined

	self assert: (lf, cr, cr, lf, lf, cr, lf ) convertSmtpToSqueakText = (cr, cr, cr, cr, cr).! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:29'!
testSqueakCrLf

	self assert: (cr, lf) convertSmtpToSqueakText = cr.! !

!SPTextConversionTest methodsFor: 'test' stamp: 'as 10/17/2006 14:29'!
testSqueakLf

	self assert: lf convertSmtpToSqueakText = cr.! !

TestCase subclass: #SPUserTest
	instanceVariableNames: 'user contact1 contact2 address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Tests'!

!SPUserTest commentStamp: '<historical>' prior: 0!
Test SPUser.!

!SPUserTest methodsFor: 'run' stamp: 'as 9/5/2006 17:34'!
email

	^ '<hal9000@space.xx>'.! !

!SPUserTest methodsFor: 'run' stamp: 'as 9/11/2006 15:11'!
setUp

	user := SPUser withName: self userName password: self userPassword.
	address := SPMailAddress fromPath: self email.
	contact1 := SPContact withAddress: address user: user.
	contact2 := SPContact withAddress: address user: user.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/18/2006 14:19'!
testActivation

	user activate.
	self assert: user isActive.
	user deactivate.
	self deny: user isActive.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/7/2006 16:32'!
testAddContact

	user addContact: contact1.
	self assert: (user contact: address) == contact1.
	user addContact: contact1.
	self assert: (user contact: address) == contact1.
	user addContact: contact2.
	self assert: (user contact: address) == contact1.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/7/2006 16:38'!
testEqual

	| user2 |
	user2 := SPUser withName: self userName password: self userPassword.
	self assert: user = user2.
	self deny: user == user2.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/12/2006 16:32'!
testGetContact

	self assert: (user contact: address) = nil.
	user addContact: contact1.
	self assert: (user contact: address) == contact1.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/18/2006 15:01'!
testInitialization

	self assert: user isActive.
	self assert: user contacts isEmpty.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/18/2006 14:22'!
testPassword

	user checkPassword: self userPassword.! !

!SPUserTest methodsFor: 'test' stamp: 'as 9/12/2006 16:32'!
testRemoveContact

	user addContact: contact1.
	user removeContact: contact1.
	self assert: (user contact: address) = nil.! !

!SPUserTest methodsFor: 'run' stamp: 'as 9/5/2006 17:33'!
userName

	^ 'hal'.! !

!SPUserTest methodsFor: 'run' stamp: 'as 9/5/2006 17:32'!
userPassword

	^ '9000'.! !

Exception subclass: #SPException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPException commentStamp: '<historical>' prior: 0!
Common super class of all Stamp exceptions.!

SPException subclass: #SPConfigurationException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurationException commentStamp: 'as 1/8/2007 15:28' prior: 0!
Stamp configuration exception.!

SPConfigurationException subclass: #SPConfigurationAttributeNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurationAttributeNotFoundException commentStamp: 'as 1/8/2007 15:28' prior: 0!
There was no configuration attribute found by that name.!

SPConfigurationException subclass: #SPImmutableConfigurationAttributeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPImmutableConfigurationAttributeException commentStamp: 'as 12/12/2006 12:44' prior: 0!
There was an attempt to mutate an immutable configuration attribute.!

SPConfigurationException subclass: #SPInvalidConfigurationAttributeValueException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPInvalidConfigurationAttributeValueException commentStamp: 'as 1/8/2007 15:34' prior: 0!
The value didn't pass the value check of the configuration attribute.!

SPException subclass: #SPContactNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPContactNotFoundException commentStamp: '<historical>' prior: 0!
The contact was not found in the system.!

SPException subclass: #SPContactNotVerifiedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPContactNotVerifiedException commentStamp: '<historical>' prior: 0!
The contact is not verified.!

!SPException methodsFor: 'priv handling' stamp: 'as 8/17/2006 11:04'!
isResumable

	^ false.! !

SPException subclass: #SPInvalidMailAddressException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPInvalidMailAddressException commentStamp: '<historical>' prior: 0!
Invalid mail address.!

SPException subclass: #SPListNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPListNotFoundException commentStamp: '<historical>' prior: 0!
The list was not found in the system.!

SPException subclass: #SPQueueFullException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPQueueFullException commentStamp: '<historical>' prior: 0!
The queue is full, no further objects can be queued.!

SPException subclass: #SPReceiverException
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPReceiverException commentStamp: '<historical>' prior: 0!
Stamp receiver exception.!

SPReceiverException subclass: #SPConnectionClosedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPConnectionClosedException commentStamp: '<historical>' prior: 0!
The connection was unexpectedly closed.!

!SPConnectionClosedException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:07'!
defaultAction

	receiver clientQuit.! !

SPReceiverException subclass: #SPConnectionTimedOutException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPConnectionTimedOutException methodsFor: 'priv handling' stamp: 'as 12/11/2006 18:19'!
defaultAction

	receiver close: 'Connection timed out'.! !

!SPReceiverException class methodsFor: 'instance creation' stamp: 'as 10/18/2006 13:41'!
withReceiver: aSPMailReceiver

	^ self new
		receiver: aSPMailReceiver;
		yourself.! !

!SPReceiverException methodsFor: 'access' stamp: 'as 10/18/2006 13:40'!
receiver: aSPMailReceiver

	receiver := aSPMailReceiver.! !

SPReceiverException subclass: #SPSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPSmtpException commentStamp: '<historical>' prior: 0!
An SMTP command from the client has failed on the server.!

SPSmtpException subclass: #SPCommandNotAllowedSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPCommandNotAllowedSmtpException commentStamp: '<historical>' prior: 0!
The command is not allowed in the current state of the server.!

!SPCommandNotAllowedSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpException subclass: #SPCommandNotFoundSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPCommandNotFoundSmtpException commentStamp: '<historical>' prior: 0!
The specified command was not found.!

!SPCommandNotFoundSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

SPSmtpException subclass: #SPLineTooLongSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPLineTooLongSmtpException methodsFor: 'priv handling' stamp: 'as 10/17/2006 22:43'!
reply

	^ SPSmtpReply lineTooLong.! !

!SPSmtpException methodsFor: 'priv handling' stamp: 'as 10/3/2006 15:50'!
defaultAction

	receiver reply: self reply.! !

!SPSmtpException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:05'!
reply

	"Every command failure should be replied to the client."

	self subclassResponsibility.! !

SPSmtpException subclass: #SPTooManyRecipientsSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPTooManyRecipientsSmtpException methodsFor: 'priv handling' stamp: 'as 10/18/2006 20:40'!
reply

	^ SPSmtpReply tooManyRecipients.! !

SPSmtpException subclass: #SPTooMuchMailDataSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPTooMuchMailDataSmtpException methodsFor: 'priv handling' stamp: 'as 10/18/2006 17:46'!
reply

	^ SPSmtpReply tooMuchMailData.! !

SPSmtpException subclass: #SPWrongCommandSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPWrongCommandSmtpException commentStamp: '<historical>' prior: 0!
Wrong parameters or arguments. !

!SPWrongCommandSmtpException methodsFor: 'priv handling' stamp: 'as 9/14/2006 13:59'!
reply

	^ SPSmtpReply wrongParameterOrArgument.! !

SPReceiverException subclass: #SPTooManyConnectionsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPTooManyConnectionsException commentStamp: '<historical>' prior: 0!
There are too many connections, the current connection will be aborted.!

!SPTooManyConnectionsException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:08'!
defaultAction

	receiver close: 'Too many connections'.! !

SPException subclass: #SPSubscriptionNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPSubscriptionNotFoundException commentStamp: '<historical>' prior: 0!
The subscription was not found in the system.!

SPException subclass: #SPSyntaxException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPSyntaxException commentStamp: '<historical>' prior: 0!
Stamp syntax exception.!

SPException subclass: #SPTooMuchDataException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPTooMuchDataException commentStamp: '<historical>' prior: 0!
The received data exceeds the limits.!

SPException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPUserNotFoundException commentStamp: '<historical>' prior: 0!
The user was not found in the system.!

SPException subclass: #SPWrongPasswordException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPWrongPasswordException commentStamp: '<historical>' prior: 0!
The given password is not correct.!

Object subclass: #SPConfiguration
	instanceVariableNames: 'attributes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfiguration commentStamp: 'as 1/8/2007 13:08' prior: 0!
Stamp configuration.
Stores configuration attributes and connects them to a symbol. The values of the attributes are called preferences and can be changed with the appropriate methods.!

!SPConfiguration methodsFor: 'attributes' stamp: 'as 12/13/2006 13:47'!
attributeAt: aSymbol

	^ attributes at: aSymbol ifAbsent: [ SPConfigurationAttributeNotFoundException signal. ].! !

!SPConfiguration methodsFor: 'attributes' stamp: 'as 12/12/2006 11:01'!
attributeAt: aSymbol put: aSPConfigurationAttribute

	attributes at: aSymbol put: aSPConfigurationAttribute.! !

!SPConfiguration methodsFor: 'initialize-release' stamp: 'as 12/12/2006 18:05'!
initialize

	attributes _ Dictionary new.! !

!SPConfiguration methodsFor: 'preferences' stamp: 'as 12/12/2006 10:58'!
preferenceAt: aSymbol

	^ (self attributeAt: aSymbol) value.! !

!SPConfiguration methodsFor: 'preferences' stamp: 'as 12/12/2006 10:59'!
preferenceAt: aSymbol put: anObject

	(self attributeAt: aSymbol) value: anObject.! !

SPConfiguration subclass: #SPStampConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPStampConfiguration commentStamp: 'as 12/12/2006 14:45' prior: 0!
Default Stamp configuration.!

!SPStampConfiguration methodsFor: 'initialize-release' stamp: 'as 12/12/2006 18:06'!
initialize

	super initialize.

	"base"
	self attributeAt: #resolverTimeout put:
		(SPIntegerConfigurationAttribute withValue: 3 min: 1 max: 100).
	self attributeAt: #serverName put:
		(SPStringConfigurationAttribute withValue: NetNameResolver localHostName).
	self attributeAt: #timezone put:
		(SPStringConfigurationAttribute withValue: '+0100').

	"listener"
	self attributeAt: #listenerMaxConnections put:
		(SPIntegerConfigurationAttribute withValue: 10 min: 0 max: 1000).
	self attributeAt: #listenerPort put:
		(SPIntegerConfigurationAttribute withValue: 2525 min: 1 max: 65536).
		
	"receiver"
	self attributeAt: #receiverMaxMailSize put:
		(SPIntegerConfigurationAttribute withValue: 1024 * 1024 min: 64 * 1024 max: 4096 * 1024).
	self attributeAt: #receiverMaxRecipients put:
		(SPIntegerConfigurationAttribute withValue: 10 min: 1 max: 100).
		
	"sender"
	self attributeAt: #senderPort put:
		(SPIntegerConfigurationAttribute withValue: 25 min: 1 max: 65536).
	self attributeAt: #senderServer put:
		(SPStringConfigurationAttribute withValue: 'smtp.unibe.ch').
		
	"queue"
	self attributeAt: #queueSize put:
		(SPIntegerConfigurationAttribute withValue: 1000 min: 1 max: 10000).
	self attributeAt: #queueInterval put:
		(SPIntegerConfigurationAttribute withValue: 120 min: 60 max: 600).

	"contacts"
	self attributeAt: #contactVerificationLength put:
		(SPIntegerConfigurationAttribute withValue: 32 min: 8 max: 512).! !

Object subclass: #SPConfigurationAttribute
	instanceVariableNames: 'value mutable'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurationAttribute commentStamp: 'as 1/8/2007 15:27' prior: 0!
Stamp configuration attribute.
Stores one value of any type that can be set or retrieved. A new value is checked against the configured type and checkValue: is called which is intended to be overwritten in subclasses. There is also some code for mutability: setting a new value will fail if the instance is not mutable. As for now, mutability isn't really used, that means it is checked but by default it is mutable.!

!SPConfigurationAttribute class methodsFor: 'instance creation' stamp: 'as 12/12/2006 12:56'!
withValue: anObject

	^ self new value: anObject.! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 12/12/2006 12:45'!
checkMutable

	mutable ifFalse: [ SPImmutableConfigurationAttributeException signal. ].! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 12/12/2006 12:50'!
checkValue: anObject

	(anObject isKindOf: self type) ifFalse:
		[SPInvalidConfigurationAttributeValueException signal: 'Value should be of kind: ', self type asString. ].! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 12:47'!
immutable

	mutable _ false.! !

!SPConfigurationAttribute methodsFor: 'initialize-release' stamp: 'as 12/12/2006 14:42'!
initialize

	mutable _ true.! !

!SPConfigurationAttribute methodsFor: 'test' stamp: 'as 12/12/2006 12:47'!
isMutable

	^ mutable.! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 12:47'!
mutable

	mutable := true.! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 12:41'!
type

	^ Object.! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 10:01'!
value

	^ value.! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 12:45'!
value: anObject

	self checkMutable.
	self checkValue: anObject.
	value _ anObject.! !

SPConfigurationAttribute subclass: #SPNumberConfigurationAttribute
	instanceVariableNames: 'min max'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPNumberConfigurationAttribute commentStamp: 'as 1/8/2007 15:35' prior: 0!
Stamp number configuration attribute.!

SPNumberConfigurationAttribute subclass: #SPIntegerConfigurationAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPIntegerConfigurationAttribute commentStamp: 'as 1/8/2007 15:34' prior: 0!
Stamp integer configuration attribute.!

!SPIntegerConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 14:35'!
type

	^ Integer.! !

!SPNumberConfigurationAttribute class methodsFor: 'instance creation' stamp: 'as 12/12/2006 17:42'!
withValue: valueNumber max: maxNumber min: minNumber

	^ self withValue: valueNumber min: minNumber max: maxNumber.! !

!SPNumberConfigurationAttribute class methodsFor: 'instance creation' stamp: 'as 12/12/2006 17:42'!
withValue: valueNumber min: minNumber max: maxNumber

	^ self new
		min: minNumber;
		max: maxNumber;
		value: valueNumber.! !

!SPNumberConfigurationAttribute methodsFor: 'check' stamp: 'as 12/12/2006 14:34'!
checkLimits: aNumber

	aNumber < min ifTrue:
		[ SPInvalidConfigurationAttributeValueException
			signal: 'Value should not be smaller than ', min. ].
	aNumber > max ifTrue:
		[ SPInvalidConfigurationAttributeValueException
			signal: 'Value should not be higher than ', max. ].! !

!SPNumberConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 14:28'!
checkValue: aNumber

	super checkValue: aNumber.
	self checkLimits: aNumber.! !

!SPNumberConfigurationAttribute methodsFor: 'access' stamp: 'as 12/12/2006 13:00'!
max: aNumber

	max _ aNumber.! !

!SPNumberConfigurationAttribute methodsFor: 'access' stamp: 'as 12/12/2006 13:00'!
min: aNumber

	min _ aNumber.! !

!SPNumberConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 13:11'!
type

	^ Number.! !

SPConfigurationAttribute subclass: #SPStringConfigurationAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPStringConfigurationAttribute commentStamp: 'as 1/8/2007 15:38' prior: 0!
Stamp string configuration attribute.!

!SPStringConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 14:48'!
type

	^ String.! !

Object subclass: #SPDummy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPDummy commentStamp: '<historical>' prior: 0!
An object that understands every message. All messages that are not inherited are dumb, they do nothing but return self. Useful for testing.!

!SPDummy class methodsFor: 'system primitives' stamp: 'as 9/14/2006 10:16'!
doesNotUnderstand: aMessage

	^ self.! !

!SPDummy methodsFor: 'system primitives' stamp: 'as 9/14/2006 10:14'!
doesNotUnderstand: aMessage

	^ self.! !

Object subclass: #SPKernel
	instanceVariableNames: 'database listener sender manager queue archive configurator monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

SPKernel class
	instanceVariableNames: 'db instance database'!

!SPKernel commentStamp: 'as 12/12/2006 14:57' prior: 0!
The core of Stamp.
Holds references to all important components and manages the database.!

SPKernel class
	instanceVariableNames: 'db instance database'!

!SPKernel class methodsFor: 'instance creation' stamp: 'as 12/12/2006 16:13'!
instance

	^ instance ifNil: [ instance _ self basicNew initialize. ].! !

!SPKernel class methodsFor: 'instance creation' stamp: 'as 8/8/2006 16:20'!
new

	self shouldNotImplement.! !

!SPKernel methodsFor: 'access' stamp: 'as 6/12/2006 14:08'!
archive

	^ archive.! !

!SPKernel methodsFor: 'database' stamp: 'as 12/11/2006 16:50'!
closeDatabase

	database ifNotNil: [
		database
			disconnect;
			closeRepository.
		database := nil.
	].! !

!SPKernel methodsFor: 'access' stamp: 'as 12/12/2006 17:32'!
configurator

	^ configurator.! !

!SPKernel methodsFor: 'access' stamp: 'as 12/4/2006 11:49'!
database

	^ database.! !

!SPKernel methodsFor: 'database' stamp: 'as 12/4/2006 13:39'!
databaseCritical: aBlock

	| result |
	monitor critical: [ database commit: [ result _ aBlock value. ]. ].
	^ result.! !

!SPKernel methodsFor: 'database' stamp: 'as 11/29/2006 08:40'!
databaseUser

	^ 'stamp'.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 12/13/2006 10:59'!
initialize

	configurator _ SPConfigurator withKernel: self.
	listener _ SPMailListener withKernel: self.
	sender _ SPMailSender withKernel: self.
	archive _ SPMailArchive withKernel: self.
	manager _ SPListManager withKernel: self.
	queue _ SPMailQueue withKernel: self.
	monitor _ Monitor new.! !

!SPKernel methodsFor: 'database' stamp: 'as 12/12/2006 17:01'!
initializeDatabase: pathString

	MagmaRepositoryController create: pathString root: Dictionary new.
	database _ MagmaSession openLocal: pathString.
	database connectAs: self databaseUser.
	database commit: [
		database root at: #configuration put: (SPStampConfiguration new).
		database root at: #model put: Dictionary new.
		(database root at: #model)
			at: #users put: Set new;
			at: #lists put: Set new;
			at: #subscriptions put: Set new.
		database root at: #queue put: MagmaCollection new.
		database root at: #archive put: MagmaCollection new.
	].! !

!SPKernel methodsFor: 'access' stamp: 'as 3/10/2006 16:19'!
listener

	^ listener.! !

!SPKernel methodsFor: 'access' stamp: 'as 8/18/2006 19:37'!
manager

	^ manager.! !

!SPKernel methodsFor: 'database' stamp: 'as 12/13/2006 13:44'!
openDatabase: pathString

	database ifNil: [
		[ database _ MagmaSession openLocal: pathString.
		  database connectAs: self databaseUser. ]
			on: MagmaEnvironmentError
			do: [ self initializeDatabase: pathString. ].
	].! !

!SPKernel methodsFor: 'access' stamp: 'as 11/15/2006 18:03'!
queue

	^ queue.! !

!SPKernel methodsFor: 'access' stamp: 'as 10/5/2006 13:36'!
sender

	^ sender.! !

!SPKernel methodsFor: 'start-stop' stamp: 'as 12/13/2006 12:59'!
startOnLocalDatabase: pathString

	self openDatabase: pathString.
	sender start.
	queue start.
	listener start.! !

!SPKernel methodsFor: 'start-stop' stamp: 'as 12/13/2006 12:59'!
stop

	listener stop.
	queue stop.
	listener waitForStop.
	queue waitForStop.
	sender stop.
	self closeDatabase.! !

Object subclass: #SPList
	instanceVariableNames: 'address name moderated active closed visible'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPList commentStamp: '<historical>' prior: 0!
A mailing list.!

!SPList class methodsFor: 'instance creation' stamp: 'as 10/5/2006 14:47'!
withAddress: aSPMailAddress name: aString

	^ self new
		address: aSPMailAddress;
		name: aString;
		yourself.! !

!SPList methodsFor: 'compare' stamp: 'as 9/26/2006 17:10'!
= aSPList

	^ address = aSPList address.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 14:14'!
activate

	active := true.! !

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address

	^ address.! !

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:28'!
close

	closed := true.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 14:14'!
deactivate

	active := false.! !

!SPList methodsFor: 'compare' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:33'!
hide

	visible := false.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 10/19/2006 11:33'!
initialize

	self unmoderate.
	self activate.
	self close.
	self hide.! !

!SPList methodsFor: 'test' stamp: 'as 9/5/2006 14:14'!
isActive

	^ active.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:29'!
isClosed

	^ closed.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:31'!
isHidden

	^ visible not.! !

!SPList methodsFor: 'test' stamp: 'as 9/5/2006 13:03'!
isModerated

	^ moderated.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:29'!
isOpen

	^ closed not.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:30'!
isVisible

	^ visible.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 13:05'!
moderate

	moderated := true.! !

!SPList methodsFor: 'access' stamp: 'as 10/5/2006 14:47'!
name

	^ name.! !

!SPList methodsFor: 'access' stamp: 'as 10/5/2006 14:47'!
name: aString

	name := aString.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:28'!
open

	closed := false.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:33'!
show

	visible := true.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 13:05'!
unmoderate

	moderated := false.! !

Object subclass: #SPMailAddress
	instanceVariableNames: 'localPart domain'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPMailAddress commentStamp: '<historical>' prior: 0!
An electronic mail address.
Consists of a local part (part before '@') which is case sensitive and a domain (part after '@') that is case insensitive.!

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 11/7/2006 16:26'!
fromPath: aString

	| address localPart domain |
	address := self mailPathToAddress: aString.
	localPart := address copyUpTo: $@.
	domain := (address copyAfter: $@) asLowercase.
	(localPart isNil or: [ domain isNil. ])
		ifTrue: [ SPInvalidMailAddressException signal. ].
	^ self new
		localPart: localPart;
		domain: domain.! !

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 11/7/2006 16:22'!
mailPathToAddress: aString

	| address |
	(SPSyntax isMailPath: aString)
		ifFalse: [ SPInvalidMailAddressException signal. ].
	address := aString copyFrom: 2 to: aString size - 1.
	(address includes: $:) ifTrue: [ address := address copyAfterLast: $:. ].
	^ address.! !

!SPMailAddress methodsFor: 'compare' stamp: 'as 10/21/2006 12:10'!
= aSPMailAddress

	^ self asString = aSPMailAddress asString.! !

!SPMailAddress methodsFor: 'print' stamp: 'as 10/21/2006 12:10'!
asString

	^ localPart, '@', domain.! !

!SPMailAddress methodsFor: 'access' stamp: 'as 6/8/2006 16:51'!
domain

	^ domain.! !

!SPMailAddress methodsFor: 'access' stamp: 'as 10/19/2006 19:01'!
domain: aString

	domain := aString asLowercase.! !

!SPMailAddress methodsFor: 'compare' stamp: 'as 10/21/2006 12:10'!
hash

	^ self asString hash.! !

!SPMailAddress methodsFor: 'access' stamp: 'as 6/8/2006 17:32'!
localPart

	^ localPart.! !

!SPMailAddress methodsFor: 'access' stamp: 'as 6/8/2006 17:31'!
localPart: aString

	localPart := aString.! !

!SPMailAddress methodsFor: 'print' stamp: 'as 9/26/2006 16:57'!
path

	^ '<', localPart, '@', domain, '>'.! !

Object subclass: #SPObject
	instanceVariableNames: 'kernel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPObject commentStamp: 'as 12/12/2006 14:55' prior: 0!
A Stamp object is distinguished only by a reference to the Stamp kernel.!

SPObject subclass: #SPConfigurator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurator commentStamp: 'as 1/8/2007 15:29' prior: 0!
Stamp configurator.
!

!SPConfigurator methodsFor: 'configuration' stamp: 'as 12/12/2006 17:02'!
configuration

	^ kernel database root at: #configuration.! !

!SPConfigurator methodsFor: 'configuration' stamp: 'as 12/12/2006 17:14'!
preferenceAt: aSymbol

	^ kernel databaseCritical: [
		self configuration preferenceAt: aSymbol.
	].! !

!SPConfigurator methodsFor: 'configuration' stamp: 'as 12/12/2006 17:17'!
preferenceAt: aSymbol put: anObject

	kernel databaseCritical: [
		self configuration preferenceAt: aSymbol put: anObject.
	].! !

SPObject subclass: #SPListManager
	instanceVariableNames: 'monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPListManager commentStamp: 'as 12/4/2006 12:39' prior: 0!
Access/modify lists, users, contacts and subscriptions.!

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:40'!
addContact: aSPContact user: aSPUser

	self critical: [
		aSPUser addContact: aSPContact.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:40'!
addList: aSPList

	self critical: [
		self lists add: aSPList.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:45'!
addUser: aSPUser

	self critical: [
		self users add: aSPUser.
	].! !

!SPListManager methodsFor: 'get-list' stamp: 'as 12/4/2006 13:48'!
allLists

	^ self critical: [ self lists. ].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 12/4/2006 13:52'!
allSubscriptions

	^ self critical: [ self subscriptions. ].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 12/4/2006 14:27'!
allUsers

	^ self critical: [ self users. ].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 12/4/2006 14:47'!
contactWithAddress: aSPMailAddress

	| contact |
	self critical: [
		self users detect: [
			:user |
			contact _ user contacts detect: [ :each | each address = aSPMailAddress. ] ifNone: [ nil. ].
			contact notNil.
		].
	].
	^ contact.! !

!SPListManager methodsFor: 'access' stamp: 'as 12/4/2006 13:39'!
critical: aBlock

	^ kernel databaseCritical: aBlock.! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 12/4/2006 12:37'!
initialize

	monitor _ Monitor new.! !

!SPListManager methodsFor: 'test' stamp: 'as 12/4/2006 14:52'!
isAllowed: aSPMailAddress postTo: aSPList

	| user |
	user _ self userWithAddress: aSPMailAddress.
	^ aSPList isModerated not and: [
		aSPList isOpen or: [
			user notNil and: [ self isSubscribed: user to: aSPList. ].
		].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 12/4/2006 15:01'!
isSubscribed: aSPUser to: aSPList

	^ self critical: [
		(self subscriptions detect: [
			:subscription |
			subscription list = aSPList and: [ aSPUser contacts includes: subscription contact. ].
		]) notNil.
	].! !

!SPListManager methodsFor: 'get-list' stamp: 'as 12/4/2006 13:51'!
listWithAddress: aSPMailAddress

	^ self critical: [
		self lists
			detect: [ :each | each address = aSPMailAddress. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'access' stamp: 'as 12/4/2006 12:45'!
lists

	^ (kernel database root at: #model) at: #lists.! !

!SPListManager methodsFor: 'get-other' stamp: 'as 12/4/2006 15:02'!
recipientsForList: aSPList

	| activeSubscriptions |
	^ self critical: [
		activeSubscriptions _ self subscriptions select: [ :each | each list = aSPList and: [ each isActive. ]. ].
		activeSubscriptions collect: [ :subscription | subscription contact address. ].
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:45'!
removeContact: aSPContact

	self critical: [
		aSPContact user removeContact: aSPContact.
		self subscriptions removeAll: (self subscriptionsForContact: aSPContact).
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:46'!
removeList: aSPList

	self critical: [
		self lists remove: aSPList ifAbsent: [ SPListNotFoundException signal. ].
		self subscriptions removeAll: (self subscriptionsForList: aSPList).
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 12/4/2006 13:46'!
removeUser: aSPUser

	self critical: [
		self users remove: aSPUser ifAbsent: [ SPUserNotFoundException signal. ].
		self subscriptions removeAll: (self subscriptionsForUser: aSPUser).
	].! !

!SPListManager methodsFor: 'subscription' stamp: 'as 12/4/2006 15:04'!
subscribe: aSPContact to: aSPList

	| subscription |
	aSPContact isVerified ifFalse: [ SPContactNotVerifiedException signal. ].
	subscription _ SPSubscription withList: aSPList contact: aSPContact.
	^ self critical: [ self subscriptions add: subscription. ].! !

!SPListManager methodsFor: 'access' stamp: 'as 12/4/2006 12:45'!
subscriptions

	^ (kernel database root at: #model) at: #subscriptions.! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 12/4/2006 13:53'!
subscriptionsForContact: aSPContact

	^ self critical: [ self subscriptions select: [ :each | aSPContact = each contact. ]. ].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 12/4/2006 14:21'!
subscriptionsForList: aSPList

	^ self critical: [ self subscriptions select: [ :each | each list = aSPList. ]].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 12/4/2006 14:26'!
subscriptionsForUser: aSPUser

	| contacts |
	^ self critical: [
		contacts _ Set withAll: aSPUser contacts.
		self subscriptions select: [ :each | contacts includes: each contact. ].
	].! !

!SPListManager methodsFor: 'subscription' stamp: 'as 12/4/2006 15:04'!
unsubscribe: aSPSubscription

	self critical: [
		self subscriptions remove: aSPSubscription ifAbsent: [ SPSubscriptionNotFoundException signal. ].
	].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 12/4/2006 14:27'!
userWithAddress: aSPMailAddress

	^ self critical: [
		self users
			detect: [ :each | each contacts includes: aSPMailAddress. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 12/4/2006 14:27'!
userWithName: aString

	^ self critical: [
		self users
			detect: [ :each | each name = aString. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'access' stamp: 'as 12/4/2006 12:45'!
users

	^ (kernel database root at: #model) at: #users.! !

SPObject subclass: #SPMailArchive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Storage'!

!SPMailArchive commentStamp: '<historical>' prior: 0!
Mail archive that basically wraps around MailDB.!

!SPMailArchive methodsFor: 'store' stamp: 'as 11/17/2006 14:52'!
addMessage: aMailMessage toList: aSPList

		| dir |
		dir := self archiveDir, '/', aSPList address asString.
		(MailDB openOn: dir) addNewMessage: aMailMessage.! !

!SPMailArchive methodsFor: 'preferences' stamp: 'as 10/16/2006 19:17'!
archiveDir

	^ self preferenceAt: #archiveDir.! !

SPObject subclass: #SPMailListener
	instanceVariableNames: 'service connections monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailListener commentStamp: '<historical>' prior: 0!
Listens for incoming SMTP connections and treats them appropriately.!

!SPMailListener methodsFor: 'connection' stamp: 'as 11/8/2006 11:09'!
addConnection: aSPMailReceiver

	monitor critical: [
		self checkConnections: aSPMailReceiver.
		connections add: aSPMailReceiver.
	].! !

!SPMailListener methodsFor: 'check' stamp: 'as 11/8/2006 22:11'!
checkConnections: aSPMailReceiver

	connections size >= self listenerMaxConnections ifTrue: [
		(SPTooManyConnectionsException withReceiver: aSPMailReceiver) signal.
	].! !

!SPMailListener methodsFor: 'initialize-release' stamp: 'as 12/13/2006 11:02'!
initialize

	service _ SPMailService withListener: self.
	monitor _ Monitor new.
	connections _ IdentitySet new.! !

!SPMailListener methodsFor: 'preferences' stamp: 'as 11/8/2006 11:06'!
listenerMaxConnections

	^ self preferenceAt: #listenerMaxConnections.! !

!SPMailListener methodsFor: 'preferences' stamp: 'as 11/16/2006 14:13'!
listenerPort

	^ self preferenceAt: #listenerPort.! !

!SPMailListener methodsFor: 'connection' stamp: 'as 11/8/2006 11:04'!
removeConnection: aSPMailReceiver

	monitor critical: [ connections remove: aSPMailReceiver. ].! !

!SPMailListener methodsFor: 'access' stamp: 'as 9/14/2006 09:57'!
service

	^ service.! !

!SPMailListener methodsFor: 'start-stop' stamp: 'as 12/13/2006 11:02'!
start

	service startOn: self listenerPort.! !

!SPMailListener methodsFor: 'start-stop' stamp: 'as 12/4/2006 15:28'!
stop

	service stop.! !

!SPMailListener methodsFor: 'start-stop' stamp: 'as 12/5/2006 14:08'!
waitForStop

	service waitForStop.! !

SPObject subclass: #SPMailQueue
	instanceVariableNames: 'process run processMonitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Mail queue.!

!SPMailQueue methodsFor: 'queue' stamp: 'as 12/11/2006 14:43'!
add: aSPMailMessage

	self critical: [
		self queue add: aSPMailMessage.
	].! !

!SPMailQueue methodsFor: 'check' stamp: 'as 12/11/2006 15:40'!
checkQueueNotFull

	self queue size >= self queueSize ifTrue: [
		SPQueueFullException signal.
	].! !

!SPMailQueue methodsFor: 'access' stamp: 'as 12/11/2006 14:42'!
critical: aBlock

	^ kernel databaseCritical: aBlock.! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/5/2006 13:56'!
delayQueueStartedAt: aDateAndTime

	| processTime delayTime |
	processTime _ (DateAndTime now - aDateAndTime) asSeconds.
	delayTime _ self queueInterval - processTime.
	delayTime > 0 ifTrue: [ processMonitor waitFor: delayTime. ].! !

!SPMailQueue methodsFor: 'queue' stamp: 'as 11/15/2006 17:58'!
enqueue: aSPMailMessage

	self checkQueueNotFull.
	aSPMailMessage
		ensureMessageId: self serverName;
		insertReturnPath.
	self add: aSPMailMessage.! !

!SPMailQueue methodsFor: 'util' stamp: 'as 11/14/2006 15:10'!
forever: aBlock

	[ true. ] whileTrue: [ aBlock value. ].! !

!SPMailQueue methodsFor: 'initialize-release' stamp: 'as 12/11/2006 14:44'!
initialize

	processMonitor _ Monitor new.
	process _ [ self processQueue. ] newProcess.
	run _ false.! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/16/2006 14:06'!
messageInterval

	^ self preferenceAt: #messageInterval.! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/16/2006 14:06'!
messageLifetime

	^ self preferenceAt: #messageLifetime.! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/11/2006 15:01'!
processMessage: aSPMailMessage

	[
		SPMailMessage state = #new ifTrue: [ self processNewMessage: aSPMailMessage. ].
		SPMailMessage state = #saved ifTrue: [ self processSavedMessage: aSPMailMessage. ].
	]
	on: Exception do: [ :ex | ex return. ].! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/11/2006 15:03'!
processNewMessage: aSPMailMessage

	| list |
	list _ kernel manager listWithAddress: aSPMailMessage recipient.
	list ifNotNil: [
		"kernel archive addMessage: aSPMailMessage toList: list."
		aSPMailMessage state: #saved.
	].! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/11/2006 15:17'!
processQueue

	| start |
	self forever: [
		processMonitor critical: [
			run ifFalse: [ processMonitor wait. ].
			start _ DateAndTime now.
			self queue do: [
				:message |
				self processMessage: message.
			].
			processMonitor waitMaxSeconds: (self queueDelay: start).
		].
	].! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/11/2006 15:08'!
processSavedMessage: aSPMailMessage

	| list sender |
	list _ kernel manager listWithAddress: aSPMailMessage recipient.
	list ifNotNil: [
		sender _ aSPMailMessage sender.
		(kernel manager isAllowed: sender postTo: list) ifTrue: [
			kernel sender
				sendMessage: aSPMailMessage mail
				from: sender
				to: (kernel recipientsForList: list).
			self remove: aSPMailMessage.
		].
	].! !

!SPMailQueue methodsFor: 'access' stamp: 'as 12/11/2006 14:38'!
queue

	^ kernel database root at: #queue.! !

!SPMailQueue methodsFor: 'processing' stamp: 'as 12/11/2006 15:18'!
queueDelay: aDateAndTime

	| elapsed delay |
	elapsed _ (DateAndTime now - aDateAndTime) asSeconds.
	delay _ self queueInterval - elapsed.
	delay < 0 ifTrue: [ delay _ 0. ].
	^ delay.! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/16/2006 14:06'!
queueFile

	^ self preferenceAt: #queueFile.! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/16/2006 14:06'!
queueInterval

	^ self preferenceAt: #queueInterval.! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/16/2006 14:06'!
queueSize

	^ self preferenceAt: #queueSize.! !

!SPMailQueue methodsFor: 'queue' stamp: 'as 12/11/2006 14:43'!
remove: aSPMailMessage

	self critical: [
		self queue remove: aSPMailMessage.
	].! !

!SPMailQueue methodsFor: 'preferences' stamp: 'as 11/15/2006 15:00'!
serverName

	^ self preferenceAt: #serverName.! !

!SPMailQueue methodsFor: 'start-stop' stamp: 'as 12/11/2006 15:44'!
start

	run _ true.
	process isSuspended ifTrue: [
		processMonitor critical: [ processMonitor signal. ].
	].! !

!SPMailQueue methodsFor: 'start-stop' stamp: 'as 12/5/2006 13:12'!
stop

	run _ false.! !

!SPMailQueue methodsFor: 'start-stop' stamp: 'as 12/5/2006 13:56'!
waitForStop

	processMonitor critical: [ . ].! !

SPObject subclass: #SPMailReceiver
	instanceVariableNames: 'state stream quit messages'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server trying to follow RFC 2821. It only receives mail. One receiver serves one client connection, and the whole will usually be multithreaded.

A SPMailReceiver is created on a socket. Mail reception starts with the receive method. After its return received data is available in the message.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 11/16/2006 14:19'!
withKernel: aSPKernel stream: aSocketStream

	^ (self withKernel: aSPKernel)
		stream: aSocketStream;
		postInit;
		yourself.! !

!SPMailReceiver methodsFor: 'check' stamp: 'as 11/16/2006 19:26'!
checkNumberOfRecipients

	messages size >= self receiverMaxRecipients ifTrue: [
		(SPTooManyRecipientsSmtpException withReceiver: self) signal.
	].! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 11/15/2006 18:29'!
clientQuit

	quit := true.! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 11/16/2006 17:08'!
close: aString

	self replyClosing: aString.
	stream close.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 10/5/2006 14:22'!
initMessages

	messages := OrderedCollection new.
	messages add: SPMailMessage new.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 11/16/2006 14:20'!
initialize

	quit := false.
	self initMessages.
	self state: SPReadySmtpState.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 11/15/2006 12:44'!
insertTrace

	| local remote |
	local := self localName ifNil: [ self localAddress. ].
	remote := self remoteName ifNil: [ self remoteAddress. ].
	messages do: [
		:message |
		message insertTraceFrom: local by: remote.
	].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 10/17/2006 22:30'!
lineDelimiter

	^ String crlf.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:39'!
localAddress

	^ stream socket localAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 23:31'!
localName

	^ self nameForAddress: self localAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:40'!
localPort

	^ stream socket localPort.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 14:12'!
mail: aString

	messages do: [ :message | message mail: aString. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 11/16/2006 19:42'!
mailDelimiter

	^ '.', String crlf.! !

!SPMailReceiver methodsFor: 'limits' stamp: 'as 10/18/2006 17:30'!
maxCommandLineLength

	^ 512.! !

!SPMailReceiver methodsFor: 'limits' stamp: 'as 10/18/2006 17:30'!
maxLineLength

	^ 1000.! !

!SPMailReceiver methodsFor: 'limits' stamp: 'as 10/18/2006 21:35'!
maxReplyLength

	^ 512.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 10/18/2006 14:02'!
nameForAddress: addressString

	^ NetNameResolver nameForAddress: addressString timeout: self resolverTimeout.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 11/16/2006 14:20'!
postInit

	kernel listener addConnection: self.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 11/15/2006 12:33'!
queueMessages

	messages do: [
		:message |
		kernel queue enqueue: message.
	].! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 11/16/2006 15:56'!
quit

	stream close.
	kernel listener removeConnection: self.! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 12/12/2006 09:11'!
receive

	"Receive commands from client as long as connection is there and
	 quit is not requested."
	"In case of an error the connection is closed."

	self reply: (SPSmtpReply ready: self serverName).
	[
		[
			[ quit not and: [ stream isConnected. ] ] whileTrue: [ self receiveCommand. ].
		] on: Exception do: [ self replyClosing: 'Unknown error'. ].
	] ensure: [ self quit. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 11/16/2006 15:35'!
receiveCommand

	"Find the appropriate command for a string line from the client and execute it."

	| line command |
	[ line := self receiveCommandLine.
	  command := SPSmtpCommand fromString: line target: self.
	  command execute. ]
		on: SPReceiverException
		do: [ :ex | ex defaultAction; return. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 11/16/2006 14:37'!
receiveCommandLine

	[ ^ self receiveUpTo: self lineDelimiter maxSize: self maxCommandLineLength. ]
		on: SPTooMuchDataException
		do: [ (SPLineTooLongSmtpException withReceiver: self) signal. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 10/18/2006 20:10'!
receiveLine

	[ ^ self receiveTo: self lineDelimiter maxSize: self maxLineLength. ]
		on: SPTooMuchDataException
		do: [ (SPLineTooLongSmtpException withReceiver: self) signal. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 11/16/2006 19:43'!
receiveMail

	| mail line overflow |
	mail := line := ''.
	overflow := false.
	[ line = self mailDelimiter. ] whileFalse: [
		overflow ifFalse: [
			mail := mail, line.
			overflow := mail size > self receiverMaxMailSize.
		].
		line := self receiveLine.
	].
	overflow ifTrue: [
		(SPTooMuchMailDataSmtpException withReceiver: self) signal.
	] ifFalse: [
		^ mail convertSmtpToSqueakText.
	].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 12/11/2006 18:25'!
receiveNext

	[ ^ stream next ifNil: [ (SPConnectionClosedException withReceiver: self) signal. ]. ]
		on: ConnectionTimedOut do: [ (SPConnectionTimedOutException withReceiver: self) signal. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 11/16/2006 15:38'!
receiveTo: aString maxSize: aNumber

	"Receives all data up to and including aString. After receiving if the data exceedes
	 aNumber an exception is thrown, otherwise the data is returned.
	 Receives but avoids storing data if aNumber is exceeded to prevent overflow."

	| data buffer overflow |
	data := buffer := ''.
	overflow := false.
	[ data endsWith: aString. ] whileFalse: [
		buffer := self receiveNext.
		overflow ifFalse: [
			data := data, buffer asString.
			overflow := data size >= aNumber.
		] ifTrue: [
			"add buffer to data but cut at start to prevent overflow"
			data := (data copyFrom: buffer asString size + 1 to: data size), buffer asString
		].
	].
	overflow ifTrue: [ SPTooMuchDataException signal. ] ifFalse: [ ^ data. ].! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 10/18/2006 21:37'!
receiveUpTo: aString maxSize: aNumber

	"Same as receiveTo:maxSize, but exclude aString in return."

	| data |
	data := self receiveTo: aString maxSize: aNumber.
	^ data first: (data size - aString size).! !

!SPMailReceiver methodsFor: 'preferences' stamp: 'as 10/18/2006 17:29'!
receiverMaxMailSize

	^ self preferenceAt: #receiverMaxMailSize.! !

!SPMailReceiver methodsFor: 'preferences' stamp: 'as 11/16/2006 19:27'!
receiverMaxRecipients

	^ self preferenceAt: #receiverMaxRecipients.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 11/15/2006 12:34'!
recipient: aSPMailAddress

	| last new |
	self checkNumberOfRecipients.
	last := messages last.
	last recipient ifNil: [
		last recipient: aSPMailAddress.
	] ifNotNil: [
		new := last copy.
		new recipient: aSPMailAddress.
		messages add: new.
	].! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:40'!
remoteAddress

	^ stream socket remoteAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 23:31'!
remoteName

	^ self nameForAddress: self remoteAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:40'!
remotePort

	^ stream socket remotePort.! !

!SPMailReceiver methodsFor: 'reply' stamp: 'as 11/8/2006 21:53'!
reply: aSPSmtpReply

	| reply |
	reply := aSPSmtpReply replyString, self lineDelimiter.
	reply size > self maxReplyLength ifTrue: [ reply := reply first: self maxReplyLength. ].
	stream nextPutAll: reply; flush.! !

!SPMailReceiver methodsFor: 'reply' stamp: 'as 11/16/2006 17:00'!
replyClosing: aString

	self reply: (SPSmtpReply closing: self serverName reason: aString).! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 10/5/2006 14:06'!
reset

	self initMessages.
	self state: SPResetSmtpState.! !

!SPMailReceiver methodsFor: 'preferences' stamp: 'as 10/18/2006 14:03'!
resolverTimeout

	^ self preferenceAt: #resolverTimeout.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 11/17/2006 15:35'!
sender: aSPMailAddress

	messages last sender: aSPMailAddress.! !

!SPMailReceiver methodsFor: 'preferences' stamp: 'as 10/17/2006 20:52'!
serverName

	^ self preferenceAt: #serverName.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 4/20/2006 17:45'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'access' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

SPObject subclass: #SPMailSender
	instanceVariableNames: 'client monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPMailSender commentStamp: '<historical>' prior: 0!
Send mails over an smtp server.!

!SPMailSender methodsFor: 'initialize-release' stamp: 'as 10/14/2006 12:56'!
initClient

	| hostIP |
	hostIP := NetNameResolver
		addressForName: (self preferenceAt: #senderServer)
		timeout: (self preferenceAt: #resolverTimeout).
	client := SPSmtpClient
		onHost: hostIP
		port: (self preferenceAt: #senderPort).! !

!SPMailSender methodsFor: 'initialize-release' stamp: 'as 12/13/2006 12:56'!
initialize

	monitor _ Monitor new.! !

!SPMailSender methodsFor: 'send' stamp: 'as 11/17/2006 13:35'!
sendMessage: aMailMessage from: aSPMailAddress to: aCollection

	monitor critical: [
		[
			client open; from: aSPMailAddress.
			aCollection do: [ :each | client to: each. ].
			client data: aMailMessage; quit.
		] ensure: [ client close. ].
	].! !

!SPMailSender methodsFor: 'start-stop' stamp: 'as 12/13/2006 12:56'!
start

	self initClient.! !

!SPMailSender methodsFor: 'start-stop' stamp: 'as 12/13/2006 12:57'!
stop

	client close.
	client _ nil.! !

!SPObject class methodsFor: 'instance creation' stamp: 'as 9/14/2006 13:46'!
withKernel: aSPKernel

	^ self new
		kernel: aSPKernel;
		yourself.! !

!SPObject methodsFor: 'access' stamp: 'as 9/13/2006 17:08'!
kernel

	^ kernel.! !

!SPObject methodsFor: 'access' stamp: 'as 9/13/2006 17:08'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPObject methodsFor: 'configuration' stamp: 'as 12/12/2006 17:33'!
preferenceAt: aSymbol

	^ kernel configurator preferenceAt: aSymbol.! !

!SPObject methodsFor: 'configuration' stamp: 'as 12/12/2006 17:33'!
preferenceAt: aSymbol put: anObject

	kernel configurator preferenceAt: aSymbol put: anObject.! !

Object subclass: #SPPassword
	instanceVariableNames: 'password'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPPassword commentStamp: '<historical>' prior: 0!
A password that can be checked and is store encrypted.!

!SPPassword class methodsFor: 'instance creation' stamp: 'as 9/26/2006 15:01'!
withPassword: aString

	^ self new
		new: aString;
		yourself.! !

!SPPassword methodsFor: 'check' stamp: 'as 9/26/2006 14:09'!
check: aString

	^ password = (self encrypt: aString).! !

!SPPassword methodsFor: 'private' stamp: 'as 9/26/2006 14:09'!
encrypt: aString

	^ SHA1 hashStream: (ReadStream on: aString).! !

!SPPassword methodsFor: 'private' stamp: 'as 9/26/2006 14:42'!
new: aString

	password := self encrypt: aString.! !

!SPPassword methodsFor: 'set' stamp: 'as 9/26/2006 14:44'!
new: newString old: oldString

	(self check: oldString) ifFalse: [ SPWrongPasswordException signal. ].
	self new: newString.! !

Object subclass: #SPSmtpCommand
	instanceVariableNames: 'argument target reply state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

SPSmtpCommand class
	instanceVariableNames: 'states'!

!SPSmtpCommand commentStamp: '<historical>' prior: 0!
SMTP commands are received by the server from the client.

I'm abstract, don't instantiate me. The method fromString:target: will return an instance of the appropriate subclass and should only be called on me.!

SPSmtpCommand class
	instanceVariableNames: 'states'!

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

!SPDataSmtpCommand methodsFor: 'execute' stamp: 'as 11/17/2006 15:18'!
doExecute

	target
		reply: SPSmtpReply mailInput;
		mail: target receiveMail;
		insertTrace;
		queueMessages;
		reset.
	self state: SPResetSmtpState.! !

!SPDataSmtpCommand methodsFor: 'execute' stamp: 'as 11/13/2006 16:35'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPEhloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPEhloSmtpCommand commentStamp: '<historical>' prior: 0!
The EHLO command is unimplemented since no service extension are needed/implemented.!

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:37'!
hasArgument

	^ true.! !

!SPEhloSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPReadySmtpState;
		yourself.! !

!SPEhloSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/7/2006 16:51'!
verb

	^ 'ehlo '.! !

!SPEhloSmtpCommand methodsFor: 'execute' stamp: 'as 4/21/2006 10:47'!
doExecute

	self reply: SPSmtpReply notImplemented.! !

!SPEhloSmtpCommand methodsFor: 'execute' stamp: 'as 4/21/2006 10:10'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPHeloSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPHeloSmtpCommand commentStamp: '<historical>' prior: 0!
HELO command is used by the client to initiate a new session with the server.!

!SPHeloSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:38'!
hasArgument

	^ true.! !

!SPHeloSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPReadySmtpState;
		yourself.! !

!SPHeloSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/7/2006 16:50'!
verb

	^ 'helo '.! !

!SPHeloSmtpCommand methodsFor: 'execute' stamp: 'as 6/8/2006 18:34'!
doExecute

	self state: SPResetSmtpState.! !

!SPHeloSmtpCommand methodsFor: 'execute' stamp: 'as 4/20/2006 19:37'!
doValidate

	"do hostname verification?"! !

SPSmtpCommand subclass: #SPMailSmtpCommand
	instanceVariableNames: 'sender'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPMailSmtpCommand commentStamp: '<historical>' prior: 0!
The MAIL command specifies the sender address.!

!SPMailSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:38'!
hasArgument

	^ true.! !

!SPMailSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:21'!
initStates

	"self initialize"

	^ Set new
		add: SPResetSmtpState;
		yourself.! !

!SPMailSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/16/2006 17:19'!
verb

	^ 'mail from:'.! !

!SPMailSmtpCommand methodsFor: 'execute' stamp: 'as 11/15/2006 12:21'!
doExecute

	target sender: sender.
	self state: SPMailSmtpState.! !

!SPMailSmtpCommand methodsFor: 'execute' stamp: 'as 10/18/2006 19:33'!
doValidate

	[ sender := SPMailAddress fromPath: argument. ]
		on: SPInvalidMailAddressException
		do: [ (SPWrongCommandSmtpException withReceiver: target) signal. ].! !

SPSmtpCommand subclass: #SPNoopSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPNoopSmtpCommand commentStamp: '<historical>' prior: 0!
NOOP means no operation. This command is recognized but ignored and has no effect on the server.!

!SPNoopSmtpCommand class methodsFor: 'class initialization' stamp: 'as 11/16/2006 17:36'!
initStates

	"self initialize"

	^ self allStates.! !

!SPNoopSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/12/2006 22:18'!
verb

	^ 'noop'.! !

!SPNoopSmtpCommand methodsFor: 'execute' stamp: 'as 11/16/2006 17:38'!
doExecute

	"nothing to do"! !

!SPNoopSmtpCommand methodsFor: 'execute' stamp: 'as 11/13/2006 16:36'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPQuitSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPQuitSmtpCommand commentStamp: '<historical>' prior: 0!
The client wants to quit the session.!

!SPQuitSmtpCommand class methodsFor: 'class initialization' stamp: 'as 11/16/2006 17:36'!
initStates

	"self initialize"

	^ self allStates.! !

!SPQuitSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 22:31'!
verb

	^ 'quit'.! !

!SPQuitSmtpCommand methodsFor: 'execute' stamp: 'as 11/16/2006 16:51'!
doExecute

	self reply: (SPSmtpReply quit: target serverName).
	target clientQuit.! !

!SPQuitSmtpCommand methodsFor: 'execute' stamp: 'as 11/13/2006 16:36'!
doValidate

	"nothing to do"! !

SPSmtpCommand subclass: #SPRecipientSmtpCommand
	instanceVariableNames: 'recipient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPRecipientSmtpCommand commentStamp: '<historical>' prior: 0!
The client specifies a recipient address.!

!SPRecipientSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:38'!
hasArgument

	^ true.! !

!SPRecipientSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/21/2006 11:12'!
initStates

	"self initialize"

	^ Set new
		add: SPMailSmtpState;
		add: SPRecipientSmtpState;
		yourself.! !

!SPRecipientSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/16/2006 17:20'!
verb

	^ 'rcpt to:'.! !

!SPRecipientSmtpCommand methodsFor: 'execute' stamp: 'as 12/4/2006 12:34'!
doExecute

	| list |
	list _ target kernel manager listWithAddress: recipient.
	list ifNil: [
		self reply: SPSmtpReply noSuchUser.
	] ifNotNil: [
		target recipient: recipient.
		self state: SPRecipientSmtpState.
	].! !

!SPRecipientSmtpCommand methodsFor: 'execute' stamp: 'as 10/18/2006 19:33'!
doValidate

	[ recipient := SPMailAddress fromPath: argument. ]
		on: SPInvalidMailAddressException
		do: [ (SPWrongCommandSmtpException withReceiver: target) signal. ].! !

SPSmtpCommand subclass: #SPResetSmtpCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPResetSmtpCommand commentStamp: '<historical>' prior: 0!
Resets the current session to start over from beginning.!

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

!SPResetSmtpCommand methodsFor: 'execute' stamp: 'as 4/21/2006 11:27'!
doExecute

	target reset.
	self state: SPResetSmtpState.! !

!SPResetSmtpCommand methodsFor: 'execute' stamp: 'as 11/13/2006 16:36'!
doValidate

	"nothing to do"! !

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 4/20/2006 15:56'!
allStates

	^ SPSmtpState allSubclasses.! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 11/8/2006 11:37'!
argumentFor: aString command: aSmtpCommand

	"Find arguments in a line assuming the given verb for the command."

	aString size > aSmtpCommand verb size ifTrue: [
		^ aString copyFrom: (aSmtpCommand verb size + 1) to: aString size.
	] ifFalse: [
		^ ''.
	].! !

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 10/21/2006 13:04'!
commandFor: aString target: aSPMailReceiver

	"Extract command and return an instance of the appropriate command class.
	 The verb string for a SMTP command is case insensitive."

	| class |
	class := self allSubclasses detect: [
		:each |
		aString asLowercase beginsWith: each verb asLowercase.
	] ifNone: [
		nil	
	].
	class isNil ifTrue: [ (SPCommandNotFoundSmtpException withReceiver: aSPMailReceiver) signal. ].
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

!SPSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:31'!
hasArgument

	^ false.! !

!SPSmtpCommand class methodsFor: 'class initialization' stamp: 'as 9/27/2006 11:53'!
initStates

	"Returns a collection of states this command is allowed to execute in."
	
	"IMPORTANT: changes made here or in called methods do only have effect
	 after reinitialization of the class!!"

	"self initialize"
	"self allSubclasses do: [ :each | each initialize. ]"! !

!SPSmtpCommand class methodsFor: 'class initialization' stamp: 'as 4/15/2006 16:12'!
initialize

	states := self initStates.! !

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 4/15/2006 16:11'!
states

	^ states.! !

!SPSmtpCommand class methodsFor: 'smtp' stamp: 'as 11/7/2006 16:54'!
verb

	"The string representation for this command in SMTP (must be treated case insensitive)."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'access' stamp: 'as 1/10/2006 21:49'!
argument: aString

	argument := aString.! !

!SPSmtpCommand methodsFor: 'check' stamp: 'as 11/8/2006 12:30'!
checkEmptyArgument

	argument ifNotEmpty: [ (SPWrongCommandSmtpException withReceiver: target) signal. ].! !

!SPSmtpCommand methodsFor: 'defaults' stamp: 'as 4/18/2006 11:31'!
defaultNextState

	^ target state.! !

!SPSmtpCommand methodsFor: 'defaults' stamp: 'as 4/18/2006 11:30'!
defaultReply

	^ SPSmtpReply okay.! !

!SPSmtpCommand methodsFor: 'execute' stamp: 'as 4/18/2006 11:33'!
doExecute

	"Command-specific execution code goes here."
	"If the instance variables reply and nextState are not set the defaults are taken."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'validate' stamp: 'as 9/14/2006 13:50'!
doValidate

	"Validate whatever is necessary for the command to be executed successfully.
	 Throw exception if something is wrong."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'execute' stamp: 'as 11/13/2006 16:31'!
execute

	self
		validateState;
		validateArgument;
		doValidate;
		doExecute;
		gotoNextState;
		sendReply.! !

!SPSmtpCommand methodsFor: 'state' stamp: 'as 4/21/2006 11:00'!
gotoNextState

	state isNil ifTrue: [ state := self defaultNextState. ].
	target state: state.! !

!SPSmtpCommand methodsFor: 'smtp' stamp: 'as 11/13/2006 16:37'!
hasArgument

	^ self class hasArgument.! !

!SPSmtpCommand methodsFor: 'access' stamp: 'as 4/20/2006 17:41'!
reply: aSPSmtpReply

	reply := aSPSmtpReply.! !

!SPSmtpCommand methodsFor: 'reply' stamp: 'as 4/18/2006 11:29'!
sendReply

	reply isNil ifTrue: [ reply := self defaultReply. ].
	target reply: reply.! !

!SPSmtpCommand methodsFor: 'access' stamp: 'as 4/21/2006 10:59'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPSmtpCommand methodsFor: 'state' stamp: 'as 4/20/2006 19:35'!
states

	^ self class states.! !

!SPSmtpCommand methodsFor: 'access' stamp: 'as 1/12/2006 17:37'!
target: aSPMailReceiver

	target := aSPMailReceiver.! !

!SPSmtpCommand methodsFor: 'validate' stamp: 'as 11/13/2006 16:35'!
validateArgument

	self hasArgument ifFalse: [
		self checkEmptyArgument.
	].! !

!SPSmtpCommand methodsFor: 'validate' stamp: 'as 10/18/2006 19:32'!
validateState

	(self states includes: target state) ifFalse: [
		(SPCommandNotAllowedSmtpException withReceiver: target) signal.
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

!SPVerifySmtpCommand class methodsFor: 'smtp' stamp: 'as 11/13/2006 16:38'!
hasArgument

	^ true.! !

!SPVerifySmtpCommand class methodsFor: 'class initialization' stamp: 'as 11/16/2006 17:36'!
initStates

	"self initialize"

	^ self allStates.! !

!SPVerifySmtpCommand class methodsFor: 'smtp' stamp: 'as 11/8/2006 12:31'!
verb

	^ 'vrfy '.! !

!SPVerifySmtpCommand methodsFor: 'execute' stamp: 'as 4/21/2006 11:11'!
doExecute

	self reply: SPSmtpReply cannotVerify.! !

!SPVerifySmtpCommand methodsFor: 'execute' stamp: 'as 4/21/2006 11:11'!
doValidate

	"nothing to do"! !

Object subclass: #SPSmtpReply
	instanceVariableNames: 'code message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpReply commentStamp: '<historical>' prior: 0!
SMTP replies are sent from a server to a client as answer to client SMTP commands.!

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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 11/16/2006 16:59'!
closing: hostnameString reason: aString

	^ self new
		code: 421;
		message: hostnameString, ' ', aString;
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
commandUnrecognized

	^ self new
		code: 500;
		message: 'Syntax error or command unrecognized';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 10/17/2006 22:41'!
lineTooLong

	^ self new
		code: 500;
		message: 'Line too long';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 4/20/2006 16:17'!
mailInput

	^ self new
		code: 354;
		message: 'Start mail input; end with <CRLF>.<CRLF>';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 10/17/2006 22:40'!
noSuchUser

	^ self new
		code: 550;
		message: 'Mailbox unavailable';
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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 11/16/2006 16:46'!
quit: hostnameString

	^ self new
		code: 221;
		message: hostnameString, ' Bye';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 10/12/2006 15:50'!
ready: hostnameString

	^ self new
		code: 220;
		message: hostnameString;
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 10/18/2006 20:40'!
tooManyRecipients

	^ self new
		code: 452;
		message: 'Too many recipients';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 10/18/2006 17:46'!
tooMuchMailData

	^ self new
		code: 552;
		message: 'Too much mail data';
		yourself.! !

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 9/11/2006 17:02'!
wrongParameterOrArgument

	^ self new
		code: 501;
		message: 'Syntax error in parameters or arguments';
		yourself.! !

!SPSmtpReply methodsFor: 'access' stamp: 'as 4/18/2006 15:54'!
code

	^ code.! !

!SPSmtpReply methodsFor: 'access' stamp: 'as 4/18/2006 15:54'!
code: aNumber

	code := aNumber.! !

!SPSmtpReply methodsFor: 'access' stamp: 'as 4/18/2006 15:54'!
message

	^ message.! !

!SPSmtpReply methodsFor: 'access' stamp: 'as 4/18/2006 15:55'!
message: aString

	message := aString.! !

!SPSmtpReply methodsFor: 'print' stamp: 'as 10/18/2006 21:35'!
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
The server has received the sender address.!

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
The server has received at least one recipient address.!

SPSmtpState subclass: #SPResetSmtpState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-States'!

!SPResetSmtpState commentStamp: '<historical>' prior: 0!
The server is reset and can receive a new mail.!

Object subclass: #SPSubscription
	instanceVariableNames: 'list contact active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPSubscription commentStamp: '<historical>' prior: 0!
A subscription subscribes a user to a mailing list.!

!SPSubscription class methodsFor: 'instance creation' stamp: 'as 9/5/2006 13:12'!
withList: aSPList contact: aSPContact

	^ self new
		list: aSPList;
		contact: aSPContact;
		yourself.! !

!SPSubscription methodsFor: 'compare' stamp: 'as 8/18/2006 16:00'!
= aSPSubscription

	^ (list = aSPSubscription list) and: [ contact = aSPSubscription contact].! !

!SPSubscription methodsFor: 'state' stamp: 'as 9/5/2006 13:17'!
activate

	active := true.! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:58'!
contact

	^ contact.! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:58'!
contact: aSPContact

	contact := aSPContact.! !

!SPSubscription methodsFor: 'state' stamp: 'as 9/5/2006 13:17'!
deactivate

	active := false.! !

!SPSubscription methodsFor: 'compare' stamp: 'as 10/21/2006 12:11'!
hash

	^ (list name, contact address asString) hash.! !

!SPSubscription methodsFor: 'initialize-release' stamp: 'as 10/11/2006 12:39'!
initialize

	self activate.! !

!SPSubscription methodsFor: 'test' stamp: 'as 9/5/2006 14:15'!
isActive

	^ contact isActive and: [ list isActive. ] and: [ active. ].! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:57'!
list

	^ list.! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:58'!
list: aSPList

	list := aSPList.! !

Object subclass: #SPSyntax
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPSyntax commentStamp: '<historical>' prior: 0!
Implements some regular expressions to test strings. They are minimal versions of those used in RFC 2821 and 2822. IPv6 and general address literals are not implemented.
Everything is done on the class side.!

!SPSyntax class methodsFor: 'check' stamp: 'as 10/20/2006 17:17'!
checkDomainLength: aString

	aString size > self maxDomainLength
		ifTrue: [ SPSyntaxException signal: 'domain length limit is', self maxDomainLength. ].! !

!SPSyntax class methodsFor: 'check' stamp: 'as 10/20/2006 17:24'!
checkMailPathLength: aString

	aString size > self maxMailPathLength
		ifTrue: [ SPSyntaxException signal: 'mail path length limit is', self maxMailPathLength. ].! !

!SPSyntax class methodsFor: 'test' stamp: 'as 10/20/2006 17:16'!
isDomain: aString

	self checkDomainLength: aString.
	^ aString matchesRegex: self reDomain.! !

!SPSyntax class methodsFor: 'test' stamp: 'as 10/20/2006 17:22'!
isIPv4Address: aString

	^ aString matchesRegex: self reIPv4AddressLiteral.! !

!SPSyntax class methodsFor: 'test' stamp: 'as 10/20/2006 17:58'!
isMailPath: aString

	self checkMailPathLength: aString.
	^ aString matchesRegex: self rePath.! !

!SPSyntax class methodsFor: 'test' stamp: 'as 10/20/2006 17:26'!
isSmtpMailFrom: aString

	self checkMailPathLength: aString.
	^ aString matchesRegex: self reMailFrom.! !

!SPSyntax class methodsFor: 'test' stamp: 'as 10/20/2006 17:26'!
isSmtpRcptTo: aString

	self checkMailPathLength: aString.
	^ aString matchesRegex: self reRcptTo.! !

!SPSyntax class methodsFor: 'limits' stamp: 'as 10/19/2006 19:05'!
maxDomainLength

	^ 255.! !

!SPSyntax class methodsFor: 'limits' stamp: 'as 10/19/2006 19:05'!
maxMailPathLength

	^ 256.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 18:11'!
re3digit

	^ '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 11:41'!
reAddressLiteral

	"IPv6 and general address literals are not implemented."

	^ self reIPv4AddressLiteral.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/19/2006 22:01'!
reAtDomain

	^ '@', self reDomain.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/19/2006 23:01'!
reAtom

	^ '[[:alnum:]!!#\$%&''\*\+-/=\?\^_`{\|}~]'! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 11:23'!
reDomain

	^ '(', self reSubDomain, '(.', self reSubDomain, ')+)|(', self reAddressLiteral , ')'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 11:50'!
reIPv4AddressLiteral

	^ self reSnum, '\.', self reSnum, '\.', self reSnum, '\.', self reSnum.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 17:11'!
reLdhStr

	^ '([[:alnum:]]\-)*', self reLetDig.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 17:10'!
reLetDig

	^ '[[:alnum:]]'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 17:07'!
reMailFrom

	^ '(<>)|(', self rePath, ')'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 17:07'!
rePath

	^ '<.*@.*>'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 17:07'!
reRcptTo

	^ '(<Postmaster>)|(', self rePath, ')'.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 11:51'!
reSnum

	^ self re3digit.! !

!SPSyntax class methodsFor: 'regex' stamp: 'as 10/20/2006 11:26'!
reSubDomain

	^ self reLetDig, '(', self reLdhStr, ')?'.! !

Object subclass: #SPUser
	instanceVariableNames: 'name password contacts active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPUser commentStamp: '<historical>' prior: 0!
A user is identified by a name, has a password and optionally one or multiple contacts.!

!SPUser class methodsFor: 'instance creation' stamp: 'as 8/17/2006 14:55'!
withName: nameString password: passwordString

	^ self new
		name: nameString;
		password: passwordString;
		yourself.! !

!SPUser methodsFor: 'compare' stamp: 'as 3/9/2006 16:51'!
= aSPUser

	^ name = aSPUser name.! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:21'!
activate

	active := true.! !

!SPUser methodsFor: 'contacts' stamp: 'as 11/17/2006 21:09'!
addContact: aSPContact

	contacts add: aSPContact.! !

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:02'!
checkPassword: aString

	^ password check: aString.! !

!SPUser methodsFor: 'contacts' stamp: 'as 8/17/2006 15:11'!
contacts

	^ contacts.! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:26'!
deactivate

	active := false.! !

!SPUser methodsFor: 'compare' stamp: 'as 3/9/2006 16:52'!
hash

	^ name hash.! !

!SPUser methodsFor: 'initialize-release' stamp: 'as 11/17/2006 21:05'!
initialize

	contacts := Set new.
	self activate.! !

!SPUser methodsFor: 'test' stamp: 'as 9/5/2006 11:22'!
isActive

	^ active.! !

!SPUser methodsFor: 'access' stamp: 'as 3/9/2006 16:54'!
name

	^ name.! !

!SPUser methodsFor: 'access' stamp: 'as 3/9/2006 16:48'!
name: aString

	name := aString.! !

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:03'!
newPassword: newString oldPassword: oldString

	password new: newString old: oldString.! !

!SPUser methodsFor: 'access' stamp: 'as 9/26/2006 15:02'!
password: aString

	password := SPPassword withPassword: aString.! !

!SPUser methodsFor: 'contacts' stamp: 'as 11/17/2006 21:10'!
removeContact: aSPContact

	contacts remove: aSPContact ifAbsent: [ SPContactNotFoundException signal. ].! !

!MailDBFile methodsFor: '*Stamp' stamp: 'as 10/3/2006 17:35'!
reopen
	"check the file size and mod time; if they match, then do a fast reopen.  Otherwise, read everything in the slow way"
	| entry dir file |
	modTimeAtSave ifNil: [ ^self open ].
	sizeAtSave ifNil: [ ^self open ].

	"Fix by Anselm Strauss, 2006/10/03, astrauss@gmx.ch"
	"Can now use relative filenames with multiple directories."
	dir := FileDirectory default fullName, '/', (FileDirectory dirPathFor: filename).
	file := FileDirectory localNameFor: filename.
	entry := (FileDirectory on: dir) entryAt: file.

	entry ifNil: [ ^self open ].

	entry fileSize = sizeAtSave ifFalse: [ ^self open ].
	entry modificationTime = modTimeAtSave ifFalse: [ ^self open ].

! !

!MailDBFile methodsFor: '*Stamp' stamp: 'as 10/3/2006 17:24'!
save
	"Atomically save a representation of this object to its file.  The new file is written to <name>.new, and on success, renamed to simply <name>.  If the write fails, then the old version will still exist"

	| f dir shortName dirname |

	(StandardFileStream fileNamed: filename) close.	"ensure it exists"
	shortName := FileDirectory localNameFor: filename.
	
	"Fix by Anselm Strauss, 2006/10/03, astrauss@gmx.ch"
	"Can now use relative filenames with multiple directories."
	dirname := FileDirectory default fullName, '/', (FileDirectory dirPathFor: filename).
	dir := FileDirectory on: dirname.

	Cursor write showWhile: [
		f := FileStream fileNamed: filename, '.new'.
		self writeOn: f.
		f setToEnd; close
		].
	dir deleteFileNamed: shortName ifAbsent: [].
	dir rename: shortName, '.new' toBe: shortName.

	self updateSizeAndModTime.! !

!MailDBFile methodsFor: '*Stamp' stamp: 'as 10/3/2006 17:22'!
updateSizeAndModTime
	"update the cached size and modification time"
	| entry dir file |

	"Fix by Anselm Strauss, 2006/10/03, astrauss@gmx.ch"
	"Can now use relative filenames with multiple directories."
	dir := FileDirectory default fullName, '/', (FileDirectory dirPathFor: filename).
	file := FileDirectory localNameFor: filename.
	entry := (FileDirectory on: dir) entryAt: file.
	
	entry ifNil: [
		"uh oh!!"
		self reportInconsistency.
		sizeAtSave := nil.
		modTimeAtSave := nil.
		^self ].

	sizeAtSave := entry fileSize.
	modTimeAtSave := entry modificationTime.! !

WAComponent subclass: #SPWeb
	instanceVariableNames: 'kernel body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWeb commentStamp: '<historical>' prior: 0!
Stamp web interface.!

!SPWeb class methodsFor: 'class initialization' stamp: 'as 7/19/2006 10:19'!
initialize

	"self initialize"

	self registerAsApplication: 'stamp'.! !

!SPWeb methodsFor: 'as yet unclassified' stamp: 'as 7/26/2006 09:30'!
children

	^ Array with: body.! !

!SPWeb methodsFor: 'accessing' stamp: 'as 7/24/2006 10:35'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 7/26/2006 09:26'!
renderContentOn: html

	html heading: 'stamp'.
	kernel isNil
		ifTrue: [ self renderKernelSelection: html. ]
		ifFalse: [ self renderDefault: html. ].

	"html anchorWithAction: [ self call: SPWeb3 new. ] text: 'stamp3'."! !

!SPWeb methodsFor: 'rendering' stamp: 'as 7/26/2006 09:27'!
renderDefault: html

	html paragraph: 'kernel is: ', kernel name.

	html anchorWithAction: [ body := SPWebUsers withKernel: kernel. ] text: 'users'.
	html horizontalRule.
	html render: body.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 7/26/2006 09:38'!
renderKernelSelection: html

	html paragraph: 'kernels:'.
	SPKernel allInstances do: [
		:each |
		html anchorWithAction: [ self kernel: each. ] text: each name.
		html text: ' '.
	].! !

WAComponent subclass: #SPWebAddUser
	instanceVariableNames: 'kernel name address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

SPWebAddUser class
	instanceVariableNames: 'kernel'!

!SPWebAddUser commentStamp: '<historical>' prior: 0!
testing...!

SPWebAddUser class
	instanceVariableNames: 'kernel'!

!SPWebAddUser class methodsFor: 'instance creation' stamp: 'as 7/25/2006 15:50'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPWebAddUser methodsFor: 'as yet unclassified' stamp: 'as 7/26/2006 11:10'!
addUser

	kernel userManager addUser: name address: address.
	self answer.! !

!SPWebAddUser methodsFor: 'accessing' stamp: 'as 7/25/2006 16:15'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPWebAddUser methodsFor: 'rendering' stamp: 'as 7/25/2006 16:17'!
renderContentOn: html

	html form: [
		html defaultAction: [ self addUser. ].
		html textInputWithValue: name callback: [ :n | name := n. ].
		html textInputWithValue: address callback: [ :a | address := a. ].
		html submitButtonWithText: 'ok'.
	].! !

WAComponent subclass: #SPWebUsers
	instanceVariableNames: 'kernel test'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebUsers commentStamp: '<historical>' prior: 0!
testing...!

!SPWebUsers class methodsFor: 'instance creation' stamp: 'as 7/24/2006 11:31'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPWebUsers methodsFor: 'accessing' stamp: 'as 7/24/2006 11:31'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPWebUsers methodsFor: 'rendering' stamp: 'as 7/26/2006 11:14'!
renderAllUsers: html

	kernel userManager allUsers do: [
		:user |
		html paragraph: [ html text: user name, ' - ', user address. ].
	].! !

!SPWebUsers methodsFor: 'rendering' stamp: 'as 7/26/2006 09:29'!
renderContentOn: html

	html heading: 'users' level: 3.
	self renderAllUsers: html.
	html horizontalRule.
	html anchorWithAction: [ self call: (SPWebAddUser withKernel: kernel). ] text: 'add user'.
	"html anchorWithAction: [ test := 1. ] text: 'test'."! !

SMTPClient subclass: #SPSmtpClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPSmtpClient commentStamp: '<historical>' prior: 0!
A smtp client with anonymous login.!

!SPSmtpClient class methodsFor: 'instance creation' stamp: 'as 10/10/2006 17:44'!
onHost: hostIP port: portNumber

	^ self new
		host: hostIP;
		port: portNumber;
		yourself.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 11/17/2006 13:27'!
from: aSPMailAddress

	self sendCommand: 'mail from:', aSPMailAddress path.
	self checkResponse.! !

!SPSmtpClient methodsFor: 'private' stamp: 'as 10/10/2006 14:27'!
login

	"anonymous login"! !

!SPSmtpClient methodsFor: 'open-close' stamp: 'as 10/10/2006 14:34'!
open

	self ensureConnection.! !

!SPSmtpClient methodsFor: 'open-close' stamp: 'as 2/22/2006 15:48'!
reopen

	self close.
	self ensureConnection.! !

!SPSmtpClient methodsFor: 'private' stamp: 'as 10/10/2006 17:31'!
reset

	self sendCommand: 'rset'.
	self checkResponse.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 11/17/2006 13:28'!
to: aSPMailAddress

	self sendCommand: 'rcpt to:', aSPMailAddress path.
	self checkResponse.! !

AnObsoleteSPConfigurable subclass: #SPContact
	instanceVariableNames: 'user address active verification'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPContact commentStamp: '<historical>' prior: 0!
A contact connects a user with an email address.!

!SPContact class methodsFor: 'instance creation' stamp: 'as 9/5/2006 11:28'!
withAddress: aSPMailAddress user: aSPUser

	^ self new
		address: aSPMailAddress;
		user: aSPUser;
		yourself.! !

!SPContact methodsFor: 'compare' stamp: 'as 8/21/2006 09:32'!
= aSPContact

	^ address = aSPContact address.! !

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
activate

	active := true.! !

!SPContact methodsFor: 'access' stamp: 'as 8/17/2006 15:14'!
address

	^ address.! !

!SPContact methodsFor: 'access' stamp: 'as 8/17/2006 15:14'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
deactivate

	active := false.! !

!SPContact methodsFor: 'compare' stamp: 'as 8/17/2006 15:48'!
hash

	^ address name hash.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 10/12/2006 16:56'!
initVerification

	| r |
	verification := ''.
	r := Random new.
	1 to: (self preferenceAt: #contactVerificationLength) do:
		[ :i | verification := verification, (r nextInt: 9) asString. ].! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 10/4/2006 22:34'!
initialize

	self activate.
	self initVerification.! !

!SPContact methodsFor: 'test' stamp: 'as 9/5/2006 14:08'!
isActive

	^ user isActive and: [ active. ].! !

!SPContact methodsFor: 'test' stamp: 'as 10/4/2006 22:35'!
isVerified

	^ verification isNil.! !

!SPContact methodsFor: 'access' stamp: 'as 11/17/2006 21:17'!
user

	^ user.! !

!SPContact methodsFor: 'access' stamp: 'as 9/5/2006 11:29'!
user: aSPUser

	user := aSPUser.! !

!SPContact methodsFor: 'access' stamp: 'as 10/4/2006 22:36'!
verification

	^ verification.! !

!SPContact methodsFor: 'state' stamp: 'as 10/14/2006 13:03'!
verify: aString

	self isVerified ifTrue:[
		^ true.
	] ifFalse: [
		^ verification = aString ifTrue: [ verification := nil. ].
	].! !

AnObsoleteSPConfigurable subclass: #SPMailMessage
	instanceVariableNames: 'mail sender recipient date state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

SPMailMessage class
	instanceVariableNames: 'monitor messageId'!

!SPMailMessage commentStamp: '<historical>' prior: 0!
The SMTP protocol defines commands for specifying a sender and one or multiple recipient addresses apart from the ones in the header of a mail message (from:, to:, cc:, ...).
This class is a wrapper around MailMessage that stores these addresses as well, since they are important when relaying mail.
There can be only one recipient, mails to multiple recipients must be split into multiple mail messages.!

SPMailMessage class
	instanceVariableNames: 'monitor messageId'!

!SPMailMessage class methodsFor: 'class initialization' stamp: 'as 10/17/2006 16:18'!
initialize

	messageId := 0.
	monitor := Monitor new.! !

!SPMailMessage class methodsFor: 'id' stamp: 'as 10/17/2006 16:20'!
uniqueMessageId

	monitor critical: [
		messageId := messageId + 1.
		^ messageId.
	].! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 10/17/2006 16:21'!
ensureMessageId: hostnameString

	mail fieldNamed: 'message-id' ifAbsent: [
		mail setField: 'message-id' toString: '<', self class uniqueMessageId asString, '@', hostnameString, '>'.
	].! !

!SPMailMessage methodsFor: 'initialize-release' stamp: 'as 12/11/2006 14:33'!
initialize

	state := #new.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 11/15/2006 12:32'!
insertListName: aSPList

	mail subject: '[', aSPList name, '] ', mail subject.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 11/14/2006 18:22'!
insertReturnPath

	mail returnPath: sender path.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 12/4/2006 12:32'!
insertTraceFrom: fromString by: byString

	mail received: 'from ', fromString, ' by ', byString, '; ', MailMessage dateStampNow, ' ', self timezone.
	date _ DateAndTime now.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 6/12/2006 14:32'!
mail: aString

	mail := MailMessage from: aString.! !

!SPMailMessage methodsFor: 'copy' stamp: 'as 10/5/2006 15:13'!
postCopy

	mail := MailMessage from: mail text.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 11/15/2006 12:25'!
recipient

	^ recipient.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 11/15/2006 12:25'!
recipient: aSPMailAddress

	recipient := aSPMailAddress.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:13'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:29'!
sender: aSPMailAddress

	sender := aSPMailAddress.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 12/11/2006 14:31'!
state

	^ state.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 12/11/2006 14:31'!
state: aSymbol

	state := aSymbol.! !

!SPMailMessage methodsFor: 'preferences' stamp: 'as 11/15/2006 12:45'!
timezone

	self preferenceAt: #timezone.! !
SPSmtpCommand initialize!
SPWeb initialize!
SPMailMessage initialize!
