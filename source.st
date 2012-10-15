SystemOrganization addCategory: #'Stamp-Configuration-Attributes'!
SystemOrganization addCategory: #'Stamp-Configuration'!
SystemOrganization addCategory: #'Stamp-Core'!
SystemOrganization addCategory: #'Stamp-ListManager-Exceptions'!
SystemOrganization addCategory: #'Stamp-ListManager'!
SystemOrganization addCategory: #'Stamp-ListManager-Tests'!
SystemOrganization addCategory: #'Stamp-Mail-Client'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Exceptions'!
SystemOrganization addCategory: #'Stamp-Mail-Server'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Commands'!
SystemOrganization addCategory: #'Stamp-Mail-Server-States'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Tests'!
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
	instanceVariableNames: 'listener'
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

!SPMailService methodsFor: 'conversation' stamp: 'as 1/16/2007 14:48'!
serve: aSocket

	[
		(SPMailReceiver withStream: (SocketStream on: aSocket)) receive.
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

!SPException commentStamp: 'as 1/16/2007 11:30' prior: 0!
Top exception class for Stamp.!

SPException subclass: #SPAlreadySubscribedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPAlreadySubscribedException commentStamp: 'as 2/6/2007 12:33' prior: 0!
The subscription already exists.!

SPException subclass: #SPConfigurationException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurationException commentStamp: 'as 1/15/2007 17:52' prior: 0!
General configuration exception.!

SPConfigurationException subclass: #SPConfigurationAttributeNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPConfigurationAttributeNotFoundException commentStamp: 'as 1/16/2007 11:26' prior: 0!
The configuration attribute or preference was not found.!

SPConfigurationException subclass: #SPImmutableConfigurationAttributeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPImmutableConfigurationAttributeException commentStamp: 'as 12/12/2006 12:44' prior: 0!
There was an attempt to mutate an immutable configuration attribute.!

SPConfigurationException subclass: #SPInvalidConfigurationAttributeValueException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPInvalidConfigurationAttributeValueException commentStamp: 'as 1/8/2007 15:34' prior: 0!
The value didn't pass the value check of the configuration attribute.!

SPException subclass: #SPContactAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactAlreadyExistsException commentStamp: 'as 2/6/2007 12:33' prior: 0!
The contact already exists.!

SPException subclass: #SPContactNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactNotFoundException commentStamp: 'as 1/15/2007 10:32' prior: 0!
The contact was not found.!

SPException subclass: #SPContactNotVerifiedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactNotVerifiedException commentStamp: 'as 1/15/2007 10:32' prior: 0!
The contact is not verified. It must be verified before it can be used.!

SPException subclass: #SPContactVerificationFailedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactVerificationFailedException commentStamp: 'as 2/6/2007 12:34' prior: 0!
The verification string is wrong.!

!SPException methodsFor: 'priv handling' stamp: 'as 8/17/2006 11:04'!
isResumable

	^ false.! !

SPException subclass: #SPInvalidMailAddressException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPInvalidMailAddressException commentStamp: '<historical>' prior: 0!
Invalid mail address.!

SPException subclass: #SPListAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPListAlreadyExistsException commentStamp: 'as 1/30/2007 15:35' prior: 0!
The list already exists.!

SPException subclass: #SPListNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPListNotFoundException commentStamp: 'as 1/16/2007 12:37' prior: 0!
The list was not found.!

SPException subclass: #SPQueueFullException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPQueueFullException commentStamp: 'as 2/7/2007 00:02' prior: 0!
The requested amount can't be queued, it would overfill the queue.!

SPException subclass: #SPReceiverException
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPReceiverException commentStamp: 'as 1/16/2007 14:49' prior: 0!
General mail receiver exception.!

SPReceiverException subclass: #SPConnectionClosedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPConnectionClosedException commentStamp: '<historical>' prior: 0!
The connection was unexpectedly closed.!

!SPConnectionClosedException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:07'!
defaultAction

	receiver clientQuit.! !

SPReceiverException subclass: #SPConnectionTimedOutException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPConnectionTimedOutException commentStamp: 'as 1/15/2007 11:30' prior: 0!
The connection has timed out.!

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
	category: 'Stamp-Mail-Server-Exceptions'!

!SPSmtpException commentStamp: '<historical>' prior: 0!
An SMTP command from the client has failed on the server.!

SPSmtpException subclass: #SPCommandNotAllowedSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPCommandNotAllowedSmtpException commentStamp: '<historical>' prior: 0!
The command is not allowed in the current state of the server.!

!SPCommandNotAllowedSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpException subclass: #SPCommandNotFoundSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPCommandNotFoundSmtpException commentStamp: '<historical>' prior: 0!
The specified command was not found.!

!SPCommandNotFoundSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

SPSmtpException subclass: #SPLineTooLongSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPLineTooLongSmtpException commentStamp: 'as 1/16/2007 15:04' prior: 0!
There is too much data on one line.!

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
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooManyRecipientsSmtpException commentStamp: 'as 2/6/2007 12:36' prior: 0!
The maximum number of recipients is reached, no more can be specified for this message.!

!SPTooManyRecipientsSmtpException methodsFor: 'priv handling' stamp: 'as 10/18/2006 20:40'!
reply

	^ SPSmtpReply tooManyRecipients.! !

SPSmtpException subclass: #SPTooMuchMailDataSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooMuchMailDataSmtpException commentStamp: 'as 2/6/2007 12:37' prior: 0!
The mail data exceeds the limits.!

!SPTooMuchMailDataSmtpException methodsFor: 'priv handling' stamp: 'as 10/18/2006 17:46'!
reply

	^ SPSmtpReply tooMuchMailData.! !

SPSmtpException subclass: #SPWrongCommandSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPWrongCommandSmtpException commentStamp: '<historical>' prior: 0!
Wrong parameters or arguments. !

!SPWrongCommandSmtpException methodsFor: 'priv handling' stamp: 'as 9/14/2006 13:59'!
reply

	^ SPSmtpReply wrongParameterOrArgument.! !

SPReceiverException subclass: #SPTooManyConnectionsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooManyConnectionsException commentStamp: '<historical>' prior: 0!
There are too many connections, the current connection will be aborted.!

!SPTooManyConnectionsException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:08'!
defaultAction

	receiver close: 'Too many connections'.! !

SPException subclass: #SPSubscriptionNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPSubscriptionNotFoundException commentStamp: 'as 1/15/2007 11:28' prior: 0!
The subscription was not found.!

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
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooMuchDataException commentStamp: '<historical>' prior: 0!
The received data exceeds the limits.!

SPException subclass: #SPUserAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPUserAlreadyExistsException commentStamp: 'as 1/30/2007 15:34' prior: 0!
The user already exists.!

SPException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPUserNotFoundException commentStamp: 'as 1/15/2007 11:28' prior: 0!
The user was not found.!

SPException subclass: #SPWrongPasswordException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPWrongPasswordException commentStamp: 'as 1/16/2007 12:43' prior: 0!
The given password is incorrect.!

Object subclass: #SPConfiguration
	instanceVariableNames: 'attributes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfiguration commentStamp: 'as 1/15/2007 18:16' prior: 0!
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

!SPStampConfiguration commentStamp: 'as 1/16/2007 11:28' prior: 0!
Initializes a default configuration for Stamp.!

!SPStampConfiguration methodsFor: 'initialize-release' stamp: 'as 2/8/2007 17:08'!
initialize

	super initialize.

	"basic"
	self attributeAt: #resolverTimeout put:
		(SPIntegerConfigurationAttribute withValue: 3 min: 1 max: 100).
	self attributeAt: #serverName put:
		(SPStringConfigurationAttribute withValue: NetNameResolver localHostName).
	self attributeAt: #timezone put:
		(SPStringConfigurationAttribute withValue: '+0100').
	self attributeAt: #adminAddress put:
		(SPAddressConfigurationAttribute withValue: (SPMailAddress fromPath: '<postmaster@localhost>')).

	"listener"
	self attributeAt: #listenerMaxConnections put:
		(SPIntegerConfigurationAttribute withValue: 10 min: 0 max: 100).
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
	category: 'Stamp-Configuration-Attributes'!

!SPConfigurationAttribute commentStamp: 'as 1/23/2007 14:57' prior: 0!
A configuration attribute stores one value of any type that can be set/get. A new value is checked against the configured type and checkValue: is called which is intended to be overwritten in subclasses. There is also some code for mutability: setting a new value will fail if the instance is not mutable. As for now, mutability isn't really used, that means it is checked but by default set to true (=mutable).!

SPConfigurationAttribute subclass: #SPAddressConfigurationAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPAddressConfigurationAttribute commentStamp: 'as 2/8/2007 16:21' prior: 0!
Address configuration attribute.!

!SPAddressConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/8/2007 16:22'!
type

	^ SPMailAddress.! !

!SPConfigurationAttribute class methodsFor: 'instance creation' stamp: 'as 12/12/2006 12:56'!
withValue: anObject

	^ self new value: anObject.! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 12/12/2006 12:45'!
checkMutable

	mutable ifFalse: [ SPImmutableConfigurationAttributeException signal. ].! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 1/15/2007 17:49'!
checkValue: anObject

	(anObject isKindOf: self type) ifFalse:
		[ SPInvalidConfigurationAttributeValueException signal: 'Value should be of kind: ', self type asString. ].! !

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
	category: 'Stamp-Configuration-Attributes'!

!SPNumberConfigurationAttribute commentStamp: 'as 1/16/2007 11:27' prior: 0!
Number configuration attribute.!

SPNumberConfigurationAttribute subclass: #SPIntegerConfigurationAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPIntegerConfigurationAttribute commentStamp: 'as 1/16/2007 11:27' prior: 0!
Integer configuration attribute.!

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

!SPNumberConfigurationAttribute methodsFor: 'check' stamp: 'as 1/18/2007 01:05'!
checkLimits: aNumber

	aNumber < min ifTrue:
		[ SPInvalidConfigurationAttributeValueException
			signal: 'Value should not be smaller than ', min asString. ].
	aNumber > max ifTrue:
		[ SPInvalidConfigurationAttributeValueException
			signal: 'Value should not be higher than ', max asString. ].! !

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
	category: 'Stamp-Configuration-Attributes'!

!SPStringConfigurationAttribute commentStamp: 'as 1/8/2007 15:38' prior: 0!
Stamp string configuration attribute.!

!SPStringConfigurationAttribute methodsFor: 'configuration' stamp: 'as 12/12/2006 14:48'!
type

	^ String.! !

Object subclass: #SPConfigurator
	instanceVariableNames: 'config monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfigurator commentStamp: 'as 1/23/2007 15:38' prior: 0!
Holds all configuration data, allows to get/set attributes.!

!SPConfigurator methodsFor: 'initialize-release' stamp: 'as 1/29/2007 17:01'!
initialize

	monitor _ Monitor new.
	config _ SPStampConfiguration new.! !

!SPConfigurator methodsFor: 'configuration' stamp: 'as 1/23/2007 15:37'!
preferenceAt: aSymbol

	monitor critical: [
		^ config preferenceAt: aSymbol.
	].! !

!SPConfigurator methodsFor: 'configuration' stamp: 'as 1/23/2007 15:37'!
preferenceAt: aSymbol put: anObject

	monitor critical: [
		config preferenceAt: aSymbol put: anObject.
	].! !

Object subclass: #SPContact
	instanceVariableNames: 'user address active verification'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPContact commentStamp: '<historical>' prior: 0!
A contact connects a user with an email address.!

!SPContact class methodsFor: 'instance creation' stamp: 'as 1/29/2007 17:13'!
withAddress: aSPMailAddress user: aSPUser

	^ self new
		user: aSPUser;
		address: aSPMailAddress;
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

!SPContact methodsFor: 'configuration' stamp: 'as 1/17/2007 19:44'!
config

	^ SPKernel instance configurator.! !

!SPContact methodsFor: 'configuration' stamp: 'as 1/16/2007 14:24'!
contactVerificationLength

	^ self config preferenceAt: #contactVerificationLength.! !

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
deactivate

	active := false.! !

!SPContact methodsFor: 'compare' stamp: 'as 8/17/2006 15:48'!
hash

	^ address name hash.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 1/16/2007 14:24'!
initVerification

	| r |
	verification _ ''.
	r _ Random new.
	1 to: (self contactVerificationLength) do:
		[ :i | verification _ verification, (r nextInt: 9) asString. ].! !

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

!SPContact methodsFor: 'verification' stamp: 'as 2/5/2007 10:32'!
verify: aString

	self isVerified ifFalse: [
		verification = aString
			ifTrue: [ verification _ nil. ]
			ifFalse: [ SPContactVerificationFailedException signal. ].
	].! !

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
	instanceVariableNames: 'listener manager queue archive configurator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

SPKernel class
	instanceVariableNames: 'instance'!

!SPKernel commentStamp: 'as 1/15/2007 10:09' prior: 0!
The core of Stamp.
Holds references to all important components and the base attributes for the databases.!

SPKernel class
	instanceVariableNames: 'instance'!

!SPKernel class methodsFor: 'instance creation' stamp: 'as 1/24/2007 15:15'!
instance

	^ instance ifNil: [ instance _ self basicNew initialize. ].! !

!SPKernel class methodsFor: 'instance creation' stamp: 'as 8/8/2006 16:20'!
new

	self shouldNotImplement.! !

!SPKernel methodsFor: 'access' stamp: 'as 12/12/2006 17:32'!
configurator

	^ configurator.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 2/8/2007 16:16'!
initialize

	listener _ SPMailListener new.
	manager _ SPListManager new.
	queue _ SPMailQueue new.
	configurator _ SPConfigurator new.! !

!SPKernel methodsFor: 'access' stamp: 'as 3/10/2006 16:19'!
listener

	^ listener.! !

!SPKernel methodsFor: 'access' stamp: 'as 8/18/2006 19:37'!
manager

	^ manager.! !

!SPKernel methodsFor: 'access' stamp: 'as 11/15/2006 18:03'!
queue

	^ queue.! !

!SPKernel methodsFor: 'start-stop' stamp: 'as 1/24/2007 15:14'!
start

	listener start.! !

!SPKernel methodsFor: 'start-stop' stamp: 'as 1/24/2007 15:14'!
stop

	listener stop.
	listener waitForStop.! !

Object subclass: #SPList
	instanceVariableNames: 'address name description closed visible admin'
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

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address

	^ address.! !

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:10'!
admin

	^ admin.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:17'!
admin: aSPMailAddress

	admin _ aSPMailAddress.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:28'!
close

	closed := true.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:08'!
description

	^ description.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:08'!
description: aString

	^ description _ aString.! !

!SPList methodsFor: 'compare' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'state' stamp: 'as 10/19/2006 11:33'!
hide

	visible := false.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 2/6/2007 18:09'!
initialize

	self close.
	self hide.
	self description: ''.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:29'!
isClosed

	^ closed.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:31'!
isHidden

	^ visible not.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:29'!
isOpen

	^ closed not.! !

!SPList methodsFor: 'test' stamp: 'as 10/19/2006 11:30'!
isVisible

	^ visible.! !

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

Object subclass: #SPListManager
	instanceVariableNames: 'users lists subscriptions monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPListManager commentStamp: 'as 12/4/2006 12:39' prior: 0!
Access/modify lists, users, contacts and subscriptions.!

!SPListManager methodsFor: 'get-recipients' stamp: 'as 2/5/2007 09:57'!
activeRecipientsForList: aSPList

	^ monitor critical: [
		(self activeSubscriptionsForList: aSPList) collect: [
			:each |
			each contact address.
		].
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/5/2007 09:55'!
activeSubscriptionsForList: aSPList

	^ monitor critical: [
		(self subscriptionsForList: aSPList) select: [
			:each |
			each isActive.
		].
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/2/2007 14:48'!
addContact: aSPContact

	monitor critical: [
		self assert: (aSPContact isVerified not).
		aSPContact user addContact: aSPContact.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 1/30/2007 15:38'!
addList: aSPList

	monitor critical: [
		(lists contains: aSPList) ifTrue: [ SPListAlreadyExistsException signal. ].
		lists add: aSPList.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 1/30/2007 15:38'!
addUser: aSPUser

	monitor critical: [
		(users contains: aSPUser) ifTrue: [ SPUserAlreadyExistsException signal. ].
		users add: aSPUser.
	].! !

!SPListManager methodsFor: 'configuration' stamp: 'as 2/12/2007 15:49'!
adminAddress

	^ SPKernel instance configurator preferenceAt: #adminAddress.! !

!SPListManager methodsFor: 'get-list' stamp: 'as 2/12/2007 15:51'!
adminForList: aSPList

	^ monitor critical: [
		aSPList admin ifNil: [ self adminAddress. ].
	].! !

!SPListManager methodsFor: 'get-list' stamp: 'as 2/6/2007 15:37'!
allLists

	^ monitor critical: [
		lists.
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 1/24/2007 15:25'!
allSubscriptions

	^ monitor critical: [ subscriptions. ].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 1/24/2007 15:26'!
allUsers

	^ monitor critical: [ users. ].! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 2/2/2007 17:33'!
initialize

	users _ Set new.
	lists _ Set new.
	subscriptions _ Set new.
	monitor _ Monitor new.! !

!SPListManager methodsFor: 'get-list' stamp: 'as 2/2/2007 14:52'!
invisibleLists

	^ monitor critical: [
		lists select: [ :list | list isVisible not.].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/4/2007 22:18'!
isAllowed: aSPUser toPostTo: aSPList

	^ monitor critical: [
		aSPList isOpen or: [
			aSPUser notNil and: [ self isSubscribed: aSPUser to: aSPList. ].
		].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/5/2007 11:17'!
isSubscribed: aSPUser to: aSPList

	^ monitor critical: [
		(subscriptions detect: [
			:subscription |
			subscription list = aSPList and:
				[ aSPUser verifiedContacts includes: subscription contact. ].
		] ifNone: [ nil. ]) notNil.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/6/2007 18:15'!
list: aSPList admin: aSPMailAddress

	monitor critical: [
		aSPList admin: aSPMailAddress.
	].! !

!SPListManager methodsFor: 'get-list' stamp: 'as 1/24/2007 15:25'!
listWithAddress: aSPMailAddress

	^ monitor critical: [
		lists
			detect: [ :each | each address = aSPMailAddress. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 1/24/2007 15:24'!
removeContact: aSPContact

	monitor critical: [
		aSPContact user removeContact: aSPContact.
		subscriptions removeAll: (self subscriptionsForContact: aSPContact).
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 1/24/2007 15:24'!
removeList: aSPList

	monitor critical: [
		lists remove: aSPList ifAbsent: [ SPListNotFoundException signal. ].
		subscriptions removeAll: (self subscriptionsForList: aSPList).
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 1/24/2007 15:24'!
removeUser: aSPUser

	monitor critical: [
		users remove: aSPUser ifAbsent: [ SPUserNotFoundException signal. ].
		subscriptions removeAll: (self subscriptionsForUser: aSPUser).
	].! !

!SPListManager methodsFor: 'subscription' stamp: 'as 2/2/2007 17:57'!
subscribe: aSPContact to: aSPList

	| subscription |
	monitor critical: [
		aSPContact isVerified ifFalse: [ SPContactNotVerifiedException signal. ].
		subscription _ SPSubscription withList: aSPList contact: aSPContact.
		(subscriptions includes: subscription) ifTrue: [
			SPAlreadySubscribedException signal.
		].
		subscriptions add: subscription.
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/2/2007 18:27'!
subscriptionsForContact: aSPContact

	^ monitor critical: [
		subscriptions select: [ :each | aSPContact = each contact. ].
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/2/2007 18:27'!
subscriptionsForList: aSPList

	^ monitor critical: [
		subscriptions select: [ :each | each list = aSPList. ].
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/2/2007 14:59'!
subscriptionsForUser: aSPUser

	^ monitor critical: [
		subscriptions select: [ :each | SPUser contacts includes: each contact. ].
	].! !

!SPListManager methodsFor: 'subscription' stamp: 'as 1/24/2007 15:28'!
unsubscribe: aSPSubscription

	monitor critical: [
		subscriptions remove: aSPSubscription ifAbsent: [ SPSubscriptionNotFoundException signal. ].
	].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 2/5/2007 10:46'!
userWithAddress: aSPMailAddress

	^ monitor critical: [
		users
			detect: [ :u | (u contacts collect: [ :c | c address. ]) includes: aSPMailAddress. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 1/24/2007 15:26'!
userWithName: aString

	^ monitor critical: [
		users
			detect: [ :each | each name = aString. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/2/2007 15:07'!
verifiedContacts

	| contacts |
	contacts _ IdentitySet new.
	monitor critical: [
		users do: [
			:each |
			contacts addAll: (each verifiedContacts).
		].
	].
	^ contacts.! !

!SPListManager methodsFor: 'verification' stamp: 'as 2/13/2007 16:51'!
verifyContact: aSPContact code: aString

	monitor critical: [
		(self verifiedContacts includes: aSPContact) ifTrue: [
			SPContactAlreadyExistsException signal.
		].
		aSPContact verify: aString.
	].! !

!SPListManager methodsFor: 'verification' stamp: 'as 2/13/2007 16:54'!
verifyUser: userString password: passwordString

	| user verified |
	monitor critical: [
		user _ self userWithName: userString.
		user ifNil: [
			verified _ false.
		] ifNotNil: [
			verified _ user checkPassword: passwordString.
		].
	].
	^ verified.! !

!SPListManager methodsFor: 'get-list' stamp: 'as 2/2/2007 14:52'!
visibleLists

	^ monitor critical: [
		lists select: [ :list | list isVisible.].
	].! !

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

Object subclass: #SPMailHandler
	instanceVariableNames: 'process message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailHandler commentStamp: 'as 1/25/2007 11:32' prior: 0!
Each incoming mail is wrapped in it's own mail handler that runs its own process to handle the message.!

!SPMailHandler class methodsFor: 'instance creation' stamp: 'as 1/25/2007 11:32'!
withMessage: aSPMailMessage

	^ self new message: aSPMailMessage.! !

!SPMailHandler methodsFor: 'utility' stamp: 'as 1/26/2007 17:48'!
forever: aBlock

	[ true. ] whileTrue: [ aBlock value. ].! !

!SPMailHandler methodsFor: 'initialize-release' stamp: 'as 1/25/2007 11:34'!
initialize

	process _ [ self processMessage. ] newProcess.! !

!SPMailHandler methodsFor: 'access' stamp: 'as 1/30/2007 10:22'!
message: aSPMailMessage

	message _ aSPMailMessage.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/12/2007 15:54'!
processMessage

	| recipients |
	[
		recipients _ message listRecipients.
		(message isAllowedPost and: [ recipients notNil. ]) ifTrue: [
			message insertListName; insertReturnPath.
			self sendMessageTo: recipients.
		].
	] ensure: [ SPKernel instance queue removeHandler: self. ].! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/5/2007 10:14'!
sendMessageTo: aCollection

	SPSmtpClient new
		sendMessage: message mail
		from: message sender
		to: aCollection.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/7/2007 00:00'!
start

	process resume.! !

Object subclass: #SPMailListener
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

!SPMailListener methodsFor: 'configuration' stamp: 'as 1/15/2007 11:31'!
config

	^ SPKernel instance configurator.! !

!SPMailListener methodsFor: 'initialize-release' stamp: 'as 12/13/2006 11:02'!
initialize

	service _ SPMailService withListener: self.
	monitor _ Monitor new.
	connections _ IdentitySet new.! !

!SPMailListener methodsFor: 'configuration' stamp: 'as 1/15/2007 11:31'!
listenerMaxConnections

	^ self config preferenceAt: #listenerMaxConnections.! !

!SPMailListener methodsFor: 'configuration' stamp: 'as 1/15/2007 11:31'!
listenerPort

	^ self config preferenceAt: #listenerPort.! !

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

Object subclass: #SPMailMessage
	instanceVariableNames: 'mail sender recipient date'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

SPMailMessage class
	instanceVariableNames: 'monitor messageId'!

!SPMailMessage commentStamp: 'as 2/6/2007 12:38' prior: 0!
The SMTP protocol defines commands for specifying a sender and one or multiple recipient addresses apart from the ones in the header of a mail message (from:, to:, cc:, ...).
This class is a wrapper around MailMessage and stores the SMTP addresses as well, since they are important when relaying mail.!

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

!SPMailMessage methodsFor: 'access' stamp: 'as 2/12/2007 15:58'!
admin

	^ SPKernel instance manager adminForList: self recipientList.! !

!SPMailMessage methodsFor: 'configuration' stamp: 'as 1/15/2007 11:32'!
config

	^ SPKernel instance configurator.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 1/30/2007 10:26'!
date

	^ date.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 1/30/2007 10:26'!
date: aDateAndTime

	date _ aDateAndTime.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 10/17/2006 16:21'!
ensureMessageId: hostnameString

	mail fieldNamed: 'message-id' ifAbsent: [
		mail setField: 'message-id' toString: '<', self class uniqueMessageId asString, '@', hostnameString, '>'.
	].! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 2/12/2007 15:53'!
insertListName

	mail subject: '[', self recipientList name, '] ', mail subject.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 2/12/2007 16:08'!
insertReturnPath

	mail returnPath: self admin path.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 12/4/2006 12:32'!
insertTraceFrom: fromString by: byString

	mail received: 'from ', fromString, ' by ', byString, '; ', MailMessage dateStampNow, ' ', self timezone.
	date _ DateAndTime now.! !

!SPMailMessage methodsFor: 'test' stamp: 'as 2/12/2007 15:32'!
isAllowedPost

	| user |
	user _ SPKernel instance manager userWithAddress: sender.
	^ SPKernel instance manager isAllowed: user toPostTo: self recipientList.! !

!SPMailMessage methodsFor: 'posts' stamp: 'as 2/6/2007 23:34'!
listRecipients

	^ SPKernel instance manager activeRecipientsForList: self recipientList.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 6/12/2006 14:32'!
mail: aString

	mail := MailMessage from: aString.! !

!SPMailMessage methodsFor: 'copy' stamp: 'as 10/5/2006 15:13'!
postCopy

	mail := MailMessage from: mail text.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 2/6/2007 23:35'!
recipient

	^ recipient.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 2/6/2007 23:38'!
recipient: aSPMailAddress

	recipient _ aSPMailAddress.! !

!SPMailMessage methodsFor: 'posts' stamp: 'as 2/6/2007 23:34'!
recipientList

	SPKernel instance manager listWithAddress: recipient.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:13'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:29'!
sender: aSPMailAddress

	sender := aSPMailAddress.! !

!SPMailMessage methodsFor: 'configuration' stamp: 'as 1/17/2007 22:40'!
timezone

	^ self config preferenceAt: #timezone.! !

Object subclass: #SPMailQueue
	instanceVariableNames: 'queue monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Mail queue.!

!SPMailQueue methodsFor: 'queue' stamp: 'as 2/7/2007 00:14'!
addMessages: aCollection

	| handlers |
	handlers _ IdentitySet new.
	monitor critical: [
		self checkFreeQueueSize: aCollection size.
		aCollection do: [
			:each |
			handlers add: (SPMailHandler withMessage: each).
		].
		queue addAll: handlers.
		handlers do: [ :each | each start. ].
	].! !

!SPMailQueue methodsFor: 'check' stamp: 'as 2/7/2007 00:02'!
checkFreeQueueSize: aNumber

	(queue size + aNumber) > self queueSize ifTrue: [
		SPQueueFullException signal.
	].! !

!SPMailQueue methodsFor: 'configuration' stamp: 'as 1/15/2007 18:14'!
config

	^ SPKernel instance configurator.! !

!SPMailQueue methodsFor: 'initialize-release' stamp: 'as 1/30/2007 15:50'!
initialize

	queue _ IdentitySet new.
	monitor _ Monitor new.! !

!SPMailQueue methodsFor: 'configuration' stamp: 'as 1/30/2007 15:51'!
queueSize

	^ self config preferenceAt: #queueSize.! !

!SPMailQueue methodsFor: 'queue' stamp: 'as 2/7/2007 00:00'!
removeHandler: aSPMailHandler

	monitor critical: [
		queue remove: aSPMailHandler.
	].! !

Object subclass: #SPMailReceiver
	instanceVariableNames: 'state stream quit message recipients'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server trying to follow RFC 2821. It only receives mail. One receiver serves one client connection, and the whole will usually be multithreaded.

A SPMailReceiver is created on a socket. Mail reception starts with the receive method. After its return received data is available in the message.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 1/15/2007 17:37'!
withStream: aSocketStream

	^ self new
		stream: aSocketStream;
		postInit;
		yourself.! !

!SPMailReceiver methodsFor: 'check' stamp: 'as 1/30/2007 10:15'!
checkNumberOfRecipients

	message recipients size >= self receiverMaxRecipients ifTrue: [
		(SPTooManyRecipientsSmtpException withReceiver: self) signal.
	].! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 11/15/2006 18:29'!
clientQuit

	quit := true.! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 11/16/2006 17:08'!
close: aString

	self replyClosing: aString.
	stream close.! !

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 1/17/2007 13:39'!
config

	^ SPKernel instance configurator.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 2/6/2007 23:43'!
initMessage

	message _ SPMailMessage new.
	recipients _ IdentitySet new.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/30/2007 10:16'!
initialize

	quit _ false.
	self initMessage.
	self state: SPReadySmtpState.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/6/2007 18:33'!
insertTraces

	| local remote |
	local _ self localName ifNil: [ self localAddress. ].
	remote _ self remoteName ifNil: [ self remoteAddress. ].
	
	message insertTraceFrom: local by: remote;
		ensureMessageId: self serverName;
		date: DateAndTime now.! !

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

!SPMailReceiver methodsFor: 'message' stamp: 'as 1/30/2007 10:17'!
mail: aString

	message mail: aString.! !

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

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/15/2007 17:34'!
postInit

	SPKernel instance listener addConnection: self.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/6/2007 23:46'!
queueMessages

	| messages |
	messages _ IdentitySet new.
	recipients do: [
		:each |
		messages add: (message copy recipient: each).
	].
	SPKernel instance queue queueAll: messages.! !

!SPMailReceiver methodsFor: 'quit' stamp: 'as 1/15/2007 17:35'!
quit

	stream close.
	SPKernel instance listener removeConnection: self.! !

!SPMailReceiver methodsFor: 'receive' stamp: 'as 2/5/2007 16:19'!
receive

	"Receive commands from client as long as connection is there and
	 quit is not requested."
	"In case of an error the connection is closed."

	self reply: (SPSmtpReply ready: self serverName).
	[
		[
			[ quit not and: [ stream isConnected. ] ] whileTrue: [ self receiveCommand. ].
		] on: Exception do: [ :e | self replyClosing: 'Unknown error'. ].
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

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 1/15/2007 17:36'!
receiverMaxMailSize

	^ self config preferenceAt: #receiverMaxMailSize.! !

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 1/15/2007 17:36'!
receiverMaxRecipients

	^ self config preferenceAt: #receiverMaxRecipients.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/6/2007 23:41'!
recipient: aSPMailAddress

	self checkNumberOfRecipients.
	recipients add: aSPMailAddress.! !

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

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/30/2007 10:16'!
reset

	self initMessage.
	self state: SPResetSmtpState.! !

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 1/15/2007 17:36'!
resolverTimeout

	^ self config preferenceAt: #resolverTimeout.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 1/30/2007 10:19'!
sender: aSPMailAddress

	message sender: aSPMailAddress.! !

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 1/15/2007 17:36'!
serverName

	^ self config preferenceAt: #serverName.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 4/20/2006 17:45'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'access' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

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

!SPDataSmtpCommand methodsFor: 'execute' stamp: 'as 2/6/2007 23:43'!
doExecute

	target
		reply: SPSmtpReply mailInput;
		mail: target receiveMail;
		insertTraces;
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

!SPRecipientSmtpCommand methodsFor: 'execute' stamp: 'as 1/15/2007 17:44'!
doExecute

	| list |
	list _ SPKernel instance manager listWithAddress: recipient.
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

!SPSubscription commentStamp: 'as 2/6/2007 12:35' prior: 0!
A subscription subscribes a users contact to a mailing list.!

!SPSubscription class methodsFor: 'instance creation' stamp: 'as 9/5/2006 13:12'!
withList: aSPList contact: aSPContact

	^ self new
		list: aSPList;
		contact: aSPContact;
		yourself.! !

!SPSubscription methodsFor: 'compare' stamp: 'as 1/16/2007 14:17'!
= aSPSubscription

	^ (list = aSPSubscription list) and: [ contact = aSPSubscription contact. ].! !

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

!SPSubscription methodsFor: 'test' stamp: 'as 1/30/2007 16:29'!
isActive

	^ contact isActive and: [ active. ].! !

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

!SPUser methodsFor: 'contacts' stamp: 'as 2/4/2007 21:56'!
addContact: aSPContact

	(contacts includes: aSPContact) ifTrue: [
		SPContactAlreadyExistsException signal.
	].
	contacts add: aSPContact.! !

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:02'!
checkPassword: aString

	^ password check: aString.! !

!SPUser methodsFor: 'access' stamp: 'as 2/2/2007 14:59'!
contacts

	^ contacts.! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:26'!
deactivate

	active := false.! !

!SPUser methodsFor: 'compare' stamp: 'as 3/9/2006 16:52'!
hash

	^ name hash.! !

!SPUser methodsFor: 'initialize-release' stamp: 'as 2/2/2007 18:20'!
initialize

	contacts _ Set new.
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

!SPUser methodsFor: 'contacts' stamp: 'as 2/2/2007 14:36'!
unverifiedContacts

	^ contacts select: [ :contact | contact isVerified not. ].! !

!SPUser methodsFor: 'contacts' stamp: 'as 2/2/2007 14:36'!
verifiedContacts

	^ contacts select: [ :contact | contact isVerified. ].! !

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
	instanceVariableNames: 'main navbar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWeb commentStamp: '<historical>' prior: 0!
Stamp web interface.!

!SPWeb class methodsFor: 'seaside' stamp: 'as 2/6/2007 12:52'!
canBeRoot

	^ true.! !

!SPWeb class methodsFor: 'class initialization' stamp: 'as 7/19/2006 10:19'!
initialize

	"self initialize"

	self registerAsApplication: 'stamp'.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 2/6/2007 14:59'!
children

	^ Array with: navbar with: main.! !

!SPWeb methodsFor: 'initialize-release' stamp: 'as 2/13/2007 16:59'!
initialize

	main _ SPWebEmpty new.
	navbar _ SPWebNavBar withTarget: main.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 2/6/2007 14:51'!
renderContentOn: html

	html divNamed: 'header' with: [
		html heading: self title.
		html paragraph: [ html text: self subtitle. ].
	].
	html divNamed: 'navbar' with: navbar.
	html divNamed: 'content' with: main.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 2/6/2007 13:31'!
subtitle

	^ 'A Mailing List Manager for Squeak.'.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 2/6/2007 13:30'!
title

	^ 'Stamp'.! !

WAComponent subclass: #SPWebEmpty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebEmpty commentStamp: 'as 2/6/2007 15:25' prior: 0!
Dummy page, show nothing.!

!SPWebEmpty methodsFor: 'rendering' stamp: 'as 2/6/2007 14:54'!
renderContentOn: html

	html text: 'Welcome!!'.! !

WAComponent subclass: #SPWebLists
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebLists commentStamp: 'as 2/6/2007 14:56' prior: 0!
List view.!

!SPWebLists methodsFor: 'rendering' stamp: 'as 2/6/2007 15:57'!
renderContentOn: html

	html table: [
		html tableHeadings: #('Name' 'Address').
		SPKernel instance manager allLists do: [
			:each |
			html tableRow: [
				html tableData: [ html text: each name ].
				html tableData: [ html text: each address asString. ].
			].
		].
	].! !

WAComponent subclass: #SPWebLogin
	instanceVariableNames: 'username password'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebLogin commentStamp: 'as 2/12/2007 17:13' prior: 0!
Login dialog.!

!SPWebLogin methodsFor: 'login' stamp: 'as 2/12/2007 18:12'!
cancel

	self answer: nil.! !

!SPWebLogin methodsFor: 'login' stamp: 'as 2/13/2007 17:01'!
login

	self verify ifTrue: [
		self answer: username.
	].! !

!SPWebLogin methodsFor: 'rendering' stamp: 'as 2/13/2007 16:56'!
renderContentOn: html

	html form: [
		html table: [
			html tableRowWithLabel: 'Username:' column: [
				html textInputWithValue: username callback: [ :v | username _ v. ]
			].
			html tableRowWithLabel: 'Password:' column: [
				html passwordInputWithCallback: [ :v | password _ v. ]
			].
			html attributes alignCenter.
			html tableRowWith: [
				html submitButtonOn: #login of: self.
				html space.
				html submitButtonOn: #cancel of: self.
			] span: 2.
		].
	].! !

!SPWebLogin methodsFor: 'login' stamp: 'as 2/12/2007 17:56'!
verify

	^ SPKernel instance manager verifyUser: username password: password.! !

WAComponent subclass: #SPWebNavBar
	instanceVariableNames: 'target context user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

SPWebNavBar class
	instanceVariableNames: 'target'!

!SPWebNavBar commentStamp: 'as 2/6/2007 14:54' prior: 0!
Navigation bar.!

SPWebNavBar class
	instanceVariableNames: 'target'!

!SPWebNavBar class methodsFor: 'instance creation' stamp: 'as 2/13/2007 16:44'!
withTarget: aWAComponent

	^ self new
		target: aWAComponent.! !

!SPWebNavBar methodsFor: 'access' stamp: 'as 2/13/2007 16:02'!
context: aSPWebContext

	context _ aSPWebContext.! !

!SPWebNavBar methodsFor: 'rendering' stamp: 'as 2/6/2007 15:16'!
lists

	target call: (SPWebLists new).! !

!SPWebNavBar methodsFor: 'rendering' stamp: 'as 2/13/2007 16:46'!
login

	user _ target call: (SPWebLogin new).! !

!SPWebNavBar methodsFor: 'rendering' stamp: 'as 2/13/2007 16:57'!
renderContentOn: html

	user ifNotNil: [
		html paragraph: [ html text: 'Logged in as ', user name. ].
	].

	html unorderedList: [
		html listItem: [ html anchorWithAction: [ self lists ] text: 'Lists' ].
		html listItem: [ html anchorWithAction: [ self login ] text: 'Login' ].
	].! !

!SPWebNavBar methodsFor: 'access' stamp: 'as 2/6/2007 15:12'!
target: aWAComponent

	target _ aWAComponent.! !

SMTPClient subclass: #SPSmtpClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPSmtpClient commentStamp: '<historical>' prior: 0!
A smtp client with anonymous login.!

!SPSmtpClient methodsFor: 'configuration' stamp: 'as 1/24/2007 16:27'!
config

	^ SPKernel instance configurator.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 11/17/2006 13:27'!
from: aSPMailAddress

	self sendCommand: 'mail from:', aSPMailAddress path.
	self checkResponse.! !

!SPSmtpClient methodsFor: 'initialize-release' stamp: 'as 1/24/2007 16:27'!
initialize

	| hostIP |
	hostIP _ NetNameResolver
		addressForName: self senderServer
		timeout: self resolverTimeout.
	self
		host: hostIP;
		port: self senderPort.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 1/18/2007 02:40'!
login

	self sendCommand: 'helo me'.
	self checkResponse.! !

!SPSmtpClient methodsFor: 'open-close' stamp: 'as 10/10/2006 14:34'!
open

	self ensureConnection.! !

!SPSmtpClient methodsFor: 'open-close' stamp: 'as 2/22/2006 15:48'!
reopen

	self close.
	self ensureConnection.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 10/10/2006 17:31'!
reset

	self sendCommand: 'rset'.
	self checkResponse.! !

!SPSmtpClient methodsFor: 'configuration' stamp: 'as 1/24/2007 16:27'!
resolverTimeout

	^ self config preferenceAt: #resolverTimeout.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 2/5/2007 11:24'!
sendMessage: aMailMessage from: aSPMailAddress to: aCollection

	[
		self open; from: aSPMailAddress.
		aCollection do: [ :each | self to: each. ].
		self data: aMailMessage text; quit.
	] ensure: [ self close. ].! !

!SPSmtpClient methodsFor: 'configuration' stamp: 'as 1/24/2007 16:27'!
senderPort

	^ self config preferenceAt: #senderPort.! !

!SPSmtpClient methodsFor: 'configuration' stamp: 'as 1/24/2007 16:27'!
senderServer

	^ self config preferenceAt: #senderServer.! !

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 11/17/2006 13:28'!
to: aSPMailAddress

	self sendCommand: 'rcpt to:', aSPMailAddress path.
	self checkResponse.! !
SPMailMessage initialize!
SPSmtpCommand initialize!
SPWeb initialize!
