package test;

public class Booking {
	int idHotelBooking;
	int idRoom;
	String checkIn;
	String checkOut;
	double rate;
		public Booking(int idHotelBooking, int idRoom, String checkin, String ckeckout, double rate) {
			this.idHotelBooking = idHotelBooking;
			this.idRoom=idRoom;
			this.checkIn = checkin;
			this.checkOut = ckeckout;
			this.rate = rate;
		}
	public String  toString(){
				return " idHotelBooking:" + this.idHotelBooking +" id Room: "+this.idRoom + 
						" Checkin: "+ this.checkIn + " Checkout: " + this.checkOut + " Rate: " + this.rate ; 
			}
			 
}
