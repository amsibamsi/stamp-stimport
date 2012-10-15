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

Object subclass: #SPContact
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

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
activate

	active := true.! !

!SPContact methodsFor: 'accessing' stamp: 'as 8/17/2006 15:14'!
address

	^ address.! !

!SPContact methodsFor: 'accessing' stamp: 'as 8/17/2006 15:14'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPContact methodsFor: 'state' stamp: 'as 9/5/2006 11:27'!
deactivate

	active := false.! !

!SPContact methodsFor: 'comparing' stamp: 'as 8/17/2006 15:48'!
hash

	^ address name hash.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 10/4/2006 22:34'!
initialize

	self activate.
	self initVerification.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 10/4/2006 22:33'!
initVerification

	| r |
	verification := ''.
	r := Random new.
	1 to: self verificationLength do: [ :i | verification := verification, (r nextInt: 9) asString. ].! !

!SPContact methodsFor: 'testing' stamp: 'as 9/5/2006 14:08'!
isActive

	^ user isActive and: [ active. ].! !

!SPContact methodsFor: 'testing' stamp: 'as 10/4/2006 22:35'!
isVerified

	^ verification isNil.! !

!SPContact methodsFor: 'accessing' stamp: 'as 9/5/2006 11:29'!
user: aSPUser

	user := aSPUser.! !

!SPContact methodsFor: 'accessing' stamp: 'as 10/4/2006 22:36'!
verification

	^ verification.! !

!SPContact methodsFor: 'initialize-release' stamp: 'as 10/4/2006 22:34'!
verificationLength

	^ 32.! !

!SPContact methodsFor: 'state' stamp: 'as 10/4/2006 22:36'!
verify: aString

	^ verification = aString ifTrue: [ verification := nil. ].! !

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
	instanceVariableNames: 'listener archive manager filter sender'
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

!SPKernel methodsFor: 'accessing' stamp: 'as 9/25/2006 12:59'!
filter

	^ filter.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 10/10/2006 18:19'!
initialize

	listener := SPMailListener withKernel: self.
	sender := SPMailSender withKernel: self.
	archive := SPMailArchive withKernel: self.
	manager := SPListManager new.
	filter := SPMailFilter withKernel: self.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 3/10/2006 16:19'!
listener

	^ listener.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 8/18/2006 19:37'!
manager

	^ manager.! !

!SPKernel methodsFor: 'initialize-release' stamp: 'as 10/10/2006 18:20'!
reinitialize

	self stop.
	self initialize.! !

!SPKernel methodsFor: 'starting-stoping' stamp: 'as 9/27/2006 12:01'!
restart

	listener stop; start.! !

!SPKernel methodsFor: 'accessing' stamp: 'as 10/5/2006 13:36'!
sender

	^ sender.! !

!SPKernel methodsFor: 'starting-stoping' stamp: 'as 3/14/2006 14:10'!
start

	listener start.! !

!SPKernel methodsFor: 'starting-stoping' stamp: 'as 3/14/2006 14:11'!
stop

	listener stop.! !

Object subclass: #SPList
	instanceVariableNames: 'address name moderated active closedPosting'
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

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 14:14'!
activate

	active := true.! !

!SPList methodsFor: 'accessing' stamp: 'as 9/26/2006 17:10'!
address

	^ address.! !

!SPList methodsFor: 'accessing' stamp: 'as 9/26/2006 17:10'!
address: aSPMailAddress

	address := aSPMailAddress.! !

!SPList methodsFor: 'state' stamp: 'as 10/5/2006 11:21'!
closedPosting

	^ closedPosting := true.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 14:14'!
deactivate

	active := false.! !

!SPList methodsFor: 'testing' stamp: 'as 10/5/2006 11:20'!
hasClosedPosting

	^ closedPosting.! !

!SPList methodsFor: 'comparing' stamp: 'as 3/9/2006 16:50'!
hash

	^ name hash.! !

!SPList methodsFor: 'testing' stamp: 'as 10/5/2006 11:22'!
hasOpenPosting

	^ closedPosting not.! !

!SPList methodsFor: 'initialize-release' stamp: 'as 10/5/2006 11:20'!
initialize

	self unmoderate.
	self activate.
	self closedPosting.! !

!SPList methodsFor: 'testing' stamp: 'as 9/5/2006 14:14'!
isActive

	^ active.! !

!SPList methodsFor: 'testing' stamp: 'as 9/5/2006 13:03'!
isModerated

	^ moderated.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 13:05'!
moderate

	moderated := true.! !

!SPList methodsFor: 'accessing' stamp: 'as 10/5/2006 14:47'!
name

	^ name.! !

!SPList methodsFor: 'accessing' stamp: 'as 10/5/2006 14:47'!
name: aString

	name := aString.! !

!SPList methodsFor: 'state' stamp: 'as 10/5/2006 11:21'!
openPosting

	^ closedPosting := false.! !

!SPList methodsFor: 'state' stamp: 'as 9/5/2006 13:05'!
unmoderate

	moderated := false.! !

!SPList methodsFor: 'comparing' stamp: 'as 9/26/2006 17:10'!
= aSPList

	^ address = aSPList address.! !

Object subclass: #SPListManager
	instanceVariableNames: 'users lists subscriptions monitor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPListManager commentStamp: '<historical>' prior: 0!
Coordinates lists, users, subscriptions and more.!

!SPListManager methodsFor: 'managing' stamp: 'as 9/12/2006 16:42'!
addList: aSPList

	lists add: aSPList.! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/12/2006 16:42'!
addUser: aSPUser

	users add: aSPUser.! !

!SPListManager methodsFor: 'managing' stamp: 'as 10/10/2006 17:05'!
allActiveSubscriptionsForList: aSPList

	^ subscriptions select: [ :each | each list = aSPList and: [ each isActive. ]. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 8/18/2006 15:03'!
allLists

	^ lists.! !

!SPListManager methodsFor: 'managing' stamp: 'as 8/18/2006 15:03'!
allSubscriptions

	^ subscriptions.! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/5/2006 13:10'!
allSubscriptionsForList: aSPList

	^ subscriptions select: [ :each | each list = aSPList. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/5/2006 13:11'!
allSubscriptionsForUser: aSPUser

	| contacts |
	contacts := Set withAll: aSPUser contacts.
	^ subscriptions select: [ :each | contacts includes: each contact. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 8/18/2006 15:03'!
allUsers

	^ users.! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/26/2006 16:55'!
contactWithAddress: aSPMailAddress

	| contact |
	users do: [
		:user |
		contact := user contacts detect: [ :each | each address = aSPMailAddress. ] ifNone: [ nil. ].
		contact ifNotNil: [ ^ contact. ].
	].
	^ nil.! !

!SPListManager methodsFor: 'initialize-release' stamp: 'as 9/12/2006 16:36'!
initialize

	users := Set new.
	lists := Set new.
	subscriptions := Set new.
	monitor := Monitor new.! !

!SPListManager methodsFor: 'accessing' stamp: 'as 8/17/2006 11:07'!
kernel: aSPKernel

	kernel := aSPKernel.! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/26/2006 17:03'!
listWithAddress: aSPMailAddress

	^ lists
		detect: [ :each | each address = aSPMailAddress. ]
		ifNone: [ nil. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/26/2006 16:50'!
listWithName: aString

	^ lists
		detect: [ :each | each name = aString. ]
		ifNone: [ nil. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/5/2006 13:11'!
removeList: aSPList

	lists remove: aSPList ifAbsent: [ SPListNotFoundException signal. ].
	subscriptions removeAll: (self subscriptionsForList: aSPList).! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/5/2006 10:28'!
removeUser: aSPUser

	users remove: aSPUser ifAbsent: [ SPUserNotFoundException signal. ].
	subscriptions removeAll: (self subscriptionsForUser: aSPUser).! !

!SPListManager methodsFor: 'managing' stamp: 'as 10/11/2006 12:39'!
subscribe: aSPContact to: aSPList

	| subscription |
	subscription := SPSubscription withList: aSPList contact: aSPContact.
	subscriptions add: subscription.! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/5/2006 13:09'!
unsubscribe: aSPSubscription

	subscriptions remove: aSPSubscription ifAbsent: [ SPSubscriptionNotFoundException signal. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/26/2006 17:02'!
userWithAddress: aSPMailAddress

	^ users
		detect: [ :each | each contacts includes: aSPMailAddress. ]
		ifNone: [ nil. ].! !

!SPListManager methodsFor: 'managing' stamp: 'as 9/26/2006 16:50'!
userWithName: aString

	^ users
		detect: [ :each | each name = aString. ]
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

!SPMailAddress methodsFor: 'printing' stamp: 'as 9/27/2006 13:14'!
addressString

	^ localPart, '@', domain.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 16:51'!
domain

	^ domain.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 16:51'!
domain: aString

	domain := aString.! !

!SPMailAddress methodsFor: 'comparing' stamp: 'as 9/27/2006 13:15'!
hash

	^ self addressString hash.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 17:32'!
localPart

	^ localPart.! !

!SPMailAddress methodsFor: 'accessing' stamp: 'as 6/8/2006 17:31'!
localPart: aString

	localPart := aString.! !

!SPMailAddress methodsFor: 'printing' stamp: 'as 9/26/2006 16:57'!
path

	^ '<', localPart, '@', domain, '>'.! !

!SPMailAddress methodsFor: 'comparing' stamp: 'as 9/27/2006 13:15'!
= aSPMailAddress

	^ self addressString = aSPMailAddress addressString.! !

Object subclass: #SPMailMessage
	instanceVariableNames: 'mail user sender list'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailMessage commentStamp: '<historical>' prior: 0!
The SMTP protocol defines commands for specifying a sender and one or multiple recipient addresses apart from the ones in the header of a mail message (from:, to:, cc:, ...).
This class is a wrapper around MailMessage that stores these addresses as well, since they are important when relaying mail. The addresses are not stored directly. The sender is stored as a sender address and the possible corresponding user. The recipients are stored as mailing lists.!

!SPMailMessage methodsFor: 'inserting' stamp: 'as 10/5/2006 14:53'!
instertName

	mail subject: '[', list name, '] ', mail subject.! !

!SPMailMessage methodsFor: 'inserting' stamp: 'as 10/5/2006 14:46'!
instertReturnPath

	mail returnPath: mail sender path.! !

!SPMailMessage methodsFor: 'testing' stamp: 'as 10/11/2006 19:31'!
isModerated

	^ list isModerated.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 10/5/2006 14:21'!
list

	^ list.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 10/5/2006 14:21'!
list: aSPList

	list := aSPList.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 5/24/2006 12:42'!
mail

	^ mail.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 6/12/2006 14:32'!
mail: aString

	mail := MailMessage from: aString.! !

!SPMailMessage methodsFor: 'copying' stamp: 'as 10/5/2006 15:13'!
postCopy

	mail := MailMessage from: mail text.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 9/26/2006 16:13'!
sender

	^ sender.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 9/26/2006 16:29'!
sender: aSPMailAddress

	sender := aSPMailAddress.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 9/26/2006 16:02'!
user

	^ user.! !

!SPMailMessage methodsFor: 'accessing' stamp: 'as 9/26/2006 13:50'!
user: aSPUser

	user := aSPUser.! !

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

!SPMailArchive methodsFor: 'storing' stamp: 'as 10/11/2006 19:32'!
addMessage: aSPMailMessage

		| dir |
		dir := (self preferenceAt: #archiveDir), '/', aSPMailMessage list address addressString.
		(MailDB openOn: dir) addNewMessage: aSPMailMessage mail.! !

SPObject subclass: #SPMailFilter
	instanceVariableNames: 'inbox outbox holdbox'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailFilter commentStamp: '<historical>' prior: 0!
Filters incoming/outgoing mail and decides what to do with it.!

!SPMailFilter methodsFor: 'filtering' stamp: 'as 10/3/2006 23:02'!
filter: aSPMailMessage

	inbox enqueue: aSPMailMessage.! !

!SPMailFilter methodsFor: 'holdbox' stamp: 'as 10/5/2006 10:46'!
holdboxProcessBlock

	^ [
		:aSPMailMessage |
	].! !

!SPMailFilter methodsFor: 'inbox' stamp: 'as 10/5/2006 12:46'!
inboxProcessBlock

	^ [
		:aSPMailMessage |
		aSPMailMessage isModerated ifTrue: [
			holdbox enqueue: aSPMailMessage.
		] ifFalse: [
			outbox enqueue: aSPMailMessage.
		].
	].! !

!SPMailFilter methodsFor: 'initialize-release' stamp: 'as 10/5/2006 10:45'!
initialize

	inbox := SPQueue withProcessBlock: self inboxProcessBlock.
	outbox := SPQueue withProcessBlock: self outboxProcessBlock.
	holdbox := SPQueue withProcessBlock: self holdboxProcessBlock.! !

!SPMailFilter methodsFor: 'outbox' stamp: 'as 10/5/2006 13:35'!
outboxProcessBlock

	^ [
		:aSPMailMessage |
		kernel archive addMessage: aSPMailMessage.
		kernel sender sendMessage: aSPMailMessage.
	].! !

SPObject subclass: #SPMailListener
	instanceVariableNames: 'service'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPMailListener commentStamp: '<historical>' prior: 0!
Listens for incoming SMTP connections and treats them appropriately.!

!SPMailListener methodsFor: 'starting-stopping' stamp: 'as 7/24/2006 09:28'!
destroy

	service unregister.
	service := nil.! !

!SPMailListener methodsFor: 'initialize-release' stamp: 'as 10/11/2006 18:42'!
initialize

	service := SPMailService withListener: self onPort: (self preferenceAt: #receiverPort).! !

!SPMailListener methodsFor: 'accessing' stamp: 'as 9/14/2006 09:57'!
service

	^ service.! !

!SPMailListener methodsFor: 'starting-stopping' stamp: 'as 5/30/2006 14:06'!
start

	service start.! !

!SPMailListener methodsFor: 'starting-stopping' stamp: 'as 5/30/2006 14:06'!
stop

	service stop.! !

SPObject subclass: #SPMailReceiver
	instanceVariableNames: 'state stream quit messages'
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

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 2/6/2006 15:19'!
dataDelimiter

	"The delimiter string that will end mail data input."

	^ String crlf, '.', String crlf.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 14:44'!
filterMessages

	messages do: [
		:message |
		kernel filter filter: message.
	].! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 10/5/2006 14:06'!
initialize

	quit := false.
	self initMessages.
	self state: SPReadySmtpState.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 10/5/2006 14:22'!
initMessages

	messages := OrderedCollection new.
	messages add: SPMailMessage new.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 15:02'!
insertTrace

	messages do: [
		:message |
		message mail received: 'from ', self remoteName, ' by ', self localName, '; ', MailMessage dateStampNow.
	].! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 15:11'!
list: aSPList

	| last new |
	last := messages last.
	last list ifNil: [
		last list: aSPList.
	] ifNotNil: [
		new := last copy.
		new list: aSPList.
		messages add: new.
	].! !

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

!SPMailReceiver methodsFor: 'private' stamp: 'as 9/25/2006 11:42'!
nameForAddress: addressString

	| name |
	name := NetNameResolver nameForAddress: addressString timeout: (self preferenceAt: #resolverTimeout).
	name ifNil: [ name := 'UNRESOLVED'. ].
	^ name.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 10/3/2006 16:06'!
receive

	"Receive commands from client as long as connection is there and
	 quit is not requested."

	self reply: SPSmtpReply ready.
	[
		[
			[ quit not and: [ stream isConnected. ] ] whileTrue: [ self receiveCommand. ].
		] on: Exception do: [ self reply: SPSmtpReply closing. ].
	] ensure: [ stream close. ].! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 4/18/2006 16:50'!
receiveCommand

	"Find the apropriate command for a string line from the client and execute it."

	| line command |
	line := stream nextLineCrLf.
	[ command := SPSmtpCommand fromString: line target: self.
	  command execute. ]
		on: SPSmtpCommandException
		do: [ :ex | ex defaultAction. ex return. ].! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 5/24/2006 13:50'!
receiveData

	"Receive mail data as specified by the DATA SMTP command."

	^ (stream upToAll: self dataDelimiter) convertToSqueakText.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:40'!
remoteAddress

	^ stream socket remoteAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 23:31'!
remoteName

	^ self nameForAddress: self remoteAddress.! !

!SPMailReceiver methodsFor: 'socket' stamp: 'as 9/20/2006 14:40'!
remotePort

	^ stream socket remotePort.! !

!SPMailReceiver methodsFor: 'replying' stamp: 'as 4/18/2006 16:37'!
reply: aSPSmtpReply

	"Reply a message to the client."

	stream nextPutAll: aSPSmtpReply replyString; crlf; flush.! !

!SPMailReceiver methodsFor: 'receiving' stamp: 'as 1/18/2006 17:10'!
requestQuit

	quit := true.! !

!SPMailReceiver methodsFor: 'initialize-release' stamp: 'as 10/5/2006 14:06'!
reset

	self initMessages.
	self state: SPResetSmtpState.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 14:09'!
sender: aSPMailAddress

	messages do: [ :message | message sender: aSPMailAddress. ].! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 1/11/2006 14:34'!
state

	^ state.! !

!SPMailReceiver methodsFor: 'state' stamp: 'as 4/20/2006 17:45'!
state: aSPSmtpState

	state := aSPSmtpState.! !

!SPMailReceiver methodsFor: 'accessing' stamp: 'as 1/10/2006 21:36'!
stream: aStream

	stream := aStream.! !

!SPMailReceiver methodsFor: 'message' stamp: 'as 10/5/2006 14:11'!
user: aSPUser

	messages do: [ :message | message user: aSPUser. ].! !

SPObject subclass: #SPMailSender
	instanceVariableNames: 'client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Client'!

!SPMailSender commentStamp: '<historical>' prior: 0!
Send mails over an smtp server.!

!SPMailSender methodsFor: 'initialize-release' stamp: 'as 10/11/2006 21:40'!
initialize

	| hostIP |
	hostIP := NetNameResolver
		addressForName: (self preferenceAt: #senderServer)
		timeout: (self preferenceAt: #resolveTimeout).
	client := SPSmtpClient
		onHostNamed: hostIP
		port: (self preferenceAt: #senderPort).! !

!SPMailSender methodsFor: 'sending' stamp: 'as 10/11/2006 18:27'!
sendMessage: aSPMailMessage

	| subscriptions recipients sender |
	subscriptions := kernel manager allActiveSubscriptionsForList: aSPMailMessage list.
	recipients := subscriptions collect: [ :subscription | subscription contact address. ].
	sender := aSPMailMessage list address.
	[
		client
			open;
			from: sender;
			to: recipients;
			data: aSPMailMessage mail;
			quit.
	] ensure: [ client close. ].! !

!SPObject class methodsFor: 'configuration' stamp: 'as 9/27/2006 11:58'!
configuration

	| class |
	class := Smalltalk classNamed: (self name, self defaultConfigurationSuffix).
	class ifNil: [ class := self defaultConfiguration. ].
	^ class localConfiguration.! !

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

SPObject subclass: #SPQueue
	instanceVariableNames: 'queue monitor process processBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Core'!

!SPQueue commentStamp: '<historical>' prior: 0!
Enqueues objects and processes each one with the given process block. The processing is done in a separate process. Enqueuing of objects is thread-safe.!

!SPQueue class methodsFor: 'instance creation' stamp: 'as 10/3/2006 18:23'!
withProcessBlock: aBlock

	^ self new processBlock: aBlock; yourself.! !

!SPQueue methodsFor: 'private' stamp: 'as 10/3/2006 18:19'!
addLast: anObject

	monitor critical: [ queue addLast: anObject. ].! !

!SPQueue methodsFor: 'queueing' stamp: 'as 10/3/2006 22:55'!
enqueue: anObject

	self addLast: anObject.
	process isSuspended ifTrue: [ process resume. ].! !

!SPQueue methodsFor: 'private' stamp: 'as 9/27/2006 13:18'!
forever: aBlock

	[ true. ] whileTrue: [ aBlock value. ].! !

!SPQueue methodsFor: 'initialize-release' stamp: 'as 10/3/2006 18:15'!
initialize

	monitor := Monitor new.
	queue := OrderedCollection new.
	process := [ self processQueue. ] newProcess.! !

!SPQueue methodsFor: 'accessing' stamp: 'as 10/3/2006 18:23'!
processBlock: aBlock

	processBlock := aBlock.! !

!SPQueue methodsFor: 'processing' stamp: 'as 10/3/2006 23:12'!
processQueue

	| object |
	self forever: [
		queue ifEmpty: [ process suspend. ].
		object := self removeFirst.
		processBlock value: object.
	].! !

!SPQueue methodsFor: 'private' stamp: 'as 10/3/2006 18:19'!
removeFirst

	monitor critical: [ ^ queue removeFirst. ].! !

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

!SPPassword methodsFor: 'checking' stamp: 'as 9/26/2006 14:09'!
check: aString

	^ password = (self encrypt: aString).! !

!SPPassword methodsFor: 'private' stamp: 'as 9/26/2006 14:09'!
encrypt: aString

	^ SHA1 hashStream: (ReadStream on: aString).! !

!SPPassword methodsFor: 'private' stamp: 'as 9/26/2006 14:42'!
new: aString

	password := self encrypt: aString.! !

!SPPassword methodsFor: 'setting' stamp: 'as 9/26/2006 14:44'!
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

!SPDataSmtpCommand methodsFor: 'executing' stamp: 'as 10/5/2006 15:02'!
doExecute

	target
		reply: SPSmtpReply mailInput;
		mail: target receiveData;
		insertTrace;
		filterMessages;
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
	instanceVariableNames: 'sender'
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

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 9/26/2006 17:02'!
doExecute

	target sender: sender.
	target user: (target kernel manager userWithAddress: sender).
	self state: SPMailSmtpState.! !

!SPMailSmtpCommand methodsFor: 'executing' stamp: 'as 10/3/2006 15:52'!
doValidate

	[ sender := SPMailAddress fromPath: argument. ]
		on: SPInvalidMailAddressException
		do: [ (SPWrongSmtpCommandException withReceiver: target) signal. ].! !

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

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 10/5/2006 15:03'!
doExecute

	| list |
	list := target kernel manager listWithAddress: recipient.
	list isNil ifTrue: [
		self reply: SPSmtpReply noSuchUser.
	] ifFalse: [
		target list: list.
		self state: SPRecipientSmtpState.
	].! !

!SPRecipientSmtpCommand methodsFor: 'executing' stamp: 'as 10/3/2006 15:52'!
doValidate

	[ recipient := SPMailAddress fromPath: argument. ]
		on: SPInvalidMailAddressException
		do: [ (SPWrongSmtpCommandException withReceiver: target) signal. ].! !

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

!SPSmtpCommand class methodsFor: 'private' stamp: 'as 10/3/2006 15:51'!
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
	class isNil ifTrue: [ (SPNotFoundSmtpCommandException withReceiver: aSPMailReceiver) signal. ].
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

!SPSmtpCommand class methodsFor: 'class initialization' stamp: 'as 9/27/2006 11:53'!
initStates

	"Returns a collection of states this command is allowed to execute in."
	
	"IMPORTANT: changes made here or in called methods do only have effect
	 after reinitialization of the class!!"

	"self initialize"
	"self allSubclasses do: [ :each | each initialize. ]"! !

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

!SPSmtpCommand methodsFor: 'executing' stamp: 'as 9/14/2006 13:50'!
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

!SPSmtpCommand methodsFor: 'state' stamp: 'as 10/3/2006 15:51'!
validateState

	(self states includes: target state) ifFalse: [
		(SPNotAllowedSmtpCommandException withReceiver: target) signal.
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

!SPSubscription methodsFor: 'state' stamp: 'as 9/5/2006 13:17'!
activate

	active := true.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
contact

	^ contact.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
contact: aSPContact

	contact := aSPContact.! !

!SPSubscription methodsFor: 'state' stamp: 'as 9/5/2006 13:17'!
deactivate

	active := false.! !

!SPSubscription methodsFor: 'comparing' stamp: 'as 10/11/2006 12:41'!
hash

	^ (list name, contact address addressString) hash.! !

!SPSubscription methodsFor: 'initialize-release' stamp: 'as 10/11/2006 12:39'!
initialize

	self activate.! !

!SPSubscription methodsFor: 'testing' stamp: 'as 9/5/2006 14:15'!
isActive

	^ contact isActive and: [ list isActive. ] and: [ active. ].! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:57'!
list

	^ list.! !

!SPSubscription methodsFor: 'accessing' stamp: 'as 8/18/2006 14:58'!
list: aSPList

	list := aSPList.! !

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

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:21'!
activate

	active := true.! !

!SPUser methodsFor: 'contacts' stamp: 'as 9/5/2006 11:25'!
addContact: aSPContact

	contacts add: aSPContact.! !

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:02'!
checkPassword: aString

	^ password check: aString.! !

!SPUser methodsFor: 'contacts' stamp: 'as 8/17/2006 15:11'!
contacts

	^ contacts.! !

!SPUser methodsFor: 'contacts' stamp: 'as 9/27/2006 13:09'!
contactWithAddress: aSPMailAddress

	^ contacts
		detect: [ :each | each address = aSPMailAddress. ]
		ifNone: [ nil. ].! !

!SPUser methodsFor: 'state' stamp: 'as 9/5/2006 11:26'!
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

!SPUser methodsFor: 'password' stamp: 'as 9/26/2006 15:03'!
newPassword: newString oldPassword: oldString

	password new: newString old: oldString.! !

!SPUser methodsFor: 'accessing' stamp: 'as 9/26/2006 15:02'!
password: aString

	password := SPPassword withPassword: aString.! !

!SPUser methodsFor: 'contacts' stamp: 'as 9/5/2006 11:25'!
removeContact: aSPContact

	contacts remove: aSPContact ifAbsent: [ SPContactNotFoundException signal. ].! !

!SPUser methodsFor: 'comparing' stamp: 'as 3/9/2006 16:51'!
= aSPUser

	^ name = aSPUser name.! !

WASystemConfiguration subclass: #SPBaseConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPBaseConfiguration commentStamp: '<historical>' prior: 0!
Base configuration attributes for Stamp.!

!SPBaseConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/10/2006 18:05'!
attributes

	^ Array
		with: (WAStringAttribute key: #rootDir);
		with: (WANumberAttribute key: #resolverTimeout).! !

!SPBaseConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/10/2006 18:04'!
resolverTimeout

	^ 3.! !

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

!SPMailListenerConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/11/2006 18:41'!
attributes

	^ Array
		with: (WANumberAttribute key: #receiverPort).! !

!SPMailListenerConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/11/2006 19:26'!
receiverPort

	^ 2525.! !

SPConfiguration subclass: #SPMailSenderConfiguration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Configuration'!

!SPMailSenderConfiguration commentStamp: '<historical>' prior: 0!
Mail sender configuration.!

!SPMailSenderConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/11/2006 18:35'!
attributes

	^ Array
		with: (WAStringAttribute key: #senderServer);
		with: (WANumberAttribute key: #senderPort).! !

!SPMailSenderConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/11/2006 18:34'!
senderPort

	^ 25.! !

!SPMailSenderConfiguration methodsFor: 'as yet unclassified' stamp: 'as 10/11/2006 18:35'!
senderServer

	^ 'smtp.unibe.ch'.! !

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
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPSmtpCommandException commentStamp: '<historical>' prior: 0!
An SMTP command from the client has failed on the server.!

SPSmtpCommandException subclass: #SPNotAllowedSmtpCommandException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPNotAllowedSmtpCommandException commentStamp: '<historical>' prior: 0!
The command is not allowed in the current state of the server.!

!SPNotAllowedSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:04'!
reply

	^ SPSmtpReply badSequence.! !

SPSmtpCommandException subclass: #SPNotFoundSmtpCommandException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPNotFoundSmtpCommandException commentStamp: '<historical>' prior: 0!
The specified command was not found.!

!SPNotFoundSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/17/2006 18:06'!
reply

	^ SPSmtpReply commandUnrecognized.! !

!SPSmtpCommandException class methodsFor: 'instance creation' stamp: 'as 10/3/2006 15:50'!
withReceiver: aSPMailReceiver

	^ self new
		receiver: aSPMailReceiver;
		yourself.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 10/3/2006 15:50'!
defaultAction

	receiver reply: self reply.! !

!SPSmtpCommandException methodsFor: 'accessing' stamp: 'as 10/3/2006 15:49'!
receiver: aSPMailReceiver

	receiver := aSPMailReceiver.! !

!SPSmtpCommandException methodsFor: 'priv handling' stamp: 'as 1/31/2006 11:05'!
reply

	"Every command failure should be replied to the client."

	self subclassResponsibility.! !

!SPSmtpCommandException methodsFor: 'accessing' stamp: 'as 1/31/2006 11:24'!
server: aSPMailReceiver

	server := aSPMailReceiver.! !

SPSmtpCommandException subclass: #SPWrongSmtpCommandException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-Mail-Server'!

!SPWrongSmtpCommandException commentStamp: '<historical>' prior: 0!
Wrong parameters or arguments. !

!SPWrongSmtpCommandException methodsFor: 'priv handling' stamp: 'as 9/14/2006 13:59'!
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

SPException subclass: #SPWrongPasswordException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager'!

!SPWrongPasswordException commentStamp: '<historical>' prior: 0!
The given password is not correct.!

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

!SPMailReceivingSendingTest methodsFor: 'running' stamp: 'as 10/5/2006 13:24'!
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

TestCase subclass: #SPPasswordTest
	instanceVariableNames: 'password1 password2 password'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stamp-ListManager-Tests'!

!SPPasswordTest commentStamp: '<historical>' prior: 0!
Stamp password test.!

!SPPasswordTest methodsFor: 'running' stamp: 'as 9/26/2006 14:48'!
setUp

	password1 := 'password1'.
	password2 := 'password2'.
	password := SPPassword withPassword: password1.! !

!SPPasswordTest methodsFor: 'testing' stamp: 'as 9/26/2006 14:50'!
testCheck

	self assert: (password check: password1).
	self deny: (password check: password2).! !

!SPPasswordTest methodsFor: 'testing' stamp: 'as 9/26/2006 14:51'!
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

!MailMessage class methodsFor: '*Stamp' stamp: 'as 9/27/2006 13:39'!
dateStampNow
	"Return the current date and time formatted as a email Date: line"
	"The result conforms to RFC822 with a long year, e.g.  'Thu, 18 Feb 1999 20:38:51'"

	"Fix:
	 According to RFC822, this must also include the time zone.
	 Anselm Strauss, astrauss@gmx.ch, Wed, 20 Sep 2006"

	| zone digits sign |
	zone := DateAndTime localTimeZone offset.
	digits := zone hours abs * 100 + zone minutes abs.
	zone negative ifTrue: [ sign := '-'. ] ifFalse: [ sign := '+'. ].

	^	(Date today weekday copyFrom: 1 to: 3), ', ',
		(Date today printFormat: #(1 2 3 $  2 1 1)), ' ',
		Time now print24, ' ',
		sign, (digits printPaddedWith: $0 to: 4).! !

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

!MailMessage methodsFor: '*Stamp' stamp: 'as 9/25/2006 11:35'!
returnPath: aString

	self addField: 'return-path' fromString: aString.! !

!MailMessage methodsFor: '*Stamp' stamp: 'as 10/5/2006 14:48'!
subject: aString

	self addField: 'subject' fromString: aString.! !

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

!SPMailService methodsFor: 'conversation' stamp: 'as 10/3/2006 15:51'!
serve: aSocket

	| receiver |
	receiver := SPMailReceiver withKernel: listener kernel stream: (SocketStream on: aSocket) .
	receiver receive.! !

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

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 10/10/2006 17:33'!
from: aSPMailAddress

	self sendCommand: 'mail from: ', aSPMailAddress path.
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

!SPSmtpClient methodsFor: 'smtp' stamp: 'as 10/10/2006 17:34'!
to: aCollection

	aCollection do: [
		:aSPMailAddress |
		self sendCommand: 'rcpt to: ', aSPMailAddress path.
		self checkResponse.
	].! !
SPWeb initialize!
SPSmtpCommand initialize!
