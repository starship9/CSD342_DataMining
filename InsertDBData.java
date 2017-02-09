/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package insertdbdata;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Random;

/**
 *
 * @author Nishank
 */
public class InsertDBData {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception{
        // TODO code application logic here
        Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeedb","root","SilverRonil1996");
	Statement s = con.createStatement();
        int trans;
        double prob;
        ZipfGen1 z = new ZipfGen1(1000,2);
        Random rnd = new Random(System.currentTimeMillis());
        for(int i=1;i<=10;i++){
            prob = z.getProbability(i)*1000;
            for(int j=1;j<=Math.ceil(prob);j++){
                trans = rnd.nextInt(1000);
                s.executeUpdate("INSERT IGNORE INTO rand_numbers VALUES ("+trans+","+i+");");
            }
        }
    }
    
}
