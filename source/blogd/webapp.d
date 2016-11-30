module blogd.webapp;

import vibe.d;
import blogd.userdata;

final class WebApp {
	private enum auth = before!ensureAuth("_user");
	private SessionVar!(UserData, "user") user;
	private MongoClient mongo;

	this() {
		mongo = connectMongoDB("localhost");
	}

	@method(HTTPMethod.GET)
	void index() {
		string title = "home";
		render!("index.dt", title);
	}

	@method(HTTPMethod.GET)
	void login(string _error = null) {
		string title = "login";
		render!("login.dt", title, _error);
	}

	@method(HTTPMethod.POST)
	@errorDisplay!login
	void login(string email, string password) {
		MongoCollection users = mongo.getCollection("blogd.users");
		//enforce(users.findOne(["email": email, "password": password]) != Bson(null), "Incorrect email/password");
		//auto json = users.findOne(["email": email, "password": password]);
		string title = "post";
		render!("test.dt", title, users);
		//redirect("index");
	}

	private string ensureAuth(scope HTTPServerRequest req, scope HTTPServerResponse res) {
		if(!user.loggedIn) {
			redirect("/");
		}
		return user.name;
	}
}