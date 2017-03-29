/** 
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/

module blogd.repositories.accountrepositorymongo;

import vibe.web.validation : ValidEmail;
import vibe.db.mongo.mongo : MongoCollection;
import vibe.data.bson : Bson, deserializeBson;

import blogd.models.account : Account;
import blogd.repositories.interfaces.iaccountrepository : IAccountRepository;

class AccountRepositoryMongo : IAccountRepository {
	MongoCollection repository;

	public this(MongoCollection repository) {
		this.repository = repository;
	}

	/**
	* Returns all user accounts
	*
	* Authors: Joshua Hodkinson
	*/
	public Account[] get() {
		// TODO: implement
		Account[] accounts;
		return accounts;
		//return repository.find();
	}

	/**
	* Returns user account with email
	*
	* Authors: Joshua Hodkinson
	*/
	public Account get(ValidEmail email) {
		// TODO: implement
		auto result = repository.findOne(["email": email.toString]);
		return result != Bson(null) ? deserializeBson!Account(result) : Account.init;
	}

	/**
	* Returns user accounts with display name
	*
	* Authors: Joshua Hodkinson
	*/
	public Account[] get(string name) {
		// TODO: implement
		Account[] accounts;
		return accounts;
	}

	/**
	 * 
	 */
	public void post(Account user) {
		// TODO: implement
	}

	/**
	* Returns user accounts with display name
	*
	* Authors: Joshua Hodkinson
	*/
	public void put(Account user) {
		// TODO: implement
	}
	
	/**
	 * 
	 */
	public void remove(Account user) {
		// TODO: implment
	}
}
