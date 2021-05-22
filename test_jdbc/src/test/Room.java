package test;

public class Room {
	int anagnoristiko;
	String type;
	int number;
		public Room(int anagnoristiko, String type, int number) {
			this.anagnoristiko = anagnoristiko;
			this.type = type;
			this.number =  number;
			
		}
		 public String  toString(){
				return " Anagnoristiko:" + this.anagnoristiko +" type: "+this.type + " Number: "+ this.number;
			}
}
