import vibe.d;
import blogd.webapp;

shared static this() {
	auto faviconSettings = new HTTPFileServerSettings;
	faviconSettings.serverPathPrefix = "/";
	faviconSettings.options = HTTPFileServerOption.failIfNotFound;
	faviconSettings.preWriteCallback = (scope req, scope res, ref path) {
		res.headers["Content-Type"] = "image/vnd.microsoft.icon";
	};

	auto filesServerSettings = new HTTPFileServerSettings;
	filesServerSettings.serverPathPrefix = "/static/";
	filesServerSettings.options = HTTPFileServerOption.failIfNotFound;

	auto router = new URLRouter;
	router.registerWebInterface(new WebApp);
	router.get("/static/*", serveStaticFiles("public/", filesServerSettings));

	auto settings = new HTTPServerSettings;
	settings.sessionStore = new MemorySessionStore;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

