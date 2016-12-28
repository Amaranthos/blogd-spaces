/** 
* This module contains a struct to represent user data
* 
* Copyright: &copy; 2015 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
* History:
* 	V1 - initial release
*/

module blogd.userdata;

/**
* The struct which holds relevant auth'd user data
*
* Instances of this struct are passed to the veiws to display relevant auth'd user data.
* They are also used to indicate that the the user has been auth'd via the blogd.web.Web.ensureUserAuthed method
*
* Authors: Joshua Hodkinson
*/
struct UserData {
	/// Indicates the auth'd status of the current user
	bool loggedIn;
	/// The current user's name if auth'd
	string name;
}