package test;

import java.util.Dictionary;
import java.util.Hashtable;
import java.util.Scanner;

import java.sql.*;



public class Menu {
	 Connection _conn;
	 DbApp db;
	 //Saving hotels Bookings and room for choosing by user
	 Dictionary<Integer,Hotel> hotels ;
	 Dictionary<Integer,Booking> bookings;
	 Dictionary<Integer,Room> rooms;
	 //We use dictionaries in order to not iterate through lists for finding the right choice

	 // Display Main Menu
	  public void display_menu() {
		    System.out.println ( "1) Connect to database 1\n2) Find a hotel by prefix " );
		    System.out.print ( "Selection: " );
		  }
	  
	  //Display Sub Menu
	  public void display_sub_menu() {
		    System.out.println ( "1) Find Clients \n2) Find and update Bookings of a client  \n3) Find free rooms and book one" );
		    System.out.print ( "Selection: " );
		  }
	  
	  // Main Menu only provides the first two options
	  // 1) Connect to database
	  // 2) Search for hotel by prefix
	  public Menu() throws SQLException {
		    Scanner in = new Scanner ( System.in );
		    Boolean stay  = true;
		    //Menu is a while from which you can get out by default option
		    while(stay) {
		    	display_menu();
		    	switch ( in.nextInt() ) {
		    	case 1:
		    		System.out.println ( "You picked option 1" );
		    		try {
		    			db.dbClose();
		    		} catch (Exception e) {
		    			System.out.println("No Database to close");
		    		}
		    		db = new DbApp();
		    		System.out.println("Insert IP");
		    		Scanner scanner = new Scanner(System.in);
		    		String ip = scanner.nextLine();
		    		System.out.println("Insert Database Name");
		    		String dbName = scanner.nextLine();
		    		System.out.println("Insert Username");
		    		String username = scanner.nextLine();
		    		System.out.println("Insert password");
		    		String password = scanner.nextLine();
		    		db.dbConnect(ip, dbName, username, password);
		    		break;
		    	case 2:
		      		System.out.println ( "You picked option 2" );
		      		try {
		      			// Calls option2 which in turn calls optionI,optionII, optionIII
		      			option2();
		      		} catch (Exception e) {
		      			System.out.println(e);
		      		}
		    		break;
		      	default:
		      		System.err.println ( "Unrecognized option" );
		      		stay = false;
		      		break;
		    	}
		    }
		  }
	  
	  public void option2() throws SQLException {
  			System.out.println ("Insert a hotel prefix");
		    Scanner in2 = new Scanner ( System.in );
		    String prothema = in2.nextLine();
			Statement st = db._conn.createStatement();
			ResultSet rs = st.executeQuery( "SELECT * FROM hotel WHERE \"name\" like  '"+ prothema + "%' ORDER BY \"name\" ");
			// Hotels are a Hashtable
			hotels =new Hashtable<>();
			int numberACD = 0;
			// Auksontas arithmos is numberACD and is the key of the hashtable
			// So, when you choose an interger you get Back through the hashtable the correct hotel. 
			// All these are repeated for bookings and rooms
			while (rs.next()) {
				Hotel temp = new Hotel(rs.getInt(1), rs.getString(2), rs.getString(3));
				System.out.println("Choice:" + numberACD);
				System.out.println(temp);
				hotels.put(numberACD,temp);
				numberACD++;
			}
			rs.close();
			st.close();
		    Scanner in = new Scanner ( System.in );
		    Boolean stay  = true;
		    while(stay) {
		    	display_sub_menu();
		    	switch ( in.nextInt() ) {
		    	case 1:
		    		System.out.println ( "You picked option 1" );
		    		optionI();
		    		break;
		    	case 2:
		      		System.out.println ( "You picked option 2" );
		      		optionII();
		    		break;
		    	case 3:
		      		System.out.println ( "You picked option 3" );
		      		optionIII();
		    		break;
		      	default:
		      		System.err.println ( "Unrecognized option" );
		      		stay = false;
		      		System.out.println("Going to main menu");
		      		break;
		    	}
		    }
		  
	  }
	  public void optionI() throws SQLException {
		    Scanner in2 = new Scanner ( System.in );
  			System.out.println ("Insert the choice of hotel");
		    Integer idHotelChoice = in2.nextInt();
		    Scanner in3 = new Scanner ( System.in );
  			System.out.println ("Insert a last name prefix ");
		    String prothema = in3.nextLine();
			Statement st = db._conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT \"idPerson\", fname, lname , dateofbirth FROM\n" + 
					"(\n" + 
					"SELECT \"bookedforpersonID\"\n" + 
					"FROM room, roombooking  \n" + 
					"WHERE \"idHotel\" = " + hotels.get(idHotelChoice).idHotel + "and roombooking.\"roomID\" = room.\"idRoom\" )\n" + 
					"as query1\n" + 
					"inner join person  on query1.\"bookedforpersonID\" = person.\"idPerson\" WHERE lname like'"+prothema+ "%' ORDER BY \"lname\"; ");
			while (rs.next()) {
				System.out.println("idPerson: " + rs.getInt(1) +" Name: "+rs.getString(3)+ " " + rs.getString(2) + " Date Of Birth: "+ rs.getString(4));
			}
			rs.close();
			st.close();
	  }
	  
	  public void optionII() throws SQLException {
		    Scanner in2 = new Scanner ( System.in );
			System.out.println ("Insert the choice of hotel");
		    Integer idHotelChoice = in2.nextInt();
			System.out.println ("Insert the client id ");
		    Integer idClient = in2.nextInt();
			Statement st = db._conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT \"hotelbookingID\",\"roomID\",checkin,checkout,rate\n" + 
					"FROM \n" + 
					"roombooking, room \n" + 
					"WHERE  roombooking.\"bookedforpersonID\" = " + idClient + " and room.\"idRoom\"= roombooking.\"roomID\" \n" + 
					"and room.\"idHotel\"  = " + hotels.get(idHotelChoice).idHotel+ "\n" + 
					"ORDER BY \"hotelbookingID\";");
			System.out.println("Results of Hotel: "+ hotels.get(idHotelChoice).idHotel + " id Client: "+ idClient);
			// Get and print the bookings of the client chosen and the right choice of hotel
			bookings =new Hashtable<>();
			int numberACD = 1;
			while (rs.next()) {
				Booking temp = new Booking(rs.getInt(1),rs.getInt(2),rs.getString(3),rs.getString(4),rs.getDouble(5));
				System.out.println("Choice: " + numberACD );
				System.out.println(temp);
				bookings.put(numberACD, temp);
				numberACD++;
			}
			System.out.println("Pick a choice of booking");
			Integer choice = in2.nextInt();
			if (choice == 0) return;
		    System.out.println("yyyy-mm-day of Starting Date");
		    Scanner scanner = new Scanner(System.in);
		    String start_date = scanner.nextLine();
		    System.out.println("yyyy-mm-dd of ending Date");
		    String end_date = scanner.nextLine();
		    // For dates we first check if they are received with the right sql format
		    //If there is an error we return to the sub menu
			try {
				System.out.println("Starting Date: " + java.sql.Date.valueOf( start_date ));
			} catch (Exception e) {
				System.out.println("Wrong date format for Starting Date");
				return;
			}  
			try {
				System.out.println("Ending Date: " + java.sql.Date.valueOf( end_date ));
			} catch (Exception e) {
				System.out.println("Wrong date format for Ending Date");
				return;
			}
			//Updating room booking with the right dates
			Statement st1 = db._conn.createStatement();
			int rowCount = st1.executeUpdate("UPDATE roombooking SET checkin ='"+ java.sql.Date.valueOf(start_date) +"' , checkout ='"+ java.sql.Date.valueOf(end_date)+"' WHERE \"hotelbookingID\" = "+bookings.get(choice).idHotelBooking +"and \"roomID\" =" + bookings.get(choice).idRoom);
			if (rowCount == 1) System.out.println("Succefully updated values") ;
			else if(rowCount == 0 ) System.out.println("No update ");
			else System.out.println("WoW?");
			
	  }
	  
	  public void optionIII() throws SQLException {
		    Scanner in2 = new Scanner ( System.in );
			System.out.println ("Insert the choice of hotel");
		    Integer idHotelChoice = in2.nextInt();
		    System.out.println("yyyy-mm-day of Starting Date");
		    Scanner scanner = new Scanner(System.in);
		    String start_date = scanner.nextLine();
		    System.out.println("yyyy-mm-dd of ending Date");
		    String end_date = scanner.nextLine();
		    //We pick again the hotel and the dates
			try {
				System.out.println("Starting Date: " + java.sql.Date.valueOf( start_date ));
			} catch (Exception e) {
				System.out.println("Wrong date format for Starting Date");
				return;
			}  
			try {
				System.out.println("Ending Date: " + java.sql.Date.valueOf( end_date ));
			} catch (Exception e) {
				System.out.println("Wrong date format for Ending Date");
				return;
			}

		    System.out.println("idhotel chosen: "+ hotels.get(idHotelChoice).idHotel );
			Statement st = db._conn.createStatement();
			ResultSet rs = st.executeQuery( 
					"SELECT * FROM (SELECT \"idRoom\", \"number\", roomtype FROM room WHERE room.\"idHotel\"=" + hotels.get(idHotelChoice).idHotel + ") as query2 LEFT JOIN (SELECT DISTINCT (\"roomID\")\n" + 
					"FROM room,roombooking as roombooking_0\n" + 
					"WHERE room.\"idHotel\" = "+ hotels.get(idHotelChoice).idHotel + " and roombooking_0.\"roomID\" = room.\"idRoom\" \n" + 
					"and (('" + java.sql.Date.valueOf( end_date ) + "' <= roombooking_0.checkout and '" + java.sql.Date.valueOf( end_date )+ "' >= roombooking_0.checkin )\n" + 
					"or ('" +java.sql.Date.valueOf( start_date )+ "' >= roombooking_0.checkin and '" +java.sql.Date.valueOf( start_date ) + "' <= roombooking_0.checkout) or \n" + 
					"('" +java.sql.Date.valueOf( end_date )+ "' >= roombooking_0.checkout and '" + java.sql.Date.valueOf( start_date )+ "' <= roombooking_0.checkout) or \n" + 
					"('" + java.sql.Date.valueOf( end_date ) +"' >= roombooking_0.checkin and '"+ java.sql.Date.valueOf( start_date ) + "' <= roombooking_0.checkin))) as query1 ON query2.\"idRoom\" = query1.\"roomID\"\n" + 
					"EXCEPT \n" + 
					"SELECT * FROM (SELECT \"idRoom\", \"number\", roomtype FROM room WHERE room.\"idHotel\"=" +hotels.get(idHotelChoice).idHotel +" ) as query2 RIGHT JOIN (SELECT DISTINCT(\"roomID\")\n" + 
					"FROM room,roombooking as roombooking_0\n" + 
					"WHERE room.\"idHotel\" =" + hotels.get(idHotelChoice).idHotel + "and roombooking_0.\"roomID\" = room.\"idRoom\" \n" + 
					"and (('" + java.sql.Date.valueOf( end_date ) + "' <= roombooking_0.checkout and '" + java.sql.Date.valueOf( end_date ) + "' >= roombooking_0.checkin )\n" + 
					"or ('" + java.sql.Date.valueOf( start_date ) + "' >= roombooking_0.checkin and '" + java.sql.Date.valueOf( start_date ) + "' <= roombooking_0.checkout) or \n" + 
					"('" + java.sql.Date.valueOf( end_date )+ "' >= roombooking_0.checkout and '" + java.sql.Date.valueOf( start_date )+ "' <= roombooking_0.checkout) or \n" + 
					"('" + java.sql.Date.valueOf( end_date ) + "' >= roombooking_0.checkin and '" + java.sql.Date.valueOf( start_date )+ "' <= roombooking_0.checkin))) as query1 ON query2.\"idRoom\" = query1.\"roomID\" ");
			int numberACD = 1;
			//To find the right rooms that are available for the received 
			// 1) I find all the rooms 
			// 2) I find all the rooms that are NOT available 
			// I sql-minus 1) from 2)
			rooms =new Hashtable<>();
			//Putting the rooms into the HashTable
			while (rs.next()) {
				Room temp = new Room(rs.getInt(1),rs.getString(3), rs.getInt(2));
				System.out.println("Choice "+ numberACD+ " :");
				System.out.println(temp);
				rooms.put(numberACD,temp);
				numberACD++;
			}
			System.out.println("Pick a room or Pick zero to EXIT ");
			Integer roomACD = in2.nextInt();
			if (roomACD == 0 ) return;
			System.out.println("You chose room:");
			System.out.println(rooms.get(roomACD));
			System.out.println("Insert client id to book the room");
			Integer clientID = in2.nextInt();
			Statement st1 = db._conn.createStatement();
			// Inserting into hotelbooking
			ResultSet rs1 = st1.executeQuery( "INSERT INTO hotelbooking(reservationdate, cancellationdate, totalamount, \"bookedbyclientID\", payed) VALUES ('2022-05-25', '" + java.sql.Date.valueOf(start_date) +"', 180, " + clientID + ", false) RETURNING \"idhotelbooking\" " );
			int idhotelbooking = 0; 
			while (rs1.next()) {
				idhotelbooking = rs1.getInt(1);
			}
			if(idhotelbooking == 0) {
				System.out.println("Insert of hotel booking failed");
			} else {
				//It needs a manager to be updated! So, I insert into him
				st1.executeUpdate("insert into \"Manages\" Values (2496,"+ idhotelbooking+")"); 
				Statement st3 = db._conn.createStatement();
				try {
					 st3.executeUpdate( "INSERT INTO roombooking VALUES (" + idhotelbooking + "," + rooms.get(roomACD).anagnoristiko + ", " + clientID + ", '" +  java.sql.Date.valueOf(start_date) + "', '" + java.sql.Date.valueOf(end_date) + "', 100)" ); 
				} catch( Exception e)  {
					System.out.println(e);
					System.out.println("insert roombooking failed!");
					return;
				}
					System.out.println("A hotel booking was added with id: " + idhotelbooking);
			}
			rs.close();
			st.close();
	  }
	  
}
