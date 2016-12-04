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

	@method(HTTPMethod.GET)
	void index() {
		// Display home
		DisplayData display = {"home", _authdUser};
		render!("index.dt", display);
	}

	@method(HTTPMethod.GET)
	void login(string _error = null) {
		// Display form
		DisplayData display = {"login", _authdUser};
		render!("login.dt", display, _error);
	}

	@method(HTTPMethod.POST)
	@errorDisplay!login
	void login(string email, string password) {
		// Check account
		auto account = mongo.getDatabase("blogd")["blogd.users"].findOne(["email": email, "password": password]);
		enforce(account != Bson(null), "Incorrect email/password");
		
		// Add logged in user to session
		UserData user;
		user.loggedIn = true;
		user.name = "Josh";
		this._authdUser = user;

		// Go home
		redirect("./");
	}

	@method(HTTPMethod.GET)
	void logout() {
		// Terminate session
		_authdUser = UserData.init;
		terminateSession();
		// Go home
		redirect("./");
	}

	@method(HTTPMethod.GET)
	@path("/user/create")
	void userCreate(string _error = null) {
		// Send logged in user home
		if(_authdUser.loggedIn) {
			redirect("./");
		}

		// Display form
		DisplayData display = {"create account", _authdUser};
		render!("user_create.dt", display, _error);
	}

	@method(HTTPMethod.POST)
	@errorDisplay!userCreate
	void userCreate(string email, string password, string name) {
		// Send logged in user home
		if(_authdUser.loggedIn) {
			redirect("./");
		}

		// Check new user doesn't exist

		// Create new user

		// Go home
		redirect("./");
	}

	@method(HTTPMethod.GET)
	@auth
	void test(string _user, string _error = null) {
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