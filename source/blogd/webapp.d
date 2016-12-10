module blogd.webapp;

import dauth;

import vibe.d;
import blogd.userdata;
import blogd.displaydata;

final class WebApp {
	private enum auth = before!ensureUserAuthed("_user");
	private SessionVar!(UserData, "user") _authdUser;
	private MongoClient mongoClient;
	private MongoCollection mongoUsers;

	this() {
		mongoClient = connectMongoDB("127.0.0.1", 27017);
		mongoUsers = mongoClient.getDatabase("blogd")["blogd.users"];
	}

	void index() {
		// Display home
		DisplayData display = {"home", _authdUser};
		render!("index.dt", display);
	}

	void getLogin(string _error = null) {
		// Display form
		DisplayData display = {"login", _authdUser};
		render!("login.dt", display, _error);
	}

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

	void getLogout() {
		// Terminate session
		_authdUser = UserData.init;
		terminateSession();

		// Go home
		redirect("/");
	}

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
		auto hashedPassword = password.toString.dup.toPassword.makeHash.toString;
		mongoUsers.insert(["email": email.toString, "password": hashedPassword, "name": name]);

		// Log user in
		UserData user;
		user.loggedIn = true;
		user.name = name;
		this._authdUser = user;

		// Go home
		redirect("/");
	}

	@auth
	void getTest(string _user, string _error = null) {
		DisplayData display = {"test", _authdUser};
		render!("test.dt", display, _error);
	}

	private string ensureUserAuthed(scope HTTPServerRequest req, scope HTTPServerResponse res) {
		// Send non authed to login
		if(!WebApp._authdUser.loggedIn) {
			redirect("/login");
		}
		return WebApp._authdUser.name;
	}

	mixin PrivateAccessProxy;
}