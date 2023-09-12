aptos config show-profile --profile default

aptos init --profile new

aptos move publish --named-addresses charity_donation=default

aptos move run --function-id 'default::CharityDonation::add_charity' --args 'address:default'

aptos move view --function-id 'default::CharityDonation::get_platform_apt_raised' 

aptos move view --function-id 'default::CharityDonation::get_charity_apt_raised' --args 'address:default'