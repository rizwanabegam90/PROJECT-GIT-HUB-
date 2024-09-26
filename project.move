module MyModule::EventTicketing {

    use aptos_framework::token::{Token, create_token, transfer_token};
    use aptos_framework::signer;
    use aptos_framework::aptos_account;

    struct EventTicket has store, key {
        ticket_id: u64,
        event_name: vector<u8>,
        owner: address,
    }

    // Function to mint a new ticket for an event
    public fun mint_ticket(creator: &signer, ticket_id: u64, event_name: vector<u8>, to: address)  {
        let ticket = EventTicket {
            ticket_id,
            event_name,
            owner: to,
        };
        create_token(creator, aptos_account::address_of(creator), ticket_id, b"Ticket", 1, true);
        move_to(creator, ticket);
    }

    // Function to transfer a ticket to another user
    public fun transfer_ticket(owner: &signer, to: address, ticket_id: u64)  {
        let ticket = borrow_global_mut<EventTicket>(signer::address_of(owner));
        assert!(ticket.ticket_id == ticket_id, 1);  // Ensure the correct ticket is transferred
        ticket.owner = to;
        transfer_token(owner, to, ticket_id, 1);
    }
}
