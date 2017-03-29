/** 
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/

module blogd.repositories.interfaces.irepository;

interface IRepository(T) {
	T[] get();
	void put(T obj);
	void post(T obj);
	void remove(T obj);
}
