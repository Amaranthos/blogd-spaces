/** 
* This module contains the web app for users to interact with blogd.spaces
* 
* The scope of this web app is to create/authenticate users, to create, edit and display blogs and to customize user information
*
* TODO: Extract db operations to a separate REST interface
* 
* Copyright: &copy; 2015 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
* History:
* 	V1 - initial release
*/

module blogd.web;

import vibe.d;

/**
* The class which outlines the blog.spaces functionality
*
* This class is registered with the URLRouter as a web interface.
* It's scope is to allow users to create and read blogs, and for users to interact with their accounts.
* The following route conventions will be used:
* $(UL
* 	$(LI "/": home, login/logout)
* 	$(LI "/user/": create account, view/update account details)
* 	$(LI "/read/": reading/searching existing blog posts)
* 	$(LI "/write/": writing blog posts)
* )
*
* Authors: Joshua Hodkinson
*/
final class Web {
	import dauth;
	import blogd.userdata;
	import blogd.displaydata;
	import blogd.models.account;

	private {
		enum auth = before!ensureUserAuthed("_user"); /// Annotation that ensures a user is auth'd
		SessionVar!(UserData, "user") _authdUser; /// The auth'd user
		MongoClient _mongoClient; /// Mongo db instance
		//MongoCollection _mongoUsers; /// Mongo users collection
		MongoCollection _mongoPosts; /// Mongo posts collection
		IAccountRepo _accountsRepo; /// User accounts data source
	}

	/** 
	* Constructor to init members
	*
	* This constructor initializes relevant members.
	*
	* Authors: Joshua Hodkinson
	*/
	this() {
		import std.process;
		_mongoClient = connectMongoDB(environment.get("MONGO", "mongodb://localhost")); // mongodb://mongo/
		_mongoPosts = _mongoClient.getDatabase("blogd")["posts"];
		_accountsRepo = new AccountRepo(_mongoClient.getDatabase("blogd")["users"]);
	}

	/**
	* GET "/", displays home page
	*
	* This is the index route "/" and displays the home page.
	*
	* TODO: create feed?
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
	* This is a child to the index route "/" and displays the login form.
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
	* POST "/login", auth'd user, redirects to GET "/" on success or GET "/login" on failure
	*
	* This is a child to the index route "/" and handles the submitted login form.
	* The submitted data is checked to be valid, and the user is pulled from the db.
	* If user doesn't exist, or password is incorrect user is redirected to GET "/login" with an error message.
	* Else user details are stored for this session and user is redirected to GET "/".
	*
	* Params:
	*	email = field passed in via form
	*	password = field passed in via form
	* 
	* Authors: Joshua Hodkinson
	*/
	@errorDisplay!getLogin
	void postLogin(ValidEmail email, ValidPassword password) {
		// Check account
		auto account = _accountsRepo.get(email); // _mongoUsers.findOne(["email": email.toString]);
		DisplayData display = {"test", _authdUser};

		enforce(account == Account.init && isSameHash(password.dup.toPassword, account.password.parseHash), "incorrect email/password");

		// Add logged in user to session
		UserData user;
		user.loggedIn = true;
		user.name = account.name;
		this._authdUser = user;

		// Go home
		redirect("/");
	}
		
	/**
	* GET "/logout", requires auth'd user, logs user out + terminates session and redirects to GET "/"
	*
	* This is a child to the index route "/" and handles logging out an auth'd user.
	* Tracked user details are dropped, the session is terminated and user is redirected to GET "/".
	* As this route requires auth'd user, non auth'd users are redirected to GET "/login".
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
	* This is a child to the user route "/user/" and displays the create user form.
	* Auth'd users are redirected to GET "/".
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
	* This is a child to the user route "/user/" and handles the submitted create user form.
	* The submitted data is checked to be valid, and checked to not already exist.
	* If the user is auth'd they are redirected to GET "/".
	* Else if the user does exist, or the submitted data isn't valid the user is redirected to GET "/user/create" with an error message.
	* Else new user password is hashed, user details are inserted into the db, the user is auth'd and redirected to GET "/".
	* 
	* TODO: send confirmation email to user and login via link
	*
	* Params:
	*	email = field passed in via form
	*	password = field passed in via form
	*	name = field passed in via form
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
		auto account = _accountsRepo.get(email); // _mongoUsers.findOne(["email": email.toString]);
		enforce(account == Account.init, "that account already exists");

		// Create new user
		// TODO: makeHash fixed in Dauth 0.6.3
		import std.random : Mt19937, unpredictableSeed;
		auto rand = Mt19937(unpredictableSeed);
		auto hashed = makeHash(password.dup.toPassword, randomSalt(rand));
		_accountsRepo.put(Account(name, email, password)); //_mongoUsers.insert(["email": email.toString, "password": hashed.toString, "name": name]);

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
	*
	* TODO: Remove this route
	*
	* Authors: Joshua Hodkinson
	*/
	@auth
	void getTest(string _user, string _error = null) {
		DisplayData display = {"test", _authdUser};
		render!("test.dt", display, _error);
	}
	
	/**
	* Ensures current user is auth'd, redirects to GET "/login" on failure
	*
	* Checks the session to see if user is logged in.
	* If user not logged in redirects to GET "/login".
	* Else returns user name
	*
	* Returns: The logged in user's name
	*
	* Authors: Joshua Hodkinson
	*/
	private string ensureUserAuthed(scope HTTPServerRequest req, scope HTTPServerResponse res) {
		// Send non auth'd to login
		if(!Web._authdUser.loggedIn) {
			redirect("/login");
		}
		return Web._authdUser.name;
	}
	
	mixin PrivateAccessProxy;
}

unittest {
	auto router = new URLRouter;
	router.registerWebInterface(new Web);

	auto res = createTestHTTPServerResponse(null, new MemorySessionStore);
	router.handleRequest(createTestHTTPServerRequest(URL("http://localhost/")), res);
	//assert(res);
	logInfo("Res:" ~ res.toString);
}