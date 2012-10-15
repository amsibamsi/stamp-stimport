SystemOrganization addCategory: #'Stamp-Configuration'!
SystemOrganization addCategory: #'Stamp-Core'!
SystemOrganization addCategory: #'Stamp-ListManager-Tests'!
SystemOrganization addCategory: #'Stamp-ListManager'!
SystemOrganization addCategory: #'Stamp-Mail-Client'!
SystemOrganization addCategory: #'Stamp-Mail-Server'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Commands'!
SystemOrganization addCategory: #'Stamp-Mail-Server-States'!
SystemOrganization addCategory: #'Stamp-Mail-Server-Tests'!
SystemOrganization addCategory: #'Stamp-Storage'!
SystemOrganization addCategory: #'Stamp-Tests'!
SystemOrganization addCategory: #'Stamp-Web'!

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

TcpService subclass: #SPMailService
	instanceVariableNames: 'listener'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailService commentStamp: '<historical>' prior: 0!
A TCP service listening for incoming SMTP connections.!

!SPMailService class methodsFor: 'instance creation' stamp: 'as 5/30/2006 09:28'!
withListener: aSPMailListener onPort: aNumber

	^ (self on: aNumber) listener: aSPMailListener.! !

!SPMailService methodsFor: 'accessing' stamp: 'as 5/30/2006 09:17'!
listener: aSPMailListener

	listener := aSPMailListener.! !

!SPMailService methodsFor: 'conversation' stamp: 'as 9/14/2006 09:42'!
serve: aSocket

	| receiver |
	receiver := SPMailReceiver withKernel: listener kernel stream: (SocketStream on: aSocket) .
	receiver receive.! !

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

Object subclass: #SPContact
	instanceVariableNames: 'user address active verified'
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

!SPContact methodsFor: 'operations' stamp: 'as 9/5/2006 11:27'!
activate

	active := true.! !

!SPContact methodsFor: 'accessing' stamp: 'as 8/17/2006 15:14'!
address

	^ address.! !

!SPContact methodsFor: 'accessing' stamp: 'as 8/17/2006 15:14'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPContact methodsFor: 'operations' stamp: 'as 9/5/2006 11:27'!
deactivate

	active := false.! !

!SPContact methodsFor: 'comparing' stamp: 'as 8/17/2006 15:48'!
hash

	^ address name hash.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 9/14/2006 09:37'!
initialize

	self activate.
	verified := false.! !

!SPContact methodsFor: 'testing' stamp: 'as 9/5/2006 14:08'!
isActive

	^ user isActive and: [ active. ].! !

!SPContact methodsFor: 'testing' stamp: 'as 9/14/2006 09:31'!
isVerified

	^ verified.! !

!SPContact methodsFor: 'accessing' stamp: 'as 9/5/2006 11:29'!
user: aSPUser

	user := aSPUser.! !

!SPContact methodsFor: 'operations' stamp: 'as 9/14/2006 09:37'!
verify

	verified := true.! !

!SPContact methodsFor: 'comparing' stamp: 'as 8/21/2006 09:32'!
= aSPContact

	^ address = aSPContact address.! !

Object subclass: #SPDummy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPDummy commentStamp: '<historical>' prior: 0!
An object that understands every message. All messages that are not inherited are dumb, they do nothing and return self. Useful for testing.!

!SPDummy class methodsFor: 'system primitives' stamp: 'as 9/14/2006 10:16'!
doesNotUnderstand: aMessage

	^ self.! !

!SPDummy methodsFor: 'system primitives' stamp: 'as 9/14/2006 10:14'!
doesNotUnderstand: aMessage

	^ self.! !

Object subclass: #SPKernel
	instanceVariableNames: 'listener queue archive manager'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

SPKernel class
	instanceVariableNames: 'instance'!

!SPKernel commentStamp: '<historical>' prior: 0!
The core of Stamp. Holds references to all important components.!

!SPKernel class methodsFor: 'instance creation' stamp: 'as 9/14/2006 13:45'!
instance

	^ instance ifNil: [ ^ instance := self basicNew initialize. ].! !

!SPKernel class methodsFor: 'instance creation' stamp: 'as 8/8/2006 16:20'!
new

	self shouldNotImplement.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 6/12/2006 14:08'!
archive

	^ archive.! !

!SPKernel methodsFor: 'actions' stamp: 'as 8/18/2006 19:35'!
destroy

	listener destroy.
	listener := nil.
	queue := nil.
	archive := nil.
	manager := nil.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 8/18/2006 19:35'!
initialize

	listener := SPMailListener withKernel: self.
	queue := SPMailQueue withKernel: self.
	archive := SPMailArchive new.
	manager := SPListManager new.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:19'!
listener

	^ listener.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 8/18/2006 19:37'!
manager

	^ manager.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:22'!
queue

	^ queue.! !

!SPKernel methodsFor: 'actions' stamp: 'as 3/14/2006 14:10'!
start

	listener start.! !

!SPKernel methodsFor: 'actions' stamp: 'as 3/14/2006 14:11'!
stop

	listener stop.! !

Object subclass: #SPList
	instanceVariableNames: 'name moderated active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPList commentStamp: '<historical>' prior: 0!
A mailing list.!

!SPList class methodsFor: 'instance creation' stamp: 'as 3/20/2006 16:12'!
withName: aString

	^ self new
		name: aString;
		yourself.! !

!SPList methodsFor: 'operations' stamp: 'as 9/5/2006 14:14'!
activate

	active := true.! !

!SPList methodsFor: 'operations' stamp: 'as 9/5/2006 14:14'!
deactivate

	active := false.! !

!SPList methodsFor: 'comparing' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 9/5/2006 14:13'!
initialize

	self unmoderate.
	self activate.! !

!SPList methodsFor: 'testing' stamp: 'as 9/5/2006 14:14'!
isActive

	^ active.! !

!SPList methodsFor: 'testing' stamp: 'as 9/5/2006 13:03'!
isModerated

	^ moderated.! !

!SPList methodsFor: 'operations' stamp: 'as 9/5/2006 13:05'!
moderate

	moderated := true.! !

!SPList methodsFor: 'accessing' stamp: 'as 3/9/2006 16:53'!
name

	^ name.! !

!SPList methodsFor: 'accessing' stamp: 'as 3/20/2006 16:13'!
name: aString

	name := aString.! !

!SPList methodsFor: 'operations' stamp: 'as 9/5/2006 13:05'!
unmoderate

	moderated := false.! !

!SPList methodsFor: 'comparing' stamp: 'as 3/9/2006 16:48'!
= aSPList

	^ name = aSPList name.! !

Object subclass: #SPListManager
	instanceVariableNames: 'kernel users lists subscriptions monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPListManager commentStamp: '<historical>' prior: 0!
Coordinates lists, users, subscriptions and more.!

!SPListManager class methodsFor: 'instance creation' stamp: 'as 8/17/2006 11:07'!
withKernel: aSPKernel

	^ self new kernel: aSPKernel.! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/12/2006 16:42'!
addList: aSPList

	lists add: aSPList.! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/12/2006 16:42'!
addUser: aSPUser

	users add: aSPUser.! !

!SPListManager methodsFor: 'operations' stamp: 'as 8/18/2006 15:03'!
allLists

	^ lists.! !

!SPListManager methodsFor: 'operations' stamp: 'as 8/18/2006 15:03'!
allSubscriptions

	^ subscriptions.! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 13:10'!
allSubscriptionsForList: aSPList

	^ subscriptions select: [ :each | each list = aSPList. ].! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 13:11'!
allSubscriptionsForUser: aSPUser

	| contacts |
	contacts := Set withAll: aSPUser contacts.
	^ subscriptions select: [ :each | contacts includes: each contact. ].! !

!SPListManager methodsFor: 'operations' stamp: 'as 8/18/2006 15:03'!
allUsers

	^ users.! !

!SPListManager methodsFor: 'testing' stamp: 'as 9/8/2006 10:06'!
hasList: nameString

	^ (lists detect: [ :each | each name = nameString. ] ifNone: [ nil. ]) notNil.! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 9/12/2006 16:36'!
initialize

	users := Set new.
	lists := Set new.
	subscriptions := Set new.
	monitor := Monitor new.! !

!SPListManager methodsFor: 'accessing' stamp: 'as 8/17/2006 11:07'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/11/2006 15:41'!
list: nameString

	^ lists
		detect: [ :each | each name = nameString. ]
		ifNone: [ nil. ].! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 13:11'!
removeList: aSPList

	lists remove: aSPList ifAbsent: [ SPListNotFoundException signal. ].
	subscriptions removeAll: (self subscriptionsForList: aSPList).! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 10:28'!
removeUser: aSPUser

	users remove: aSPUser ifAbsent: [ SPUserNotFoundException signal. ].
	subscriptions removeAll: (self subscriptionsForUser: aSPUser).! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 13:07'!
subscribe: aSPContact to: aSPList

	| subscription |
	subscription := SPSubscription withList: aSPList withContact: aSPContact.
	subscriptions add: subscription.! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/5/2006 13:09'!
unsubscribe: aSPSubscription

	subscriptions remove: aSPSubscription ifAbsent: [ SPSubscriptionNotFoundException signal. ].! !

!SPListManager methodsFor: 'operations' stamp: 'as 9/11/2006 15:41'!
user: nameString

	^ users
		detect: [ :each | each name = nameString. ]
		ifNone: [ nil. ].! !

Object subclass: #SPMailAddress
	instanceVariableNames: 'localPart domain'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPMailAddress commentStamp: '<historical>' prior: 0!
An address as used in electronic mails.!

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 9/11/2006 18:13'!
delimiter

	^ $@.! !

!SPMailAddress class methodsFor: 'instance creation' stamp: 'as 9/14/2006 09:38'!
fromPath: aString

	| addressStrings address |
	[
		addressStrings := MailAddressParser addressesIn: aString.
		address := addressStrings first.
		^ self new
			localPart: (address copyUpTo: self delimiter);
			domain: (address copyAfter: self delimiter).
	]
	on: Exception
	do: [ :e | SPInvalidMailAddressException signal. ].! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 9/12/2006 16:30'!
address

	^ localPart, '@', domain.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 16:51'!
domain

	^ domain.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 16:51'!
domain: aString

	domain := aString.! !

!SPMailAddress methodsFor: 'comparing' stamp: 'as 9/14/2006 15:28'!
hash

	^ self address hash.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 17:32'!
localPart

	^ localPart.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 17:31'!
localPart: aString

	localPart := aString.! !

!SPMailAddress methodsFor: 'comparing' stamp: 'as 9/12/2006 16:30'!
= aSPMailAddress

	^ self address = aSPMailAddress address.! !

Object subclass: #SPMailMessage
	instanceVariableNames: 'mail sender recipients'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Storage'!

!SPMailMessage commentStamp: '<historical>' prior: 0!
A mail message that contains some attributes specific to mail reception besides the normal mail data.

When relaying mail, SMTP servers specify a separate sender and recipients that are not necessarily equal to the ones of the mail message. This makes it possible to relay mail for different users without modifying the actual mail message, but sometimes this can also be a bit confusing.

In addition to the normal mail message this implementation contains sender and recipients as they were specified by the relaying server.!

!SPMailMessage methodsFor: 'accessing' stamp: 'as 9/14/2006 14:49'!
addRecipient: aSPMailAddress

	recipients add: aSPMailAddress.! !

!SPMailMessage methodsFor: 'initialize-release' stamp: 'as 9/14/2006 14:53'!
initialize

	recipients := Set new.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 6/8/2006 18:32'!
lists

	^ lists.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 6/12/2006 14:32'!
mail: aString

	mail := MailMessage from: aString.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 6/12/2006 12:29'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 6/12/2006 12:29'!
sender: aSPMailAddress

	sender := aSPMailAddress.! !

Object subclass: #SPObject
	instanceVariableNames: 'kernel configuration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPObject commentStamp: '<historical>' prior: 0!
A Stamp object is distinguished by:

  - a reference to the Stamp kernel,
  - integrated configuration managment.!

SPObject subclass: #SPMailArchive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Storage'!

!SPMailArchive commentStamp: '<historical>' prior: 0!
Mail archive that basically wraps around MailDB.!

!SPMailArchive methodsFor: 'messages' stamp: 'as 6/12/2006 14:15'!
addNewMessage: aMailMessage

	(MailDB openOn: 'stamp-archive') addNewMessage: aMailMessage.! !

SPObject subclass: #SPMailListener
	instanceVariableNames: 'service'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailListener commentStamp: '<historical>' prior: 0!
Listens for incoming SMTP connections and treats them appropriately.!

!SPMailListener methodsFor: 'starting and stopping' stamp: 'as 7/24/2006 09:28'!
destroy

	service unregister.
	service := nil.! !

!SPMailListener methodsFor: 'initialize-release' stamp: 'as 5/30/2006 09:31'!
initialize

	service := SPMailService withListener: self onPort: (self preferenceAt: #port).! !

!SPMailListener methodsFor: 'accessing' stamp: 'as 9/14/2006 09:57'!
service

	^ service.! !

!SPMailListener methodsFor: 'starting and stopping' stamp: 'as 5/30/2006 14:06'!
start

	service start.! !

!SPMailListener methodsFor: 'starting and stopping' stamp: 'as 5/30/2006 14:06'!
stop

	service stop.! !

SPObject subclass: #SPMailQueue
	instanceVariableNames: 'buffer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailQueue commentStamp: '<historical>' prior: 0!
Handles incoming mail, e.g. storing/forwarding/...!

!SPMailQueue methodsFor: 'private' stamp: 'as 6/12/2006 13:28'!
handle: aSPMailMessage

	kernel archive addNewMessage: aSPMailMessage mail.
	! !

!SPMailQueue methodsFor: 'actions' stamp: 'as 3/16/2006 15:42'!
queue: aMailMessage

	[ self handle: aMailMessage ] newProcess resume.! !

SPObject subclass: #SPMailReceiver
	instanceVariableNames: 'state stream message quit'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailReceiver commentStamp: '<historical>' prior: 0!
Minimalistic mail server trying to follow RFC 2821. It only receives mail. One receiver serves one client connection, and the whole will usually be multithreaded.

A SPMailReceiver is created on a socket. Mail reception starts with the receive method. After its return received data is available in the message.!

!SPMailReceiver class methodsFor: 'instance creation' stamp: 'as 9/14/2006 09:42'!
withKernel: aSPKernel stream: aSocketStream

	^ (self withKernel: aSPKernel)
		stream: aSocketStream;
		yourself.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 9/14/2006 14:50'!
addRecipient: aSPMailAddress

	message addRecipient: aSPMailAddress.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 2/6/2006 15:19'!
dataDelimiter

	"The delimiter string that will end mail data input."

	^ String crlf, '.', String crlf.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 6/12/2006 14:27'!
initialize

	quit := false.
	message := SPMailMessage new.
	self state: SPReadySmtpState.! !

!SPMailReceiver methodsFor: 'private' stamp: 'as 5/24/2006 14:16'!
insertTrace! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 5/24/2006 11:46'!
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

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 6/12/2006 14:27'!
reset

	message := SPMailMessage new.
	self state: SPResetSmtpState.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 6/12/2006 12:29'!
sender: aSPMailAddress

	message sender: aSPMailAddress.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 4/20/2006 17:45'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

!SPObject class methodsFor: 'configuration' stamp: 'as 5/30/2006 16:08'!
configuration

	| c |
	c := Smalltalk classNamed: (self name, self defaultConfigurationSuffix).
	c ifNil: [ c := self defaultConfiguration. ].
	^ c localConfiguration.! !

!SPObject class methodsFor: 'configuration' stamp: 'as 5/30/2006 16:09'!
defaultConfiguration

	^ SPBaseConfiguration.! !

!SPObject class methodsFor: 'configuration' stamp: 'as 5/26/2006 10:20'!
defaultConfigurationSuffix

	^ 'Configuration'.! !

!SPObject class methodsFor: 'instance creation' stamp: 'as 9/14/2006 13:46'!
withKernel: aSPKernel

	^ self new
		kernel: aSPKernel;
		yourself.! !

!SPObject methodsFor: 'configuration' stamp: 'as 7/26/2006 11:07'!
configuration

	^ configuration ifNil: [ configuration := WAUserConfiguration new addAncestor: self class configuration. ].! !

!SPObject methodsFor: 'accessing' stamp: 'as 9/13/2006 17:08'!
kernel

	^ kernel.! !

!SPObject methodsFor: 'accessing' stamp: 'as 9/13/2006 17:08'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPObject methodsFor: 'configuration' stamp: 'as 7/26/2006 10:51'!
preferenceAt: aSymbol

	^ self configuration valueAt: aSymbol.! !

!SPObject methodsFor: 'configuration' stamp: 'as 7/26/2006 11:06'!
preferenceAt: aSymbol put: anObject

	self configuration valueAt: aSymbol put: anObject.! !

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

!SPEhloSmtpCommand commentStamp: '<historical>' prior: 0!
The EHLO command is unimplemented since no service extension are needed/implemented.!

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

!SPHeloSmtpCommand methodsFor: 'executing' stamp: 'as 6/8/2006 18:34'!
doExecute

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

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 9/11/2006 15:11'!
doExecute

	target sender: (SPMailAddress fromPath: argument).
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

!SPNoopSmtpCommand methodsFor: 'executing' stamp: 'as 9/13/2006 16:30'!
doExecute

	"nothing to do"! !

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
	instanceVariableNames: 'recipient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Commands'!

!SPRecipientSmtpCommand commentStamp: '<historical>' prior: 0!
The client specifies a recipient address.!

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

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 9/14/2006 14:52'!
doExecute

	| list |
	list := target kernel manager list: recipient localPart.
	list isNil ifTrue: [
		self reply: SPSmtpReply noSuchUser.
	] ifFalse: [
		target addRecipient: recipient.
		self state: SPRecipientSmtpState.
	].! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 9/14/2006 13:59'!
doValidate

	[ recipient := SPMailAddress fromPath: argument. ]
		on: SPInvalidMailAddressException
		do: [ SPSmtpCommandWrongException signal. ].! !

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

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 9/8/2006 10:43'!
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
	class isNil ifTrue: [ (SPSmtpCommandNotFoundException on: aSPMailReceiver) signal. ].
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

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 9/14/2006 13:50'!
doValidate

	"Validate whatever is necessary for the command to be executed successfully.
	 Throw exception if something is wrong."

	self subclassResponsibility.! !

!SPSmtpCommand methodsFor: 'public' stamp: 'as 9/14/2006 13:50'!
execute

	self
		validateState;
		doValidate;
		doExecute;
		gotoNextState;
		sendReply.! !

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

!SPSmtpCommand methodsFor: 'state' stamp: 'as 9/8/2006 10:42'!
validateState

	(self states includes: target state) ifFalse: [
		(SPSmtpCommandNotAllowedException on: target) signal.
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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 9/12/2006 16:56'!
closing

	^ self new
		code: 421;
		message: NetNameResolver localHostName, ' Service not available, closing transmission channel';
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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 9/12/2006 17:19'!
noSuchUser

	^ self new
		code: 550;
		message: 'Requested action not taken: mailbox unavailable';
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

!SPSmtpReply class methodsFor: 'instance creation' stamp: 'as 9/11/2006 17:02'!
wrongParameterOrArgument

	^ self new
		code: 501;
		message: 'Syntax error in parameters or arguments';
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

Object subclass: #SPSubscription
	instanceVariableNames: 'list contact moderated active'
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

!SPSubscription methodsFor: 'operations' stamp: 'as 9/5/2006 13:17'!
activate

	active := true.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
contact

	^ contact.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
contact: aSPContact

	contact := aSPContact.! !

!SPSubscription methodsFor: 'operations' stamp: 'as 9/5/2006 13:17'!
deactivate

	active := false.! !

!SPSubscription methodsFor: 'comparing' stamp: 'as 8/18/2006 15:49'!
hash

	^ (list name, contact address) hash.! !

!SPSubscription methodsFor: 'initialize-release' stamp: 'as 9/5/2006 14:05'!
initialize

	self unmoderate.
	self activate.! !

!SPSubscription methodsFor: 'testing' stamp: 'as 9/5/2006 14:15'!
isActive

	^ contact isActive and: [ list isActive. ] and: [ active. ].! !

!SPSubscription methodsFor: 'testing' stamp: 'as 9/5/2006 14:19'!
isModerated

	^ contact isModerated and: [ list isModerated. ] and: [ moderated. ].! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:57'!
list

	^ list.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
list: aSPList

	list := aSPList.! !

!SPSubscription methodsFor: 'operations' stamp: 'as 9/5/2006 13:17'!
moderate

	moderated := true.! !

!SPSubscription methodsFor: 'operations' stamp: 'as 9/5/2006 13:17'!
unmoderate

	moderated := false.! !

!SPSubscription methodsFor: 'comparing' stamp: 'as 8/18/2006 16:00'!
= aSPSubscription

	^ (list = aSPSubscription list) and: [ contact = aSPSubscription contact].! !

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

!SPUser methodsFor: 'operations' stamp: 'as 9/5/2006 11:21'!
activate

	active := true.! !

!SPUser methodsFor: 'operations' stamp: 'as 9/5/2006 11:25'!
addContact: aSPContact

	contacts add: aSPContact.! !

!SPUser methodsFor: 'operations' stamp: 'as 8/22/2006 13:33'!
allContacts

	^ contacts.! !

!SPUser methodsFor: 'operations' stamp: 'as 9/18/2006 15:13'!
checkPassword: passwordString

	^ password = (self cryptedPassword: passwordString).! !

!SPUser methodsFor: 'operations' stamp: 'as 8/17/2006 15:11'!
contacts

	^ contacts.! !

!SPUser methodsFor: 'operations' stamp: 'as 9/11/2006 15:40'!
contact: aSPMailAddress

	^ contacts
		detect: [ :each | each address = aSPMailAddress. ]
		ifNone: [ nil. ].! !

!SPUser methodsFor: 'private' stamp: 'as 9/5/2006 12:00'!
cryptedPassword: passwordString

	^ SHA1 hashStream: (ReadStream on: passwordString).! !

!SPUser methodsFor: 'operations' stamp: 'as 9/5/2006 11:26'!
deactivate

	active := false.! !

!SPUser methodsFor: 'comparing' stamp: 'as 3/9/2006 16:52'!
hash

	^ name hash.! !

!SPUser methodsFor: 'initialize-release' stamp: 'as 9/5/2006 14:04'!
initialize

	contacts := Set new.
	self activate.! !

!SPUser methodsFor: 'testing' stamp: 'as 9/5/2006 11:22'!
isActive

	^ active.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:54'!
name

	^ name.! !

!SPUser methodsFor: 'accessing' stamp: 'as 3/9/2006 16:48'!
name: aString

	name := aString.! !

!SPUser methodsFor: 'accessing' stamp: 'as 9/5/2006 12:02'!
password: aString

	password := self cryptedPassword: aString.! !

!SPUser methodsFor: 'operations' stamp: 'as 9/5/2006 11:25'!
removeContact: aSPContact

	contacts remove: aSPContact ifAbsent: [ SPContactNotFoundException signal. ].! !

!SPUser methodsFor: 'comparing' stamp: 'as 3/9/2006 16:51'!
= aSPUser

	^ name = aSPUser name.! !

Exception subclass: #SPException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPException commentStamp: '<historical>' prior: 0!
Common super class of all Stamp exceptions.!

SPException subclass: #SPContactNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPContactNotFoundException commentStamp: '<historical>' prior: 0!
The contact was not found in the system.!

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

SPException subclass: #SPSmtpCommandException
	instanceVariableNames: 'server'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandException commentStamp: '<historical>' prior: 0!
An SMTP command from the client has failed on the server.!

!SPSmtpCommandException class methodsFor: 'instance creation' stamp: 'as 1/31/2006 11:22'!
on: aSPMailReceiver

	^ self new
		server: aSPMailReceiver;
		yourself.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:21'!
defaultAction

	server reply: self reply.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:05'!
reply

	"Every command failure should be replied to the client."

	self subclassResponsibility.! !

!SPSmtpCommandException methodsFor: 'accessing' stamp: 'as 1/31/2006 11:24'!
server: aSPMailReceiver

	server := aSPMailReceiver.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotAllowedException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandNotAllowedException commentStamp: '<historical>' prior: 0!
The command is not allowed in the current state of the server.!

!SPSmtpCommandNotAllowedException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpCommandException subclass: #SPSmtpCommandNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandNotFoundException commentStamp: '<historical>' prior: 0!
The specified command was not found.!

!SPSmtpCommandNotFoundException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

SPSmtpCommandException subclass: #SPSmtpCommandWrongException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandWrongException methodsFor: 'priv handling' stamp: 'as 9/14/2006 13:59'!
reply

	^ SPSmtpReply wrongParameterOrArgument.! !

SPException subclass: #SPSubscriptionNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPSubscriptionNotFoundException commentStamp: '<historical>' prior: 0!
The subscription was not found in the system.!

SPException subclass: #SPUserNotFoundException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPUserNotFoundException commentStamp: '<historical>' prior: 0!
The user was not found in the system.!

TestCase subclass: #SPCodeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPCodeTest commentStamp: '<historical>' prior: 0!
Test different coding style aspects of the implementation.!

!SPCodeTest methodsFor: 'running' stamp: 'as 1/11/2006 17:03'!
packageName

	^ 'Stamp'.! !

!SPCodeTest methodsFor: 'testing' stamp: 'as 1/11/2006 17:03'!
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

!SPListTest methodsFor: 'running' stamp: 'as 9/18/2006 14:58'!
listName

	^ 'mylist'.! !

!SPListTest methodsFor: 'running' stamp: 'as 9/18/2006 14:56'!
setUp

	list := SPList withName: self listName.! !

!SPListTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:02'!
testActivation

	list activate.
	self assert: list isActive.
	list deactivate.
	self deny: list isActive.! !

!SPListTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:04'!
testEqual

	| list2 |
	list2 := SPList withName: self listName.
	self assert: list = list2.
	self deny: list ~= list2.! !

!SPListTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:00'!
testInitialization

	self assert: list isActive.
	self deny: list isModerated.! !

!SPListTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:02'!
testModeration

	list moderate.
	self assert: list isModerated.
	list unmoderate.
	self deny: list isModerated.! !

!SPListTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:03'!
testName

	self assert: list name = self listName.! !

TestCase subclass: #SPMailReceivingSendingTest
	instanceVariableNames: 'server client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server-Tests'!

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

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 9/14/2006 13:39'!
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
		[ client := SPMailSender openOnHostNamed: 'localhost' port: port. ]
			on: ConnectionTimedOut
			do: [ :ex | tries := tries + 1. ex return. ].
		delay wait.
	] doWhileTrue: [
		client == nil and: [ tries <= maxTries ].
	]! !

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 9/14/2006 10:04'!
tearDown

	client close.
	server destroy.! !

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

TestCase subclass: #SPTextConversionTest
	instanceVariableNames: 'cr lf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Tests'!

!SPTextConversionTest commentStamp: '<historical>' prior: 0!
Test text conversion from SMTP to Squeak and back.!

!SPTextConversionTest methodsFor: 'running' stamp: 'as 3/7/2006 11:47'!
setUp

	cr := String cr.
	lf := String lf.! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:41'!
testSmtpCombined

	self assert: (cr, cr, lf, lf) convertToSmtpText = (cr, lf, cr, lf, cr, lf, cr, lf).! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:41'!
testSmtpCrLf

	self assert: cr convertToSmtpText = (cr, lf).! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:42'!
testSmtpLf

	self assert: lf convertToSmtpText = (cr, lf).! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:41'!
testSqueakCombined

	self assert: (lf, cr, cr, lf, lf, cr, lf ) convertToSqueakText = (cr, cr, cr, cr, cr).! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:41'!
testSqueakCrLf

	self assert: (cr, lf) convertToSqueakText = cr.! !

!SPTextConversionTest methodsFor: 'testing' stamp: 'as 9/5/2006 14:42'!
testSqueakLf

	self assert: lf convertToSqueakText = cr.! !

TestCase subclass: #SPUserTest
	instanceVariableNames: 'user contact1 contact2 address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Tests'!

!SPUserTest commentStamp: '<historical>' prior: 0!
Test SPUser.!

!SPUserTest methodsFor: 'running' stamp: 'as 9/5/2006 17:34'!
email

	^ '<hal9000@space.xx>'.! !

!SPUserTest methodsFor: 'running' stamp: 'as 9/11/2006 15:11'!
setUp

	user := SPUser withName: self userName password: self userPassword.
	address := SPMailAddress fromPath: self email.
	contact1 := SPContact withAddress: address user: user.
	contact2 := SPContact withAddress: address user: user.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/18/2006 14:19'!
testActivation

	user activate.
	self assert: user isActive.
	user deactivate.
	self deny: user isActive.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/7/2006 16:32'!
testAddContact

	user addContact: contact1.
	self assert: (user contact: address) == contact1.
	user addContact: contact1.
	self assert: (user contact: address) == contact1.
	user addContact: contact2.
	self assert: (user contact: address) == contact1.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/7/2006 16:38'!
testEqual

	| user2 |
	user2 := SPUser withName: self userName password: self userPassword.
	self assert: user = user2.
	self deny: user == user2.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/12/2006 16:32'!
testGetContact

	self assert: (user contact: address) = nil.
	user addContact: contact1.
	self assert: (user contact: address) == contact1.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/18/2006 15:01'!
testInitialization

	self assert: user isActive.
	self assert: user contacts isEmpty.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/18/2006 14:22'!
testPassword

	user checkPassword: self userPassword.! !

!SPUserTest methodsFor: 'testing' stamp: 'as 9/12/2006 16:32'!
testRemoveContact

	user addContact: contact1.
	user removeContact: contact1.
	self assert: (user contact: address) = nil.! !

!SPUserTest methodsFor: 'running' stamp: 'as 9/5/2006 17:33'!
userName

	^ 'hal'.! !

!SPUserTest methodsFor: 'running' stamp: 'as 9/5/2006 17:32'!
userPassword

	^ '9000'.! !

SMTPClient subclass: #SPMailSender
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPMailSender commentStamp: '<historical>' prior: 0!
Some minor changes to my superclass.!

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

WASystemConfiguration subclass: #SPBaseConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPBaseConfiguration commentStamp: '<historical>' prior: 0!
Base configuration attributes for Stamp.!

!SPBaseConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 15:28'!
attributes

	^ Array
		with: (WAStringAttribute key: #rootDir).! !

!SPBaseConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 15:28'!
rootDir

	^ 'stamp'.! !

WASystemConfiguration subclass: #SPConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPConfiguration commentStamp: '<historical>' prior: 0!
Configuration for a Stamp object. Includes the base configuration as ancestor by default.!

!SPConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 15:32'!
ancestors

	^ Array
		with: (SPBaseConfiguration localConfiguration).! !

SPConfiguration subclass: #SPMailArchiveConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPMailArchiveConfiguration commentStamp: '<historical>' prior: 0!
Mail archive configuration.!

!SPMailArchiveConfiguration methodsFor: 'as yet unclassified' stamp: 'as 6/7/2006 17:15'!
archiveDir

	^ (self valueAt: #rootDir), '/archive'.! !

!SPMailArchiveConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 15:23'!
attributes

	^ Array
		with: (WAStringAttribute key: #archiveDir).! !

SPConfiguration subclass: #SPMailListenerConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPMailListenerConfiguration commentStamp: '<historical>' prior: 0!
Mail listener configuration.!

!SPMailListenerConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 09:41'!
attributes

	^ Array
		with: (WANumberAttribute key: #port).! !

!SPMailListenerConfiguration methodsFor: 'as yet unclassified' stamp: 'as 5/30/2006 09:42'!
port

	^ 2525.! !
SPWeb initialize!
SPSmtpCommand initialize!
