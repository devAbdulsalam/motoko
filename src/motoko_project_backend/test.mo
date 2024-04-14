import Debug "mo:base/Debug";
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor {
	var message : Text = "Hello";
	var currentValue = 300;
	currentValue := 100;
	let id = 14232378937898934;

	Debug.print(debug_show (id));

	public func topUp(amount : Nat) {
		currentValue += amount;
		// Debug.print(debug_show(currentValue));
		// return checkBalance();
	};
	// topUp();

	// Decrease the currentValue by amount
	public func withdrawl(amount : Nat) {
		let tempValue : Int = currentValue - amount;
		if (tempValue >= 0) {
			currentValue -= amount;
		} else {
			Debug.print("Amount too large, currentValue is less than zero.");
		};
	};

	public query func greet() : async Text {
		return message;
	};
	public query func checkBalance() : async Nat {
		return currentValue;
	};
	public func changeName(newMessage : Text) {
		message := newMessage;
	};

	var question : Text = "What is your favorite programming language?";
	var votes : RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);

	public query func getQuestion() : async Text {
		question;
	};
	// query the list of entries and votes for each one
	// Example:
	//      * JSON that the frontend will receive using the values above:
	//      * [["Motoko","0"],["Python","0"],["Rust","0"],["TypeScript","0"]]

	public query func getVotes() : async [(Text, Nat)] {
		Iter.toArray(votes.entries());
	};

	// This method takes an entry to vote for, updates the data and returns the updated hashmap
	// Example input: vote("Motoko")
	// Example:
	//      * JSON that the frontend will receive using the values above:
	//      * [["Motoko","1"],["Python","0"],["Rust","0"],["TypeScript","0"]]

	public func vote(entry : Text) : async [(Text, Nat)] {

		//Check if the entry already has votes.
		//Note that "votes_for_entry" is of type ?Nat. This is because:
		// * If the entry is in the RBTree, the RBTree returns a number.
		// * If the entry is not in the RBTree, the RBTree returns `null` for the new entry.
		let votes_for_entry : ?Nat = votes.get(entry);

		//Need to be explicit about what to do when it is null or a number so every case is taken care of
		let current_votes_for_entry : Nat = switch votes_for_entry {
			case null 0;
			case (?Nat) Nat;
		};

		//once we have the number of votes, update the votes for the entry
		votes.put(entry, current_votes_for_entry + 1);

		//Return the number of votes as an array (so frontend can display it)
		Iter.toArray(votes.entries());
	};

	public func resetVotes() : async [(Text, Nat)] {
		votes.put("Motoko", 0);
		votes.put("Rust", 0);
		votes.put("TypeScript", 0);
		votes.put("Python", 0);
		Iter.toArray(votes.entries());
	};

};
