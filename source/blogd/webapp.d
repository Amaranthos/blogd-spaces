/** 
* This module contains the web app for users to interact with blogd.spaces
* 
* The scope of this web app is to create/authenticate users, to create, edit and display blogs and to customise user information
* 
* Copyright: &copy; 2015 Joshua Hodkinson
* License: As per included LICENSE document
* Authors: Joshua Hodkinson
* 
* History:
* 	V1 - initial release
*/


module blogd.webapp;

import dauth;
import vibe.d;
import std.random;
import blogd.userdata;
import blogd.displaydata;

/**
* The class which outlines the blog.spaces functionality
*
* Authors: Joshua Hodkinson
*/
final class WebApp {
	private enum auth = before!ensureUserAuthed("_user");
	private SessionVar!(UserData, "user") _authdUser;
	private MongoClient mongoClient;
	private MongoCollection mongoUsers;

	/** 
	* Intialises members
	*
	* Authors: Joshua Hodkinson
	*/
	this() {
		mongoClient = connectMongoDB("127.0.0.1", 27017);
		mongoUsers = mongoClient.getDatabase("blogd")["users"];
	}

	/**
	* GET "/", displays home page
	* 
	* Authors: Joshua Hodkinson
	*/
	void index() {
		// Display home
		DisplayData display = {"home", _authdUser};
		render!("index.dt", display);
	}

	/**
	* GET "/login", displays login form
	* 
	* Params:
	*	_error = optional parameter to display error information in the rendered template
	*
	* Authors: Joshua Hodkinson
	*/
	void getLogin(string _error = null) {
		// Display form
		DisplayData display = {"login", _authdUser};
		render!("login.dt", display, _error);
	}

	/**
	* POST "/login", auth's user, redirects to GET "/" on success or GET "/login" on failure
	*
	* Params:
	*	email = field passed in via form
	*	password = field passed in via form
	* 
	* Authors: Joshua Hodkinson
	*/
	@errorDisplay!getLogin
	void postLogin(string email, char[] password) {
		// Check account
		auto account = mongoUsers.findOne(["email": email]);
		DisplayData display = {"test", _authdUser};

		enforce(account != Bson(null) && isSameHash(password.toPassword, account["password"].get!string.parseHash), "Incorrect email/password.");

		// Add logged in user to session
		UserData user;
		user.loggedIn = true;
		user.name = account["name"].get!string;
		this._authdUser = user;

		// Go home
		redirect("/");
	}
	
	/**
	* GET "/logout", requires auth'd user, logs user out + terminates session and redirects to GET "/"
	* 
	* Authors: Joshua Hodkinson
	*/
	@auth
	void getLogout() {
		// Terminate session
		_authdUser = UserData.init;
		terminateSession();

		// Go home
		redirect("/");
	}
	
	/**
	* GET "/user/create", displays create account form, auth'd user redirects to GET "/"
	* 
	* Authors: Joshua Hodkinson
	*/
	@path("/user/create")
	void getUserCreate(string _error = null) {
		// Send logged in user home
		if(_authdUser.loggedIn) {
			redirect("/");
		}

		// Display form
		DisplayData display = {"create account", _authdUser};
		render!("user_create.dt", display, _error);
	}
	
	/**
	* POST "/user/create", validates new user details and inserts in db, redirects to GET "/" on success or to GET "/user/create" on failure
	* 
	* Authors: Joshua Hodkinson
	*/
	@path("/user/create")
	@errorDisplay!getUserCreate
	void postUserCreate(ValidEmail email, ValidPassword password, string name) {
		// Send logged in user home
		if(_authdUser.loggedIn) {
			redirect("/");
		}

		// Check new user doesn't exist
		auto account = mongoUsers.findOne(["email": email.toString]);
		enforce(account == Bson(null), "That account already exists.");

		// Create new user
		auto rand = Mt19937(unpredictableSeed);
		auto hashed = makeHash(password.dup.toPassword, randomSalt(rand));
		mongoUsers.insert(["email": email.toString, "password": hashed.toString, "name": name]);

		// Log user in
		UserData user;
		user.loggedIn = true;
		user.name = name;
		this._authdUser = user;

		// Go home
		redirect("/");
	}
	
	/**
	* GET "/test", requires auth'd user, displays a test page
	* Authors: Joshua Hodkinson
	*/
	@auth
	void getTest(string _user, string _error = null) {
		DisplayData display = {"test", _authdUser};
		render!("test.dt", display, _error);
	}
	
	/**
	* Ensures current user is auth'd, redirects to GET "/login" on failure
	* Authors: Joshua Hodkinson
	*/
	private string ensureUserAuthed(scope HTTPServerRequest req, scope HTTPServerResponse res) {
		// Send non authed to login
		if(!WebApp._authdUser.loggedIn) {
			redirect("/login");
		}
		return WebApp._authdUser.name;
	}

	mixin PrivateAccessProxy;
}