FactoryGirl.define do

	sequence(:email) {|n| "person-#{n}@example.com" }

	factory :user do
		email
		encrypted_password "$2a$10$nhFLUQJb.9eanNIzrUA8D.TDdD7ZQd7/W4T1o5tZq5lOVC2dAgDeq"
		role 'user'
	end

	factory :admin, class: 'User' do
		email
		encrypted_password "$2a$10$nhFLUQJb.9eanNIzrUA8D.TDdD7ZQd7/W4T1o5tZq5lOVC2dAgDeq"
		role "admin"
	end

end
