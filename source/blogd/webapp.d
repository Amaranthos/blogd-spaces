module blogd.webapp;

import vibe.d;
import blogd.userdata;

class WebApp {
	private enum auth = before!ensureAuth("_authUser");
	private SessionVar!(bool, "user") user; //(UserData, "user") user;

	private string ensureAuth(HTTPServerRequest req, HTTPServerResponse res) {
		if(!user) {
			redirect("/");
		}
		return "josh"; //user.name;
	}

	@method(HTTPMethod.GET)	
	void index(string _error = null) {
		render!("index.dt", _error);
	}
}