function expandNav() {
	var elem = document.getElementsByTagName("nav")[0].getElementsByTagName("ul")[0];
	if (elem.className === "responsive-nav") {
		elem.className = "";
	}
	else{
		elem.className = "responsive-nav";
	}
}