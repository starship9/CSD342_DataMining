/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package insertdbdata;
import java.util.Random;
import static javax.management.Query.lt;
/**
 *
 * @author Nishank
 */
public class ZipfGen1 {
 private Random rnd = new Random(System.currentTimeMillis());
 private int size;
 private double skew;
 private double bottom = 0;
 
 public ZipfGen1(int size, double skew) {
  this.size = size;
  this.skew = skew;
 
  for(int i=1;i < size; i++) {
  this.bottom += (1/Math.pow(i, this.skew));
  }
 }
 
 // the next() method returns an random rank id.
 // The frequency of returned rank ids are follows Zipf distribution.
// public int next() {
//   int rank;
//   double friquency = 0;
//   double dice;
// 
//   rank = rnd.nextInt(size);
//   friquency = (1.0d / Math.pow(rank, this.skew)) / this.bottom;
//   dice = rnd.nextDouble();
// 
//   while(!(dice &lt ; friquency)) {
//     rank = rnd.nextInt(size);
//     friquency = (1.0d / Math.pow(rank, this.skew)) / this.bottom;
//     dice = rnd.nextDouble();
//   }
// 
//   return rank;
// }
 
 // This method returns a probability that the given rank occurs.
 public double getProbability(int rank) {
   return (1.0d / Math.pow(rank, this.skew)) / this.bottom;
 }
 
 public static void main(String[] args) {
   if(args.length != 2) {
     System.out.println("usage: ./zipf size skew");
     System.exit(-1);
   }
 
   ZipfGen1 zipf = new ZipfGen1(Integer.valueOf(args[0]),
   Double.valueOf(args[1]));
   for(int i=1;i <= Integer.parseInt(args[0]); i++)
     System.out.println(i+" "+100*zipf.getProbability(i));
 }
}