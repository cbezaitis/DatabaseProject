package test;

import java.sql.*;

public class DbApp {
	Connection _conn;
	public DbApp() {
		try {
			Class.forName("org.postgresql.Driver");
			System.out.println("Driver Found !");
		}
		catch (java.lang.ClassNotFoundException e){
			System.out.println(e);
			System.out.println("Driver not Found!");
		}
	}
	public void dbConnect(String ip, String dbName, String username, String password){
		try {
			_conn = DriverManager.getConnection("jdbc:postgresql://" + ip + ":5432/" + dbName, username, password);
			System.out.println("Connection to base sucessfull !\n" + _conn);
		}
		catch (SQLException E) {
			System.out.println("Problem in Driver manager!");
			java.lang.System.out.println("SQLException: " + E.getMessage());
			java.lang.System.out.println("SQLState: " + E.getSQLState());
			java.lang.System.out.println("VendorError: " + E.getErrorCode());
			}

	}
	
	public void dbClose() {
		try {
		_conn.close();
		}
		catch (Exception E) {
			System.out.println("Problem in closing!");
			java.lang.System.out.println("SQLException: " + E.getMessage());

		}
	}
	
	public static void main(String[] args) throws SQLException {
		//Opens the Menu
		new Menu();
	}

}
