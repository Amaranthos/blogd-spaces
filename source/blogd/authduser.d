module blogd.authduser;

/**
* The struct which holds relevant auth'd user data
*
* Instances of this struct are passed to the veiws to display relevant auth'd user data.
* They are also used to indicate that the the user has been auth'd via the blogd.web.Web.ensureUserAuthed method
*
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document*
* Authors: Joshua Hodkinson
*/
struct AuthdUser {
	/// Indicates the auth'd status of the current user
	bool loggedIn;
	/// The current user's name if auth'd
	string name;
}
