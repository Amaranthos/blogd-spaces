module blogd.repositories.interfaces.irepository;

/** 
* Generic repository interface, suitable for use with all models to decouple data storage from the application
* 
* Copyright: &copy; 2017 Joshua Hodkinson
* License: MIT as per included LICENSE document
* Authors: Joshua Hodkinson
*/
interface IRepository(T) {
	T[] get();
	void put(T obj);
	void post(T obj);
	void remove(T obj);
}
