/** 
* This module contains Account data struct, and interface for acces via repository pattern and relevant implmentations
* 
* Copyright: &copy; 2015 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
* History:
* 	V1 - initial release
*/

module blogd.models.account;

import vibe.db.mongo.mongo : MongoCollection;
import vibe.web.validation : ValidEmail, ValidPassword;
import vibe.data.bson : Bson;

/**
* The struct which holds data for a account db enitity
*
* 
*
* Authors: Joshua Hodkinson
*/
struct Account {
	public string name; /// The auth'd user's display name
	public ValidEmail email; /// The auth'd user's email
	public ValidPassword password; /// The auth'd user's email
}

interface IAccountRepo {
	Bson get();
	Bson get(ValidEmail email);
	Bson get(string name);
	void put(Account user);
}

class AccountRepo : IAccountRepo {
	MongoCollection repo;

	public this(MongoCollection repo) {
		this.repo = repo;
	}

	/**
	* Returns all user accounts
	*
	* Authors: Joshua Hodkinson
	*/
	public Bson get() {
		// TODO: implement
		return Bson(null);
	}

	/**
	* Returns user account with email
	*
	* Authors: Joshua Hodkinson
	*/
	public Bson get(ValidEmail email) {
		// TODO: implement
		return Bson(null);
	}

	/**
	* Returns user accounts with display name
	*
	* Authors: Joshua Hodkinson
	*/
	public Bson get(string name) {
		// TODO: implement
		return Bson(null);
	}

	/**
	* Returns user accounts with display name
	*
	* Authors: Joshua Hodkinson
	*/
	public void put(Account user) {
		// TODO: implement
	}
}