module charity_donation::CharityDonation {
    use std::error;
    use std::signer;
    use std::vector;
    //use aptos_framework::account;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    //use charity_donation::abc_coin;
    //use aptos_framework::aptos_account;

    //use smart table or simple map

    // struct Charity records the address of the charity and their corresponding apt raised
    struct Charity has key,store,drop,copy {
        charity_wallet: address,
        apt_raised: u64,
    }

    // stores total value raised for entire platform
    struct Charities has key {
        charities: vector<Charity>,
        total_apt_raised: u64,
    }

    /// charity address not found
    const EACCOUNT_NOT_FOUND: u64 = 0;
    const ERESOURCE_DNE: u64 = 1;
    const EINSUFFICIENT_BALANCE: u64 = 2;

    fun init_module(sender: &signer) {
        let c = Charities {
            charities: vector::empty<Charity>(),
            total_apt_raised: 0,
        };
        move_to(sender, c);
    }

    #[view]
    public fun get_charity_apt_raised(addr: address): u64 acquires Charity {
        assert!(exists<Charity>(addr), error::not_found(EACCOUNT_NOT_FOUND));
        let retValue = borrow_global<Charity>(addr).apt_raised;
        retValue
    }

    #[view]
    public fun get_platform_apt_raised(): u64 acquires Charities {
        let retValue = borrow_global<Charities>(@charity_donation).total_apt_raised;
        retValue
    }

    //acquires Charities
    public entry fun add_charity(addr: address) acquires Charities {
        if (exists<Charities>(addr)) {    
            let newCharity = Charity {
                charity_wallet: addr,
                apt_raised: 0
            };
            
            let platform = borrow_global_mut<Charities>(@charity_donation);
            vector::push_back(&mut platform.charities, newCharity);
        }
    }

    // adds to apt_raised of the Charity (based on address), adds to total_apt_raised of the platform
    // sends a reward token to the donor
    public fun donate_to_charity(sender: &signer, charity_address: address, amount_in_apt: u64) acquires Charity, Charities {
        //let sender_address = signer::address_of(sender);
        //create the account if doesn't exist
        // if (!account::exists_at(charity_address)) {
        //     create_account(charity_address);
        // };

        //transfer to token from donor to charity
        coin::transfer<AptosCoin>(sender,charity_address, amount_in_apt);
        //update the charity total raised value
        let charityToUpdate = borrow_global_mut<Charity>(charity_address);
        let new_total_value_for_charity = charityToUpdate.apt_raised + amount_in_apt;
        charityToUpdate.apt_raised = new_total_value_for_charity;
        //update the platform total raised value
        let platform = borrow_global_mut<Charities>(@charity_donation);
        let oldPlatformValue = platform.total_apt_raised;
        let newPlatformValue = oldPlatformValue + amount_in_apt;
        platform.total_apt_raised = newPlatformValue;

        //send native abc coin to the sender
        //how to mint the native coin to the sender
        //aptos_framework::abc_coin::mint(sender_address,amount_in_apt);
    }
    
}
