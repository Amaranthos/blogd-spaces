module blogd.repositories.interfaces.iaccountrepository;

import vibe.web.validation : ValidEmail;

import blogd.repositories.interfaces.irepository : IRepository;
import blogd.models.account : Account;

/** 
* More specific repository interface for Accounts
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/
interface IAccountRepository : IRepository!Account {
	Account get(ValidEmail email);
	Account[] get(string name);
}
