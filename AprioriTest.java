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
	static Set<ItemTuple> candidateItem;
	static Set<ItemTuple> l;
	static int d[][];
	static int minSupThreshold;
	
	public static void main(String args[]) throws Exception {
		
            //function defined for getting the connection to a MySQL database
            getDatabase();
		candidateItem = new HashSet<>();
		l = new HashSet<>();
		Scanner sc = new Scanner(System.in);
		int i, j, m, n;
		System.out.println("Enter the minimum support (as an integer value):\n");
		minSupThreshold = sc.nextInt();
		Set<Integer> candidateSet = new HashSet<>();
		for(i=0 ; i < d.length ; i++) {
			//System.out.println("Transaction Number: " + (i+1) + ":");
			for(j=0 ; j < d[i].length ; j++) {
			//	System.out.print("Item number " + (j+1) + " = ");
			//	System.out.println(d[i][j]);
				candidateSet.add(d[i][j]);
			}
		}
		
		Iterator<Integer> iter = candidateSet.iterator();
		while(iter.hasNext()) {
			Set<Integer> set = new HashSet<>();
			set.add(iter.next());
			ItemTuple t = new ItemTuple(set, getFreq(set));
			candidateItem.add(t);
		}
		
		dataClean();
		generateFreqItemSets();
	}
	
	//calculates the frequencies of each item in the itemsets, should be lesser than the minsup input
        static int getFreq(Set<Integer> s) {
		int i, j, k;
		int supportThresh = 0;
		int cnt;
		boolean checkElem;
		for(i=0 ; i < d.length ; i++) {
			cnt = 0;
			Iterator<Integer> iter = s.iterator();
			while(iter.hasNext()) {
				int elem = iter.next();
				checkElem = false;
				for(k=0 ; k < d[i].length ; k++) {
					if(elem == d[i][k]) {
						checkElem = true;
						cnt++;
						break;
					}
				}
				if(!checkElem) {
					break;
				}
			}
			if(cnt == s.size()) {
				supportThresh++;
			}
		}
		return supportThresh;
	}
	
	//only adds those values that appear atleast minsup times in the dataset
        static void dataClean() {
		l.clear();
		Iterator<ItemTuple> iter = candidateItem.iterator();
		while(iter.hasNext()) {
			ItemTuple t = iter.next();
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
	static void generateFreqItemSets() {
		boolean checkContinue = true;
		int elem = 0;
		int size = 1;
		Set<Set> candidateSet = new HashSet<>();
		while(checkContinue) {
			candidateSet.clear();
			candidateItem.clear();
			Iterator<ItemTuple> iter = l.iterator();
			while(iter.hasNext()) {
				ItemTuple t1 = iter.next();
				Set<Integer> temp = t1.itemSet;
				Iterator<ItemTuple> it2 = l.iterator();
				while(it2.hasNext()) {
					ItemTuple t2 = it2.next();
					Iterator<Integer> it3 = t2.itemSet.iterator();
					while(it3.hasNext()) {
						try {
							elem = it3.next();
						} catch(ConcurrentModificationException e) {
							// Sometimes this Exception gets thrown, so simply break in that case.
							break;
						}
						temp.add(elem);
						if(temp.size() != size) {
							Integer[] int_arr = temp.toArray(new Integer[0]);
							Set<Integer> temp2 = new HashSet<>();
							for(Integer x : int_arr) {
								temp2.add(x);
							}
							candidateSet.add(temp2);
							temp.remove(elem);
						}
					}
				}
			}
			Iterator<Set> candidate_0set_iterator = candidateSet.iterator();
			while(candidate_set_iterator.hasNext()) {
				Set s = candidate_set_iterator.next();
				// These lines cause warnings, as the candidate_set Set stores a raw set.
				candidateItem.add(new ItemTuple(s, getFreq(s)));
			}
			dataClean();
			if(l.size() <= 1) {
				checkContinue = false;
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
                ResultSet rs = s.executeQuery("SELECT * FROM rand_numbers;"); //rand_numbers is the name of the table in the employeedb database
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