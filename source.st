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
SystemOrganization addCategory: #'Stamp-Web-Exceptions'!

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

!String methodsFor: '*Stamp' stamp: 'as 2/27/2007 15:14'!
withoutBlanks

	^ self withBlanksCondensed copyReplaceAll: ' ' with: ''.
		
	"' a  bcd  ' withoutBlanks"! !

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

!SPUserTest methodsFor: 'test' stamp: 'as 2/15/2007 12:36'!
testPassword

	user verifyPassword: self userPassword.! !

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

!SPException commentStamp: 'as 2/15/2007 15:49' prior: 0!
Stamp exception.!

SPException subclass: #SPAlreadySubscribedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPAlreadySubscribedException commentStamp: 'as 2/15/2007 16:48' prior: 0!
Subscription already exists.!

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

!SPConfigurationAttributeNotFoundException commentStamp: 'as 2/15/2007 16:48' prior: 0!
Configuration attribute or preference not found.!

SPConfigurationException subclass: #SPImmutableConfigurationAttributeException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPImmutableConfigurationAttributeException commentStamp: 'as 2/15/2007 16:49' prior: 0!
I'm immutable.!

SPConfigurationException subclass: #SPInvalidConfigurationAttributeValueException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration-Attributes'!

!SPInvalidConfigurationAttributeValueException commentStamp: 'as 2/15/2007 16:49' prior: 0!
Invalid value.!

SPException subclass: #SPContactAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactAlreadyExistsException commentStamp: 'as 2/15/2007 16:50' prior: 0!
Contact already exists.!

SPException subclass: #SPContactNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactNotFoundException commentStamp: 'as 2/15/2007 16:50' prior: 0!
Contact not found.!

SPException subclass: #SPContactNotVerifiedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactNotVerifiedException commentStamp: 'as 2/15/2007 16:50' prior: 0!
Contact must be verified but is not.!

SPException subclass: #SPContactVerificationFailedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPContactVerificationFailedException commentStamp: 'as 2/15/2007 16:50' prior: 0!
Verification failed.!

SPException subclass: #SPEmptyArgumentException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPEmptyArgumentException commentStamp: 'as 3/1/2007 18:43' prior: 0!
Argument must not be empty.!

!SPException methodsFor: 'priv handling' stamp: 'as 2/21/2007 13:47'!
defaultAction

	! !

!SPException methodsFor: 'printing' stamp: 'as 2/15/2007 16:43'!
description

	^ messageText
		ifNil: [ self class comment. ]
		ifNotNil: [ self class comment, ' (', messageText, ')'. ].! !

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

!SPListAlreadyExistsException commentStamp: 'as 2/15/2007 16:50' prior: 0!
List already exists.!

SPException subclass: #SPListNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPListNotFoundException commentStamp: 'as 2/15/2007 16:51' prior: 0!
List not found.!

SPException subclass: #SPPasswordConfirmationException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web-Exceptions'!

!SPPasswordConfirmationException commentStamp: 'as 2/23/2007 15:46' prior: 0!
Confirmed password does not match.!

SPException subclass: #SPPostingNotAllowedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPPostingNotAllowedException commentStamp: 'as 2/26/2007 11:57' prior: 0!
Posting not allowed.!

SPException subclass: #SPQueueFullException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPQueueFullException commentStamp: 'as 2/15/2007 16:52' prior: 0!
Queue is full.!

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

!SPConnectionClosedException commentStamp: 'as 2/15/2007 16:52' prior: 0!
Connection unexpectedly closed.!

!SPConnectionClosedException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:07'!
defaultAction

	receiver clientQuit.! !

SPReceiverException subclass: #SPConnectionTimedOutException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPConnectionTimedOutException commentStamp: 'as 2/15/2007 16:52' prior: 0!
Connection timed out.!

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

!SPSmtpException commentStamp: 'as 2/15/2007 16:52' prior: 0!
Client SMTP command error.!

SPSmtpException subclass: #SPCommandNotAllowedSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPCommandNotAllowedSmtpException commentStamp: 'as 2/15/2007 16:53' prior: 0!
Command not allowed.!

!SPCommandNotAllowedSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpException subclass: #SPCommandNotFoundSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPCommandNotFoundSmtpException commentStamp: 'as 2/15/2007 16:53' prior: 0!
Command not found.!

!SPCommandNotFoundSmtpException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

SPSmtpException subclass: #SPLineTooLongSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPLineTooLongSmtpException commentStamp: 'as 2/15/2007 16:53' prior: 0!
Line too long.!

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

!SPTooManyRecipientsSmtpException commentStamp: 'as 2/15/2007 16:53' prior: 0!
Maximum number of recipients reached.!

!SPTooManyRecipientsSmtpException methodsFor: 'priv handling' stamp: 'as 10/18/2006 20:40'!
reply

	^ SPSmtpReply tooManyRecipients.! !

SPSmtpException subclass: #SPTooMuchMailDataSmtpException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooMuchMailDataSmtpException commentStamp: 'as 2/15/2007 16:54' prior: 0!
Too much mail data.!

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

!SPTooManyConnectionsException commentStamp: 'as 2/15/2007 16:54' prior: 0!
Too many connections.!

!SPTooManyConnectionsException methodsFor: 'priv handling' stamp: 'as 11/16/2006 17:08'!
defaultAction

	receiver close: 'Too many connections'.! !

SPException subclass: #SPRootUserException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPRootUserException commentStamp: 'as 2/15/2007 16:54' prior: 0!
Not allowed for root user.!

SPException subclass: #SPSubscriptionNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPSubscriptionNotFoundException commentStamp: 'as 2/15/2007 16:54' prior: 0!
Subscription not found!

SPException subclass: #SPSyntaxException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPSyntaxException commentStamp: 'as 2/15/2007 12:49' prior: 0!
Invalid syntax.!

SPException subclass: #SPTooMuchDataException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Exceptions'!

!SPTooMuchDataException commentStamp: 'as 2/15/2007 16:54' prior: 0!
Too much data.!

SPException subclass: #SPUserAlreadyExistsException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPUserAlreadyExistsException commentStamp: 'as 2/15/2007 16:54' prior: 0!
User already exists.!

SPException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPUserNotFoundException commentStamp: 'as 2/15/2007 16:55' prior: 0!
User not found.!

SPException subclass: #SPWrongPasswordException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Exceptions'!

!SPWrongPasswordException commentStamp: 'as 2/15/2007 16:55' prior: 0!
Wrong password.!

WATask subclass: #SPWebTask
	instanceVariableNames: 'user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebTask commentStamp: 'as 2/22/2007 13:55' prior: 0!
Models the main web application.!

!SPWebTask methodsFor: 'util' stamp: 'as 2/22/2007 14:18'!
forever: aBlock

	[ true. ] whileTrue: [ aBlock value. ].! !

!SPWebTask methodsFor: 'rendering' stamp: 'as 2/22/2007 14:17'!
go

	self forever: [
		user _ self call: SPWebMain new.
		self isolate: [ self call: (SPWebMain withUser: user). ].
	].! !

WAComponent subclass: #SPWAComponent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWAComponent commentStamp: 'as 2/15/2007 14:48' prior: 0!
Basic web application functionality for Stamp.!

!SPWAComponent methodsFor: 'exception' stamp: 'as 3/1/2007 18:40'!
do: aBlock catchExceptions: exceptions

	aBlock on: exceptions do: [
		: ex |
		self call: (SPWebExceptionDisplay withException: ex).
	].! !

!SPWAComponent methodsFor: 'rendering' stamp: 'as 2/28/2007 14:36'!
renderTitle: aString renderer: html

	html heading: aString level: 2.! !

SPWAComponent subclass: #SPWATable
	instanceVariableNames: 'table'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWATable commentStamp: 'as 2/28/2007 12:51' prior: 0!
Abstract component for table reports (see WATabelReport).!

!SPWATable methodsFor: 'rendering' stamp: 'as 2/28/2007 12:48'!
children

	^ Array with: table.! !

!SPWATable methodsFor: 'rendering' stamp: 'as 2/28/2007 12:49'!
columns

	self subclassResponsibility.! !

!SPWATable methodsFor: 'initialization' stamp: 'as 2/28/2007 14:37'!
initTable

	table _ WATableReport new rows: (self rows); columns: (self columns); yourself.
	table rowPeriod: 1; rowColors: self rowColors.! !

!SPWATable methodsFor: 'rendering' stamp: 'as 2/28/2007 15:59'!
renderContentOn: html

	self initTable.
	html render: table.! !

!SPWATable methodsFor: 'rendering' stamp: 'as 2/28/2007 16:03'!
rowColors

	^ #('white' 'lightgray').! !

!SPWATable methodsFor: 'rendering' stamp: 'as 2/28/2007 12:50'!
rows

	self subclassResponsibility.! !

SPWATable subclass: #SPWebConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebConfiguration commentStamp: 'as 2/28/2007 12:27' prior: 0!
Configuration editor.!

!SPWebConfiguration methodsFor: 'rendering' stamp: 'as 3/1/2007 18:21'!
columns

	^ OrderedCollection new
		add: (WAReportColumn selector: #key title: 'Name');
		add: (WAReportColumn selector: #value title: 'Value');
		add: (WAReportColumn new title: 'Edit'; valueBlock: [ :item | 'edit'. ]; clickBlock: [ :item | self edit: item. ]; yourself);
		yourself.! !

!SPWebConfiguration methodsFor: 'call/answer' stamp: 'as 3/1/2007 18:27'!
edit: anAssociation

	self call: (SPWebEditPreference withKey: anAssociation key value: anAssociation value).! !

!SPWebConfiguration methodsFor: 'rendering' stamp: 'as 3/1/2007 18:25'!
renderContentOn: html

	self renderTitle: 'Preferences' renderer: html.
	super renderContentOn: html.! !

!SPWebConfiguration methodsFor: 'rendering' stamp: 'as 3/1/2007 18:16'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance configurator allPreferences associations);
		yourself.! !

SPWATable subclass: #SPWebContacts
	instanceVariableNames: 'user address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebContacts commentStamp: 'as 2/14/2007 15:11' prior: 0!
Contact management.!

!SPWebContacts class methodsFor: 'instance creation' stamp: 'as 2/14/2007 22:11'!
withUser: aSPUser

	^ self new
		user: aSPUser.! !

!SPWebContacts methodsFor: 'contacts' stamp: 'as 2/27/2007 12:27'!
add

	self do: [
		SPMailNotifier verifyContact:
			(SPKernel instance manager addContact: address user: user).
	] catchExceptions: SPException.! !

!SPWebContacts methodsFor: 'rendering' stamp: 'as 2/28/2007 18:58'!
columns

	^ OrderedCollection new
		add: (WAReportColumn selector: #address title: 'Address');
		add: (WAReportColumn new title: 'Subscriptions'; valueBlock: [ :item | self numberOfSubscriptions: item. ]; yourself);
		add: ((WAReportColumn selector: #isActive title: 'Active') clickBlock: [ :item | item invertActivation.]; yourself);
		add: ((WAReportColumn selector: #isVerified title: 'Verified') clickBlock: [ :item | self verify: item.]; yourself);
		add: (WAReportColumn new title: 'Remove'; valueBlock: [ : item | 'remove'. ]; clickBlock: [ :item | self remove: item.]; yourself);
		yourself.! !

!SPWebContacts methodsFor: 'rendering' stamp: 'as 2/28/2007 19:04'!
confirmRemove: aSPContact

	| subscriptions |
	subscriptions _ self numberOfSubscriptions: aSPContact.
	subscriptions > 0 ifTrue: [
		^ self confirm: 'Do you really want to remove the contact ', aSPContact address asString, ' and its ', subscriptions asString, ' subscription(s)?'.
	] ifFalse: [
		^ true.
	].! !

!SPWebContacts methodsFor: 'contacts' stamp: 'as 2/28/2007 18:54'!
numberOfSubscriptions: aSPContact

	^ SPKernel instance manager numberOfSubscriptionsForContact: aSPContact.! !

!SPWebContacts methodsFor: 'contacts' stamp: 'as 2/28/2007 15:32'!
remove: aSPContact

	(self confirmRemove: aSPContact) ifTrue: [
		self do: [ SPKernel instance manager removeContact: aSPContact. ]
		catchExceptions: SPException.
	].! !

!SPWebContacts methodsFor: 'rendering' stamp: 'as 2/21/2007 13:48'!
renderAddContact: html

	html form: [
		html table: [
			html tableRow: [
				html textInputWithValue: address callback: [ :v | address _ v. ].
				html submitButtonWithAction: [ self add. ] text: 'Add address'.
			].
		].
	].! !

!SPWebContacts methodsFor: 'rendering' stamp: 'as 2/28/2007 15:52'!
renderContentOn: html

	self renderTitle: 'Contacts' renderer: html.
	super renderContentOn: html.
	html horizontalRule.
	self renderAddContact: html.! !

!SPWebContacts methodsFor: 'rendering' stamp: 'as 2/28/2007 15:37'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager allContactsForUser: user);
		yourself.! !

!SPWebContacts methodsFor: 'access' stamp: 'as 2/14/2007 22:12'!
user: aSPUser

	user _ aSPUser.! !

!SPWebContacts methodsFor: 'contacts' stamp: 'as 2/28/2007 15:52'!
verify: aSPContact

	aSPContact isVerified ifFalse: [
		self call: (SPWebContactVerification withContact: aSPContact).
	].! !

SPWATable subclass: #SPWebListAdmin
	instanceVariableNames: 'name address description'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebListAdmin commentStamp: 'as 2/22/2007 16:10' prior: 0!
List admin view.!

!SPWebListAdmin methodsFor: 'lists' stamp: 'as 2/26/2007 09:50'!
add

	self do: [
		SPKernel instance manager addList: address name: name description: description.
	] catchExceptions: SPException.! !

!SPWebListAdmin methodsFor: 'rendering' stamp: 'as 3/1/2007 17:35'!
columns

	^ OrderedCollection new
		add: (WAReportColumn selector: #name title: 'Name');
		add: (WAReportColumn selector: #address title: 'Address');
		add: (WAReportColumn selector: #admin title: 'Admin');
		add: (WAReportColumn selector: #description title: 'Description');
		add: (WAReportColumn new title: 'Subscriptions'; valueBlock: [ :item | self numberOfSubscriptions: item. ]);
		add: (WAReportColumn selector: #isLocked title: 'Locked' onClick: [ :item | item invertLocking. ]);
		add: (WAReportColumn new title: 'Edit'; valueBlock: [ : item | 'edit'. ]; clickBlock: [ :item | self edit: item.]);
		add: (WAReportColumn new title: 'Remove'; valueBlock: [ : item | 'remove'. ]; clickBlock: [ :item | self remove: item.]);
		yourself.! !

!SPWebListAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 21:36'!
confirmRemove: aSPList

	| subscriptions |
	subscriptions _ self numberOfSubscriptions: aSPList.
	subscriptions > 0 ifTrue: [
		^ self confirm:  'Do you really want to remove the list ', aSPList name, ' and its ', subscriptions asString, ' subscription(s)?'.
	] ifFalse: [
		^ true.
	].! !

!SPWebListAdmin methodsFor: 'lists' stamp: 'as 3/1/2007 18:12'!
edit: aSPList

	self call: (SPWebEditList withList: aSPList).! !

!SPWebListAdmin methodsFor: 'lists' stamp: 'as 2/28/2007 17:25'!
numberOfSubscriptions: aSPList

	^ SPKernel instance manager numberOfSubscriptionsForList: aSPList.! !

!SPWebListAdmin methodsFor: 'lists' stamp: 'as 2/28/2007 17:22'!
remove: aSPList

	(self confirmRemove: aSPList) ifTrue: [
		self do: [
			SPKernel instance manager removeList: aSPList.
		] catchExceptions: SPException.
	].! !

!SPWebListAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 17:28'!
renderAddList: html

	html form: [
		html table: [
			html tableRowWithLabel: 'Name:' column: [
				html textInputWithValue: name callback: [ :v | name _ v. ]
			].
			html tableRowWithLabel: 'Address:' column: [
				html textInputWithValue: address callback: [ :v | address _ v. ]
			].
			html tableRowWithLabel: 'Description:' column: [
				html textInputWithValue: description callback: [ :v | description _ v. ]
			].
			html attributes alignCenter.
			html tableRowWith: [
				html submitButtonOn: #add of: self.
			] span: 3.
		].
	].! !

!SPWebListAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 17:15'!
renderContentOn: html

	self renderTitle: 'List Administration' renderer: html.
	super renderContentOn: html.
	html horizontalRule.
	self renderAddList: html.
	! !

!SPWebListAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 17:15'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager allLists);
		yourself.! !

SPWATable subclass: #SPWebListView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebListView commentStamp: 'as 2/6/2007 14:56' prior: 0!
List view.!

SPWebListView subclass: #SPWebListSubscription
	instanceVariableNames: 'user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebListSubscription commentStamp: 'as 2/28/2007 18:33' prior: 0!
List view with subscription button.!

!SPWebListSubscription class methodsFor: 'instance creation' stamp: 'as 2/28/2007 18:37'!
withUser: aSPUser

	^ self new
		user: aSPUser;
		yourself.! !

!SPWebListSubscription methodsFor: 'rendering' stamp: 'as 2/28/2007 18:35'!
columns

	^ super columns
		add: (WAReportColumn new title: 'Subscribe'; valueBlock: [ :item | 'subscribe'. ]; clickBlock: [ :item | self subscribe: item. ]; yourself);
		yourself.! !

!SPWebListSubscription methodsFor: 'subscription' stamp: 'as 2/28/2007 18:38'!
subscribe: aSPList

	self call: (SPWebSubscribe withUser: user list: aSPList).! !

!SPWebListSubscription methodsFor: 'access' stamp: 'as 2/28/2007 18:37'!
user: aSPUser

	user _ aSPUser.! !

!SPWebListView methodsFor: 'rendering' stamp: 'as 2/27/2007 16:16'!
columns

	^ OrderedCollection new 
		add: (WAReportColumn selector: #name title: 'Name');
		add: (WAReportColumn selector: #address title: 'Address');
		add: (WAReportColumn selector: #description title: 'Description');
		add: (WAReportColumn selector: #isLocked title: 'Locked');
		yourself.! !

!SPWebListView methodsFor: 'rendering' stamp: 'as 2/28/2007 17:35'!
renderContentOn: html

	html heading: 'Lists' level: 2.
	super renderContentOn: html.! !

!SPWebListView methodsFor: 'rendering' stamp: 'as 2/27/2007 15:45'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager allLists);
		yourself.! !

SPWATable subclass: #SPWebQueue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebQueue commentStamp: 'as 2/23/2007 16:38' prior: 0!
Mail queue view.!

!SPWebQueue methodsFor: 'rendering' stamp: 'as 2/28/2007 23:17'!
columns

	^ OrderedCollection new
		add: (WAReportColumn new title: 'Subject'; valueBlock: [ :item | item message subject. ]; yourself);
		add: (WAReportColumn new title: 'Sender'; valueBlock: [ :item | item message sender. ]; yourself);
		add: (WAReportColumn new title: 'Date'; valueBlock: [ :item | item message date. ]; yourself);
		add: (WAReportColumn selector: #state title: 'State');
		add: (WAReportColumn new title: 'Attempts'; valueBlock: [ :item | item attempts asString, '/', self queueSendAttempts asString. ]; yourself);
		yourself.! !

!SPWebQueue methodsFor: 'configuration' stamp: 'as 2/28/2007 23:10'!
config

	^ SPKernel instance configurator.! !

!SPWebQueue methodsFor: 'configuration' stamp: 'as 2/28/2007 23:11'!
queueSendAttempts

	^ self config preferenceAt: #queueSendAttempts.! !

!SPWebQueue methodsFor: 'rendering' stamp: 'as 2/28/2007 18:27'!
renderContentOn: html

	self renderTitle: 'Message Queue' renderer: html.
	super renderContentOn: html.! !

!SPWebQueue methodsFor: 'rendering' stamp: 'as 2/28/2007 17:37'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance queue handlers);
		yourself.! !

SPWATable subclass: #SPWebSubscriptionAdmin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebSubscriptionAdmin commentStamp: 'as 2/27/2007 22:00' prior: 0!
Subscription administration.!

!SPWebSubscriptionAdmin methodsFor: 'subscription' stamp: 'as 2/28/2007 17:49'!
accept: aSPSubscription

	self do: [
		aSPSubscription accepted: true.
		SPMailNotifier acceptedSubscription: aSPSubscription.
	] catchExceptions: SPException.! !

!SPWebSubscriptionAdmin methodsFor: 'rendering' stamp: 'as 2/27/2007 22:12'!
columns

	^ OrderedCollection new 
		add: (WAReportColumn new title: 'List'; valueBlock: [ :item | item list address. ]);
		add: (WAReportColumn new title: 'Contact'; valueBlock: [ :item | item contact address. ]);
		add: (WAReportColumn new title: 'Accept'; valueBlock: [ :item | 'accept'. ]; clickBlock: [ :item | self accept: item. ]);
		add: (WAReportColumn new title: 'Deny'; valueBlock: [ :item | 'deny'. ]; clickBlock: [ :item | self deny: item. ]);
		yourself.! !

!SPWebSubscriptionAdmin methodsFor: 'subscription' stamp: 'as 2/28/2007 17:50'!
deny: aSPSubscription

	self do: [
		SPKernel instance manager unsubscribe: aSPSubscription.
		SPMailNotifier deniedSubscription: aSPSubscription.
	] catchExceptions: SPException.! !

!SPWebSubscriptionAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 18:26'!
renderContentOn: html

	self renderTitle: 'Pending Subscriptions' renderer: html.
	super renderContentOn: html.! !

!SPWebSubscriptionAdmin methodsFor: 'rendering' stamp: 'as 2/27/2007 22:05'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager pendingSubscriptions);
		yourself.! !

SPWATable subclass: #SPWebSubscriptions
	instanceVariableNames: 'user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebSubscriptions commentStamp: 'as 2/27/2007 17:13' prior: 0!
Subscriptions management.!

!SPWebSubscriptions class methodsFor: 'instance creation' stamp: 'as 2/27/2007 17:18'!
withUser: aSPUser

	^ self new
		user: aSPUser;
		yourself.! !

!SPWebSubscriptions methodsFor: 'rendering' stamp: 'as 2/27/2007 21:57'!
columns

	^ OrderedCollection new 
		add: (WAReportColumn new title: 'List'; valueBlock: [ :item | item list address. ]);
		add: (WAReportColumn new title: 'Contact'; valueBlock: [ :item | item contact address. ]);
		add: (WAReportColumn selector: #isActive title: 'Active' onClick: [ :item | item invertActivation. ]);
		add: (WAReportColumn selector: #isAccepted title: 'Accepted');
		add: (WAReportColumn new title: 'Remove'; valueBlock: [ :item | 'remove'. ]; clickBlock: [ :item | self unsubscribe: item. ]);
		yourself.! !

!SPWebSubscriptions methodsFor: 'rendering' stamp: 'as 2/28/2007 18:29'!
renderContentOn: html

	self renderTitle: 'Subscriptions' renderer: html.
	super renderContentOn: html.! !

!SPWebSubscriptions methodsFor: 'rendering' stamp: 'as 2/27/2007 22:03'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager subscriptionsForUser: user);
		yourself.! !

!SPWebSubscriptions methodsFor: 'subscription' stamp: 'as 2/27/2007 17:29'!
unsubscribe: aSPSubscription

	self do: [
		SPKernel instance manager unsubscribe: aSPSubscription.
	] catchExceptions: SPException.! !

!SPWebSubscriptions methodsFor: 'access' stamp: 'as 2/27/2007 17:18'!
user: aSPUser

	user _ aSPUser.! !

SPWATable subclass: #SPWebUserAdmin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebUserAdmin commentStamp: 'as 2/23/2007 14:58' prior: 0!
User admin view.!

!SPWebUserAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 18:04'!
columns

	^ OrderedCollection new 
		add: (WAReportColumn selector: #name title: 'Name');
		add: (WAReportColumn new title: 'Contacts'; valueBlock: [ :item | self numberOfContacts: item.]; yourself);
		add: (WAReportColumn new title: 'Subscriptions'; valueBlock: [ :item | self numberOfSubscriptions: item.]; yourself);
		add: (WAReportColumn new title: 'Remove'; valueBlock: [ :item | 'remove'.]; clickBlock: [ :item | self remove: item. ]; yourself);
		yourself.! !

!SPWebUserAdmin methodsFor: 'user' stamp: 'as 2/28/2007 18:05'!
numberOfContacts: aSPUser

	^ SPKernel instance manager numberOfContactsForUser: aSPUser.! !

!SPWebUserAdmin methodsFor: 'user' stamp: 'as 2/28/2007 18:05'!
numberOfSubscriptions: aSPUser

	^ SPKernel instance manager numberOfSubscriptionsForUser: aSPUser.! !

!SPWebUserAdmin methodsFor: 'user' stamp: 'as 2/28/2007 18:15'!
remove: aSPUser

	self call: (SPWebUnregister withUser: aSPUser).! !

!SPWebUserAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 18:23'!
renderContentOn: html

	self renderTitle: 'Users' renderer: html.
	super renderContentOn: html.! !

!SPWebUserAdmin methodsFor: 'rendering' stamp: 'as 2/28/2007 17:55'!
rows

	^ OrderedCollection new
		addAll: (SPKernel instance manager allUsers);
		yourself.! !

SPWAComponent subclass: #SPWeb
	instanceVariableNames: 'main banner'
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

!SPWeb methodsFor: 'rendering' stamp: 'as 2/22/2007 14:02'!
children

	^ Array with: banner with: main.! !

!SPWeb methodsFor: 'initialize-release' stamp: 'as 2/22/2007 14:02'!
initialize

	banner _ SPWebBanner new.
	main _ SPWebTask new.! !

!SPWeb methodsFor: 'rendering' stamp: 'as 2/22/2007 14:02'!
renderContentOn: html

	html divNamed: 'header' with: banner.
	html divNamed: 'main' with: main.! !

SPWAComponent subclass: #SPWebBanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebBanner commentStamp: 'as 2/22/2007 13:56' prior: 0!
A simple banner used as heading of a site.!

!SPWebBanner methodsFor: 'rendering' stamp: 'as 2/22/2007 13:57'!
renderContentOn: html

	html divNamed: 'banner' with: [
		html heading: self title.
		html paragraph: [ html emphasis: self subtitle. ].
	].! !

!SPWebBanner methodsFor: 'rendering' stamp: 'as 2/22/2007 13:58'!
subtitle

	^ 'A Mailing List Manager for Squeak.'.! !

!SPWebBanner methodsFor: 'rendering' stamp: 'as 2/22/2007 13:58'!
title

	^ 'Stamp'.! !

SPWAComponent subclass: #SPWebChangePassword
	instanceVariableNames: 'user oldPassword newPassword confirmPassword'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebChangePassword commentStamp: 'as 2/23/2007 15:03' prior: 0!
Change the password.!

!SPWebChangePassword class methodsFor: 'instance creation' stamp: 'as 2/23/2007 15:11'!
withUser: aSPUser

	^ self new
		user: aSPUser;
		yourself.! !

!SPWebChangePassword methodsFor: 'password' stamp: 'as 2/28/2007 19:09'!
cancel

	self answer.! !

!SPWebChangePassword methodsFor: 'password' stamp: 'as 2/28/2007 15:05'!
change

	self do: [
		newPassword = confirmPassword ifFalse: [
			SPPasswordConfirmationException signal.
		].
		user newPassword: newPassword oldPassword: oldPassword.
		self answer.
	] catchExceptions: SPException.! !

!SPWebChangePassword methodsFor: 'rendering' stamp: 'as 2/28/2007 19:09'!
renderContentOn: html

	self renderTitle: 'Change Password' renderer: html.
	html form: [
		html table: [
			html tableRowWithLabel: 'Old password:' column: [
				html passwordInputWithCallback: [ :v | oldPassword _ v. ]
			].
			html tableRowWithLabel: 'New password:' column: [
				html passwordInputWithCallback: [ :v | newPassword _ v. ]
			].
			html tableRowWithLabel: 'Confirm new password:' column: [
				html passwordInputWithCallback: [ :v | confirmPassword _ v. ]
			].
			html attributes alignCenter.
			html tableRowWith: [
				html submitButtonOn: #change of: self.
				html space.
				html submitButtonOn: #cancel of: self.
			] span: 2.
		].
	].! !

!SPWebChangePassword methodsFor: 'access' stamp: 'as 2/23/2007 15:17'!
user: aSPUser

	user _ aSPUser.! !

SPWAComponent subclass: #SPWebContactVerification
	instanceVariableNames: 'contact code'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebContactVerification commentStamp: 'as 2/23/2007 17:12' prior: 0!
Verify a contact.!

!SPWebContactVerification class methodsFor: 'instance creation' stamp: 'as 2/23/2007 17:13'!
withContact: aSPContact

	^ self new
		contact: aSPContact;
		yourself.! !

!SPWebContactVerification methodsFor: 'verification' stamp: 'as 2/28/2007 19:10'!
cancel

	self answer.! !

!SPWebContactVerification methodsFor: 'access' stamp: 'as 2/23/2007 17:13'!
contact: aSPContact

	contact _ aSPContact.! !

!SPWebContactVerification methodsFor: 'rendering' stamp: 'as 2/28/2007 19:10'!
renderContentOn: html

	self renderTitle: 'Contact Verification' renderer: html.
	html paragraph: [ html text: 'Verifification code for '; emphasis: (contact address); text: ':'. ].
	html form: [
		html textInputWithValue: code callback: [ :v | code _ v. ].
		html submitButtonOn: #verify of: self.
		html submitButtonOn: #cancel of: self.
	].! !

!SPWebContactVerification methodsFor: 'verification' stamp: 'as 2/27/2007 18:02'!
verify

	self do: [
		SPKernel instance manager verifyContact: contact code: code.
		self answer.
	] catchExceptions: SPException.! !

SPWAComponent subclass: #SPWebEditList
	instanceVariableNames: 'list name description admin'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebEditList commentStamp: 'as 3/1/2007 17:52' prior: 0!
Edit a list.!

!SPWebEditList class methodsFor: 'instance creation' stamp: 'as 3/1/2007 17:27'!
withList: aSPList

	^ self new
		list: aSPList;
		yourself.! !

!SPWebEditList methodsFor: 'call/answer' stamp: 'as 3/1/2007 17:46'!
cancel

	self answer.! !

!SPWebEditList methodsFor: 'access' stamp: 'as 3/1/2007 17:51'!
list: aSPList

	list _ aSPList.
	name _ list name.
	admin _ list admin asString.
	description _ list description.
	! !

!SPWebEditList methodsFor: 'rendering' stamp: 'as 3/1/2007 17:34'!
renderContentOn: html

	self renderTitle: 'Edit List' renderer: html.
	html form: [
		html table: [
			html tableRowWithLabel: 'Name:' column: [
				html textInputWithValue: name callback: [ :v | name _ v. ]
			].
			html tableRowWithLabel: 'Address:' column: [
				html text: list address.
			].
			html tableRowWithLabel: 'Admin:' column: [
				html textInputWithValue: admin callback: [ :v | admin _ v. ]
			].
			html tableRowWithLabel: 'Description:' column: [
				html textInputWithValue: description callback: [ :v | description _ v. ]
			].
			html attributes alignCenter.
			html tableRowWith: [
				html submitButtonOn: #save of: self.
				html space.
				html submitButtonOn: #cancel of: self.
			] span: 2.
		].
	].! !

!SPWebEditList methodsFor: 'call/answer' stamp: 'as 3/1/2007 18:04'!
save

	self do: [
		list name: name; description: description.
		admin isEmpty ifTrue: [
			list admin: nil.
		] ifFalse: [
			list admin: (SPMailAddress fromString: admin).
		].
	] catchExceptions: SPException.
	self answer.! !

SPWAComponent subclass: #SPWebEditPreference
	instanceVariableNames: 'user list contact preference key value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebEditPreference commentStamp: 'as 3/1/2007 18:22' prior: 0!
Edit a configuration preference.!

!SPWebEditPreference class methodsFor: 'instance creation' stamp: 'as 3/1/2007 18:31'!
withKey: aSymbol value: anObject

	^ self new
		key: aSymbol;
		value: anObject;
		yourself.! !

!SPWebEditPreference methodsFor: 'call/answer' stamp: 'as 3/1/2007 18:22'!
cancel

	self answer.! !

!SPWebEditPreference methodsFor: 'access' stamp: 'as 3/1/2007 18:27'!
key: aSymbol

	key _ aSymbol.! !

!SPWebEditPreference methodsFor: 'preferences' stamp: 'as 3/1/2007 18:23'!
preferenceAt: aSymbol put: aString

	self do: [
		SPKernel instance configurator preferenceAt: aSymbol putString: aString.
	] catchExceptions: Exception.! !

!SPWebEditPreference methodsFor: 'rendering' stamp: 'as 3/1/2007 18:32'!
renderContentOn: html

	self renderTitle: 'Edit Preference' renderer: html.
	html paragraph: 'New value for preference ', key asString, ':'.
	html form: [
		html textInputWithValue: value callback: [ :v | value _ v. ].
		html submitButtonOn: #save of: self.
		html submitButtonOn: #cancel of: self.
	].! !

!SPWebEditPreference methodsFor: 'call/answer' stamp: 'as 3/1/2007 18:33'!
save

	self do: [
		self preferenceAt: key put: value.
		self answer.
	] catchExceptions: SPException.! !

!SPWebEditPreference methodsFor: 'access' stamp: 'as 3/1/2007 18:30'!
value: anObject

	value _ anObject asString.! !

SPWAComponent subclass: #SPWebEmpty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebEmpty commentStamp: 'as 2/6/2007 15:25' prior: 0!
Dummy page, show nothing.!

!SPWebEmpty methodsFor: 'rendering' stamp: 'as 2/21/2007 12:43'!
renderContentOn: html

	html whitespace.! !

SPWAComponent subclass: #SPWebExceptionDisplay
	instanceVariableNames: 'exception'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebExceptionDisplay commentStamp: 'as 2/14/2007 14:29' prior: 0!
Render a error display for any exception.!

!SPWebExceptionDisplay class methodsFor: 'instance creation' stamp: 'as 2/16/2007 12:31'!
withException: aException

	^ self new
		exception: aException;
		yourself.! !

!SPWebExceptionDisplay methodsFor: 'access' stamp: 'as 2/14/2007 14:42'!
exception: aException

	exception _ aException.! !

!SPWebExceptionDisplay methodsFor: 'call/answer' stamp: 'as 2/28/2007 17:01'!
ok

	self answer.! !

!SPWebExceptionDisplay methodsFor: 'rendering' stamp: 'as 2/28/2007 21:37'!
renderContentOn: html

	self renderTitle: 'Error' renderer: html.
	html paragraph: [ html emphasis: exception description. ].
	html form: [
		html submitButtonOn: #ok of: self.
	].! !

SPWAComponent subclass: #SPWebLogin
	instanceVariableNames: 'username password user repeated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebLogin commentStamp: 'as 2/12/2007 17:13' prior: 0!
Login dialog.!

!SPWebLogin methodsFor: 'login' stamp: 'as 2/28/2007 19:14'!
cancel

	self answer: nil.! !

!SPWebLogin methodsFor: 'initialize-release' stamp: 'as 2/22/2007 15:01'!
initialize

	repeated := false.! !

!SPWebLogin methodsFor: 'login' stamp: 'as 2/22/2007 15:01'!
login

	self verify ifTrue: [
		self answer: user.
	] ifFalse: [
		repeated _ true.
	].! !

!SPWebLogin methodsFor: 'rendering' stamp: 'as 2/28/2007 19:13'!
renderContentOn: html

	self renderTitle: 'Login' renderer: html.
	repeated ifTrue: [
		html emphasis: 'Wrong username or password!!'.
	].
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

!SPWebLogin methodsFor: 'login' stamp: 'as 2/21/2007 13:41'!
verify

	user _ SPKernel instance manager userWithName: username.
	user ifNil: [
		^ false.
	] ifNotNil: [
		^ user verifyPassword: password.
	].! !

SPWAComponent subclass: #SPWebMain
	instanceVariableNames: 'user main body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebMain commentStamp: 'as 2/22/2007 14:19' prior: 0!
Main web application component.!

!SPWebMain class methodsFor: 'instance creation' stamp: 'as 2/22/2007 14:27'!
withUser: aSPUser

	^ self new
		user: aSPUser;
		yourself.! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/22/2007 14:47'!
children

	^ Array with: body.! !

!SPWebMain methodsFor: 'initialize-release' stamp: 'as 2/22/2007 15:05'!
initialize

	body _ SPWebEmpty new.! !

!SPWebMain methodsFor: 'test' stamp: 'as 2/27/2007 14:53'!
isRootUser

	^ SPKernel instance manager isRootUser: user.! !

!SPWebMain methodsFor: 'call/answer' stamp: 'as 2/28/2007 19:13'!
login: aSPUser

	aSPUser ifNotNil: [ self answer: aSPUser. ].! !

!SPWebMain methodsFor: 'call/answer' stamp: 'as 2/22/2007 14:47'!
logout

	self answer.! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:58'!
navigateChangePassword

	body call: (SPWebChangePassword withUser: user).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/28/2007 14:51'!
navigateConfiguration

	body call: (SPWebConfiguration new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:58'!
navigateContacts

	body call: (SPWebContacts withUser: user).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:59'!
navigateListAdministration

	body call: (SPWebListAdmin new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/28/2007 18:39'!
navigateLists

	body call: (SPWebListSubscription withUser: user).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:56'!
navigateLogin

	self login: (body call: (SPWebLogin new)).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:59'!
navigateLogout

	self logout.! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/28/2007 12:29'!
navigatePendingSubscriptions

	body call: (SPWebSubscriptionAdmin new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:59'!
navigateQueue

	body call: (SPWebQueue new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:56'!
navigateRegister

	self login: (body call: SPWebRegister new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 17:30'!
navigateSubscriptions

	body call: (SPWebSubscriptions withUser: user).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 16:00'!
navigateSystem

	body call: (SPWebSystem new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:58'!
navigateUnregister

	(body call: (SPWebUnregister withUser: user)) ifTrue: [ self logout. ].! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/27/2007 15:59'!
navigateUserAdministration

	body call: (SPWebUserAdmin new).! !

!SPWebMain methodsFor: 'navigation' stamp: 'as 2/28/2007 18:32'!
navigateViewLists

	body call: (SPWebListView new).! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/27/2007 15:21'!
publicNavigationItems

	^ #('View Lists' 'Login' 'Register').! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/22/2007 14:33'!
renderContentOn: html

	self renderNavigation: html.
	html divNamed: 'body' with: body.! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/27/2007 14:54'!
renderNavigation: html

	html div: [
		html cssId: 'navigation'.
		user ifNotNil: [
			html paragraph: [ html text: 'Logged in as '; emphasis: user name. ].
			self isRootUser ifTrue: [
				self renderNavigation: html items: self rootNavigationItems.
			] ifFalse: [
				self renderNavigation: html items: self userNavigationItems.
			].
		] ifNil: [
			self renderNavigation: html items: self publicNavigationItems.
		].
	].! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/27/2007 15:15'!
renderNavigation: html items: aCollection

	html unorderedList: [
		aCollection do: [
			:each |
			html listItem: [
				html anchorWithAction:
					[ self perform: ('navigate', each) withoutBlanks asSymbol. ]
				text: each asString.
			].
		].
	].! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/28/2007 14:51'!
rootNavigationItems

	^ #('List Administration' 'User Administration' 'Pending Subscriptions' 'Queue' 'System' 'Configuration' 'Change Password' 'Logout').! !

!SPWebMain methodsFor: 'access' stamp: 'as 2/22/2007 15:06'!
user: aSPUser

	user _ aSPUser.! !

!SPWebMain methodsFor: 'rendering' stamp: 'as 2/27/2007 17:30'!
userNavigationItems

	^ #('Lists' 'Subscriptions' 'Contacts' 'Change Password' 'Unregister' 'Logout').! !

SPWAComponent subclass: #SPWebRegister
	instanceVariableNames: 'username password confirmPassword'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebRegister commentStamp: 'as 2/13/2007 18:04' prior: 0!
Register as new user.!

!SPWebRegister methodsFor: 'register' stamp: 'as 2/28/2007 19:15'!
cancel

	self answer: nil.! !

!SPWebRegister methodsFor: 'register' stamp: 'as 2/28/2007 17:45'!
register

	self do: [
		password = confirmPassword ifFalse: [
			SPPasswordConfirmationException signal.
		].
		self answer: (SPKernel instance manager addUser: username password: password).
	] catchExceptions: SPException.! !

!SPWebRegister methodsFor: 'rendering' stamp: 'as 2/28/2007 21:35'!
renderContentOn: html

	self renderTitle: 'Registration' renderer: html.
	html form: [
		html table: [
			html tableRowWithLabel: 'Username:' column: [
				html textInputWithValue: username callback: [ :v | username _ v. ]
			].
			html tableRowWithLabel: 'Password:' column: [
				html passwordInputWithCallback: [ :v | password _ v. ]
			].
			html tableRowWithLabel: 'Confirm password:' column: [
				html passwordInputWithCallback: [ :v | confirmPassword _ v. ]
			].
			html attributes alignCenter.
			html tableRowWith: [
				html submitButtonOn: #register of: self.
				html space.
				html submitButtonOn: #cancel of: self.
			] span: 2.
		].
	].! !

SPWAComponent subclass: #SPWebSubscribe
	instanceVariableNames: 'user list contact'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebSubscribe commentStamp: 'as 2/27/2007 16:08' prior: 0!
Subscribe a user to a list.!

!SPWebSubscribe class methodsFor: 'instance creation' stamp: 'as 2/27/2007 16:10'!
withUser: aSPUser list: aSPList

	^ self new
		user: aSPUser;
		list: aSPList;
		yourself.! !

!SPWebSubscribe methodsFor: 'subscription' stamp: 'as 2/28/2007 19:20'!
cancel

	self answer.! !

!SPWebSubscribe methodsFor: 'contacts' stamp: 'as 2/27/2007 16:39'!
contacts

	^ SPKernel instance manager contactsForUser: user.! !

!SPWebSubscribe methodsFor: 'access' stamp: 'as 2/27/2007 16:08'!
list: aSPList

	list _ aSPList.! !

!SPWebSubscribe methodsFor: 'rendering' stamp: 'as 2/28/2007 19:19'!
renderContentOn: html

	self renderTitle: 'Subscription' renderer: html.
	html paragraph: [ html text: 'Subscribe '; emphasis: (user name); text: ' to '; emphasis: (list name); text: ' with contact:'. ].
	html form: [
		html
			selectFromList: self contacts
			selected: contact
			callback: [ :item | contact _ item. ]
			labels: [ : item | item address. ].
		html submitButtonOn: #subscribe of: self.
		html submitButtonOn: #cancel of: self.
	].! !

!SPWebSubscribe methodsFor: 'subscription' stamp: 'as 2/27/2007 16:37'!
subscribe

	self do: [
		SPKernel instance manager subscribe: contact to: list.
		self answer.
	] catchExceptions: SPException.! !

!SPWebSubscribe methodsFor: 'access' stamp: 'as 2/27/2007 16:08'!
user: aSPUser

	user _ aSPUser.! !

SPWAComponent subclass: #SPWebSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebSystem commentStamp: 'as 2/26/2007 13:16' prior: 0!
System management.!

!SPWebSystem methodsFor: 'rendering' stamp: 'as 2/26/2007 14:07'!
renderContentOn: html

	html heading: 'System' level: 2.
	html paragraph: [
		html anchorWithAction: [ self restartListener. ] text: 'Restart listener'.
	].! !

!SPWebSystem methodsFor: 'listener' stamp: 'as 2/28/2007 17:53'!
restartListener

	SPKernel instance listener restart.! !

SPWAComponent subclass: #SPWebUnregister
	instanceVariableNames: 'user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Web'!

!SPWebUnregister commentStamp: 'as 2/21/2007 17:46' prior: 0!
Unregister (remove) the user.!

!SPWebUnregister class methodsFor: 'instance creation' stamp: 'as 2/21/2007 17:47'!
withUser: aSPUser

	^ self new
		user: aSPUser;
		yourself.! !

!SPWebUnregister methodsFor: 'rendering' stamp: 'as 2/28/2007 19:04'!
confirmUnregister

	^ self confirm: 'Do you really want to remove the user ', user name, ' with its ', self numberOfContacts asString, ' contact(s) and ', self numberOfSubscriptions asString, ' subscription(s)?'.! !

!SPWebUnregister methodsFor: 'user' stamp: 'as 2/28/2007 18:10'!
numberOfContacts

	^ SPKernel instance manager numberOfContactsForUser: user.! !

!SPWebUnregister methodsFor: 'user' stamp: 'as 2/28/2007 18:10'!
numberOfSubscriptions

	^ SPKernel instance manager numberOfSubscriptionsForUser: user.! !

!SPWebUnregister methodsFor: 'rendering' stamp: 'as 2/28/2007 18:07'!
renderContentOn: html

	self confirmUnregister ifTrue: [
		self unregister.
		self answer: true.
	] ifFalse: [
		self answer: false.
	].! !

!SPWebUnregister methodsFor: 'call/answer' stamp: 'as 2/26/2007 09:52'!
unregister

	self do: [ SPKernel instance manager removeUser: user. ]
		catchExceptions: SPException.! !

!SPWebUnregister methodsFor: 'access' stamp: 'as 2/21/2007 17:53'!
user: aSPUser

	user _ aSPUser.! !

Object subclass: #SPConfiguration
	instanceVariableNames: 'attributes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfiguration commentStamp: 'as 1/15/2007 18:16' prior: 0!
Stores configuration attributes and connects them to a symbol. The values of the attributes are called preferences and can be changed with the appropriate methods.!

!SPConfiguration methodsFor: 'preferences' stamp: 'as 2/28/2007 13:03'!
allPreferences

	| preferences |
	preferences _ Dictionary new.
	attributes associationsDo: [
		:attribute |
		preferences at: attribute key put: attribute value value.
	].
	^ preferences.! !

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

!SPConfiguration methodsFor: 'preferences' stamp: 'as 2/28/2007 14:47'!
preferenceAt: aSymbol putString: aString

	(self attributeAt: aSymbol) valueFromString: aString.! !

SPConfiguration subclass: #SPStampConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPStampConfiguration commentStamp: 'as 1/16/2007 11:28' prior: 0!
Initializes a default configuration for Stamp.!

!SPStampConfiguration methodsFor: 'initialize-release' stamp: 'as 2/28/2007 22:58'!
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
		(SPAddressConfigurationAttribute withValue: (SPMailAddress fromString: 'postmaster@localhost')).

	"listener"
	self attributeAt: #listenerMaxConnections put:
		(SPIntegerConfigurationAttribute withValue: 10 min: 0 max: 100).
	self attributeAt: #listenerPort put:
		(SPIntegerConfigurationAttribute withValue: 2525 min: 1 max: 65536).
		
	"receiver"
	self attributeAt: #receiverMaxMailSize put:
		(SPIntegerConfigurationAttribute withValue: 1024 * 1024 min: 64 * 1024 max: 16 * 1024 * 1024).
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
	self attributeAt: #queueSendAttempts put:
		(SPIntegerConfigurationAttribute withValue: 10 min: 1 max: 1000).
	self attributeAt: #queueDelaySeconds put:
		(SPIntegerConfigurationAttribute withValue: 120 min: 60 max: 3600).

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

!SPAddressConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/28/2007 12:42'!
fromString: aString

	^ SPMailAddress fromString: aString.! !

!SPAddressConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/8/2007 16:22'!
type

	^ SPMailAddress.! !

!SPConfigurationAttribute class methodsFor: 'instance creation' stamp: 'as 12/12/2006 12:56'!
withValue: anObject

	^ self new value: anObject.! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 12/12/2006 12:45'!
checkMutable

	mutable ifFalse: [ SPImmutableConfigurationAttributeException signal. ].! !

!SPConfigurationAttribute methodsFor: 'check' stamp: 'as 2/28/2007 12:38'!
checkValue: anObject

	(anObject isKindOf: self type) ifFalse:
		[ SPInvalidConfigurationAttributeValueException signal: 'Value must be of kind: ', self type asString. ].! !

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/28/2007 12:39'!
fromString: aString

	self subclassResponsibility.! !

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

!SPConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/28/2007 12:39'!
valueFromString: aString

	self value: (self fromString: aString).! !

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

!SPNumberConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/28/2007 12:41'!
fromString: aString

	^ aString asNumber.! !

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

!SPStringConfigurationAttribute methodsFor: 'configuration' stamp: 'as 2/28/2007 12:41'!
fromString: aString

	^ aString.! !

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

!SPConfigurator methodsFor: 'configuration' stamp: 'as 2/28/2007 13:04'!
allPreferences

	^ monitor critical: [
		config allPreferences.
	].! !

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

!SPConfigurator methodsFor: 'configuration' stamp: 'as 2/28/2007 14:47'!
preferenceAt: aSymbol putString: aString

	monitor critical: [
		config preferenceAt: aSymbol putString: aString.
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

!SPContact methodsFor: 'compare' stamp: 'as 2/28/2007 16:43'!
<= aSPContact

	^ address asString <= aSPContact address asString.

	! !

!SPContact methodsFor: 'compare' stamp: 'as 2/27/2007 17:08'!
= anObject

	^ self hash = anObject hash.! !

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
activate

	active := true.! !

!SPContact methodsFor: 'state' stamp: 'as 2/21/2007 15:08'!
active: aBoolean

	active _ aBoolean.! !

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

!SPContact methodsFor: 'compare' stamp: 'as 2/27/2007 17:53'!
hash

	^ address asString hash.! !

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

!SPContact methodsFor: 'verification' stamp: 'as 2/23/2007 18:00'!
verify: aString

	self isVerified ifFalse: [
		verification = aString ifTrue: [ verification _ nil. ].
	].
	^ self isVerified.! !

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
	instanceVariableNames: 'address name description closed admin locked'
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

!SPList methodsFor: 'compare' stamp: 'as 2/27/2007 17:42'!
= anObject

	^ self hash = anObject hash.! !

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address

	^ address.! !

!SPList methodsFor: 'access' stamp: 'as 9/26/2006 17:10'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPList methodsFor: 'access' stamp: 'as 3/1/2007 17:55'!
admin

	^ admin.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:17'!
admin: aSPMailAddress

	admin _ aSPMailAddress.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:08'!
description

	^ description.! !

!SPList methodsFor: 'access' stamp: 'as 2/6/2007 18:08'!
description: aString

	^ description _ aString.! !

!SPList methodsFor: 'compare' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 2/27/2007 15:45'!
initialize

	self locked: true.
	self description: ''.! !

!SPList methodsFor: 'state' stamp: 'as 2/27/2007 15:30'!
invertLocking

	locked _ locked not.! !

!SPList methodsFor: 'test' stamp: 'as 2/27/2007 15:33'!
isLocked

	^ locked.! !

!SPList methodsFor: 'access' stamp: 'as 2/27/2007 15:30'!
locked: aBoolean

	locked _ aBoolean.! !

!SPList methodsFor: 'access' stamp: 'as 10/5/2006 14:47'!
name

	^ name.! !

!SPList methodsFor: 'access' stamp: 'as 3/1/2007 13:02'!
name: aString

	name _ aString.! !

Object subclass: #SPListManager
	instanceVariableNames: 'users lists subscriptions monitor contacts newContacts'
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

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/22/2007 15:31'!
addContact: addressString user: aSPUser

	| address contact |
	address _ SPMailAddress fromString: addressString.
	contact _ SPContact withAddress: address user: aSPUser.
	self assert: (contact isVerified not).
	monitor critical: [
		self checkUserExists: aSPUser.
		newContacts add: contact.
	].
	^ contact.! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/22/2007 15:31'!
addList: addressString name: nameString

	| list address |
	address _ SPMailAddress fromString: addressString.
	list _ SPList withAddress: address name: nameString.
	monitor critical: [
		self checkListExistsNot: list.
		lists add: list.
	].
	^ list.! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/22/2007 16:18'!
addList: addressString name: nameString description: descriptionString

	monitor critical: [
		(self addList: addressString name: nameString) description: descriptionString.
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/22/2007 15:31'!
addUser: nameString password: passwordString

	| user |
	user _ SPUser withName: nameString password: passwordString.
	monitor critical: [
		self checkUserExistsNot: user.
		users add: user.
	].
	^ user.! !

!SPListManager methodsFor: 'configuration' stamp: 'as 2/12/2007 15:49'!
adminAddress

	^ SPKernel instance configurator preferenceAt: #adminAddress.! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 3/1/2007 18:00'!
adminForList: aSPList

	| admin |
	admin _ aSPList admin.
	admin ifNil: [ admin _ self adminAddress. ].
	^ admin.! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/21/2007 15:02'!
allContacts

	^ self contacts addAll: self newContacts.! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/23/2007 18:11'!
allContactsForUser: aSPUser

	| c |
	c _ IdentitySet new.
	c addAll: (self contactsForUser: aSPUser).
	c addAll: (self newContactsForUser: aSPUser).
	^ c.! !

!SPListManager methodsFor: 'get-list' stamp: 'as 2/21/2007 11:49'!
allLists

	^ monitor critical: [
		lists copy.
	].! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/21/2007 11:50'!
allSubscriptions

	^ monitor critical: [
		subscriptions copy.
	].! !

!SPListManager methodsFor: 'get-user' stamp: 'as 2/21/2007 12:03'!
allUsers

	^ monitor critical: [
		users copy.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 13:49'!
checkContactExists: aSPContact

	(self contactExists: aSPContact) ifFalse: [
		SPContactNotFoundException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/27/2007 17:50'!
checkContactExistsNot: aSPContact

	(self contactExists: aSPContact) ifTrue: [
		SPContactAlreadyExistsException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/21/2007 14:49'!
checkContactVerified: aSPContact

	aSPContact isVerified ifFalse: [ SPContactNotVerifiedException signal. ].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 13:13'!
checkListExists: aSPList

	(self listExists: aSPList) ifFalse: [
		SPListNotFoundException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 13:13'!
checkListExistsNot: aSPList

	(self listExists: aSPList) ifTrue: [
		SPListAlreadyExistsException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/21/2007 14:51'!
checkNewContactExists: aSPContact

	(self newContactExists: aSPContact) ifFalse: [
		SPContactNotFoundException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/21/2007 17:56'!
checkNotRootUser: aSPUser

	(self isRootUser: aSPUser) ifTrue: [
		SPRootUserException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 14:26'!
checkSubscriptionExists: aSPSubscription

	(self subscriptionExists: aSPSubscription) ifFalse: [
		SPSubscriptionNotFoundException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 14:26'!
checkSubscriptionExistsNot: aSPSubscription

	(self subscriptionExists: aSPSubscription) ifTrue: [
		SPAlreadySubscribedException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/14/2007 22:24'!
checkUserExists: aSPUser

	(self userExists: aSPUser) ifFalse: [
		SPUserNotFoundException signal.
	].! !

!SPListManager methodsFor: 'check' stamp: 'as 2/15/2007 12:42'!
checkUserExistsNot: aSPUser

	(self userExists: aSPUser) ifTrue: [
		SPUserAlreadyExistsException signal.
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/21/2007 14:45'!
contactExists: aSPContact

	^ monitor critical: [
		contacts includes: aSPContact.
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/21/2007 14:53'!
contacts

	^ monitor critical: [
		contacts copy.
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/21/2007 14:54'!
contactsForUser: aSPUser

	^ monitor critical: [
		contacts select: [
			:each |
			each user = aSPUser.
		].
	].! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 2/15/2007 12:43'!
initRootUser

	self addUser: self rootUsername password: self rootInitialPassword.! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 2/15/2007 13:42'!
initialize

	users _ Set new.
	lists _ Set new.
	subscriptions _ Set new.
	newContacts _ IdentitySet new.
	contacts _ Set new.
	monitor _ Monitor new.
	
	self initRootUser.! !

!SPListManager methodsFor: 'test' stamp: 'as 2/4/2007 22:18'!
isAllowed: aSPUser toPostTo: aSPList

	^ monitor critical: [
		aSPList isOpen or: [
			aSPUser notNil and: [ self isSubscribed: aSPUser to: aSPList. ].
		].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/13/2007 17:39'!
isRootUser: aSPUser

	^ aSPUser name = self rootUsername.! !

!SPListManager methodsFor: 'test' stamp: 'as 2/13/2007 18:00'!
isRootUsername: aString

	^ aString = self rootUsername.! !

!SPListManager methodsFor: 'test' stamp: 'as 2/5/2007 11:17'!
isSubscribed: aSPUser to: aSPList

	^ monitor critical: [
		(subscriptions detect: [
			:subscription |
			subscription list = aSPList and:
				[ aSPUser verifiedContacts includes: subscription contact. ].
		] ifNone: [ nil. ]) notNil.
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/14/2007 22:23'!
listExists: aSPList

	^ monitor critical: [
		lists includes: aSPList.
	].! !

!SPListManager methodsFor: 'get-list' stamp: 'as 1/24/2007 15:25'!
listWithAddress: aSPMailAddress

	^ monitor critical: [
		lists
			detect: [ :each | each address = aSPMailAddress. ]
			ifNone: [ nil. ].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/21/2007 14:47'!
newContactExists: aSPContact

	^ monitor critical: [
		newContacts includes: aSPContact.
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/23/2007 18:03'!
newContacts

	^ monitor critical: [
		newContacts copy.
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/21/2007 14:52'!
newContactsForUser: aSPUser

	^ monitor critical: [
		newContacts select: [
			:each |
			each user = aSPUser.
		].
	].! !

!SPListManager methodsFor: 'get-contact' stamp: 'as 2/28/2007 18:05'!
numberOfContactsForUser: aSPUser

	^ (self allContactsForUser: aSPUser) size.! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/28/2007 18:56'!
numberOfSubscriptionsForContact: aSPContact

	^ (self subscriptionsForContact: aSPContact) size.! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/28/2007 17:24'!
numberOfSubscriptionsForList: aSPList

	^ (self subscriptionsForList: aSPList) size.! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/28/2007 17:30'!
numberOfSubscriptionsForUser: aSPUser

	^ (self subscriptionsForUser: aSPUser) size.! !

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/28/2007 18:47'!
pendingSubscriptions

	^ monitor critical: [
		subscriptions select: [
			:each |
			each isAccepted not.
		].
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/21/2007 15:00'!
removeContact: aSPContact

	monitor critical: [
		aSPContact isVerified ifTrue: [
			self checkContactExists: aSPContact.
			contacts remove: aSPContact.
			subscriptions removeAll: (self subscriptionsForContact: aSPContact).
		] ifFalse: [
			self checkNewContactExists: aSPContact.
			newContacts remove: aSPContact.
		].
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/15/2007 13:52'!
removeList: aSPList

	monitor critical: [
		self checkListExists: aSPList.
		lists remove: aSPList.
		subscriptions removeAll: (self subscriptionsForList: aSPList).
	].! !

!SPListManager methodsFor: 'add-remove' stamp: 'as 2/21/2007 18:30'!
removeUser: aSPUser

	self checkNotRootUser: aSPUser.
	monitor critical: [
		self checkUserExists: aSPUser.
		subscriptions removeAll: (self subscriptionsForUser: aSPUser).
		contacts removeAll: (self contactsForUser: aSPUser).
		newContacts removeAll: (self newContactsForUser: aSPUser).
		users remove: aSPUser.
	].! !

!SPListManager methodsFor: 'settings' stamp: 'as 2/21/2007 15:05'!
rootInitialPassword

	^ 'changeme'.! !

!SPListManager methodsFor: 'settings' stamp: 'as 2/13/2007 17:22'!
rootUsername

	^ 'root'.! !

!SPListManager methodsFor: 'subscription' stamp: 'as 2/27/2007 22:14'!
subscribe: aSPContact to: aSPList

	| subscription |
	monitor critical: [
		self checkContactExists: aSPContact.
		self checkListExists: aSPList.
		subscription _ SPSubscription withList: aSPList contact: aSPContact.
		subscription accepted: (aSPList isLocked not).
		self checkSubscriptionExistsNot: subscription.
		subscriptions add: subscription.
		subscription isAccepted ifFalse: [ SPMailNotifier pendingSubscription: subscription. ].
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/27/2007 17:11'!
subscriptionExists: aSPSubscription

	^ monitor critical: [
		subscriptions includes: aSPSubscription.
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

!SPListManager methodsFor: 'get-subscription' stamp: 'as 2/27/2007 17:33'!
subscriptionsForUser: aSPUser

	^ monitor critical: [
		subscriptions select: [
			:each |
			(self contactsForUser: aSPUser) includes: each contact.
		].
	].! !

!SPListManager methodsFor: 'subscription' stamp: 'as 2/15/2007 13:59'!
unsubscribe: aSPSubscription

	monitor critical: [
		self checkSubscriptionExists: aSPSubscription.
		subscriptions remove: aSPSubscription.
	].! !

!SPListManager methodsFor: 'test' stamp: 'as 2/14/2007 22:22'!
userExists: aSPUser

	^ monitor critical: [
		users includes: aSPUser.
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

!SPListManager methodsFor: 'verification' stamp: 'as 2/23/2007 17:57'!
verifyContact: aSPContact code: aString

	monitor critical: [
		self checkNewContactExists: aSPContact.
		self checkContactExistsNot: aSPContact.
		(aSPContact verify: aString) ifTrue: [
			newContacts remove: aSPContact.
			contacts add: aSPContact.
		] ifFalse: [
			SPContactVerificationFailedException signal.
		].
	].! !

Object subclass: #SPMailAddress
	instanceVariableNames: 'localPart domain'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPMailAddress commentStamp: '<historical>' prior: 0!
An electronic mail address.
Consists of a local part (part before '@') which is case sensitive and a domain (part after '@') that is case insensitive.!

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 2/15/2007 13:10'!
fromPath: aString

	| address |
	(SPSyntax isMailPath: aString)
		ifFalse: [ SPInvalidMailAddressException signal. ].
	address _ aString copyFrom: 2 to: aString size - 1.
	(address includes: $:) ifTrue: [ address _ address copyAfterLast: $:. ].
	^ self fromString: address.! !

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 2/15/2007 13:09'!
fromString: aString

	| localPart domain |
	(SPSyntax isMailAddress: aString)
		ifFalse: [ SPInvalidMailAddressException signal. ].
	localPart _ aString copyUpTo: $@.
	domain _ (aString copyAfter: $@) asLowercase.
	(localPart isNil or: [ domain isNil. ])
		ifTrue: [ SPInvalidMailAddressException signal. ].
	(localPart isEmpty or: [ domain isEmpty. ])
		ifTrue: [ SPInvalidMailAddressException signal. ].
	^ self new
		localPart: localPart;
		domain: domain.! !

!SPMailAddress methodsFor: 'compare' stamp: 'as 2/27/2007 17:41'!
= anObject

	^ self hash = anObject hash.! !

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
	instanceVariableNames: 'process message state attempts sent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailHandler commentStamp: 'as 1/25/2007 11:32' prior: 0!
Each incoming mail is wrapped in it's own mail handler that runs its own process to handle the message.!

!SPMailHandler class methodsFor: 'instance creation' stamp: 'as 2/16/2007 12:31'!
withMessage: aSPMailMessage

	^ self new
		message: aSPMailMessage;
		yourself.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 21:57'!
attempting

	attempts _ attempts + 1.! !

!SPMailHandler methodsFor: 'access' stamp: 'as 2/28/2007 22:18'!
attempts

	^ attempts.! !

!SPMailHandler methodsFor: 'configuration' stamp: 'as 2/28/2007 22:20'!
config

	^ SPKernel instance configurator.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/21/2007 11:00'!
delay

	(Delay forSeconds: self queueDelaySeconds) wait.! !

!SPMailHandler methodsFor: 'initialize-release' stamp: 'as 2/28/2007 22:14'!
initialize

	sent _ false.
	attempts _ 0.
	process _ [ self run. ] newProcess.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 22:13'!
isFinished

	^ sent or: [ attempts >= self queueSendAttempts. ].! !

!SPMailHandler methodsFor: 'access' stamp: 'as 2/23/2007 16:43'!
message

	^ message.! !

!SPMailHandler methodsFor: 'access' stamp: 'as 1/30/2007 10:22'!
message: aSPMailMessage

	message _ aSPMailMessage.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 22:41'!
processMessage

	[ self sendMessage. ] on: Exception do: [
		:ex |
		state _ ex description.
		ex return.
	].! !

!SPMailHandler methodsFor: 'configuration' stamp: 'as 2/28/2007 22:20'!
queueDelaySeconds

	^ self config preferenceAt: #queueDelaySeconds.! !

!SPMailHandler methodsFor: 'configuration' stamp: 'as 2/28/2007 21:59'!
queueSendAttempts

	^ self config preferenceAt: #queueSendAttempts.! !

!SPMailHandler methodsFor: 'configuration' stamp: 'as 2/28/2007 22:20'!
queueTries

	^ self config preferenceAt: #queueTries.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 22:38'!
run

	[
		self processMessage.
		[ self isFinished. ] whileFalse: [ self delay; processMessage. ].
	] ensure: [ SPKernel instance queue removeHandler: self. ].! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 22:45'!
sendMessage

	self attempting.
	message prepareToSend.
	SPSmtpClient new sendMessage: message.
	self sent.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/26/2007 18:27'!
sent

	state _ 'sent'.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/7/2007 00:00'!
start

	process resume.! !

!SPMailHandler methodsFor: 'processing' stamp: 'as 2/28/2007 22:16'!
state

	sent ifTrue: [ ^ 'sent'. ].
	state ifNil: [ ^ 'new'. ] ifNotNil: [ ^ state. ].! !

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

!SPMailListener methodsFor: 'start-stop' stamp: 'as 2/28/2007 17:53'!
restart

	self stop; waitForStop; start.! !

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
	instanceVariableNames: 'mail sender recipients date'
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

!SPMailMessage class methodsFor: 'instance creation' stamp: 'as 2/26/2007 15:42'!
from: fromString to: toString mail: mailString

	^ self
		from: fromString
		toAll: (Array with: toString)
		mail: mailString.! !

!SPMailMessage class methodsFor: 'instance creation' stamp: 'as 2/26/2007 15:41'!
from: fromString toAll: collectionOfStrings mail: mailString

	| recipients |
	recipients _ IdentitySet new.
	collectionOfStrings do: [
		:each |
		recipients add: (SPMailAddress fromString: each).
	].
	^ self
		sender: (SPMailAddress fromString: fromString)
		recipients: recipients
		mail: (MailMessage from: mailString).! !

!SPMailMessage class methodsFor: 'class initialization' stamp: 'as 10/17/2006 16:18'!
initialize

	messageId := 0.
	monitor := Monitor new.! !

!SPMailMessage class methodsFor: 'instance creation' stamp: 'as 2/26/2007 13:37'!
sender: fromSPMailAddress recipients: collectionOfSPMailAddress mail: aMailMessage

	^ self new
		sender: fromSPMailAddress;
		recipients: collectionOfSPMailAddress;
		mail: aMailMessage;
		ensureMessageId.! !

!SPMailMessage class methodsFor: 'id' stamp: 'as 10/17/2006 16:20'!
uniqueMessageId

	monitor critical: [
		messageId := messageId + 1.
		^ messageId.
	].! !

!SPMailMessage methodsFor: 'configuration' stamp: 'as 1/15/2007 11:32'!
config

	^ SPKernel instance configurator.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 1/30/2007 10:26'!
date

	^ date.! !

!SPMailMessage methodsFor: 'insert' stamp: 'as 2/26/2007 10:15'!
ensureMessageId

	mail fieldNamed: 'message-id' ifAbsent: [
		mail setField: 'message-id' toString: '<', self class uniqueMessageId asString, '@', self serverName, '>'.
	].! !

!SPMailMessage methodsFor: 'initialize-release' stamp: 'as 2/26/2007 10:12'!
initialize

	date _ DateAndTime now.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 2/26/2007 15:48'!
mail: aMailMessage

	mail _ aMailMessage.! !

!SPMailMessage methodsFor: 'send' stamp: 'as 2/26/2007 13:10'!
prepareToSend! !

!SPMailMessage methodsFor: 'access' stamp: 'as 2/26/2007 10:03'!
recipients

	^ recipients.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 2/26/2007 10:10'!
recipients: aCollection

	recipients _ aCollection! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:13'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'access' stamp: 'as 9/26/2006 16:29'!
sender: aSPMailAddress

	sender := aSPMailAddress.! !

!SPMailMessage methodsFor: 'configuration' stamp: 'as 2/26/2007 10:14'!
serverName

	^ self config preferenceAt: #serverName.! !

!SPMailMessage methodsFor: 'mail' stamp: 'as 2/23/2007 16:44'!
subject

	^ mail subject.! !

SPMailMessage subclass: #SPMailPosting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailPosting commentStamp: 'as 2/26/2007 10:28' prior: 0!
A mail message dedicated for postings to mailing lists.
Only the first recipient is used and is interpreted as list address.!

!SPMailPosting class methodsFor: 'instance creation' stamp: 'as 2/26/2007 15:37'!
from: fromString to: toString mail: mailString

	^ self
		from: fromString
		to: (Array with: toString)
		mail: mailString.! !

!SPMailPosting class methodsFor: 'instance creation' stamp: 'as 2/26/2007 11:00'!
from: fromString to: toString mailFrom: mailString

	^ self
		from: fromString
		to: (Array with: toString)
		mailFrom: mailString.! !

!SPMailPosting methodsFor: 'post' stamp: 'as 2/26/2007 11:23'!
admin

	^ SPKernel instance manager adminForList: self recipientList.! !

!SPMailPosting methodsFor: 'check' stamp: 'as 2/26/2007 11:58'!
checkIsAllowed

	self isAllowed ifFalse: [
		^ SPPostingNotAllowedException signal.
	].! !

!SPMailPosting methodsFor: 'insert' stamp: 'as 2/26/2007 10:03'!
insertListName

	mail subject: '[', self recipientList name, '] ', mail subject.! !

!SPMailPosting methodsFor: 'test' stamp: 'as 2/26/2007 11:54'!
isAllowed

	| user |
	user _ SPKernel instance manager userWithAddress: sender.
	^ SPKernel instance manager isAllowed: user toPostTo: self recipientList.! !

!SPMailPosting methodsFor: 'post' stamp: 'as 2/26/2007 10:12'!
listRecipients

	^ SPKernel instance manager activeRecipientsForList: self recipientList.! !

!SPMailPosting methodsFor: 'send' stamp: 'as 2/26/2007 13:15'!
prepareToSend

	"Insert list name and return path. Replace mail to be sure things aren't
	 written multiple times if this gets called more than once."

	| message |
	message _ MailMessage from: mail.
	message returnPath: self admin asString.
	message subject: '[', self recipientList name, '] ', mail subject.
	mail _ message.! !

!SPMailPosting methodsFor: 'post' stamp: 'as 2/26/2007 10:28'!
recipientList

	SPKernel instance manager listWithAddress: recipients first.! !

!SPMailPosting methodsFor: 'access' stamp: 'as 2/26/2007 11:48'!
recipients

	^ self listRecipients.! !

Object subclass: #SPMailNotifier
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPMailNotifier commentStamp: 'as 2/26/2007 13:28' prior: 0!
Send pre-defined mail notifications.!

!SPMailNotifier class methodsFor: 'notifications' stamp: 'as 3/1/2007 18:09'!
acceptedSubscription: aSPSubscription

	self send: (
		SPMailMessage
			from: (self listAdmin: aSPSubscription list) asString
			to: aSPSubscription contact address asString
			mail: (self textAcceptedSubscription: aSPSubscription)
	).! !

!SPMailNotifier class methodsFor: 'configuration' stamp: 'as 2/26/2007 15:20'!
adminAddress

	^ self config preferenceAt: #adminAddress.! !

!SPMailNotifier class methodsFor: 'configuration' stamp: 'as 2/26/2007 13:59'!
config

	^ SPKernel instance configurator.! !

!SPMailNotifier class methodsFor: 'notifications' stamp: 'as 3/1/2007 18:07'!
deniedSubscription: aSPSubscription

	self send: (
		SPMailMessage
			from: (self listAdmin: aSPSubscription list) asString
			to: aSPSubscription contact address asString
			mail: (self textDeniedSubscription: aSPSubscription)
	).! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 2/27/2007 12:49'!
greetingText

^
'Hi, this is Stamp, the mailing list manager at ', self serverName, '.'.! !

!SPMailNotifier class methodsFor: 'lists' stamp: 'as 3/1/2007 18:10'!
listAdmin: aSPList

	^ SPKernel instance manager adminForList: aSPList.! !

!SPMailNotifier class methodsFor: 'notifications' stamp: 'as 3/1/2007 18:09'!
pendingSubscription: aSPSubscription

	self send: (
		SPMailMessage
			from: (self listAdmin: aSPSubscription list) asString
			to: aSPSubscription list admin asString
			mail: (self textPendingSubscription: aSPSubscription)
	).! !

!SPMailNotifier class methodsFor: 'send' stamp: 'as 2/26/2007 13:40'!
send: aSPMailMessage

	SPKernel instance queue addMessage: aSPMailMessage.! !

!SPMailNotifier class methodsFor: 'configuration' stamp: 'as 2/27/2007 12:42'!
serverName

	^ self config preferenceAt: #serverName.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 3/1/2007 18:09'!
textAcceptedSubscription: aSPSubscription

^ (self
	textFrom: (self listAdmin: aSPSubscription list) asString
	to: aSPSubscription contact address asString
	subject: 'Subscription Accepted'),
self greetingText, '

Your subscription from ', aSPSubscription contact address asString, ' for the list ', aSPSubscription list address asString,' was accepted.


', self textFooter.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 3/1/2007 18:09'!
textDeniedSubscription: aSPSubscription

^ (self
	textFrom: (self listAdmin: aSPSubscription list) asString
	to: aSPSubscription contact address asString
	subject: 'Subscription Denied'),
self greetingText, '

Your subscription from ', aSPSubscription contact address asString, ' for the list ', aSPSubscription list address asString,' was denied.


', self textFooter.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 2/27/2007 12:48'!
textFooter

^
'Sincerly,
Stamp Mailing List Manager'.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 2/27/2007 12:49'!
textFrom: fromString to: toString subject: subjectString

^
'From: ', fromString, '
To: ', toString, '
Subject: ', subjectString, '
Date: ', MailMessage dateStampNow, ' ', self timezone, '

'.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 3/1/2007 18:09'!
textPendingSubscription: aSPSubscription

^ (self
	textFrom: (self listAdmin: aSPSubscription list) asString
	to: aSPSubscription list admin asString
	subject: 'New Subscription'),
self greetingText, '

There is a new subscription request from ', aSPSubscription contact address asString, ' for the list ', aSPSubscription list address asString,' which needs your approval.


', self textFooter.! !

!SPMailNotifier class methodsFor: 'text' stamp: 'as 2/27/2007 12:52'!
textVerifyContact: aSPContact

^ (self
	textFrom: self adminAddress asString
	to: aSPContact address asString
	subject: 'Contact Verification'),
self greetingText, '

Your email address was registered and this is the code to verify it in your user profile:

', aSPContact verification, '

If you have received this message by mistake, ignore it.


', self textFooter.! !

!SPMailNotifier class methodsFor: 'configuration' stamp: 'as 2/26/2007 13:59'!
timezone

	^ self config preferenceAt: #timezone.! !

!SPMailNotifier class methodsFor: 'notifications' stamp: 'as 2/27/2007 12:49'!
verifyContact: aSPContact

	self send: (
		SPMailMessage
			from: self adminAddress asString
			to: aSPContact address asString
			mail: (self textVerifyContact: aSPContact)
	).! !

Object subclass: #SPMailQueue
	instanceVariableNames: 'queue monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Mail queue.!

!SPMailQueue methodsFor: 'queue' stamp: 'as 2/26/2007 15:49'!
addMessage: aSPMailMessage 

	| handler |
	handler _ (SPMailHandler withMessage: aSPMailMessage).
	monitor critical: [
		self checkFreeQueueSize: 1.
		queue add: handler.
		handler start.
	].! !

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

!SPMailQueue methodsFor: 'queue' stamp: 'as 2/23/2007 16:40'!
handlers

	^ monitor critical: [
		queue copy.
	].! !

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
	instanceVariableNames: 'state stream quit sender recipients mail'
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

!SPMailReceiver methodsFor: 'check' stamp: 'as 2/26/2007 10:32'!
checkNumberOfRecipients

	recipients size >= self receiverMaxRecipients ifTrue: [
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

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 2/26/2007 10:32'!
initMessage

	recipients _ IdentitySet new.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 1/30/2007 10:16'!
initialize

	quit _ false.
	self initMessage.
	self state: SPReadySmtpState.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/26/2007 11:42'!
insertTrace

	| local remote |
	local _ self localName ifNil: [ self localAddress. ].
	remote _ self remoteName ifNil: [ self remoteAddress. ].
	
	mail received: 'from ', local, ' by ', remote, '; ', MailMessage dateStampNow, ' ', self timezone.! !

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

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/26/2007 10:33'!
mail: aString

	mail _ MailMessage from: aString.! !

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

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/26/2007 15:38'!
queueMessages

	| messages |
	messages _ IdentitySet new.
	recipients do: [
		:each |
		"ensure unique copy for each posting"
		messages add: (SPMailPosting from: sender asString to: each asString mail: mail text).
	].
	SPKernel instance queue addMessages: messages.! !

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

!SPMailReceiver methodsFor: 'message' stamp: 'as 2/26/2007 10:46'!
sender: aSPMailAddress

	 sender _ aSPMailAddress.! !

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

!SPMailReceiver methodsFor: 'configuration' stamp: 'as 2/26/2007 11:43'!
timezone

	^ self config preferenceAt: #timezone.! !

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

!SPPassword methodsFor: 'check' stamp: 'as 3/1/2007 11:46'!
checkNotNilOrEmpty: aString

	(aString isNil or: [ aString isEmpty. ]) ifTrue: [
		SPWrongPasswordException signal: 'Empty password'.
	].! !

!SPPassword methodsFor: 'private' stamp: 'as 3/1/2007 11:48'!
encrypt: aString

	self checkNotNilOrEmpty: aString.
	^ SHA1 hashStream: (ReadStream on: aString).! !

!SPPassword methodsFor: 'private' stamp: 'as 3/1/2007 11:48'!
new: aString

	password _ self encrypt: aString.! !

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

!SPDataSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:13'!
states

	^ Set new
		add: SPRecipientSmtpState;
		yourself.! !

!SPDataSmtpCommand class methodsFor: 'smtp' stamp: 'as 1/14/2006 21:40'!
verb

	^ 'data'.! !

!SPDataSmtpCommand methodsFor: 'execute' stamp: 'as 2/26/2007 10:44'!
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

!SPEhloSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:13'!
states

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

!SPHeloSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:14'!
states

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

!SPMailSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:14'!
states

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

!SPNoopSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:15'!
states

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

!SPQuitSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:15'!
states

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

!SPRecipientSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:15'!
states

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

!SPResetSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:16'!
states

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

!SPSmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:12'!
states

	self subclassResponsibility.! !

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

!SPVerifySmtpCommand class methodsFor: 'state' stamp: 'as 2/28/2007 11:16'!
states

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
	instanceVariableNames: 'list contact active accepted'
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

!SPSubscription methodsFor: 'compare' stamp: 'as 2/27/2007 17:41'!
= anObject

	^ self hash = anObject hash.! !

!SPSubscription methodsFor: 'access' stamp: 'as 2/27/2007 21:52'!
accepted: aBoolean

	accepted _ aBoolean.! !

!SPSubscription methodsFor: 'access' stamp: 'as 2/27/2007 17:24'!
active: aBoolean

	active _ aBoolean.! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:58'!
contact

	^ contact.! !

!SPSubscription methodsFor: 'access' stamp: 'as 8/18/2006 14:58'!
contact: aSPContact

	contact := aSPContact.! !

!SPSubscription methodsFor: 'compare' stamp: 'as 10/21/2006 12:11'!
hash

	^ (list name, contact address asString) hash.! !

!SPSubscription methodsFor: 'initialize-release' stamp: 'as 2/27/2007 21:54'!
initialize

	self active: true.
	self accepted: false.! !

!SPSubscription methodsFor: 'state' stamp: 'as 2/27/2007 17:24'!
invertActivation

	active _ active not.! !

!SPSubscription methodsFor: 'test' stamp: 'as 2/23/2007 18:22'!
isAccepted

	^ accepted.! !

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

!SPSyntax class methodsFor: 'check' stamp: 'as 2/15/2007 13:05'!
checkMailAddressLength: aString

	aString size > (self maxMailPathLength - 2)
		ifTrue: [ SPSyntaxException signal: 'mail address length limit is', (self maxMailPathLength - 2). ].! !

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

!SPSyntax class methodsFor: 'test' stamp: 'as 2/15/2007 13:04'!
isMailAddress: aString

	self checkMailAddressLength: aString.
	^ aString matchesRegex: self reMailAddress.! !

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

!SPSyntax class methodsFor: 'regex' stamp: 'as 2/15/2007 13:05'!
reMailAddress

	^ '.*@.*'.! !

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
	instanceVariableNames: 'name password active'
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

!SPUser methodsFor: 'compare' stamp: 'as 2/27/2007 17:40'!
= anObject

	^ self hash = anObject hash.! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:21'!
activate

	active := true.! !

!SPUser methodsFor: 'check' stamp: 'as 3/1/2007 18:43'!
checkNotNilOrEmpty: aString

	(aString isNil or: [ aString isEmpty. ]) ifTrue: [
		SPEmptyArgumentException signal: 'Username is empty'.
	].! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:26'!
deactivate

	active := false.! !

!SPUser methodsFor: 'compare' stamp: 'as 3/9/2006 16:52'!
hash

	^ name hash.! !

!SPUser methodsFor: 'initialize-release' stamp: 'as 2/15/2007 14:38'!
initialize

	self activate.! !

!SPUser methodsFor: 'test' stamp: 'as 9/5/2006 11:22'!
isActive

	^ active.! !

!SPUser methodsFor: 'access' stamp: 'as 3/9/2006 16:54'!
name

	^ name.! !

!SPUser methodsFor: 'access' stamp: 'as 3/1/2007 17:49'!
name: aString

	self checkNotNilOrEmpty: aString.
	name _ aString.! !

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:03'!
newPassword: newString oldPassword: oldString

	password new: newString old: oldString.! !

!SPUser methodsFor: 'access' stamp: 'as 9/26/2006 15:02'!
password: aString

	password := SPPassword withPassword: aString.! !

!SPUser methodsFor: 'password' stamp: 'as 2/15/2007 12:26'!
verifyPassword: aString

	^ password check: aString.! !

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

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 2/28/2007 22:09'!
sendMessage: aSPMailMessage

	self
		sendMessage: aSPMailMessage mail
		from: aSPMailMessage sender
		to: aSPMailMessage recipients.! !

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
SPWeb initialize!
SPMailMessage initialize!
