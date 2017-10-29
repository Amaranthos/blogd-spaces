/** 
* This module contains Account data struct
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/

module blogd.models.account;

import vibe.db.mongo.mongo : MongoCollection;
import vibe.web.validation : ValidEmail, ValidPassword;


/**
* The struct which holds data for a account db enitity
*
* 
*
* Authors: Joshua Hodkinson
*/
struct Account {
	public string name; /// The auth'd user's display name
	//public ValidEmail email; /// The auth'd user's email
	public string email; /// The auth'd user's email
	//public ValidPassword password; /// The auth'd user's email
	public string password; /// The auth'd user's email
}
