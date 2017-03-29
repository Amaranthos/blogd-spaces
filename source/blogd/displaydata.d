/** 
* This module contains a struct to display relevant data in views
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
* History:
* 	V1 - initial release
*/

module blogd.displaydata;

import blogd.userdata;

/**
* The struct which holds relevant display data
*
* This struct acts as a convient contianer to pass common display elements to relevant views
*
* Authors: Joshua Hodkinson
*/
struct DisplayData {
	/// The title of the relvant view
	public string pageTitle;
	/// The currently auth'd user data
	public UserData user;
}
