/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aprioritest;
import java.util.*;
import java.sql.*;

class ItemTuple {
	Set<Integer> itemSet;
	int minSupThreshold;
	
	ItemTuple() {
		itemSet = new HashSet<>();
		minSupThreshold = -1;
	}
	
	ItemTuple(Set<Integer> s) {
		itemSet = s;
		minSupThreshold = -1;
	}
	
	ItemTuple(Set<Integer> s, int i) {
		itemSet = s;
		minSupThreshold = i;
	}
}

public class AprioriTest {
	static Set<ItemTuple> c;
	static Set<ItemTuple> l;
	static int d[][];
	static int minSupThreshold;
	
	public static void main(String args[]) throws Exception {
		
            //function defined for getting the connection to a MySQL database
            getDatabase();
		c = new HashSet<>();
		l = new HashSet<>();
		Scanner scan = new Scanner(System.in);
		int i, j, m, n;
		System.out.println("Enter the minimum support (as an integer value):\n");
		minSupThreshold = scan.nextInt();
		Set<Integer> candidate_set = new HashSet<>();
		for(i=0 ; i < d.length ; i++) {
			System.out.println("Transaction Number: " + (i+1) + ":");
			for(j=0 ; j < d[i].length ; j++) {
				System.out.print("Item number " + (j+1) + " = ");
				System.out.println(d[i][j]);
				candidate_set.add(d[i][j]);
			}
		}
		
		Iterator<Integer> iterator = candidate_set.iterator();
		while(iterator.hasNext()) {
			Set<Integer> s = new HashSet<>();
			s.add(iterator.next());
			ItemTuple t = new ItemTuple(s, count(s));
			c.add(t);
		}
		
		prune();
		generateFrequentItemsets();
	}
	
	//calculates the frequencies of each item in the itemsets, should be lesser than the minsup input
        static int count(Set<Integer> s) {
		int i, j, k;
		int support = 0;
		int count;
		boolean containsElement;
		for(i=0 ; i < d.length ; i++) {
			count = 0;
			Iterator<Integer> iterator = s.iterator();
			while(iterator.hasNext()) {
				int element = iterator.next();
				containsElement = false;
				for(k=0 ; k < d[i].length ; k++) {
					if(element == d[i][k]) {
						containsElement = true;
						count++;
						break;
					}
				}
				if(!containsElement) {
					break;
				}
			}
			if(count == s.size()) {
				support++;
			}
		}
		return support;
	}
	
	//only adds those values that appear atleast minsup times in the dataset
        static void prune() {
		l.clear();
		Iterator<ItemTuple> iterator = c.iterator();
		while(iterator.hasNext()) {
			ItemTuple t = iterator.next();
			if(t.minSupThreshold >= minSupThreshold) {
				l.add(t);
			}
		}
		System.out.println("-+- L -+-");
		for(ItemTuple t : l) {
			System.out.println(t.itemSet + " : " + t.minSupThreshold);
		}
	}
	
        //generates all possible itemsets satisfying the minimum minSupThreshold threshold condition
	static void generateFrequentItemsets() {
		boolean toBeContinued = true;
		int element = 0;
		int size = 1;
		Set<Set> candidate_set = new HashSet<>();
		while(toBeContinued) {
			candidate_set.clear();
			c.clear();
			Iterator<ItemTuple> iterator = l.iterator();
			while(iterator.hasNext()) {
				ItemTuple t1 = iterator.next();
				Set<Integer> temp = t1.itemSet;
				Iterator<ItemTuple> it2 = l.iterator();
				while(it2.hasNext()) {
					ItemTuple t2 = it2.next();
					Iterator<Integer> it3 = t2.itemSet.iterator();
					while(it3.hasNext()) {
						try {
							element = it3.next();
						} catch(ConcurrentModificationException e) {
							// Sometimes this Exception gets thrown, so simply break in that case.
							break;
						}
						temp.add(element);
						if(temp.size() != size) {
							Integer[] int_arr = temp.toArray(new Integer[0]);
							Set<Integer> temp2 = new HashSet<>();
							for(Integer x : int_arr) {
								temp2.add(x);
							}
							candidate_set.add(temp2);
							temp.remove(element);
						}
					}
				}
			}
			Iterator<Set> candidate_set_iterator = candidate_set.iterator();
			while(candidate_set_iterator.hasNext()) {
				Set s = candidate_set_iterator.next();
				// These lines cause warnings, as the candidate_set Set stores a raw set.
				c.add(new ItemTuple(s, count(s)));
			}
			prune();
			if(l.size() <= 1) {
				toBeContinued = false;
			}
			size++;
		}
		System.out.println("\n=+= FINAL LIST =+=");
		for(ItemTuple t : l) {
			System.out.println(t.itemSet + " : " + t.minSupThreshold);
		}
	}
	
	//connects with a database created externally via MySQL
        static void getDatabase() throws Exception {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeedb","root","SilverRonil1996");
		Statement s = con.createStatement();
		
		//to perform operations on all the items present in the database
                ResultSet rs = s.executeQuery("SELECT * FROM rand_numbers;"); //apriori is the name of the table in the employeedb database
		Map<Integer, List <Integer>> m = new HashMap<>();
		List<Integer> temp;
		while(rs.next()) {
			int list_no = Integer.parseInt(rs.getString(1)); //parsing the query as an int for easy computation
			int object = Integer.parseInt(rs.getString(2));
			temp = m.get(list_no);
			if(temp == null) {
				temp = new LinkedList<>();
			}
			temp.add(object);
			m.put(list_no, temp);
		}
		
		Set<Integer> keyset = m.keySet();
		d = new int[keyset.size()][];
		Iterator<Integer> iterator = keyset.iterator();
		int count = 0;
		while(iterator.hasNext()) {
			temp = m.get(iterator.next());
			Integer[] int_arr = temp.toArray(new Integer[0]);
			d[count] = new int[int_arr.length];
			for(int i=0 ; i < d[count].length ; i++) {
				d[count][i] = int_arr[i].intValue();
			}
			count++;
		}
	}
}