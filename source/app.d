import vibe.d;

shared static this() {
	auto filesServerSettings = new HTTPFileServerSettings;
	filesServerSettings.serverPathPrefix = "/static/";
	filesServerSettings.options = HTTPFileServerOption.failIfNotFound;

	auto router = new URLRouter;
	router.get("/", staticTemplate!"index.dt");
	router.get("/static/*", serveStaticFiles("public/", filesServerSettings));

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}
