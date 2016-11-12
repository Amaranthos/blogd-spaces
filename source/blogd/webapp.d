module blogd.webapp;

import vibe.d;
import blogd.userdata;

class WebApp {
	private enum auth = before!ensureAuth("_authUser");
	private SessionVar!(UserData, "user") user;

	private string ensureAuth(HTTPServerRequest req, HTTPServerResponse res) {
		if(!user.loggedIn) {
			redirect("/");
		}
		return user.name;
	}

	@method(HTTPMethod.GET)	
	void index(string _error = null) {
		render!("index.dt", _error);
	}

	@method(HTTPMethod.POST)	
	void login(string _error = null) {
		render!("index.dt", _error);
	}	
}