/** 
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/

module blogd.repositories.interfaces.iaccountrepository;

import vibe.web.validation : ValidEmail;

import blogd.repositories.interfaces.irepository : IRepository;
import blogd.models.account : Account;

interface IAccountRepository : IRepository!Account {
	Account get(ValidEmail email);
	Account[] get(string name);
}
