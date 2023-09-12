// This module demonstrates a basic shared account that could be used for NFT royalties
// Users can (1) create a shared account (2) disperse the coins to multiple creators
module charity_donation::CharityDonation {
    use std::error;
    use std::signer;
    use std::vector;
    use aptos_framework::account;
    use aptos_framework::coin;

    // struct Charity records the address of the charity and their corresponding apt raised
    struct Charity has store,drop,copy {
        charity_wallet: address,
        apt_raised: u64,
    }

    // stores total value raised for entire platform
    struct Charities has key {
        charities: vector<Charity>,
        total_apt_raised: u64,
    }

    const EACCOUNT_NOT_FOUND: u64 = 0;
    const ERESOURCE_DNE: u64 = 1;
    const EINSUFFICIENT_BALANCE: u64 = 2;

    public fun get_charity_apt_raised(addr: address): u64 acquires Charity {
        assert!(exists<Charity>(addr), error::not_found(EACCOUNT_NOT_FOUND));
        borrow_global<Charity>(addr).apt_raised
    }

    public entry fun add_charity(charity: Charity) acquires Charities {
        if (!exists<Charities>(charity)) {        
            vector::push_back(&mut charity_list.charities, charity);
        }
    }

    // adds to apt_raised of the Charity (based on address), adds to total_apt_raised of the platform
    // sends a reward token to the donor
    public fun donate_to_charity(addr: address, amount_in_apt: u64) {

    }
    
}
