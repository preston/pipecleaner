admin = nil
begin
	admin = User.create! do |u|
	 	u.email = 'admin@example.com'
	 	u.password = 'password'
	 	u.password_confirmation = 'password'
	 	u.role = User::ADMIN_ROLE
	end
	admin.confirm!
	admin.approve!
rescue
	# Already exists!
	admin = User.find_by_email('admin@example.com')
ensure
end

user = nil
begin
	user = User.create! do |u|
	 	u.email = 'user@example.com'
	 	u.password = 'password'
	 	u.password_confirmation = 'password'
	 	u.role = User::USER_ROLE
	end
	user.confirm!
	# user.approve!
rescue
	# Already exists!
	user = User.find_by_email('user@example.com')
ensure
end

guest = nil
begin
	guest = User.create! do |u|
	 	u.email = 'guest@example.com'
	 	u.password = 'password'
	 	u.password_confirmation = 'password'
	 	u.role = User::GUEST_ROLE
	end
	guest.confirm!
	# guest.approve!
rescue
	# Already exists!
	guest = User.find_by_email('guest@example.com')
ensure
end


def set_some_complete(stages, user, p)
	p.members[0..4].each do |m|
		Status.create(member: m, stage: stages[0], code: Status::COMPLETE, user: user)
	end
	p.members[1..4].each do |m|
		Status.create(member: m, stage: stages[1], code: Status::COMPLETE, user: user)
	end
	p.members[2..4].each do |m|
		Status.create(member: m, stage: stages[2], code: Status::COMPLETE, user: user)
	end
	p.members[3..4].each do |m|
		Status.create(member: m, stage: stages[3], code: Status::COMPLETE, user: user)
	end
	p.members[4..4].each do |m|
		s = Status.create(member: m, stage: stages[4], code: Status::COMPLETE, user: user)
		if m.id % 2
			s.code = Status::WARNING
			s.save!
		end
	end
end

s1 = Service.find_or_create_by_name(name: 'Google Ping', url: 'http://google.com', verb: Service::VERB_GET)
s2 = Service.find_or_create_by_name(name: 'Dell Ping', url: 'http://dell.com', verb: Service::VERB_GET)
s3 = Service.find_or_create_by_name(name: 'Local Ping', url: 'http://localhost:9292', verb: Service::VERB_POST, include_basic: true, include_extended: true, include_data: true)


p = Pipeline.find_or_create_by_name(name: 'Sandbox', description: 'A sample pipeline for demonstration and experimentation purposes. In this example, the individual "items" that flow through the pipeline represent *people*, and are thus named that way. ', code: 'sandbox', user: admin)
# puts "Pipeline: #{p.name}, valid: #{p.valid?}"

stages = []
stages << Stage.create(pipeline: p, number: 0, name: 'Enrollment', description: 'All administrative paperwork etc. is being completed.')
stages << Stage.create(pipeline: p, number: 1, name: 'Biopsy', description: 'A tissue sample is being removed and shipped to pathology.')
stages << Stage.create(pipeline: p, number: 2, name: 'Pathology', description: 'Quality control is being performed.')
stages << Stage.create(pipeline: p, number: 3, name: 'Preparation', description: 'Chemical protocols are being applied in preparation for sequencing.')
stages << Stage.create(pipeline: p, number: 4, name: 'Sequencing', description: 'Reading is underway.')
stages << Stage.create(pipeline: p, number: 5, name: 'Processing', description: 'Raw data collection, collection and cross-referrencing is being performaned by bioinformaticians.')
stages << Stage.create(pipeline: p, number: 6, name: 'Analysis', description: 'Knowledge mining techniques are being applied by curators and subject matter experts.')
stages << Stage.create(pipeline: p, number: 7, name: 'Discussion', description: 'Treatment decisions are being made.')
stages << Stage.create(pipeline: p, number: 8, name: 'Delivery', description: 'Participation has ended.')

items = []
items << Item.find_or_create_by_name(user: admin, name: 'Rachel Raymond')
items << Item.find_or_create_by_name(user: admin, name: 'Brady Barnes')
items << Item.find_or_create_by_name(user: admin, name: 'Zeo Zillow')
items << Item.find_or_create_by_name(user: admin, name: 'Jamie Jacobs')
items << Item.find_or_create_by_name(user: admin, name: 'Corey Cadenza')
items << Item.find_or_create_by_name(user: admin, name: 'Alfonzo Amonia')
items.each do |i|
	p.items << i
end

Trigger.create(stage: stages[0], service: s1, condition: Status::COMPLETE)
Trigger.create(stage: stages[1], service: s2, condition: Status::COMPLETE)

set_some_complete(stages, admin, p)

p = Pipeline.create(name: 'Taco Hut', description: 'Taco shop order fulfillment!', code: 'taco', user: admin)

stages = []
stages << Stage.create(pipeline: p, number: 0, name: 'Order Placed', description: 'The customer has placed their order.')
stages << Stage.create(pipeline: p, number: 1, name: 'Paid', description: 'Money has been collected from the customer.')
stages << Stage.create(pipeline: p, number: 2, name: 'Production', description: 'Tacos are being made.')
stages << Stage.create(pipeline: p, number: 3, name: 'Packaging', description: 'All tacos are being placed into deliverable packaging.')
stages << Stage.create(pipeline: p, number: 4, name: 'Delivery', description: 'Order has been handed to the customer.')
stages << Stage.create(pipeline: p, number: 5, name: 'Complete', description: 'Done!')

items = []
items << Item.create(user: admin, name: '2938298')
items << Item.create(user: admin, name: '3983892')
items << Item.create(user: admin, name: '9183822')
items << Item.create(user: admin, name: '7302940')
items << Item.create(user: admin, name: '9298237')
items << Item.create(user: admin, name: '1818832')
items.each do |i|
	p.items << i
end

set_some_complete(stages, admin, p)

