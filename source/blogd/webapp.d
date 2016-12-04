module blogd.webapp;

import vibe.d;
import blogd.userdata;
import blogd.displaydata;

final class WebApp {
	private enum auth = before!ensureUserAuthed("_user");
	private SessionVar!(UserData, "user") _authdUser;
	private MongoClient mongo;

	this() {
		mongo = connectMongoDB("127.0.0.1", 27017);
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
	void postLogin(string email, string password) {
		// Check account
		auto account = mongo.getDatabase("blogd")["blogd.users"].findOne(["email": email, "password": password]);
		enforce(account != Bson(null), "Incorrect email/password");
		
		// Add logged in user to session
		UserData user;
		user.loggedIn = true;
		user.name = "Josh"; // TODO: Populate with user's login
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
	void postUserCreate(string email, string password, string name) {
		// Send logged in user home
		if(_authdUser.loggedIn) {
			redirect("/");
		}

		// Check new user doesn't exist
		auto account = mongo.getDatabase("blogd")["blogd.users"].findOne(["email": email, "password": password]);
		enforce(account == Bson(null), "Account already exists");

		// Create new user

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