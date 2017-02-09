/** 
* This module contains a struct to represent account db entities
* 
* Copyright: &copy; 2015 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
* History:
* 	V1 - initial release
*/

module blogd.models.account;

/**
* The struct which holds data for a account db enitity
*
* 
*
* Authors: Joshua Hodkinson
*/
struct UserData {
	
	/// The current user's name if auth'd
	string name;
}