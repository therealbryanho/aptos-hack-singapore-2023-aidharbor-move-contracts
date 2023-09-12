module charity_donation::CharityDonation {
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
  
    public entry fun donate_to_charity(sender: &signer, charity_address: address, amount_in_apt: u64) {
        //transfer to token from donor to charity
        coin::transfer<AptosCoin>(sender,charity_address, amount_in_apt);
    
    }
    
}
