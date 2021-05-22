package test;

public class Hotel {
	String name;
	int idHotel;
	String stars;
	public Hotel(int id, String name, String stars) {
			this.idHotel =id;
			this.name = name;
			this.stars = stars;
	}
	 public String  toString(){
		return " idHotel:" + this.idHotel +" Name: "+this.name + " Stars: "+ this.stars;
	}
	 
	
}
