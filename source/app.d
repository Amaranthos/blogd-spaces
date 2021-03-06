import std.process;

import vibe.d;

import blogd.web;
import blogd.repositories.implementations.accountrepositorymongo;

void main() {
	auto faviconSettings = new HTTPFileServerSettings;
	faviconSettings.serverPathPrefix = "/";
	faviconSettings.options = HTTPFileServerOption.failIfNotFound;
	faviconSettings.preWriteCallback = (scope req, scope res, ref path) {
		res.headers["Content-Type"] = "image/vnd.microsoft.icon";
	};

	MongoClient _mongoClient = connectMongoDB(environment.get("MONGO", "mongodb://localhost"));
	
	auto filesServerSettings = new HTTPFileServerSettings;
	filesServerSettings.serverPathPrefix = "/static/";
	filesServerSettings.options = HTTPFileServerOption.failIfNotFound;

	auto router = new URLRouter;
	router.get("/static/*", serveStaticFiles("public/", filesServerSettings));
	router.get("/favicon.ico", serveStaticFiles("public/", faviconSettings));
	router.registerWebInterface(
		new Web(
			new AccountRepositoryMongo(_mongoClient.getDatabase("blogd")["users"])
		)
	);

	auto settings = new HTTPServerSettings;
	settings.sessionStore = new MemorySessionStore;
	settings.port = environment.get("PORT", "8080").to!ushort;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:"~ environment.get("PORT", "8080") ~ "/ in your browser.");

	runApplication();
}
